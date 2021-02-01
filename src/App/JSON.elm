module JSON exposing (..)

import Types exposing (..)
import Json.Decode as Decode exposing (Decoder, string, list)
import Json.Decode.Pipeline exposing (required, optional, custom,  resolve)


jobDecoder : Decoder Job
jobDecoder =
    Decode.succeed Job
        |> optional "Ref.No" string "N/A"
        |> optional "Country" string "N/A"
        |> optional "Workplace" string "N/A"
        |> optional "Business" string "N/A"
        |> optional "Airport" string "N/A"
        |> optional "Employer" string "N/A"
        |> optional "Employees" string "N/A"
        |> optional "HoursWeekly" string "N/A"
        |> optional "HoursDaily" string "N/A"
        |> custom facultyDecoder
        |> optional "Specialization" string "N/A"
        |> optional "TrainingRequsired" string "N/A"
        |> optional "OtherRequirements" string "N/A"
        |> optional "Workkind" string "N/A"
        |> optional "WeeksMin" string "N/A"
        |> optional "WeeksMax" string "N/A"
        |> optional "To" string "N/A"
        |> optional "From" string "N/A"
        |> optional "StudyCompleted_Beginning" string "N"
        |> optional "StudyCompleted_Middle" string "N"
        |> optional "StudyCompleted_End" string "N"
        |> custom languageDecoder
        |> optional "Currency" string "N/A"
        |> optional "Payment" string "N/A"
        |> optional "PaymentFrequency" string "N/A"
        |> optional "Deduction" string "N/A"
        |> optional "LivingCost" string "N/A"
        |> optional "LivingCostFrequency" string "N/A"
        |> optional "idoffer" string "N/A"


languageDecoder : Decoder LanguageList
languageDecoder =
    Decode.succeed LanguageList
        |> custom (langTupleDecoder ( "Language1", "Language1Level" ))
        |> required "Language1or" string
        |> custom (langTupleDecoder ( "Language2", "Language2Level" ))
        |> required "Language2or" string
        |> custom (langTupleDecoder ( "Language3", "Language3Level" ))


langTupleDecoder : ( String, String ) -> Decoder LanguageTuple
langTupleDecoder ( langfield, levelField ) =
    Decode.succeed LanguageTuple
        |> optional langfield string "N/A"
        |> optional levelField string "N/A"


facultyDecoder : Decoder (List String)
facultyDecoder =
    let
        toListDecoder : String -> Decoder (List String)
        toListDecoder input =
            Decode.succeed (String.split ", " input)
    in
        Decode.succeed toListDecoder
            |> optional "Faculty" string "N/A"
            |> resolve


decodeJobs : String -> List Job
decodeJobs jsonString =
    Result.withDefault [] (Decode.decodeString (list jobDecoder) jsonString)
