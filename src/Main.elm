module Main exposing (..)

import Html exposing (Html, div, input, label, text, h1, nav, ul, li)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (onClick)
import Navigation
import UrlParser exposing ((</>))


main : Program Never Model Msg
main =
    Navigation.program urlParser
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { route : Route
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    }



-- Start from a location, not necessarily "/".


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( initialModel (findRouteOrGoHome location), Cmd.none )


findRouteOrGoHome : Navigation.Location -> Route
findRouteOrGoHome location =
    case Debug.log "Landing on: " (UrlParser.parsePath routeParser location) of
        Nothing ->
            HomeRoute

        Just route ->
            route



-- ROUTES


type Route
    = HomeRoute
    | PostRoute Int
    | ContactRoute
    | LoginRoute
    | NotFound



-- UPDATE


type Msg
    = FollowRoute Route
    | ViewHomePage
    | ViewPostPage Int
    | ViewContactPage
    | ViewLoginPage



-- First we get the message to view a selected page. We set the URL by calling newUrl.
-- The new URL is parsed which results in a new message FollowRoute that sets the route
-- value in the model. The route value controls the view.
-- By doing this, we enable the browser history, bookmarks and show the url in the address bar.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Update message: " msg of
        ViewHomePage ->
            ( model, Navigation.newUrl "/" )

        ViewPostPage post ->
            ( model, Navigation.newUrl ("/post/" ++ toString post) )

        ViewContactPage ->
            ( model, Navigation.newUrl "/contact" )

        ViewLoginPage ->
            ( model, Navigation.newUrl "/login" )

        FollowRoute route ->
            ( { model | route = route }, Cmd.none )



-- PARSING
-- The URL parser mentioned in the program entry point. Takes a Location and
-- parse it to see where to go next.


urlParser : Navigation.Location -> Msg
urlParser location =
    let
        l =
            Debug.log "location" location

        parsed =
            UrlParser.parsePath routeParser location
    in
        case Debug.log "parsed" parsed of
            Nothing ->
                FollowRoute NotFound

            Just route ->
                FollowRoute route



-- Try all parsers we have. The first parser to say yes will determine the route value.


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map HomeRoute homeParser
        , UrlParser.map PostRoute postParser
        , UrlParser.map ContactRoute contactParser
        , UrlParser.map LoginRoute loginParser
        ]


homeParser : UrlParser.Parser a a
homeParser =
    UrlParser.oneOf
        [ UrlParser.s "index.html"
        , UrlParser.s ""
        ]


postParser : UrlParser.Parser (Int -> a) a
postParser =
    UrlParser.s "post" </> UrlParser.int


contactParser : UrlParser.Parser a a
contactParser =
    UrlParser.s "contact"


loginParser : UrlParser.Parser a a
loginParser =
    UrlParser.s "login"



-- VIEW
-- In this example, we have a header at the top, a menu bar below and then the page specific content.


view : Model -> Html Msg
view model =
    div [ class "overflow-container" ]
        [ header
        , menuBar
        , selectPage model
        ]


header : Html Msg
header =
    div [] [ h1 [] [ text "Header" ] ]


menuBar : Html Msg
menuBar =
    nav [ class "menu-bar" ]
        [ div [ class "menu-item", onClick ViewHomePage ] [ text "home" ]
        , div [ class "menu-item", onClick ViewContactPage ] [ text "contact" ]
        , div [ class "menu-item menu-item-end", onClick ViewLoginPage ] [ text "login" ]
        ]



-- Determine the page based on the route value


selectPage : Model -> Html Msg
selectPage model =
    case Debug.log "Select page: " model.route of
        HomeRoute ->
            homePage model

        PostRoute post ->
            postPage model post

        ContactRoute ->
            contactPage model

        LoginRoute ->
            loginPage model

        NotFound ->
            notFoundPage model


homePage : Model -> Html Msg
homePage model =
    div []
        [ text ("This is the home page. ")
        , theListOfPosts
        ]


postPage : Model -> Int -> Html Msg
postPage model post =
    div [] [ text ("This is the post number " ++ toString post) ]


contactPage : Model -> Html Msg
contactPage model =
    div [] [ text ("This is the contact page. ") ]


loginPage : Model -> Html Msg
loginPage model =
    div [] [ text ("This is the login page. ") ]


notFoundPage : Model -> Html Msg
notFoundPage model =
    div [] [ text "Not found" ]


theListOfPosts =
    div []
        (List.map postLink (List.range 1 11))


postLink n =
    div [ onClick (ViewPostPage n) ] [ text ("Post number " ++ toString n) ]



-- SUBSCRIPTIONS
-- No subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
