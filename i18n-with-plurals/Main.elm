module Main exposing (..)

import AppLocalisation exposing (..)
import Html exposing (Attribute, Html, button, div, img, input, label, span, text)
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
        [ div [ blockStyle ]
            [ div [ commentStyle ] [ text <| translate model.currentLanguage ButtonSwitchText ]
            , viewLanguageSelect model.currentLanguage
            ]
        , div [ blockStyle ]
            [ div [ commentStyle ] [ text <| translate model.currentLanguage Example1Text ]
            , text simpleText
            ]
        , div [ blockStyle ]
            [ div [commentStyle] [text <| translate model.currentLanguage Example2Text],
                input [ textInputStyle, onInput SetPlaceholderText, value model.placeholderText ] []
            , text placeholderText
            ]
        , div [ blockStyle ]
            [ div [commentStyle] [text <| translate model.currentLanguage Example3Text],
                text <| toString model.pluralNumber ++ " " ++ pluralsText
            , viewApples model.pluralNumber
            , viewCounter
                model.pluralNumber
            ]
        ]



-- UI for switching language


viewCounter : Int -> Html Msg
viewCounter value =
    div []
        [ button [ onClick DecrementValue ] [ text "−" ]
        , span [ numeralCountStyle ] [ text <| toString value ]
        , button [ onClick IncrementValue ] [ text "+" ]
        ]


viewLanguageSelect : Language -> Html Msg
viewLanguageSelect currentLanguage =
    div []
        [ button [ onClick <| SetLanguage English, getButtonStyle English currentLanguage ] [ text "English" ]
        , button [ onClick <| SetLanguage Russian, getButtonStyle Russian currentLanguage ] [ text "Русский" ]
        ]


viewApples : Int -> Html msg
viewApples number =
    div [ applesContainerStyle ] <|
        List.repeat
            number
        <|
            img [ appleImageStyle, src "https://upload.wikimedia.org/wikipedia/commons/0/05/Apple.svg" ] []


getButtonStyle : Language -> Language -> Attribute msg
getButtonStyle language activeLanguage =
    if language == activeLanguage then
        activeButtonStyle
    else
        buttonStyle



-- STYLES


appStyle : Attribute msg
appStyle =
    style [ ( "padding", "30px 20px" ), ( "border", "1px solid grey" ) ]


blockStyle : Attribute msg
blockStyle =
    style [ ( "padding-bottom", "2em" ) ]


buttonStyle : Attribute msg
buttonStyle =
    style
        [ ( "width", "150px" )
        , ( "height", "15%" )
        , ( "text-align", "center" )
        , ( "padding", "10px 10px" )
        , ( "margin-right", "20px" )
        , ( "font-size", "1.2rem" )
        , ( "border", "0px" )
        , ( "background-color", "rgb(0, 120, 215)" )
        , ( "color", "#FFF  " )
        , ( "cursor", "pointer" )
        ]


activeButtonStyle : Attribute msg
activeButtonStyle =
    style
        [ ( "width", "150px" )
        , ( "height", "15%" )
        , ( "text-align", "center" )
        , ( "padding", "10px 10px" )
        , ( "margin-right", "20px" )
        , ( "font-size", "1.2rem" )
        , ( "border", "0px" )
        , ( "background-color", "rgb(150, 150, 150)" )
        , ( "color", "#FFF  " )
        , ( "cursor", "default" )
        ]


commentStyle : Attribute msg
commentStyle =
    style
        [ ( "color", "rgb(150, 150, 150)" )
        , ( "font-size", "1.1rem" )
        , ( "padding-bottom", "10px" )
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


numeralCountStyle : Attribute msg
numeralCountStyle =
    style [ ( "padding", "0px 20px" ) ]
