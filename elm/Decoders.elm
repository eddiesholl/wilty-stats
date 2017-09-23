module Decoders exposing (decodeEpisodes, decodeRounds)

import Models.Episodes exposing (Episodes, Episode)
import Models.Rounds exposing (Rounds, Round(..), StandardRoundFields, ThisIsMyRoundFields)
import Json.Decode as Json exposing (bool, int, string, oneOf, succeed)
import Json.Decode.Pipeline as JsonPipeline exposing (decode, resolve, required, custom)

decodeEpisodes : Json.Decoder Episodes
decodeEpisodes = Json.list decodeEpisode

decodeEpisode : Json.Decoder Episode
decodeEpisode =
  decode Episode
    |> JsonPipeline.required "season" string
    |> JsonPipeline.required "title" string
    |> JsonPipeline.required "episode" string
    |> JsonPipeline.required "id" string

decodeRounds : Json.Decoder Rounds
decodeRounds = Json.list decodeRound

decodeRound : Json.Decoder Round
decodeRound = oneOf [decodeStandardRound, decodeThisIsMyRound]

decodeStandardRound =
  Json.map toStandardRound decodeStandardRoundFields

toStandardRound f =
    StandardRound f

decodeStandardRoundFields : Json.Decoder StandardRoundFields
decodeStandardRoundFields =
    decode StandardRoundFields
      |> JsonPipeline.required "id" string
      |> JsonPipeline.required "episodeId" string
      |> JsonPipeline.required "round" int
      |> JsonPipeline.required "speaker" string
      |> JsonPipeline.required "guessingTeam" string
      |> JsonPipeline.required "guesser1" string
      |> JsonPipeline.required "guess1" bool
      |> JsonPipeline.required "guesser2" string
      |> JsonPipeline.required "guess2" bool
      |> JsonPipeline.required "guess" bool
      |> JsonPipeline.required "answer" bool

decodeThisIsMyRound =
  Json.map toThisIsMyRound decodeThisIsMyRoundFields

toThisIsMyRound f =
    ThisIsMyRound f

decodeThisIsMyRoundFields : Json.Decoder ThisIsMyRoundFields
decodeThisIsMyRoundFields =
    decode ThisIsMyRoundFields
    |> JsonPipeline.required "id" string
    |> JsonPipeline.required "episodeId" string
    |> JsonPipeline.required "round" int
    |> JsonPipeline.required "guessingTeam" string
    |> JsonPipeline.required "guesser1" string
    |> JsonPipeline.optional "guess1" string "null"
    |> JsonPipeline.required "guesser2" string
    |> JsonPipeline.optional "guess2" string "null"
    |> JsonPipeline.required "guess" string
    |> JsonPipeline.required "answer" string
