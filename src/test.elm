module Main exposing (..)

import Html exposing (Html, button, div, text, img, p, a)
import Html.Attributes exposing (class, src)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


main : Program Flags Model Msg
main =
    Html.programWithFlags { init = init, subscriptions = subscriptions, view = view, update = update }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model flags.json, Cmd.none )


subscriptions : a -> Sub msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "main" ] (buildDivs (decodeJobs model.jsonString))


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )


type alias Flags =
    { json : String
    }


type alias Model =
    { jsonString : String
    }


type Msg
    = None


buildDivs : List Job -> List (Html Msg)
buildDivs list =
    case list of
        head :: tail ->
            buildJobPreviewElement head :: buildDivs tail

        _ ->
            []


type alias Job =
    { country : String
    , refNo : String
    , employer : String
    , website : String
    , workkind : String
    , faculty : String
    }


buildJobPreviewElement : Job -> Html Msg
buildJobPreviewElement job =
    div [ class "job" ]
        [ (div [ class "country" ]
            [ img [ src ("res/" ++ job.country ++ ".jpg") ] []
            , text ("Country: " ++ job.country)
            ]
          )
        , (div [ class "employer" ] [ text ("Employer: " ++ job.employer) ])
        , (div [ class "faculty" ] [ text ("Faculties: " ++ job.faculty) ])
        ]


jobDecoder : Decoder Job
jobDecoder =
    decode Job
        |> required "Country" string
        |> required "Ref.No" string
        |> required "Employer" string
        |> required "Website" string
        |> required "Workkind" string
        |> required "Faculty" string


decodeJobs : String -> List Job
decodeJobs jsonString =
    Result.withDefault [] (decodeString (list jobDecoder) jsonString)
