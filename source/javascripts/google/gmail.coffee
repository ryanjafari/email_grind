class Gmail
  constructor: ->
    console.debug "Constructed Gmail API..."

  loadGmailApi: ->
    console.log "Loading Gmail API..."
    gapi.client.load "gmail", "v1", @_list_labels

  _list_labels: ->
    console.log "Listing labels..."

module.exports = Gmail
