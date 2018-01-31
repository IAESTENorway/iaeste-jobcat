module Filters exposing (..)

import Types exposing (FilterModel, FilterMsg, Msg, Job)
import FacultyFilter exposing (initMenu, update)
import CountryFilter exposing (initMenu, update)
import Html exposing (Html, div, map)
import Html.Attributes exposing (class)


initFilters : List Job -> FilterModel
initFilters jobList =
    FilterModel Maybe.Nothing
        (FacultyFilter.initMenu jobList)
        Maybe.Nothing
        (CountryFilter.initMenu jobList)


update : FilterMsg -> FilterModel -> ( FilterModel, Cmd Types.FilterMsg )
update msg model =
    case msg of
        Types.FacultyMsg selectizeMsg ->
            mapFacultyMsg (FacultyFilter.update selectizeMsg model)

        Types.CountryMsg selectizeMsg ->
            mapCountryMsg (CountryFilter.update selectizeMsg model)


mapFacultyMsg : ( FilterModel, Cmd Types.FacFilterMsg ) -> ( FilterModel, Cmd Types.FilterMsg )
mapFacultyMsg ( model, msg ) =
    ( model, Cmd.map (\a -> Types.FacultyMsg a) msg )


mapCountryMsg : ( FilterModel, Cmd Types.CountryFilterMsg ) -> ( FilterModel, Cmd Types.FilterMsg )
mapCountryMsg ( model, msg ) =
    ( model, Cmd.map (\a -> Types.CountryMsg a) msg )


filterDropdowns : FilterModel -> Html FilterMsg
filterDropdowns filterModel =
    div [ class "filters" ]
        [ Html.map
            (\a -> Types.FacultyMsg a)
            (FacultyFilter.facultyDropdown filterModel)
        , Html.map
            (\a -> Types.CountryMsg a)
            (CountryFilter.countryDropdown filterModel)
        ]
