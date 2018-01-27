# Elm SPA Navigation example

This is an empty example for my memory only.

It has a navigation bar that allows the user to think there are pages
while there is not, so called SPA.

It is easy enough to split an application's pages in Elm using an indicator
in the model. The trick is to support the back button in the browser
which requires url parsing. As a bonus, you get bookmarkable pages.

In this example, the model has only one value, the route which indicates
the page the user is on.

The route is determined on startup so that users can land directly on, 
for example, the contact page by appending "/contact".

When the user clicks on a menu item or the list of posts, the Navigation.newUrl
function appends the url to the browser history and sends it to the same
URL parser that is used for the landing page handling. 

The parser responds with a new message "FollowRoute" and the update 
function then updates the route value of the model.

When the URL is "/post/n" where n is an integer, the route will have
the value (PostRoute n), demonstrating Elm's union type. 

## scripts

### install.sh

Runs npm install which is necessary for running the stand alone
Express server. 

Runs elm package install so that the Elm packages are installed.

### run.sh

Runs elm-make and then starts the Express server on 
[http://localhost:3000](http://localhost:3000)

There is always the alternative of running elm-react, of course.
