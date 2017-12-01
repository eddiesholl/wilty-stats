module Models.Episodes exposing (..)

-- DavidsTeamId = "david"
-- LeesTeamId = "lee"
-- type TeamId
    -- = DavidsTeamId
    -- | LeesTeamId
type alias TeamId = String

type alias EpisodeId = String
type alias Episodes = List Episode

type alias Episode =
  { season: String
  , title : String
  , episode: String
  , id: EpisodeId
  }
