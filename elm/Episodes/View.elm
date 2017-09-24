module Episodes.View exposing (..)

import Html exposing (..)
import Html.CssHelpers

import Styles exposing (styles)
import Msgs exposing (Msg)
import Models.Episodes exposing (Episode)
import Models.Rounds exposing (Rounds, Round(..), StandardRoundFields, ThisIsMyRoundFields)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "dreamwriter"

view : Episode -> Rounds -> Html Msg
view model rounds =
    div []
        [ header model
        , viewRounds rounds
        ]

header : Episode -> Html Msg
header model =
  h1 [] [text model.id]

viewRounds rounds =
  div []
    [ ul [] (List.map roundToHtml rounds)
    ]

roundToHtml round =
  case round of
    (StandardRound f) -> standardRoundToHtml f
    (ThisIsMyRound f) -> thisIsMyRoundToHtml f

textDiv t =
  div []
    [ t |> toString |> text
    ]

textDivLabel l t =
  div []
    [ text (l ++ ": ")
    , t |> toString |> text
    ]

standardRoundToHtml : StandardRoundFields -> Html Msg
standardRoundToHtml s =
  div [styles (Styles.flexColumn ++ Styles.greyBorder ++ Styles.padMedium ++ Styles.marginMedium ++ Styles.bgBlue) ]
    [ textDivLabel "Round" s.round
    , textDivLabel "Type" "Standard"
    , textDivLabel "Team" s.guessingTeam
    , textDivLabel "Speaker" s.speaker
    , textDivLabel "Guess" s.guess
    , textDivLabel "Answer" s.answer
    ]

thisIsMyRoundToHtml : ThisIsMyRoundFields -> Html Msg
thisIsMyRoundToHtml s =
  div []
    [ text s.guessingTeam
    , text s.guess
    , text s.answer
    ]
