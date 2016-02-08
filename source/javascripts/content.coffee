s = document.createElement "script"
s.src = chrome.extension.getURL "javascripts/main.js"
(document.head || document.documentElement).appendChild s
