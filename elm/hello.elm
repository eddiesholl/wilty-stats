import Html exposing (..)
import Html.Attributes exposing (class, value, href)
import Http
import Navigation exposing (Location)

import Models.Episodes exposing (Episode, EpisodeId, Episodes)
import Models.Rounds exposing (getEpisodeIdFromRound, getRoundFromRound)
import Models.App exposing (EpisodesModel, initialModel, Route(..))
import Msgs exposing (Msg(..))
import Routing exposing (parseLocation)
import Decoders exposing (..)
import Episodes.List
import Episodes.View

main : Program Never EpisodesModel Msg
main =
  Navigation.program Msgs.OnLocationChange
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

getData : Cmd Msg
getData =
  Cmd.batch [
  getEpisodes
  , getRounds
  ]

getEpisodes : Cmd Msg
getEpisodes =
  let
    url = "//localhost:3000/episodes"
  in
    Http.send EpisodesFetchResult (Http.get url decodeEpisodes)

getRounds : Cmd Msg
getRounds =
  let
    url = "//localhost:3000/rounds"
  in
    Http.send RoundsFetchResult (Http.get url decodeRounds)

init : Location -> (EpisodesModel, Cmd Msg)
init location =
  let
    currentRoute =
      Routing.parseLocation location
  in
    ( initialModel currentRoute
    , getData
    )

 -- UPDATE

update : Msg -> EpisodesModel -> (EpisodesModel, Cmd Msg)
update msg model =
  case msg of
    EpisodesFetchResult (Ok newEpisodes) ->
      ({ model | episodes = newEpisodes}, Cmd.none)
    EpisodesFetchResult (Err e) ->
      let
        newError = "Episode fetch failed: " ++ toString e
      in
        ({ model | error = newError}, Cmd.none)
    RoundsFetchResult (Ok newRounds) ->
      ({ model | rounds = newRounds}, Cmd.none)
    RoundsFetchResult (Err e) ->
      let
        newError = "Rounds fetch failed: " ++ toString e
      in
        ({ model | error = newError}, Cmd.none)
    UpdateSearchString newSearchString ->
      (model, Cmd.none)
    OnLocationChange location ->
      let
          newRoute =
              parseLocation location
      in
          ( { model | route = newRoute }, Cmd.none )

isRoundForEpisode episodeId round =
  let
    e = getEpisodeIdFromRound round
  in
    e == episodeId

 -- VIEW
episodeViewPage : EpisodesModel -> EpisodeId -> Html Msg
episodeViewPage model episodeId =
  let
      maybeEpisode =
          model.episodes
              |> List.filter (\episode -> episode.id == episodeId)
              |> List.head
  in
      case maybeEpisode of
          Just episode ->
            let
              maybeRounds =
                  model.rounds
                      |> List.filter (isRoundForEpisode episode.id)
                      |> List.sortBy (getRoundFromRound)
            in
              Episodes.View.view episode maybeRounds

          Nothing ->
              notFoundView



notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]

detailView : EpisodesModel -> Html Msg
detailView model =
    case model.route of
        EpisodesRoute ->
            Episodes.List.view model

        EpisodeRoute id ->
            episodeViewPage model id

        NotFoundRoute ->
            notFoundView

headerView model =
  div []
    [a
      [ href "/"
      ]
      [text "Home"]
    ]

view model =
  div []
    [ headerView model
    , detailView model
    ]
 -- SUBSCRIPTIONS

subscriptions : EpisodesModel -> Sub Msg
subscriptions model =
  Sub.none
