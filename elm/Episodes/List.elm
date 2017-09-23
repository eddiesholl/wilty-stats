module Episodes.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (Episode, EpisodesModel)
import Msgs exposing (Msg(..))
import Routing exposing (episodePath)

episodeToHtml : Episode -> Html Msg
episodeToHtml episode =
  let
    path =
        episodePath episode.id
  in
    li [] [a
            [ href path
            ]
            [text episode.id]
          ]

view : EpisodesModel -> Html Msg
view model =
  div []
    [ text model.error
    , ul [] (List.map episodeToHtml model.episodes)
    , List.length model.rounds |> toString |> text
    ]
