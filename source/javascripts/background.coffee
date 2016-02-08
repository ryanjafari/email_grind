chrome.runtime.onMessageExternal.addListener (request, sender, sendResponse) ->
  console.log "Request is:", request

  chrome.runtime.getPackageDirectoryEntry (root) ->
    root.getFile "client_id.json", { create: false }, (entry) ->
      entry.file (file) ->
        console.log "entry.file"
        reader = new FileReader()
        reader.onloadend = (event) ->
          console.log "reader.onloadend", reader.result
          data = reader.result
          sendResponse data
        reader.readAsText file


  return true
