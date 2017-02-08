module Main exposing (..)

import Html exposing (Html, button, div, text, p)
import Html.Attributes exposing (class)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


main : Program Flags Model Msg
main =
    Html.programWithFlags { init = init, subscriptions = subscriptions, view = view, update = update }


subscriptions : a -> Sub msg
subscriptions model =
    Sub.none



-- model


type alias Flags =
    { json : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model flags.json, Cmd.none )


type alias Model =
    { json : String
    }


type alias Job =
    { country : String
    , refNo : String
    , employer : String
    , workkind : String
    }



--update


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )



--VIEW


view : Model -> Html Msg
view model =
    div [] (buildDivs (decodeJobs model.json))


buildDivs : List Job -> List (Html Msg)
buildDivs list =
    case list of
        head :: tail ->
            buildJobElement head :: buildDivs tail

        _ ->
            []


buildJobElement : Job -> Html Msg
buildJobElement job =
    div [ class "job" ]
        [ (p [ class "country" ] [ text ("Country: " ++ job.country) ])
        , (p [ class "employer" ] [ text ("Employer: " ++ job.employer) ])
        , (p [ class "refNo" ] [ text ("Ref.No: " ++ job.refNo) ])
        , (p [ class "workkind" ] [ text ("Workkind: " ++ job.workkind) ])
        ]


decodeTest : String -> List String
decodeTest input =
    Result.withDefault [ "Errors" ] (decodeString (list (field "Country" string)) input)


jobDecoder : Decoder Job
jobDecoder =
    decode Job
        |> required "Country" string
        |> required "Ref.No" string
        |> required "Employer" string
        |> required "Workkind" string


decodeJobs : String -> List Job
decodeJobs json =
    Result.withDefault [] (decodeString (list jobDecoder) json)
