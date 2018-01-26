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


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        l =
            Debug.log "init location" location

        route =
            case UrlParser.parsePath routeParser location of
                Nothing ->
                    HomeRoute

                Just route ->
                    route
    in
        ( initialModel route, Cmd.none )



-- ROUTES


type Route
    = HomeRoute
    | ContactRoute
    | LoginRoute
    | NotFound



-- UPDATE


type Msg
    = FollowRoute Route
    | ViewHomePage
    | ViewContactPage
    | ViewLoginPage



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "message" msg of
        ViewHomePage ->
            ( model, Navigation.newUrl "/" )

        ViewContactPage ->
            ( model, Navigation.newUrl "contact" )

        ViewLoginPage ->
            ( model, Navigation.newUrl "login" )

        FollowRoute route ->
            ( { model | route = route }, Cmd.none )



-- PARSING


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


homeParser : UrlParser.Parser a a
homeParser =
    UrlParser.oneOf
        [ UrlParser.s "index.html"
        , UrlParser.s ""
        ]

contactParser : UrlParser.Parser a a
contactParser =
    UrlParser.s "contact"

loginParser : UrlParser.Parser a a
loginParser =
    UrlParser.s "login"



routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map HomeRoute homeParser
        , UrlParser.map ContactRoute contactParser
        , UrlParser.map LoginRoute loginParser
        ]



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "overflow-container" ]
        [ div [] [ header ]
        , navbar
        , div [] [ selectPage model ]
        ]


header : Html Msg
header =
    h1 [] [ text "Header" ]


navbar : Html Msg
navbar =
    nav [ class "menu-bar" ]
        [ div [ class "menu-item", onClick ViewHomePage ] [ text "home" ]
        , div [ class "menu-item", onClick ViewContactPage ] [ text "contact" ]
        , div [ class "menu-item menu-item-end", onClick ViewLoginPage ] [ text "login" ]
        ]


selectPage : Model -> Html Msg
selectPage model =
    case model.route of
        HomeRoute ->
            homePage model

        ContactRoute ->
            contactPage model

        LoginRoute ->
            loginPage model

        NotFound ->
            notFoundPage model


homePage : Model -> Html Msg
homePage model =
    div [] [ text ("This is the home page. ") ]


contactPage : Model -> Html Msg
contactPage model =
    div [] [ text ("This is the contact page. ") ]


loginPage : Model -> Html Msg
loginPage model =
    div [] [ text ("This is the login page. ") ]


notFoundPage : Model -> Html Msg
notFoundPage model =
    div [] [ text "Not found" ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
