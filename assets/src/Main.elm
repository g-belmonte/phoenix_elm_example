import Browser
import Browser.Navigation as Navigation
import Html as H exposing (Html, text)
import Html.Attributes as A
import Html.Events as E
import Http
import Json.Decode as Decode
import Json.Encode as Encode
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
    , userForm: UserForm
    }

init : () -> Url.Url -> Navigation.Key -> (Model, Cmd Msg)
init flags url key =
    (Model key url initUser initUserForm , Cmd.none)

initUser : User
initUser =
    { username = ""
    , state = Empty
    }

initUserForm : UserForm
initUserForm =
    { username = ""
    , password = ""
    }

type alias User =
    { username: String
    , state: UserState
    }

type UserState
    = Empty
    | Loading
    | Loaded

type alias UserForm =
    { username: String
    , password: String
    }

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
    | AuthRequest
    | GotAuth (Result Http.Error String)
    | EnteredUsername String
    | EnteredPassword String


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

        AuthRequest ->
            ( model, loginRequest model.userForm )

        GotAuth result ->
            case result of
                Ok username ->
                    let
                        user = { username = username, state = Loaded }
                    in
                        ( { model | user = user }
                        , Cmd.none
                        )

                Err _ ->
                    ( { model | user = initUser }
                    , Cmd.none
                    )

        EnteredUsername username ->
            updateUserForm (\form -> { form | username = username }) model

        EnteredPassword password ->
            updateUserForm (\form -> { form | password = password }) model

updateUserForm: ( UserForm -> UserForm ) -> Model -> ( Model, Cmd Msg )
updateUserForm transform model =
    ( { model | userForm = transform model.userForm }, Cmd.none )



-- =============================================================================
--                                    HTTP
-- =============================================================================

loginRequest : UserForm -> Cmd Msg
loginRequest form =
    let
        data =
            Encode.object
                [ ( "username", Encode.string form.username )
                , ( "password", Encode.string form.password )
                ]
    in
        Http.post
            { url = "localhost:4000/auth"
            , body = Http.jsonBody data
            , expect = Http.expectJson GotAuth ( Decode.field "username" Decode.string )
            }


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
        [ viewNavbar model
        , viewBody model
        ]
    }

viewNavbar : Model -> Html Msg
viewNavbar model =
    H.nav []
        [ H.div [ A.class "nav-wrapper purple darken-1"]
              [ H.ul [ A.class "left" ]
                    [ H.li [] [ H.a [ A.href "/" ] [ H.i [ A.class "material-icons" ] [ text "home" ] ] ] ]
              , H.a [ A.href "#", A.class "brand-logo center" ] [ text "Logo" ]
              , H.ul [ A.class "right" ]
                  [ viewUser model.user
                  , H.li [] [ H.a [ A.href "#" ] [ H.i [ A.class "material-icons" ] [ text "person" ] ] ]
                  ]
              ]
        ]

viewUser : User -> Html Msg
viewUser user =
    case user.state of
        Empty ->
            H.li [] [ H.a [ A.href "login" ] [ text "Sign in" ] ]

        Loading ->
            H.li [] [ text "authenticating..." ]

        Loaded ->
            H.li [] [ text ("hello " ++ user.username ++ "!") ]



viewBody : Model -> Html Msg
viewBody model =
    let
        route = Parser.parse routeParser
    in
        case route model.url of
            Just Feed ->
                viewFeed ()

            Just Login ->
                viewLogin model.userForm

            Nothing ->
                viewFeed ()


viewFeed : () -> Html Msg
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

viewLogin : UserForm -> Html Msg
viewLogin form =
    H.div [ A.class "row" ]
        [ H.form [ E.onSubmit AuthRequest, A.class "col s6 offset-s4" ]
              [ H.div [ A.class "row" ]
                    [ H.div [ A.class "input-field col s6" ]
                          [ H.input [ A.name "username", A.type_ "text", A.value form.username, A.class "validate", E.onInput EnteredUsername ] []
                          , H.label [ A.for "username"] [ text "Username" ]
                          ]
                    ]
              , H.div [ A.class "row" ]
                    [ H.div [ A.class "input-field col s6" ]
                          [ H.input [ A.name "password", A.type_ "password", A.value form.password, A.class "validate", E.onInput EnteredPassword] []
                          , H.label [ A.for "password"] [ text "Password" ]
                          ]
                    ]
              , H.div [ A.class "row" ]
                  [ H.button [ A.class "btn waves-effect waves-light", A.type_ "submit" ]
                        [ text "Submit"
                        , H.i [ A.class "material-icons right" ] [ text "send" ]
                        ]
                  ]
              ]
        ]
