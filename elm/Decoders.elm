module Decoders exposing (decodeEpisodes, decodeRounds)

import Models exposing (..)
import Json.Decode as Json exposing (bool, int, string, oneOf)
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)

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
decodeRound =
  decode Round
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
    |> JsonPipeline.required "answer" oneOf [bool, string]
