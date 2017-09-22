module Models exposing (..)

type alias EpisodeId = String
type alias Episodes = List Episode

type alias Episode =
  { season: String
  , title : String
  , episode: String
  , id: EpisodeId
  }

type alias EpisodesModel =
  { episodes : Episodes
  , route : Route
  }

initialModel : Route -> EpisodesModel
initialModel route =
  { episodes = []
  , route = route
  }

type Route
    = EpisodesRoute
    | EpisodeRoute EpisodeId
    | NotFoundRoute
