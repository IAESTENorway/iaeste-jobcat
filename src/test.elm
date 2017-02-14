module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, src, attribute)
import Html.Events exposing (onClick)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Json.Decode as Decode exposing (Decoder)


type alias Flags =
    { json : String
    }


type alias Model =
    { allJobs : List Job
    , currentJobs : List Job
    }



{- Definer Filter som en union av predikater som filtrerer på ulike felter -}


type Msg
    = None
    | RunFiltering JobFilterList
    | Reset


type alias JobFilterList =
    List (Job -> Bool)


type alias LanguageList =
    { tuple1 : LanguageTuple
    , connector1 : String
    , tuple2 : LanguageTuple
    , connector2 : String
    , tuple3 : LanguageTuple
    }


type alias LanguageTuple =
    { language : String
    , knowledgeLevel : String
    }


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
    , languages : LanguageList
    , currency : String
    , payment : Int
    , paymentFreq : String
    , deduction : String
    , livingcost : Int
    , livingcostFreq : String
    }


main : Program Flags Model Msg
main =
    Html.programWithFlags { init = init, subscriptions = subscriptions, view = view, update = update }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model (decodeJobs flags.json) (decodeJobs flags.json), Cmd.none )


subscriptions : a -> Sub msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "main container" ]
        [ button [ onClick (RunFiltering [ (\job -> job.hoursDaily <= 7), (\job -> job.country == "Poland") ]) ]
            [ text ("Filter") ]
        , button [ onClick Reset ] [ text ("Reset filters") ]
        , ul
            [ class "collapsible popout", attribute "data-collapsible" "accordion" ]
            (buildDivs model.currentJobs)
        ]


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        RunFiltering filters ->
            ( filterModel filters model, Cmd.none )

        Reset ->
            ( { model | currentJobs = model.allJobs }, Cmd.none )



{- Takes a filtering predicate and updates the model by applying it
   on the list of all jobs, to obtain a list of 'current' jobs
-}


filterModel : JobFilterList -> Model -> Model
filterModel filterList model =
    case filterList of
        filterPredicate :: filters ->
            applyFilter filterPredicate (filterModel filters model)

        [] ->
            { allJobs = model.allJobs, currentJobs = model.allJobs }


applyFilter : (Job -> Bool) -> Model -> Model
applyFilter filterPredicate model =
    { allJobs = model.allJobs, currentJobs = (List.filter filterPredicate model.currentJobs) }


boolStudyLvl : String -> Bool
boolStudyLvl value =
    value == "Yes"



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
        |> custom languageDecoder
        |> required "Currency" string
        |> required "Payment" int
        |> required "PaymentFrequency" string
        |> required "Deduction" string
        |> required "LivingCost" int
        |> required "LivingCostFrequency" string


languageDecoder : Decoder LanguageList
languageDecoder =
    decode LanguageList
        |> custom (langTupleDecoder ( "Language1", "Language1Level" ))
        |> required "Language1or" string
        |> custom (langTupleDecoder ( "Language2", "Language2Level" ))
        |> required "Language2or" string
        |> custom (langTupleDecoder ( "Language3", "Language3Level" ))


langTupleDecoder : ( String, String ) -> Decoder LanguageTuple
langTupleDecoder ( langfield, levelField ) =
    decode LanguageTuple
        |> required langfield string
        |> required levelField string


decodeJobs : String -> List Job
decodeJobs jsonString =
    Result.withDefault [] (decodeString (list jobDecoder) jsonString)


formatJobLanguages : LanguageList -> String
formatJobLanguages { tuple1, connector1, tuple2, connector2, tuple3 } =
    formatLanguageTuple Nothing tuple1
        ++ " "
        ++ formatLanguageTuple (Just connector1) tuple2
        ++ " "
        ++ formatLanguageTuple (Just connector2) tuple3


formatLanguageTuple : Maybe String -> LanguageTuple -> String
formatLanguageTuple connector languageTuple =
    case languageTuple.language of
        "N/A" ->
            ""

        _ ->
            String.toLower (Maybe.withDefault "" connector)
                ++ " "
                ++ languageTuple.language
                ++ " : "
                ++ languageTuple.knowledgeLevel


buildDivs : List Job -> List (Html Msg)
buildDivs list =
    case list of
        head :: tail ->
            buildJobPreviewElement head :: buildDivs tail

        _ ->
            []


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
            , buildFullJobElement job
            ]
        ]


buildFullJobElement : Job -> Html Msg
buildFullJobElement job =
    div [ class "tables" ]
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
                        , (td [] [ text (formatJobLanguages job.languages) ])
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
