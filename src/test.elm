module Main exposing (..)

import Html exposing (Html, button, div, text, img, p, a, h1, h2)
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
    div [ class "main container" ] (buildDivs (decodeJobs model.jsonString))


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
    div [ class "job card row" ]
        [ (div [ class "country col s2" ]
            [ img [ src ("res/" ++ job.country ++ ".jpg") ] [ text ("") ]
            , p [ class "col s1" ] [ text (job.country) ]
            ]
          )
        , (h2 [ class "employer col s7" ] [ text ("" ++ job.employer) ])
        , (div [ class "faculty col s2" ] [ text (job.faculty) ])
        , (div [ class "arrow col s1" ]
            [ img [ src ("res/arrow.jpg") ] []
            ]
          )
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
