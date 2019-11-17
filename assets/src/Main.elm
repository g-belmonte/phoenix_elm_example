import Browser
import Browser.Navigation as Navigation
import Html as H exposing (Html, text)
import Html.Attributes as A
import Url

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
    }


init : () -> Url.Url -> Navigation.Key -> (Model, Cmd Msg)
init flags url key =
    ( Model key url, Cmd.none)


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
        , viewFeed ()
        ]
    }

viewNavbar : () -> Html msg
viewNavbar _ =
    H.nav []
        [ H.div [ A.class "nav-wrapper purple darken-1"]
              [ H.ul [ A.class "left" ]
                    [ H.li [] [ H.a [ A.href "#" ] [ H.i [ A.class "material-icons" ] [ text "menu" ] ] ] ]
              , H.a [ A.href "#", A.class "brand-logo center" ] [ text "Logo" ]
              , H.ul [ A.class "right" ]
                  [ H.li [] [ H.a [ A.href "#" ] [ H.i [ A.class "material-icons" ] [ text "person" ] ] ] ]
              ]
        ]

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
