ExtensionMessage = require "./email-grind/extension-message"

chrome.runtime.onMessageExternal.addListener (request, sender, sendResponse) ->
  switch request.type
    when ExtensionMessage.GET_CLIENT_ID_JSON
      console.debug "-> Received message from page:",
        "'#{ExtensionMessage.GET_CLIENT_ID_JSON}'"
      _read_file request.clientIdPath, (object) ->
        console.debug "-> Got file:", object
        sendResponse JSON.parse(object)
      return true
    # TODO: Get generic HTML?
    when ExtensionMessage.GET_AUTH_HTML
      console.debug "-> Received message from page:",
        "'#{ExtensionMessage.GET_AUTH_HTML}'"
      _read_file request.authHtmlPath, (html) ->
        console.debug "-> Got file:", html
        sendResponse html
      return true

_read_file = (filePath, callback) ->
  console.debug "-> Getting file from the file system:", "./#{filePath}"
  chrome.runtime.getPackageDirectoryEntry (root) ->
    root.getFile filePath, create: false, (entry) ->
      entry.file (file) ->
        reader = new FileReader()
        reader.onloadend = (event) ->
          data = reader.result
          callback data
        reader.readAsText file
      , ->
        console.error "There was an error reading the file:", "./#{filePath}"
    , ->
      console.error "Could not find file:", "./#{filePath}"
