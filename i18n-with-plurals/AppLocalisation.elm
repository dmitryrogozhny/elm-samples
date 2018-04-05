module AppLocalisation exposing (Language(..), TranslationKey(..), translate)

import PluralRules


type Language
    = English
    | Russian


type alias TranslationSet =
    { english : String
    , russian : String
    }


type TranslationKey
    = SimpleText
    | PlaceholderText { text : String }
    | PluralsText { number : Int }
    | ButtonSwitchText
    | Example1Text
    | Example2Text
    | Example3Text


translate : Language -> TranslationKey -> String
translate language key =
    let
        translationSet =
            case key of
                SimpleText ->
                    TranslationSet "This text is in English" "Это текст на русском языке"

                PlaceholderText { text } ->
                    TranslationSet ("Welcome, " ++ text) (text ++ ", привет!")

                PluralsText { number } ->
                    let
                        english =
                            PluralRules.english "Apple" "Apples"

                        russian =
                            PluralRules.russian "Яблоко" "Яблока" "Яблок" "Яблока"
                    in
                    TranslationSet (english number) (russian number)
                ButtonSwitchText ->
                    TranslationSet "You can switch between languages." "Можно переключать язык кнопками."
                Example1Text ->
                    TranslationSet "Example 1: static text translation." "Пример 1: перевод строки текста."
                Example2Text ->
                    TranslationSet "Example 2: translation with placeholders support." "Пример 2: перевод с подстановкой значения."
                Example3Text ->
                    TranslationSet "Example 3: translation wiht plurals support (try using '−' and '+' buttons below)." "Пример 3: перевод числительных (можно изменять число кнопками '−' и '+')."

    in
    case language of
        English ->
            .english translationSet

        Russian ->
            .russian translationSet
