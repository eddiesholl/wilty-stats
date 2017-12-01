module Models.App exposing (..)

import Models.Episodes exposing (Episodes, EpisodeId)
import Models.Rounds exposing (Rounds)

type alias EpisodesModel =
  { episodes : Episodes
  , rounds : Rounds
  , route : Route
  , error : String
  }

initialModel : Route -> EpisodesModel
initialModel route =
  { episodes = []
  , rounds = []
  , route = route
  , error = ""
  }

type Route
    = EpisodesRoute
    | EpisodeRoute EpisodeId
    | NotFoundRoute
