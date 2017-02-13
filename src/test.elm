module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, src, attribute)
import String exposing (append)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Json.Decode as Decode exposing (Decoder)


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
    div [ class "main container" ]
        [ ul [ class "collapsible popout", attribute "data-collapsible" "accordion" ] (buildDivs (decodeJobs model.jsonString))
        ]


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
    { refNo : String
    , country : String
    , workplace : String
    , business : String
    , airport : String
    , employer : String
    , employees : Int
    , hoursWeekly : Float
    , hoursDaily : Float
    , faculty : String
    , special : String
    , trainingReq : String
    , otherReq : String
    , workkind : String
    , weeksMin : Int
    , weeksMax : Int
    , to : String
    , from : String
    , study_begin : String
    , study_middle : String
    , study_end : String
    , lang1 : String
    , lang1lev : String
    , lang1or : String
    , lang2 : String
    , lang2lev : String
    , lang2or : String
    , lang3 : String
    , lang3lev : String
    , currency : String
    , payment : Int
    , paymentFreq : String
    , deduction : String
    , livingcost : Int
    , livingcostFreq : String
    }


buildJobPreviewElement : Job -> Html Msg
buildJobPreviewElement job =
    li []
        [ div [ class "collapsible-header row waves-effect" ]
            [ (div [ class "country col s2" ]
                [ img [ src ("../res/flags/" ++ job.country ++ ".png") ] [ text ("") ]
                , p [ class "col s1" ] [ text (job.country) ]
                ]
              )
            , (h2 [ class "employer col s7" ] [ text (job.employer) ])
            , (div [ class "faculty col s2" ] [ text (job.faculty) ])
            , (div [ class "arrow col s1 " ]
                [ img [ src ("../res/img/arrow.svg") ] []
                ]
              )
            ]
          {- TODO: Refaktorerer collapsible-body i egen funksjon? Kommer til å bli dritlang pga table {-, (td [ class "td-workkind" ] [ text (job.workkind) ])-} -}
        , div [ class "collapsible-body" ]
            [ div [ class "work-desc" ]
                [ h4 [] [ text ("Jobbeskrivelse") ]
                , p [] [ text (job.workkind) ]
                ]
              {- dfsdfsdfdsfdsfhdskfdsfsdfsdfs -}
            , div [ class "tables" ]
                [ div [ class "table-wrapper" ]
                    [ table [ class "responsive-table table-1" ]
                        [ (thead []
                            [ tr []
                                [ (th [] [ text ("Arbeidssted") ])
                                , (th [] [ text ("Årstrinn") ])
                                , (th [] [ text ("Lønn") ])
                                , (th [] [ text ("Arbeidsuker") ])
                                , (th [] [ text ("Arbeidsperiode") ])
                                , (th [] [ text ("Språk") ])
                                , (th [] [ text ("Leve- og bokostnader") ])
                                , (th [] [ text ("Business") ])
                                , (th [] [ text ("Tidl. arb.erfaring") ])
                                ]
                            ]
                          )
                        , (tbody []
                            [ tr []
                                [ (td [] [ text (job.workplace) ])
                                , (td [] [ text (determineStudyLvl (boolStudyLvl job.study_begin) (boolStudyLvl job.study_middle) (boolStudyLvl job.study_end)) ])
                                , (td [] [ text (toString job.payment ++ " " ++ job.currency) ])
                                , (td [] [ text (toString job.weeksMin ++ " - " ++ toString job.weeksMax ++ " uker") ])
                                , (td [] [ text (job.from ++ " til " ++ job.to) ])
                                , {- Språkkrav, TODO: Refaktoreres som funksjon -} (td [] [ text (job.lang1 ++ ", " ++ job.lang1lev ++ " " ++ job.lang1or ++ " " ++ job.lang2 ++ ", " ++ job.lang2lev ++ " " ++ job.lang2or ++ " " ++ job.lang3 ++ ", " ++ job.lang3lev) ])
                                , (td [] [ text (job.currency ++ " " ++ toString job.livingcost ++ "/" ++ job.livingcostFreq) ])
                                , (td [] [ text (job.business) ])
                                , (td [] [ text (job.trainingReq) ])
                                ]
                            ]
                          )
                        ]
                    ]
                , div [ class "table-wrapper", attribute "id" "job-table-2" ]
                    [ table [ class "responsive-table table-1" ]
                        [ (thead []
                            [ tr []
                                [ (th [] [ text ("Flyplass") ])
                                , (th [] [ text ("Ansatte") ])
                                , (th [] [ text ("Arb.timer i uken") ])
                                , (th [] [ text ("Arb.timer daglig") ])
                                , (th [] [ text ("Skatt av lønn") ])
                                , (th [] [ text ("Andre krav") ])
                                ]
                            ]
                          )
                        , (tbody []
                            [ tr []
                                [ (td [] [ text (job.airport) ])
                                , (td [] [ text (toString job.employees) ])
                                , (td [] [ text (toString job.hoursWeekly ++ " timer i uken") ])
                                , (td [] [ text (toString job.hoursDaily ++ " timer dagen") ])
                                , (td [] [ text (job.deduction) ])
                                , (td [] [ text (job.otherReq) ])
                                ]
                            ]
                          )
                        ]
                    ]
                ]
            ]
        ]


boolStudyLvl : String -> Bool
boolStudyLvl value =
    if value == "Yes" then
        True
    else
        False



{- Horribel måte å gjøre det på, men når du suger så funker IF -}


determineStudyLvl : Bool -> Bool -> Bool -> String
determineStudyLvl lvlBegin lvlMiddle lvlEnd =
    if not lvlBegin && not lvlMiddle && lvlEnd then
        "7 eller flere semestere"
    else if lvlBegin && lvlMiddle && not lvlEnd then
        "1 - 6 semestere"
    else if lvlBegin && not lvlMiddle && not lvlEnd then
        "1 - 3 semestere"
    else if not lvlBegin && lvlMiddle && not lvlEnd then
        "4 - 6 semestere"
    else
        "Alle semestere"


jobDecoder : Decoder Job
jobDecoder =
    decode Job
        |> required "Ref.No" string
        |> required "Country" string
        |> required "Workplace" string
        |> required "Business" string
        |> required "Airport" string
        |> required "Employer" string
        |> required "Employees" int
        |> required "HoursWeekly" float
        |> required "HoursDaily" float
        |> required "Faculty" string
        |> required "Specialization" string
        |> required "TrainingRequired" string
        |> required "OtherRequirements" string
        |> required "Workkind" string
        |> required "WeeksMin" int
        |> required "WeeksMax" int
        |> required "To" string
        |> required "From" string
        |> required "StudyCompleted_Beginning" string
        |> required "StudyCompleted_Middle" string
        |> required "StudyCompleted_End" string
        |> required "Language1" string
        |> required "Language1Level" string
        |> required "Language1or" string
        |> required "Language2" string
        |> required "Language2Level" string
        |> required "Language2or" string
        |> required "Language3" string
        |> required "Language3Level" string
        |> required "Currency" string
        |> required "Payment" int
        |> required "PaymentFrequency" string
        |> required "Deduction" string
        |> required "LivingCost" int
        |> required "LivingCostFrequency" string


decodeJobs : String -> List Job
decodeJobs jsonString =
    Result.withDefault [] (decodeString (list jobDecoder) jsonString)
