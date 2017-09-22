module Msgs exposing (..)

import Http
import Navigation exposing (Location)

import Models exposing (Episodes)

type Msg
  = FetchResult (Result Http.Error Episodes)
  | UpdateSearchString String
  | OnLocationChange Location
