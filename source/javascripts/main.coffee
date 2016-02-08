# TODO: coffeescript globals
jQuery = window.jQuery || {}
jQuery = require "jquery"
window.jQuery = jQuery

Gmail = window.gmail || {}
Gmail = require "gmail"
window.Gmail = Gmail

# TODO: Need these?
Inbox = require "./inbox"

refresh = (f) ->
  if ((/in/.test(document.readyState)) || (undefined == Gmail))
    setTimeout (-> refresh(f)), 10
  else
    f()

class Client
  @run: ->
    gmail = new Gmail()
    inboxDom = gmail.dom.inboxes().first()
    $messagesDom = jQuery(inboxDom).find ".zA.yO"

    inbox = new Inbox $messagesDom

    console.log inbox.getMessages()

refresh -> Client.run()

# setTimeout(function() {
#     /* Example: Send data to your Chrome extension*/
#     document.dispatchEvent(new CustomEvent('RW759_connectExtension', {
#         detail: GLOBALS // Some variable from Gmail.
#     }));
# }, 0);
