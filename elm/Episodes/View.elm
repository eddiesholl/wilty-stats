module Episodes.View exposing (..)

import Html exposing (..)
import Msgs exposing (Msg)
import Models.Episodes exposing (Episode)
import Models.Rounds exposing (Rounds)


view : Episode -> Rounds -> Html Msg
view model rounds =
    div []
        [ header model
        , text (toString (List.length rounds))
        ]

header : Episode -> Html Msg
header model =
  h1 [] [text model.id]
