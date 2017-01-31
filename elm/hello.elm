import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing(string)
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)
import Task


main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

 -- MODEL


getEpisodes : Cmd Msg
getEpisodes =
  let
    url = "//localhost:3000/episodes"
  in
    Http.send FetchResult (Http.get url decodeEpisodes)

type alias Episodes = List Episode

type alias Episode =
  { season: String
  , title : String
  , episode: String
  , id: String
  }

decodeEpisodes : Json.Decoder Episodes
decodeEpisodes = Json.list decodeEpisode

decodeEpisode : Json.Decoder Episode
decodeEpisode =
  decode Episode
    |> JsonPipeline.required "season" string
    |> JsonPipeline.required "title" string
    |> JsonPipeline.required "episode" string
    |> JsonPipeline.required "id" string

type alias Model =
  {
  episodes : List Episode
  }

init : (Model, Cmd Msg)
init =
  ( Model []
  , getEpisodes
  )

 -- UPDATE

type Msg
  = GetPoster
  | ChangeMovieTitle String
  | FetchResult (Result Http.Error Episodes)
  | UpdateSearchString String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangeMovieTitle newSearchString ->
       model ! []
    GetPoster ->
      model ! [getEpisodes]
    FetchResult (Ok episodes) ->
      (Model episodes, Cmd.none)
    FetchResult (Err _) ->
      let
        errorMessage = "We couldn’t find that movie 😯"
        errorImage = "oh-no.jpeg"
      in
        (model, Cmd.none)
    UpdateSearchString newSearchString ->
      model ! []

 -- VIEW

--episodeToHtml : Episode -> Html
episodeToHtml episode =
  li [] [text episode.id]

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "enter a movie title"
            , value "abc"
            , autofocus True
            , onInput UpdateSearchString
            ] []
   , button [ onClick GetPoster ] [ text "Get poster!" ]
   , ul []
      (List.map episodeToHtml model.episodes)
 ]

 -- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
