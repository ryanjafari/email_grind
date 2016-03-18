jQuery = require "jquery" # TODO: Rename to "$"
Gmail = require "gmail" # TODO: Rename to Gmailjs
Inbox = require "./email-grind/inbox"
EmailObserver = require "./email-grind/email-observer"

window.jQuery = jQuery # TODO: Rename to "$"

Google = {
  Client: require "./google/client"
  Gmail: require "./google/gmail"
}

refresh = (f) ->
  if ((/in/.test(document.readyState)) || (undefined == Gmail))
    setTimeout (-> refresh(f)), 10
  else
    f()

class EmailGrind
  @run: ->
    console.log "App start..."
    @_auth_with_google()

  @_auth_with_google: ->
    console.log "Now authenticating..."
    Google.Client.installClientJs @_setup_gmail_api

  @_setup_gmail_api: =>
    console.debug "-> Finished client auth, starting Gmail API load..."
    Google.Gmail.load @_gmail_api_ready

  @_gmail_api_ready: =>
    console.log "Gmail API is ready, so setting up interface..."
    gmail = new Gmail()
    gmail.observe.on "load", => @_gmail_js_ready(gmail)

  @_gmail_js_ready: (gmail) ->
    console.debug "-> The Gmail interface has finished loading..."

    serverMessages = gmail.get.visible_emails()
    primaryMessages = jQuery.grep serverMessages, (s) ->
      "^smartlabel_social" not in s.labels &&
      "^smartlabel_promo" not in s.labels

    $inboxDom = gmail.dom.inboxes().first().find ".F.cf.zt > tbody"

    inbox = @_build_initial_inbox primaryMessages, $inboxDom
    # @_watch_for_inbox_changes inbox

    # TODO: Rig each DOM message with its appropriate data from the server...
    # gmail.get.visible_emails(async)
    # gmail.get.email_data_async(email_id=undefined, callback)
    # gmail.get.email_source_async(email_id=undefined, callback)

  @_build_initial_inbox: (serverMessages, $inboxDom) ->
    console.debug "-> Building our initial representation of the inbox..."
    inbox = new Inbox serverMessages, $inboxDom
    console.log "Generated DOM messages:", inbox.getMessages()
    return inbox

  # TODO: observer.disconnect when not using it anymore...
  @_watch_for_inbox_changes: (inbox) ->
    console.debug "-> Watching for changes on inbox:", inbox
    emailObserver = new EmailObserver inbox
    emailObserver.on "messageAdded", ($message) ->
      console.debug "-> Added message:", $message
      inbox.addMessage $message
    emailObserver.on "messageRemoved", ($message) ->
      console.debug "-> Removed message:", $message
      inbox.removeMessage $message
    emailObserver.watch()

refresh -> EmailGrind.run()
