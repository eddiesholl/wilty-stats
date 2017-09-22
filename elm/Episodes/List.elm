module Episodes.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (Episode, EpisodesModel)
import Msgs exposing (Msg(..))

episodeToHtml : Episode -> Html Msg
episodeToHtml episode =
  li [] [text episode.id]

view : EpisodesModel -> Html Msg
view model =
  div []
    [ input [ placeholder "enter a movie title"
            , value "abc"
            , autofocus True
            , onInput UpdateSearchString
            ] []
   , ul []
      (List.map episodeToHtml model.episodes)
 ]
