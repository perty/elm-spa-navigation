module Main exposing (..)

import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (onInput)
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
    | NotFound



-- UPDATE


type Msg
    = FollowRoute Route


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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


postsParser : UrlParser.Parser a a
postsParser =
    UrlParser.s "posts"


homeParser : UrlParser.Parser a a
homeParser =
    UrlParser.oneOf
        [ UrlParser.s "index.html"
        , UrlParser.s ""
        ]


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map HomeRoute homeParser
        ]



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "overflow-container" ]
        [ case model.route of
            HomeRoute ->
                notImplementedYetPage model

            NotFound ->
                notFoundPage model
        ]


notImplementedYetPage : Model -> Html Msg
notImplementedYetPage model =
    div [] [ text ("This has not been implemented yet. ") ]


notFoundPage : Model -> Html Msg
notFoundPage model =
    div [] [ text "Not found" ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
