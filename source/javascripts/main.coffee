jQuery = require "jquery" # TODO: Rename to "$"
Gmail = require "gmail"
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

class Client
  @run: ->
    console.log "App start..."
    @_auth()

  @_auth: ->
    console.log "Now authenticating..."
    Google.Client.installClientJs @_setup

  @_setup: ->
    console.log "Setting up interface..."
    Google.Gmail.load @_gmail_ready

  @_gmail_ready: ->
    console.log "Gmail is ready..."
    # gmail = new Gmail() # TODO: Do we need this at all?
    # inboxDom = gmail.dom.inboxes().first()
    # $messagesDom = jQuery(inboxDom).find ".zA.yO"
    # inbox = new Inbox $messagesDom
    # console.log inbox.getMessages()

refresh -> Client.run()

# TODO: Message class for Gmail API
