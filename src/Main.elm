module Main exposing (..)

import Html exposing (programWithFlags, div, button, text, ul, body, menu, img)
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
            [ button [ onClick (RunFiltering [ (\job -> job.hoursDaily <= 7), (\job -> job.country == "Poland") ]) ]
                [ text ("Filter") ]
            , button [ onClick Reset ] [ text ("Reset filters") ]
            , ul
                [ class "collapsible popout", attribute "data-collapsible" "accordion" ]
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
