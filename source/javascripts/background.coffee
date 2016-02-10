Request = require "./request"

chrome.runtime.onMessageExternal.addListener (request, sender, sendResponse) ->
  if request.type == Request.GET_CLIENT_ID_JSON
    _get_client_id_json request.clientIdPath, (data) ->
      sendResponse JSON.parse(data)
    return true

_get_client_id_json = (clientIdPath, callback) ->
  chrome.runtime.getPackageDirectoryEntry (root) ->
    root.getFile clientIdPath, { create: false }, (entry) ->
      entry.file (file) ->
        reader = new FileReader()
        reader.onloadend = (event) ->
          data = reader.result
          callback data
        reader.readAsText file
