module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (EpisodeId, Route(..))
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map EpisodesRoute top
        , map EpisodeRoute (s "episodes" </> string)
        , map EpisodesRoute (s "episodes")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parsePath matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
