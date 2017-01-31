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


getMoviePoster : String -> Cmd Msg
getMoviePoster searchString =
  let
    --url = "//localhost:8000/episodes"
        url =
      "//www.omdbapi.com/?t=" ++ searchString
  in
    Http.send FetchResult (Http.get url decodeMovieUrl)

type alias Movie =
  { title : String
  , posterUrl : String
  }
decodeMovieUrl : Json.Decoder Movie
decodeMovieUrl =
  decode Movie
    |> JsonPipeline.required "Title" string
    |> JsonPipeline.required "Poster" string

type alias Model =
  { searchString : String
  , title: String
  , posterUrl : String
  }

init : (Model, Cmd Msg)
init =
  ( Model "Frozen" "" ""
  , getMoviePoster "Frozen"
  )

 -- UPDATE

type Msg
  = GetPoster
  | ChangeMovieTitle String
  | FetchResult (Result Http.Error Movie)
  | UpdateSearchString String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangeMovieTitle newSearchString ->
       { model | title = newSearchString } ! []
    GetPoster ->
      { model | posterUrl = "waiting.gif"
      , title = ""
      } ! [getMoviePoster model.searchString]
    FetchResult (Ok movie) ->
      (Model model.searchString movie.title movie.posterUrl, Cmd.none)
    FetchResult (Err _) ->
      let
        errorMessage = "We couldn’t find that movie 😯"
        errorImage = "oh-no.jpeg"
      in
        (Model model.searchString errorMessage errorImage, Cmd.none)
    UpdateSearchString newSearchString ->
      { model | searchString = newSearchString } ! []

 -- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "enter a movie title"
            , value model.searchString
            , autofocus True
            , onInput UpdateSearchString
            ] []
   , button [ onClick GetPoster ] [ text "Get poster!" ]
   , br [] []
   , h1 [] [ text model.title ]
   , img [ src model.posterUrl ] []
 ]

 -- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
