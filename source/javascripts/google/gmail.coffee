class Gmail
  constructor: ->
    console.debug "Constructed Gmail"

  # _load_gmail_api: ->
  #   console.debug "Loading Gmail API..."
  #   gapi.client.load "gmail", "v1", listLabels

module.exports = Gmail
