module Models exposing (..)

-- DavidsTeamId = "david"
-- LeesTeamId = "lee"
-- type TeamId
    -- = DavidsTeamId
    -- | LeesTeamId
type alias TeamId = String

type alias GuestId = String
-- type alias TeamId = String
type alias Guess = Bool
type Answer
 = Bool
 | GuestId -- Needed for "this is my"

type alias EpisodeId = String
type alias Episodes = List Episode

type alias Episode =
  { season: String
  , title : String
  , episode: String
  , id: EpisodeId
  }

type alias RoundId = String
type alias Rounds = List Round

type alias Round =
  { id: RoundId
  , episodeId: EpisodeId
  , round: Int
  , speaker: GuestId
  , guessingTeam: TeamId
  , guesser1: GuestId
  , guess1: Guess
  , guesser2: GuestId
  , guess2: Guess
  , guess: Guess
  , answer: Answer
  }

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
