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
  constructor: (serverMessages, $inboxDom) ->
    @_messages = []
    @_$dom = $inboxDom

    $domMessages = @_$dom.children()
    for serverMessage, index in serverMessages
      @addMessage serverMessage, $domMessages[index]

  addMessage: (serverMessage, $domMessage) ->
    message = new Message serverMessage, jQuery($domMessage)
    @_messages.push message

  removeMessage: ($message) ->
    $messageToRemove = jQuery.grep @_messages, (m) -> m.id == $message.id
    indexOfMessageToRemove = @_messages.indexOf $messageToRemove
    @_messages.splice indexOfMessageToRemove, 1

  # TODO: We can use instance variables
  # since we don't require computation.
  getMessages: ->
    @_messages

  @getter "$dom", -> @_$dom

class Message
  constructor: (serverMessage, $domMessage) ->
    @serverId = serverMessage.id
    @_dom_id = $domMessage.attr "id"
    @_$dom = $domMessage


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
      Google.Gmail.getMessage "me", @serverId, (message) ->
        console.log "Finished getting the email:", message
        emailMessage = new Google.EmailMessage(message, button.message)
        # Google.Gmail.sendMessage "me", emailMessage, (response) ->
          # console.log "Finished sending the email:", response

  # @getter "_$sender_dom", -> @_$dom.find ".yX.xY"
  @getter "_$subject_dom", -> @_$dom.find ".xY.a4W"
  # @getter "_$date_dom", -> @_$dom.find ".xW.xY"

  # TODO: change to yP?
  # @getter "id", -> @_id
  # @getter "senderName", -> @_$sender_dom.find(".yW").children().first().text()
  # @getter "senderEmail", -> @_$sender_dom.find(".yW").children().first().attr("email")
  # @getter "subject", -> @_$subject_dom.find(".y6").children().first().text()
  # @getter "preview", -> @_$subject_dom.find(".y2").text()
  # @getter "date", -> @_$date_dom.children().first().attr "title" # TODO: Date class?

class LikeButton
  constructor: (label) ->
    @_$dom = jQuery "<a href='#'>#{label}</a>"
    @_$dom.addClass "aKS"
    @message = "I like this!"

  @getter "$dom", -> @_$dom

module.exports = Inbox
