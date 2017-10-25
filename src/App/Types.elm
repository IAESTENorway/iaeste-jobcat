module App.Types exposing (..)


type alias Flags =
    { json : String
    }


type alias Model =
    { allJobs : List Job
    , currentJobs : List Job
    }



{- Definer Filter som en union av predikater som filtrerer på ulike felter -}


type Msg
    = None
    | RunFiltering JobFilterList
    | Reset


type alias JobFilterList =
    List (Job -> Bool)


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
    , faculty : String
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
    }
