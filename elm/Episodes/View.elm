module Episodes.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href)
import Msgs exposing (Msg)
import Models exposing (Episode)


view : Episode -> Html Msg
view model =
    div []
        [ header model
        ]

header : Episode -> Html Msg
header model =
  h1 [] [text model.id]
