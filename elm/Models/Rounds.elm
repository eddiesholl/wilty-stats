module Models.Rounds exposing (..)

import Models.Episodes exposing (EpisodeId)


type alias RoundId = String
type alias Rounds = List Round

type alias GuestId = String
type alias TeamId = String
type alias Guess = Bool
type alias Answer = Bool

type Round
 = StandardRound StandardRoundFields
 | ThisIsMyRound ThisIsMyRoundFields

getRoundFromRound round =
  case round of
    (StandardRound f) -> f.round
    (ThisIsMyRound f) -> f.round
    
getEpisodeIdFromRound : Round -> EpisodeId
getEpisodeIdFromRound round =
  case round of
    (StandardRound f) -> f.episodeId
    (ThisIsMyRound f) -> f.episodeId

type alias StandardRoundFields =
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

type alias ThisIsMyRoundFields =
  { id: RoundId
  , episodeId: EpisodeId
  , round: Int
  , guessingTeam: TeamId
  , guesser1: GuestId
  , guess1: GuestId
  , guesser2: GuestId
  , guess2: GuestId
  , guess: GuestId
  , answer: GuestId
  }
