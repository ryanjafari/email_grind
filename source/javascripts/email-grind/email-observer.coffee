class EmailObserver
  constructor: (inbox) ->
    @_inbox = inbox
    @_message_added_callback = null
    @_message_removed_callback = null

  watch: ->
    observer = new MutationObserver (mutations) => @_mutation_handler(mutations)
    targetNode = document.querySelector @_inbox.$dom.selector
    observer.observe targetNode, childList: true

  on: (event, callback) ->
    switch event
      when "messageAdded"
        @_message_added_callback = callback
      when "messageRemoved"
        @_message_removed_callback = callback

  _mutation_handler: (mutations) ->
    mutations.forEach (mutation) =>
      if mutation.type == "childList"
        if mutation.addedNodes.length
          console.debug "-> A message was added..."
          $addedMessagesDom = mutation.addedNodes
          for $addedMessageDom in $addedMessagesDom
            @_message_added_callback $addedMessageDom
        if mutation.removedNodes.length
          console.debug "-> A message was removed..."
          $removedMessagesDom = mutation.removedNodes
          for $removedMessageDom in $removedMessagesDom
            @_message_removed_callback $removedMessageDom

module.exports = EmailObserver
