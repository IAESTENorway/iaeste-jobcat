module SideNav exposing (..)

import Material
import Html exposing (..)
import Material.Layout as Layout


type alias Model =
    { mdl :
        Material.Model
        -- Boilerplate
    }


model : Model
model =
    { mdl = Material.model }


type Msg
    = Mdl (Material.Msg Msg)



-- Boilerplate


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Layout.sub0 Mdl )
        , subscriptions = subscriptions
        , view = view
        , update = update
        }


subscriptions : a -> Sub msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Mdl matMsg ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        []
        { header = []
        , drawer = drawer
        , tabs = ( [], [] )
        , main = []
        }


drawer : List (Html Msg)
drawer =
    [ Layout.title [] [ text "Example drawer" ]
    , Layout.navigation
        []
        [ Layout.link
            [ Layout.href "https://github.com/debois/elm-mdl" ]
            [ text "github" ]
        , Layout.link
            [ Layout.href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
            [ text "elm-package" ]
        , Layout.link
            [ Layout.href "#cards" ]
            [ text "Card component" ]
        ]
    ]
