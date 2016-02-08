# TODO: require/import
Function::getter = (prop, get) ->
  Object.defineProperty @prototype, prop, { get, configurable: yes }

Function::setter = (prop, set) ->
  Object.defineProperty @prototype, prop, { set, configurable: yes }

GmailApi = require "./gmail_api"

class Inbox
  constructor: ($messagesDom) ->
    @messages = []
    for messageDom in $messagesDom
      message = new Message jQuery(messageDom)
      @_add_message message

  _add_message: (message) ->
    @messages.push message

  getMessages: ->
    @messages

class Message
  constructor: ($messageDom) ->
    @_$dom = $messageDom
    likeButton = new LikeButton "Like"
    @._add_button likeButton # TODO: need .?

  _add_button: (button) ->
    wrapper = @_$subject_dom.children().first()
    unless wrapper.hasClass "a4X"
      wrapper = jQuery "<div class='a4X'></div>"
      wrapper.attr "style", "padding-right:12ex;"
      @_$subject_dom.children().wrap wrapper
    @_$subject_dom.children().first().append button.$dom

  @getter "_$sender_dom", -> @_$dom.find ".yX.xY"
  @getter "_$subject_dom", -> @_$dom.find ".xY.a4W"
  @getter "_$date_dom", -> @_$dom.find ".xW.xY"

  @getter "sender", -> @_$sender_dom.find(".yW").children().first().text()
  @getter "subject", -> @_$subject_dom.find(".y6").children().first().text()
  @getter "preview", -> @_$subject_dom.find(".y2").text()
  @getter "date", -> @_$date_dom.children().first().attr "title" # TODO: Date class?

class LikeButton
  constructor: (label) ->
    @_$dom = jQuery "<a href='#'>#{label}</a>"
    @_$dom.addClass "aKS"
    @_$dom.on "click", @_click

  _click: (event) ->
    gmailApi = new GmailApi()
    gmailApi.handleAuthClick event

  @getter "$dom", -> @_$dom

module.exports = Inbox
