module AppTranslation exposing (..)

import Translation


type Language
    = English
    | Russian


type ResourceId
    = SimpleText
    | PlaceholderText { text : String }
    | PluralsText { number : Int }


type alias TranslationSet =
    { english : String
    , russian : String
    }


translate : Language -> ResourceId -> String
translate language resourceId =
    let
        translationSet =
            case resourceId of
                SimpleText ->
                    TranslationSet "This text is in English" "Этот текст на русском языке"

                PlaceholderText { text } ->
                    TranslationSet ("Welcome, " ++ text) (text ++ ", привет!")

                PluralsText { number } ->
                    let
                        english =
                            Translation.createPluralTranslation "Apple" "Apples"

                        russian =
                            Translation.createNumeralsTranslation "Яблоко"
                                "Яблок"
                                [ Translation.createNumeralTranslation 2 "Яблока"
                                , Translation.createNumeralTranslation 3 "Яблока"
                                , Translation.createNumeralTranslation 4 "Яблока"
                                ]
                    in
                    TranslationSet (Translation.translatePlural english number) (Translation.translatePlural russian number)
    in
    case language of
        English ->
            .english translationSet

        Russian ->
            .russian translationSet
