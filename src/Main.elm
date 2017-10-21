module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (onClick)
import App.Json exposing (..)
import App.Types exposing (..)
import App.ViewGenerator exposing (buildDivs)


main : Program Flags Model Msg
main =
    Html.programWithFlags { init = init, subscriptions = subscriptions, view = view, update = update }


view : Model -> Html.Html Msg
view model =
    body []
        [ menu [ class "z-depth-2" ]
            [ img [ class "logo", attribute "src" "../res/img/logo.svg" ] []
            ]
        , div [ class "main container" ]
            [ h1 [ attribute "id" "top-text" ] [ text ("IAESTEs praktikantplasser 2017") ]
            , ul [ class "collapsible popout filter-class", attribute "data-collapsible" "accordion" ]
                [ buildFilterView ]
            , ul [ class "collapsible popout", attribute "data-collapsible" "accordion" ]
                (buildDivs model.currentJobs)
            ]
        ]


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model (decodeJobs flags.json) (decodeJobs flags.json), Cmd.none )


subscriptions : a -> Sub msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        RunFiltering filters ->
            ( filterModel filters model, Cmd.none )

        Reset ->
            ( { model | currentJobs = model.allJobs }, Cmd.none )



{- TODO: Only temporary, for showcasing on IAESTE national meeting feb. 2017 -}


buildFilterView : Html Msg
buildFilterView =
    li []
        [ div [ class "collapsible-header row waves-effect" ]
            [ h4 [] [ text ("Filtrer jobber") ]
            ]
        , div [ class "collapsible-body" ]
            [ -- button [ class "waves-effect waves-light btn grey darken-2", onClick (RunFiltering [ (\job -> job.hoursDaily <= 7), (\job -> job.country == "Poland") ]) ]
              --  [ text ("Filter") ]
              button [ class "waves-effect waves-light btn grey darken-2", onClick (RunFiltering [ (\job -> String.contains "Architecture" job.faculty) ]) ]
                [ text ("Filter: Architecture") ]
            , button [ class "waves-effect waves-light btn grey darken-2", onClick (RunFiltering [ (\job -> String.contains "Biology" job.faculty) ]) ]
                [ text ("Filter: Biology") ]
            , button [ class "waves-effect waves-light btn grey darken-2", onClick (RunFiltering [ (\job -> String.contains "Chemistry" job.faculty) ]) ]
                [ text ("Filter: Chemistry") ]
            , button [ class "waves-effect waves-light btn grey darken-2", onClick (RunFiltering [ (\job -> String.contains "Economy" job.faculty) ]) ]
                [ text ("Filter: Economy and management") ]
            , button [ class "waves-effect waves-light btn grey darken-2", onClick (RunFiltering [ (\job -> String.contains "Environment" job.faculty) ]) ]
                [ text ("Filter: Environmental science") ]
            , button [ class "waves-effect waves-light btn grey darken-2", onClick (RunFiltering [ (\job -> String.contains "Geoscience" job.faculty) ]) ]
                [ text ("Filter: Geoscience") ]
            , button [ class "waves-effect waves-light btn grey darken-2", onClick (RunFiltering [ (\job -> String.contains "Material" job.faculty) ]) ]
                [ text ("Filter: Material Science") ]
            , button [ class "waves-effect waves-light btn grey darken-2", onClick (RunFiltering [ (\job -> String.contains "Mechanical" job.faculty) ]) ]
                [ text ("Filter: Mechanical Engineering") ]
            , button [ class "waves-effect waves-light btn grey darken-2", onClick (RunFiltering [ (\job -> String.contains "Physics" job.faculty) ]) ]
                [ text ("Filter: Physics and Mathematics") ]
            , button [ class "waves-effect waves-light btn grey darken-2", onClick (RunFiltering [ (\job -> String.contains "IT" job.faculty) ]) ]
                [ text ("Filter: IT") ]
            , button
                [ class "waves-effect waves-light btn red lighten-2", onClick Reset ]
                [ text ("Reset filters") ]
            ]
        ]



{- Takes a filtering predicate and updates the model by applying it
   on the list of all jobs, to obtain a list of 'current' jobs
-}


filterModel : JobFilterList -> Model -> Model
filterModel filterList model =
    case filterList of
        filterPredicate :: filters ->
            applyFilter filterPredicate (filterModel filters model)

        [] ->
            { model | currentJobs = model.allJobs }


applyFilter : (Job -> Bool) -> Model -> Model
applyFilter filterPredicate model =
    { model | currentJobs = (List.filter filterPredicate model.currentJobs) }
