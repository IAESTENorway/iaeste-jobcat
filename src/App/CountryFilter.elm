module CountryFilter exposing (..)

import Selectize exposing (..)
import Html exposing (..)
import Html.Attributes as Attributes
import Types exposing (FilterModel, FilterMsg, CountryFilterMsg, Msg, Job)
import Set exposing (fromList, toList)


update : CountryFilterMsg -> FilterModel -> ( FilterModel, Cmd CountryFilterMsg )
update msg model =
    case msg of
        Types.CountryMenuMsg selectizeMsg ->
            let
                ( newMenu, menuCmd, maybeMsg ) =
                    Selectize.update Types.SelectCountry
                        model.country
                        model.countryMenu
                        selectizeMsg

                newModel =
                    { model | countryMenu = newMenu }

                cmd =
                    menuCmd |> Cmd.map Types.CountryMenuMsg
            in
                case maybeMsg of
                    Just nextMsg ->
                        update nextMsg newModel
                            |> andDo cmd

                    Nothing ->
                        ( newModel, cmd )

        Types.SelectCountry newSelection ->
            ( { model | country = newSelection }, Cmd.none )


andDo : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
andDo cmd ( model, cmds ) =
    ( model
    , Cmd.batch [ cmd, cmds ]
    )


initMenu : List Job -> State String
initMenu jobList =
    Selectize.closed "country-filter"
        identity
        (countries jobList |> List.map Selectize.entry)


countryDropdown : FilterModel -> Html CountryFilterMsg
countryDropdown filterModel =
    Selectize.view viewConfig
        filterModel.country
        filterModel.countryMenu
        |> Html.map Types.CountryMenuMsg


viewConfig : Selectize.ViewConfig String
viewConfig =
    Selectize.viewConfig
        { container =
            [ Attributes.class "selectize__container" ]
        , menu =
            [ Attributes.class "selectize__menu" ]
        , ul =
            [ Attributes.class "selectize__list" ]
        , entry =
            \country mouseFocused keyboardFocused ->
                { attributes =
                    [ Attributes.class "selectize__item"
                    , Attributes.classList
                        [ ( "selectize__item--mouse-selected"
                          , mouseFocused
                          )
                        , ( "selectize__item--key-selected"
                          , keyboardFocused
                          )
                        ]
                    ]
                , children =
                    [ Html.text country ]
                }
        , divider =
            \title ->
                { attributes =
                    [ Attributes.class "selectize__divider" ]
                , children =
                    [ Html.text title ]
                }
        , input = styledInput
        }


styledInput : Selectize.Input String
styledInput =
    Selectize.autocomplete <|
        { attrs =
            \sthSelected open ->
                [ Attributes.class "selectize__textfield"
                , Attributes.classList
                    [ ( "selectize__textfield--selection", sthSelected )
                    , ( "selectize__textfield--no-selection", not sthSelected )
                    , ( "selectize__textfield--menu-open", open )
                    ]
                ]
        , toggleButton =
            Just <|
                \open ->
                    Html.i
                        [ Attributes.class "material-icons"
                        , Attributes.class "selectize__icon"
                        ]
                        [ if open then
                            Html.text "arrow_drop_up"
                          else
                            Html.text "arrow_drop_down"
                        ]
        , clearButton = clearButton
        , placeholder = "Velg eller skriv inn et land"
        }


clearButton : Maybe (Html Never)
clearButton =
    Just <|
        Html.div
            [ Attributes.class "selectize__menu-toggle" ]
            [ Html.i
                [ Attributes.class "material-icons"
                , Attributes.class "selectize__icon"
                ]
                [ Html.text "backspace" ]
            ]


countries : List Job -> List String
countries jobList =
    Set.toList (Set.fromList (List.map (\job -> job.country) jobList))
