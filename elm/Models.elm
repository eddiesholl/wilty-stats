module Models exposing (..)

type alias Episodes = List Episode

type alias Episode =
  { season: String
  , title : String
  , episode: String
  , id: String
  }

type alias EpisodesModel =
  {
  episodes : List Episode
  }

initialModel : EpisodesModel
initialModel = EpisodesModel []
