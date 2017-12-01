module Msgs exposing (..)

import Http
import Navigation exposing (Location)

import Models.Episodes exposing (Episodes)
import Models.Rounds exposing (Rounds)

-- type alias EpisodesFetchResult = FetchResult
-- type alias RoundsFetchResult = FetchResult

type Msg
  = EpisodesFetchResult (Result Http.Error Episodes)
  | RoundsFetchResult (Result Http.Error Rounds)
  | UpdateSearchString String
  | OnLocationChange Location
