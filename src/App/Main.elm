module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class)
import Json exposing (..)
import Types exposing (..)
import ViewGenerator exposing (buildDivs)
import Filters exposing (..)


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
    let
        jobs =
            decodeJobs flags.json
    in
        ( Model jobs jobs (Filters.initFilters jobs), Cmd.none )


subscriptions : a -> Sub msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        Reset ->
            ( { model | currentJobs = model.allJobs }, Cmd.none )

        FilterMsg msgType ->
            let
                ( fModel, filterCmd ) =
                    Filters.update msgType model.filterModel

                updModel =
                    runFiltering model fModel
            in
                ( { updModel | filterModel = fModel }, Cmd.map (\a -> FilterMsg a) filterCmd )


buildFilterView : Model -> Html Msg
buildFilterView model =
    li []
        [ div [ class "collapsible-header row waves-effect" ]
            [ h4 [] [ text ("Filtrer jobber") ]
            ]
        , div [ class "collapsible-body" ]
            [ Html.map (\a -> FilterMsg a) (Filters.filterDropdowns model.filterModel)
            ]
        ]


runFiltering : Model -> FilterModel -> Model
runFiltering model filterModel =
    { model | currentJobs = model.allJobs }
        |> filterByFaculty filterModel
        |> filterByCountry filterModel


filterByFaculty : FilterModel -> Model -> Model
filterByFaculty filterModel model =
    case filterModel.faculty of
        Just faculty ->
            applyFilter (\job -> List.member faculty job.faculties) model

        Nothing ->
            model


filterByCountry : FilterModel -> Model -> Model
filterByCountry filterModel model =
    case filterModel.country of
        Just country ->
            applyFilter (\job -> job.country == country) model

        Nothing ->
            model


applyFilter : (Job -> Bool) -> Model -> Model
applyFilter filterPredicate model =
    { model | currentJobs = (List.filter filterPredicate model.currentJobs) }
