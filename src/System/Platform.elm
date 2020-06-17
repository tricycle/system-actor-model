module System.Platform exposing (Program)

{-|

@docs Program

-}

import System.Internal.Message exposing (SystemMessage)
import System.Internal.Model exposing (SystemModel)


{-| This will be the type of your program when you create it using this package.

Checkout out the `element` and `application` functions in the System.Browser module to find out how to create a System.Program.

_A [Program](https://package.elm-lang.org/packages/elm/core/latest/Platform#Program) describes an Elm program! How does it react to input? Does it show anything on screen? Etc._

-}
type alias Program flags addresses actors appModel applicationMsg =
    Platform.Program flags (SystemModel addresses actors appModel) (SystemMessage addresses actors applicationMsg)
