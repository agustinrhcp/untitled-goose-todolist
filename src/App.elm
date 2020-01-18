module App exposing (main)

import Browser exposing (Document)
import Html exposing (Html, div, text)


main : Program () String Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = Something


init : () -> ( String, Cmd Msg )
init _ =
    ( "", Cmd.none )


update : Msg -> String -> ( String, Cmd Msg )
update msg model =
    ( "", Cmd.none )


view : String -> Document Msg
view _ =
    { title = "A Goose"
    , body = [ div [] [ text "lala" ] ]
    }
