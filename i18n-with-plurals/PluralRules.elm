module PluralRules exposing (english, french, german, russian)

{-
   Each language has got its own set of plural rules, see http://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html

   Plural Operand Meanings
   from here http://unicode.org/reports/tr35/tr35-numbers.html#Operands

   n    absolute value of the source number (integer and decimals).
   i    integer digits of n.
   v    number of visible fraction digits in n, with trailing zeros.
   w    number of visible fraction digits in n, without trailing zeros.
   f    visible fractional digits in n, with trailing zeros.
   t    visible fractional digits in n, without trailing zeros.
-}
{-
   i - integer digits of number
-}


integerDigits : Int -> Int
integerDigits number =
    abs number



{-
   v - number of visible fraction digits in the number, with trailing zeros.

   As only Int type is supported now, always return zero.

   For Float or number type support a more complex implementation is needed. Because of JavaScript underneath Elm, we cannot distinguish between the Int and Float (i.e. 1 and 1.0).
   Options could be:
    - requre number's type explicitly, requesting to directly specify type via API.
    - require Float and do something like: number == (toInt <| floor number) to check whether the passed number is integer. The drawback is that 1 and 1.0 are indistinguashable in that case.
    - some other approach.
-}


visibleFractionDigits : Int -> Int
visibleFractionDigits _ =
    0



{-
   English plural rules

   one : i = 1 and v = 0
   other : _
-}


english : String -> String -> Int -> String
english one other number =
    let
        v =
            visibleFractionDigits number

        i =
            integerDigits number
    in
    if v == 0 && i == 1 then
        one
    else
        other



{-
   Russian plural rules

   one : v = 0 and i % 10 = 1 and i % 100 != 11
   few : v = 0 and i % 10 = 2..4 and i % 100 != 12..14
   many : v = 0 and i % 10 = 0 or v = 0 and i % 10 = 5..9 or v = 0 and i % 100 = 11..14
   other : _
-}


russian : String -> String -> String -> String -> Int -> String
russian one few many other number =
    let
        v =
            visibleFractionDigits number

        i =
            integerDigits number
    in
    if v == 0 then
        if i % 10 == 1 && i % 100 /= 11 then
            one
        else if i % 10 >= 2 && i % 10 <= 4 && not (i % 100 >= 12 && i % 100 <= 14) then
            few
        else if i % 10 == 0 || (i % 10 >= 5 && i % 10 <= 9) || (i % 100 >= 11 && i % 100 <= 14) then
            many
        else
            other
    else
        other



{-
   German plural rules

   one : i = 1 and v = 0
   other : _
-}


german : String -> String -> Int -> String
german one other number =
    let
        v =
            visibleFractionDigits number

        i =
            integerDigits number
    in
    if v == 0 && i == 1 then
        one
    else
        other



{-
   French plural rules

   one : i = 0, 1
   other : _
-}


french : String -> String -> Int -> String
french one other number =
    let
        i =
            integerDigits number
    in
    if i == 0 || i == 1 then
        one
    else
        other
