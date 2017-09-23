module Episodes.View exposing (..)

import Html exposing (..)
import Msgs exposing (Msg)
import Models exposing (Episode, Rounds)


view : Episode -> Rounds -> Html Msg
view model rounds =
    div []
        [ header model
        , text (toString (List.length rounds))
        ]

header : Episode -> Html Msg
header model =
  h1 [] [text model.id]
