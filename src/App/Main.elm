module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class)
import Json exposing (..)
import Types exposing (..)
import ViewGenerator exposing (buildDivs)
import Filters


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
                [ buildFilterView model ]
            , ul [ class "collapsible popout", attribute "data-collapsible" "accordion" ]
                (buildDivs model.currentJobs)
            ]
        ]


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model (decodeJobs flags.json) (decodeJobs flags.json) Filters.filterModel, Cmd.none )


subscriptions : a -> Sub msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        RunFiltering filters ->
            ( filterModel filters model, Cmd.none )

        Reset ->
            ( { model | currentJobs = model.allJobs }, Cmd.none )

        FilterMsg msgType ->
            let
                ( fModel, filterCmd ) =
                    Filters.update msgType model.filterModel

                updModel =
                    case fModel.faculty of
                        Just faculty ->
                            filterModel [ \job -> List.member faculty.filterString job.faculties ] model

                        Nothing ->
                            { model | currentJobs = model.allJobs }
            in
                ( { updModel | filterModel = fModel }, Cmd.map (\a -> FilterMsg a) filterCmd )


buildFilterView : Model -> Html Msg
buildFilterView model =
    li []
        [ div [ class "collapsible-header row waves-effect" ]
            [ h4 [] [ text ("Filtrer jobber") ]
            ]
        , div [ class "collapsible-body" ]
            [ Html.map (\a -> FilterMsg a) (Filters.facultyDropdown model.filterModel)
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
