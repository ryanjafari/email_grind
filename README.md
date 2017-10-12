# email_grind
Chrome extension for quick replying to Gmail emails

## Status
PRs welcome; not being actively maintained.

## What is this?
Hey! Thanks for asking! This is a Chrome extension for Gmail that simply appends a few buttons to the right of subject lines in the Gmail inbox, enabling quick replies. Surely you must know those times where you just want to quickly respond to an email, especially when you can see the message body preview, and someone says something like: "See you then!" and you just want to be like: "Thanks!" Imagine if there were buttons like:

- :white_check_mark: Thanks!
- :thumbsup: Like.
- :smile: Smile

...right inline in the message inbox without even having to drill down into the individual message! Inbox zero here we come, right?!

## Notable tech involved
- Gulp.js
- CoffeeScript (remember that?)
- Gmail API

## Why's it called "email_grind"?
It was a labor of love. The idea was pitched to me by a few business buddies of mine and I decided to start cranking on this during the evenings. A nightly grind, although I guess that doesn't really sound like love. Didn't get terribly far on it, but did get authentication working and buttons to display. 

## Challenges
- Gmail's HTML markup is obfuscated/compressed/minified.
- Gmail's message API was difficult to understand.
- Had issues with buttons disappearing when a new message came in on that same thread.
- I'm left wondering if there was an easier way to do this?

## Shame
There are debug statements and commented out code snippets in these commits. I am very sorry.

## Up next
I stopped right at the point of actually sending the emails, so in theory that's all that needs to be done to get this going. Gmail's API seems to be very particular about the email being just right before allowing you to send it. I was fussing with it a bunch.
