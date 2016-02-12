jQuery = require "jquery" # TODO: Rename to "$"
Gmail = require "gmail" # TODO: Rename to Gmailjs
Inbox = require "./inbox"

window.jQuery = jQuery

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
    @_auth()

  @_auth: ->
    console.log "Now authenticating..."
    Google.Client.installClientJs @_setup

  @_setup: =>
    console.debug "-> Finished client auth, starting Gmail API load..."
    Google.Gmail.load @_gmail_ready

  @_gmail_ready: ->
    console.log "Gmail is ready, so setting up interface..."
    gmail = new Gmail()
    inboxDom = gmail.dom.inboxes().first()
    $messagesDom = jQuery(inboxDom).find ".zA.yO"
    inbox = new Inbox $messagesDom
    console.log "Generated DOM messages:", inbox.getMessages()

    # TODO: Rig each DOM message with its appropriate data from the server...
    # gmail.get.visible_emails(async)
    # gmail.get.email_data_async(email_id=undefined, callback)
    # gmail.get.email_source_async(email_id=undefined, callback)

refresh -> EmailGrind.run()

# TODO: Message class for Gmail API
