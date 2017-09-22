module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (EpisodeId, Route(..))
import UrlParser exposing (..)

episodesPath : String
episodesPath =
    "#episodes"


episodePath : EpisodeId -> String
episodePath id =
    "#episodes/" ++ id

matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map EpisodesRoute top
        , map EpisodeRoute (s "episodes" </> string)
        , map EpisodesRoute (s "episodes")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
