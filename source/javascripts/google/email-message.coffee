class EmailMessage
  constructor: (message) ->
    console.debug "-> Constructing email message..."
    @recipientName = message.senderName
    @recipientEmail = message.senderEmail
    @subject = message.subject
    @body = null

  lines: ->
    console.debug "-> Compiling email message in RFC5322 format..."
    emailLines = []
    emailLines.push "To: #{@recipientEmail}" # TODO Name <email>
    emailLines.push "Subject: #{@subject}"
    emailLines.push ""
    emailLines.push @body
    return emailLines.join("\r\n").trim()

module.exports = EmailMessage
