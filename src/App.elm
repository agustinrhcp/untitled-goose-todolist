module App exposing (main)

import Array exposing (Array)
import Browser exposing (Document)
import Html exposing (Html, button, div, i, li, p, text, textarea, ul)
import Html.Attributes exposing (autofocus, class, rows, tabindex)
import Html.Events exposing (onClick, onInput)


main : Program () Todos Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Todo =
    { text : String
    , completed : Bool
    }


type Todos
    = Todos (Array Todo)


type Msg
    = TodoAdded
    | TodoToggleCompleted Int
    | TodoUpdated Int String


init : () -> ( Todos, Cmd Msg )
init _ =
    ( todosFromStringList
        [ "pick a ticket to work on"
        , "work on it"
        , "create a pull request"
        , "do some QA"
        , "move ticket to ready for review"
        , "address any comments"
        , "move ticket to product review"
        , "wait for product approval"
        , "ship it"
        ]
    , Cmd.none
    )


todoInit : String -> Todo
todoInit text =
    Todo text False


todosMap : (Int -> Todo -> a) -> Todos -> List a
todosMap func (Todos todos) =
    todos
        |> Array.indexedMap func
        |> Array.toList


todosFromStringList : List String -> Todos
todosFromStringList todosText =
    todosText
        |> List.map todoInit
        |> Array.fromList
        |> Todos


todosGet : Int -> Todos -> Todo
todosGet index (Todos todos) =
    todos
        |> Array.get index
        |> Maybe.withDefault (todoInit "Not found Mate")


todosSet : Int -> Todo -> Todos -> Todos
todosSet index todo (Todos todos) =
    todos
        |> Array.set index todo
        |> Todos


todosAdd : Todo -> Todos -> Todos
todosAdd todo (Todos todos) =
    todos
        |> Array.push todo
        |> Todos


update : Msg -> Todos -> ( Todos, Cmd Msg )
update msg todos =
    case msg of
        TodoToggleCompleted index ->
            let
                todo =
                    todosGet index todos
            in
            ( todosSet index { todo | completed = not todo.completed } todos
            , Cmd.none
            )

        TodoUpdated index newText ->
            let
                todo =
                    todosGet index todos
            in
            ( todosSet index { todo | text = newText } todos
            , Cmd.none
            )

        TodoAdded ->
            let
                newTodo =
                    todoInit ""
            in
            ( todosAdd newTodo todos, Cmd.none )


view : Todos -> Document Msg
view todos =
    { title = "A Goose"
    , body =
        [ div [ class "background" ] []
        , div [ class "notebook" ]
            [ div [ class "notebook__top-margin" ] []
            , div [ class "notebook__left-margin" ] []
            , p [ class "notebook__heading" ] [ text "to do :" ]
            , [ viewAddTodo ]
                |> (++) (todosMap viewTodo todos)
                |> ul [ class "notebook__ruler" ]
            ]
        ]
    }


viewTodo : Int -> Todo -> Html Msg
viewTodo index todo =
    let
        classes =
            (if todo.completed then
                [ "todo--completed" ]

             else
                []
            )
                |> (++) [ "todo" ]
                |> String.join " "
    in
    li [ class classes ]
        [ button
            [ tabindex -1
            , class "button-icon"
            , onClick <| TodoToggleCompleted index
            ]
            [ i [ class "material-icons" ] [ text "check_circle_outline" ] ]
        , textarea [ autofocus True, rows 1, onInput <| TodoUpdated index ]
            [ text todo.text ]
        ]


viewAddTodo : Html Msg
viewAddTodo =
    li [ class "todo todo--add" ]
        [ button [ class "button-icon", onClick TodoAdded ]
            [ i [ class "material-icons" ] [ text "add_circle_outline" ]
            ]
        ]
