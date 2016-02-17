# TODO: require/import
Function::getter = (prop, get) ->
  Object.defineProperty @prototype, prop, { get, configurable: yes }

Function::setter = (prop, set) ->
  Object.defineProperty @prototype, prop, { set, configurable: yes }

Google = {
  Gmail: require "../google/gmail"
  EmailMessage: require "../google/email-message"
}

# TODO: getters should have get or no?
# be consistent... functions need get, getters don't...

class Inbox
  constructor: ($dom) ->
    @_messages = []
    @_$dom = $dom
    $messagesDom = $dom.children()
    for $messageDom in $messagesDom
      @addMessage $messageDom

  addMessage: ($messageDom) ->
    message = new Message jQuery($messageDom)
    @_messages.push message

  removeMessage: ($message) ->
    $messageToRemove = jQuery.grep @_messages, (e) -> e.id == $message.id
    indexOfMessageToRemove = @_messages.indexOf $messageToRemove
    @_messages.splice indexOfMessageToRemove, 1

  # TODO: getter
  getMessages: ->
    @_messages

  @getter "$dom", -> @_$dom

class Message
  constructor: ($messageDom) ->
    @_id = $messageDom.attr "id"
    @_$dom = $messageDom

    likeButton = new LikeButton "Like"
    @_add_button likeButton
    @_add_button_listener likeButton

  _add_button: (button) ->
    wrapper = @_$subject_dom.children().first()
    unless wrapper.hasClass "a4X"
      wrapper = jQuery "<div class='a4X'></div>"
      wrapper.attr "style", "padding-right:12ex;"
      @_$subject_dom.children().wrap wrapper
    @_$subject_dom.children().first().append button.$dom

  _add_button_listener: (button) ->
    button.$dom.on "click", =>
      emailMessage = new Google.EmailMessage(this)
      emailMessage.body = "I like this!"
      Google.Gmail.sendMessage "me", emailMessage, (response) ->
        console.log "Finished sending the email:", response

  @getter "_$sender_dom", -> @_$dom.find ".yX.xY"
  @getter "_$subject_dom", -> @_$dom.find ".xY.a4W"
  @getter "_$date_dom", -> @_$dom.find ".xW.xY"

  # TODO: change to yP?
  @getter "id", -> @_id
  @getter "senderName", -> @_$sender_dom.find(".yW").children().first().text()
  @getter "senderEmail", -> @_$sender_dom.find(".yW").children().first().attr("email")
  @getter "subject", -> @_$subject_dom.find(".y6").children().first().text()
  @getter "preview", -> @_$subject_dom.find(".y2").text()
  @getter "date", -> @_$date_dom.children().first().attr "title" # TODO: Date class?

class LikeButton
  constructor: (label) ->
    @_$dom = jQuery "<a href='#'>#{label}</a>"
    @_$dom.addClass "aKS"

  @getter "$dom", -> @_$dom

module.exports = Inbox
