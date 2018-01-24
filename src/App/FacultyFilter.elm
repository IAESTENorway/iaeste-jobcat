module FacultyFilter exposing (..)

import Selectize exposing (..)
import Html exposing (..)
import Html.Attributes as Attributes
import Types exposing (FilterModel, FilterMsg, FacFilterMsg, Msg, Job)
import Set exposing (fromList, toList)


update : FacFilterMsg -> FilterModel -> ( FilterModel, Cmd FacFilterMsg )
update msg model =
    case msg of
        Types.FacMenuMsg selectizeMsg ->
            let
                ( newMenu, menuCmd, maybeMsg ) =
                    Selectize.update Types.SelectFaculty
                        model.faculty
                        model.facMenu
                        selectizeMsg

                newModel =
                    { model | facMenu = newMenu }

                cmd =
                    menuCmd |> Cmd.map Types.FacMenuMsg
            in
                case maybeMsg of
                    Just nextMsg ->
                        update nextMsg newModel
                            |> andDo cmd

                    Nothing ->
                        ( newModel, cmd )

        Types.SelectFaculty newSelection ->
            ( { model | faculty = newSelection }, Cmd.none )


andDo : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
andDo cmd ( model, cmds ) =
    ( model
    , Cmd.batch [ cmd, cmds ]
    )


initMenu : List Job -> State String
initMenu jobList =
    Selectize.closed "faculty-filter"
        identity
        (faculties jobList |> List.map Selectize.entry)


facultyDropdown : FilterModel -> Html FacFilterMsg
facultyDropdown filterModel =
    Selectize.view viewConfig
        filterModel.faculty
        filterModel.facMenu
        |> Html.map Types.FacMenuMsg


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
            \faculty mouseFocused keyboardFocused ->
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
                    [ Html.text faculty ]
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
        , placeholder = "Select a Faculty"
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


faculties : List Job -> List String
faculties jobList =
    Set.toList (Set.fromList (List.concat (List.map (\job -> job.faculties) jobList)))
