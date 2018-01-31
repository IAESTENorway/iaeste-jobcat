module Types exposing (..)

import Selectize exposing (State)


type alias Flags =
    { json : String
    }


type alias Model =
    { allJobs : List Job
    , currentJobs : List Job
    , filterModel : FilterModel
    }


type alias FilterModel =
    { faculty : Maybe String
    , facMenu : Selectize.State String
    , country : Maybe String
    , countryMenu : Selectize.State String
    }


type Msg
    = None
    | Reset
    | FilterMsg FilterMsg


type FilterMsg
    = FacultyMsg FacFilterMsg
    | CountryMsg CountryFilterMsg


type FacFilterMsg
    = FacMenuMsg (Selectize.Msg String)
    | SelectFaculty (Maybe String)


type CountryFilterMsg
    = CountryMenuMsg (Selectize.Msg String)
    | SelectCountry (Maybe String)


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
    , employees : String
    , hoursWeekly : String
    , hoursDaily : String
    , faculties : List String
    , special : String
    , trainingReq : String
    , otherReq : String
    , workkind : String
    , weeksMin : String
    , weeksMax : String
    , to : String
    , from : String
    , study_begin : String
    , study_middle : String
    , study_end : String
    , languages : LanguageList
    , currency : String
    , payment : String
    , paymentFreq : String
    , deduction : String
    , livingcost : String
    , livingcostFreq : String
    , idoffer : String
    }
