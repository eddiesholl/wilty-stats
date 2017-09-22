import Html exposing (..)
import Http
import Json.Decode as Json exposing(string)
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)
import Navigation exposing (Location)

import Models exposing (Episode, EpisodeId, Episodes, EpisodesModel, initialModel, Route)
import Msgs exposing (Msg(..))
import Routing exposing (parseLocation)
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

getEpisodes : Cmd Msg
getEpisodes =
  let
    url = "//localhost:3000/episodes"
  in
    Http.send FetchResult (Http.get url decodeEpisodes)

decodeEpisodes : Json.Decoder Episodes
decodeEpisodes = Json.list decodeEpisode

decodeEpisode : Json.Decoder Episode
decodeEpisode =
  decode Episode
    |> JsonPipeline.required "season" string
    |> JsonPipeline.required "title" string
    |> JsonPipeline.required "episode" string
    |> JsonPipeline.required "id" string

init : Location -> (EpisodesModel, Cmd Msg)
init location =
  let
    currentRoute =
      Routing.parseLocation location
  in
    ( initialModel currentRoute
    , getEpisodes
    )

 -- UPDATE

update : Msg -> EpisodesModel -> (EpisodesModel, Cmd Msg)
update msg model =
  case msg of
    FetchResult (Ok newEpisodes) ->
      ({ model | episodes = newEpisodes}, Cmd.none)
    FetchResult (Err _) ->
      let
        errorMessage = "We couldn’t find that movie 😯"
        errorImage = "oh-no.jpeg"
      in
        (model, Cmd.none)
    UpdateSearchString newSearchString ->
      (model, Cmd.none)
    OnLocationChange location ->
      let
          newRoute =
              parseLocation location
      in
          ( { model | route = newRoute }, Cmd.none )

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
              Episodes.View.view episode

          Nothing ->
              notFoundView



notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]

view : EpisodesModel -> Html Msg
view model =
    case model.route of
        Models.EpisodesRoute ->
            Episodes.List.view model

        Models.EpisodeRoute id ->
            episodeViewPage model id

        Models.NotFoundRoute ->
            notFoundView

 -- SUBSCRIPTIONS

subscriptions : EpisodesModel -> Sub Msg
subscriptions model =
  Sub.none
