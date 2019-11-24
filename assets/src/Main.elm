import Browser
import Browser.Navigation as Navigation
import Html as H exposing (Html, text)
import Html.Attributes as A
import Http
import Url
import Url.Parser as Parser exposing (Parser, (</>), oneOf)

-- =============================================================================
--                                    MAIN
-- =============================================================================


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


-- =============================================================================
--                                   MODEL
-- =============================================================================


type alias Model =
    { key : Navigation.Key
    , url : Url.Url
    , user: User
    }

init : () -> Url.Url -> Navigation.Key -> (Model, Cmd Msg)
init flags url key =
    (Model key url {username = "", state = Empty} , Cmd.none)

type alias User =
    { username: String
    , state: UserState
    }

type UserState
    = Empty
    | Loading
    | Loaded

-- =============================================================================
--                                   ROUTER
-- =============================================================================

type Route
    = Feed
    | Login

routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Parser.map Feed Parser.top
        , Parser.map Login (Parser.s "login")
        ]

-- =============================================================================
--                                   UPDATE
-- =============================================================================


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
             ( { model | url = url }
             , Cmd.none
             )


-- =============================================================================
--                               SUBSCRIPTIONS
-- =============================================================================


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


-- =============================================================================
--                                    VIEW
-- =============================================================================


view : Model -> Browser.Document Msg
view model =
    { title = "Phoenix and Elm"
    , body =
        [ viewNavbar ()
        , viewBody model.url
        ]
    }

viewNavbar : () -> Html msg
viewNavbar _ =
    H.nav []
        [ H.div [ A.class "nav-wrapper purple darken-1"]
              [ H.ul [ A.class "left" ]
                    [ H.li [] [ H.a [ A.href "/" ] [ H.i [ A.class "material-icons" ] [ text "home" ] ] ] ]
              , H.a [ A.href "#", A.class "brand-logo center" ] [ text "Logo" ]
              , H.ul [ A.class "right" ]
                  [ H.li [] [ H.a [ A.href "login" ] [ text "Sign in" ] ]
                  , H.li [] [ H.a [ A.href "#" ] [ H.i [ A.class "material-icons" ] [ text "person" ] ] ]
                  ]
              ]
        ]

viewBody : Url.Url -> Html msg
viewBody url =
    let
        route = Parser.parse routeParser
    in
        case route url of
            Just Feed ->
                viewFeed ()

            Just Login ->
                viewLogin ()

            Nothing ->
                viewFeed ()


viewFeed : () -> Html msg
viewFeed _ =
    H.div []
        [ H.table []
              [ H.thead []
                    [ H.tr []
                          [ H.th [] [ text "Post" ]
                          , H.th [] [ text "Author" ]
                          ]
                    ]
              , H.tbody []
                  [ H.tr []
                        [ H.td [] [ text "this is my post" ]
                        , H.td [] [ text "Belmonte" ]
                        ]
                  ]
              ]
        ]

viewLogin : () -> Html msg
viewLogin _ =
    H.div [ A.class "row" ]
        [ H.form [ A.action "#", A.class "col s6 offset-s4" ]
              [ H.div [ A.class "row" ]
                    [ H.div [ A.class "input-field col s6" ]
                          [ H.input [ A.id "username", A.type_ "text", A.class "validate" ] []
                          , H.label [ A.for "username"] [ text "Username" ]
                          ]
                    ]
              , H.div [ A.class "row" ]
                    [ H.div [ A.class "input-field col s6" ]
                          [ H.input [ A.id "password", A.type_ "password", A.class "validate" ] []
                          , H.label [ A.for "password"] [ text "Password" ]
                          ]
                    ]
              , H.div [ A.class "row" ]
                  [ H.button [ A.class "btn waves-effect waves-light", A.type_ "submit", A.name "action" ]
                        [ text "Submit"
                        , H.i [ A.class "material-icons right" ] [ text "send" ]
                        ]
                  ]
              ]
        ]
