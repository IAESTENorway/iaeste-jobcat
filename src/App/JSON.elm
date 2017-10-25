module App.Json exposing (..)

import App.Types exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


jobDecoder : Decoder Job
jobDecoder =
    decode Job
        |> required "Ref.No" string
        |> required "Country" string
        |> required "Workplace" string
        |> required "Business" string
        |> required "Airport" string
        |> required "Employer" string
        |> required "Employees" string
        |> required "HoursWeekly" string
        |> required "HoursDaily" string
        |> required "Faculty" string
        |> required "Specialization" string
        |> required "TrainingRequired" string
        |> required "OtherRequirements" string
        |> required "Workkind" string
        |> required "WeeksMin" string
        |> required "WeeksMax" string
        |> required "To" string
        |> required "From" string
        |> required "StudyCompleted_Beginning" string
        |> required "StudyCompleted_Middle" string
        |> required "StudyCompleted_End" string
        |> custom languageDecoder
        |> required "Currency" string
        |> required "Payment" string
        |> required "PaymentFrequency" string
        |> required "Deduction" string
        |> required "LivingCost" string
        |> required "LivingCostFrequency" string


languageDecoder : Decoder LanguageList
languageDecoder =
    decode LanguageList
        |> custom (langTupleDecoder ( "Language1", "Language1Level" ))
        |> required "Language1or" string
        |> custom (langTupleDecoder ( "Language2", "Language2Level" ))
        |> required "Language2or" string
        |> custom (langTupleDecoder ( "Language3", "Language3Level" ))


langTupleDecoder : ( String, String ) -> Decoder LanguageTuple
langTupleDecoder ( langfield, levelField ) =
    decode LanguageTuple
        |> required langfield string
        |> required levelField string


decodeJobs : String -> List Job
decodeJobs jsonString =
    Result.withDefault [] (decodeString (list jobDecoder) jsonString)
