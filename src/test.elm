module Main exposing (..)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style, class)
import Json.Decode exposing (..)


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- model


type alias Model =
    Int


model : Model
model =
    0


json : String
json =
    """[
    {
    "Ref.No": "AT-2017-000405",
    "Country": "Austria",
    "Year": 2017,
    "Deadline": "2017-03-31",
    "Expire": "2017-03-31"
  },
  {
    "Ref.No": "BE-2017-000001",
    "Country": "Belgium",
    "Year": 2017,
    "Deadline": "2017-03-31",
    "Expire": "2017-03-31"
  }
  ]"""



--update


type Msg
    = Increment
    | Decrement
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1

        Reset ->
            model - model



--VIEW


view : Model -> Html Msg
view model =
    div [] (buildDivs (decode json))


buildDivs : List String -> List (Html Msg)
buildDivs list =
    case list of
        head :: tail ->
            buildDiv head :: buildDivs tail

        _ ->
            []


buildDiv : String -> Html Msg
buildDiv input =
    div [ style [ ( "background", "pink" ) ], class "country" ] [ text input ]


decode : String -> List String
decode input =
    Result.withDefault [] (decodeString (list (field "Country" string)) input)
