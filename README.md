# Elm SPA Navigation example

This is an empty example for my memory only.

It has a navigation bar that allows the user to think there are pages
while there is not, so called SPA.

It is easy enough to split an application in Elm using an indicator
in the model. The trick is to support the back button in the browser
which requires url parsing. As a bonus, you get bookmarkable pages.

## scripts

### install.sh

Runs npm install which is necessary for running the stand alone
Express server. 

Runs elm package install so that the Elm packages are installed.

### run.sh

Runs elm-make and then starts the Express server on 
[http://localhost:3000](http://localhost:3000)

There is always the alternative of running elm-react, of course.
