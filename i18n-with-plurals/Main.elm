module Main exposing (..)

import AppTranslation exposing (..)
import Html exposing (Attribute, Html, button, div, img, input, label, text)
import Html.Attributes exposing (class, name, src, style, type_, value)
import Html.Events exposing (onClick, onInput)


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, update = update, view = view }



-- MODEL


type alias Model =
    { currentLanguage : Language
    , placeholderText : String
    , pluralNumber : Int
    }


model : Model
model =
    { currentLanguage = English
    , placeholderText = "John"
    , pluralNumber = 1
    }



-- UPDATE


type Msg
    = SetLanguage Language
    | SetPlaceholderText String
    | IncrementValue
    | DecrementValue


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetLanguage language ->
            { model | currentLanguage = language }

        SetPlaceholderText placeholder ->
            { model | placeholderText = placeholder }

        IncrementValue ->
            { model | pluralNumber = model.pluralNumber + 1 }

        DecrementValue ->
            { model | pluralNumber = model.pluralNumber - 1 }



-- VIEW


view : Model -> Html Msg
view model =
    let
        simpleText =
            translate model.currentLanguage SimpleText

        placeholderText =
            translate model.currentLanguage <| PlaceholderText { text = model.placeholderText }

        pluralsText =
            translate model.currentLanguage <| PluralsText { number = model.pluralNumber }
    in
    div [ appStyle ]
        [ div [ blockStyle ] [ viewLanguageSelect ]
        , div [ blockStyle ] [ text simpleText ]
        , div [ blockStyle ]
            [ input [ textInputStyle, onInput SetPlaceholderText, value model.placeholderText ] []
            , text placeholderText
            ]
        , div [ blockStyle ]
            [ text <| toString model.pluralNumber ++ " " ++ pluralsText
            , viewApples model.pluralNumber
            , viewCounter
                model.pluralNumber
            ]
        ]



-- UI for switching language


viewCounter : Int -> Html Msg
viewCounter value =
    div []
        [ button [ onClick DecrementValue ] [ text "-" ]
        , text <| toString value
        , button [ onClick IncrementValue ] [ text "+" ]
        ]


viewLanguageSelect : Html Msg
viewLanguageSelect =
    div []
        [ button [ onClick <| SetLanguage English, languageButtonStyle ] [ text "English" ]
        , button [ onClick <| SetLanguage Russian, languageButtonStyle ] [ text "Русский" ]
        ]


viewApples : Int -> Html msg
viewApples number =
    div [ applesContainerStyle ] <|
        List.repeat
            number
        <|
            img [ appleImageStyle, src "https://upload.wikimedia.org/wikipedia/commons/0/05/Apple.svg" ] []



-- STYLES


appStyle : Attribute msg
appStyle =
    style [ ( "padding", "30px 20px" ), ( "border", "1px solid grey" ) ]


blockStyle : Attribute msg
blockStyle =
    style [ ( "padding-bottom", "2em" ) ]


languageButtonStyle : Attribute msg
languageButtonStyle =
    style
        [ ( "width", "150px" )
        , ( "height", "15%" )
        , ( "background-color", "rgb(0, 120, 215)" )
        , ( "text-align", "center" )
        , ( "padding", "10px 10px" )
        , ( "margin-right", "20px" )
        , ( "color", "#FFF  " )
        , ( "font-size", "1.2rem" )
        , ( "cursor", "pointer" )
        , ( "border", "0px" )
        ]


textInputStyle : Attribute msg
textInputStyle =
    style [ ( "margin-right", ".5em" ), ( "width", "100px" ) ]


applesContainerStyle : Attribute msg
applesContainerStyle =
    style [ ( "height", "40px" ) ]


appleImageStyle : Attribute msg
appleImageStyle =
    style [ ( "height", "32px" ), ( "width", "32px" ), ( "border", "0px" ) ]
