module Main exposing (..)

import Html exposing (Html, menu, div, a, h1, ul, footer, img, li, h4, text)
import Html.Attributes exposing (attribute, class, href)
import JSON exposing (..)
import Types exposing (..)
import ViewGenerator exposing (buildDivs)
import Filters exposing (..)
import Browser


main : Program Flags Model Msg
main =
    Browser.element { init = init, subscriptions = subscriptions, view = view, update = update }


view : Model -> Html Msg
view model =
    div []
        [ menu [ class "z-depth-2" ] [
        div[class "logo-btn"][
        a [href "https://iaeste.no"][img [ class "logo", attribute "src" "res/img/logo.svg" ] []]]]
        , div [ class "main container" ]
            [ h1 [ attribute "id" "top-text" ] [ text ("IAESTEs praktikantplasser") ]
            , ul [ class "collapsible popout filter-class", attribute "data-collapsible" "accordion" ]
                [ buildFilterView model ]
            , ul [ class "collapsible popout", attribute "data-collapsible" "accordion" ]
                (buildDivs model.currentJobs)
            ], footer[][img [attribute "src" "res/img/hspHvit2.png"][]]
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
