module ViewGenerator exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, src, attribute)


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
                , p [] [ text (job.country) ]
                ]
              )
            , (h2 [ class "employer col s7" ] [ text (job.employer) ])
            , (div [ class "faculty col s2" ] [ text (String.join ", " job.faculties) ])
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
                        , (td [] [ text (job.employees) ])
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
