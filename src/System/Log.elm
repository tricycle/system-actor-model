module System.Log exposing
    ( LogMessage
    , emergency, alert, critical, error, warning, notice, info, debug
    , withPosix
    , withMessage
    , toString, severityToString, toMeta
    )

{-| The System and your Actors can LogMessage through this module.

The System itself doesn't store these log messages anywhere,
It's up to you to handle and/or store these messages through an Actor.

@docs LogMessage


# Create

@docs emergency, alert, critical, error, warning, notice, info, debug


# Time

When you create a log message through any of the create helpers
your log message will not have a time accociated with it.

@docs withPosix


# Msg

What was the message that resulted in this LogMessage?
I don't know, but if you supply it I'll store it on the LogMessage type!

@docs withMessage


# Helpers

@docs toString, severityToString, toMeta

-}

import System.Internal.Message as Internal
    exposing
        ( LogMessage(..)
        , Severity(..)
        , logMessageToMeta
        , logMessageToString
        )
import System.Internal.PID exposing (PID)
import System.Message exposing (SystemMessage)
import Time exposing (Posix)


{-| The opaque LogMessage type

You can create LogMessages using the helper function available

-}
type alias LogMessage address actorName wrappedMsg =
    Internal.LogMessage address actorName wrappedMsg


{-| The Severity of the log message
-}
type alias Severity =
    Internal.Severity


{-| Create a new LogMessage with the severity Emergency
-}
emergency :
    PID
    -> String
    -> LogMessage address actorName wrappedMsg
emergency =
    create Emergency


{-| Create a new LogMessage with the severity Alert
-}
alert :
    PID
    -> String
    -> LogMessage address actorName wrappedMsg
alert =
    create Alert


{-| Create a new LogMessage with the severity Critical
-}
critical :
    PID
    -> String
    -> LogMessage address actorName wrappedMsg
critical =
    create Critical


{-| Create a new LogMessage with the severity Error
-}
error :
    PID
    -> String
    -> LogMessage address actorName wrappedMsg
error =
    create Error


{-| Create a new LogMessage with the severity Warning
-}
warning :
    PID
    -> String
    -> LogMessage address actorName wrappedMsg
warning =
    create Warning


{-| Create a new LogMessage with the severity Notice
-}
notice :
    PID
    -> String
    -> LogMessage address actorName wrappedMsg
notice =
    create Notice


{-| Create a new LogMessage with the severity Informational
-}
info :
    PID
    -> String
    -> LogMessage address actorName wrappedMsg
info =
    create Informational


{-| Create a new LogMessage with the severity Debug
-}
debug :
    PID
    -> String
    -> LogMessage address actorName wrappedMsg
debug =
    create Debug


create :
    Severity
    -> PID
    -> String
    -> LogMessage address actorName wrappedMsg
create severity pid description =
    LogMessage
        { posix = Nothing
        , severity = severity
        , pid = pid
        , message = Nothing
        , description = description
        }


{-| Add a Posix (elm/time) to your LogMessage
-}
withPosix :
    LogMessage address actorName wrappedMsg
    -> Posix
    -> LogMessage address actorName wrappedMsg
withPosix (LogMessage meta) posix =
    LogMessage { meta | posix = Just posix }


{-| Supply a Message that resulted in this logMessage

You could use this to retry a failed command for instance.

-}
withMessage :
    LogMessage address actorName wrappedMsg
    -> SystemMessage address actorName wrappedMsg
    -> LogMessage address actorName wrappedMsg
withMessage (LogMessage meta) message =
    LogMessage { meta | message = Just message }


{-| Turn a LogMessage into a String

    error pid wrappedMsg "I'm sorry Dave, I'm afraid I can't do that"
        |> toString

    -- error | 2(1) | I'm sorry Dave, I'm afraid I can't do that

    error system wrappedMsg "I'm sorry Dave, I'm afraid I can't do that"
        |> withPosix now
        |> toString

    -- 2019/12/25 12:59:59 (UTC) | error | system | I'm sorry Dave, I'm afraid I can't do that

-}
toString :
    LogMessage address actorName wrappedMsg
    -> String
toString =
    Internal.logMessageToString


{-| Severity to String
-}
severityToString :
    Severity
    -> String
severityToString =
    Internal.severityToString


{-| LogMessage to Description
-}
toMeta :
    LogMessage address actorName appMsg
    ->
        { posix : Maybe Posix
        , severity : Severity
        , pid : PID
        , message : Maybe (SystemMessage address actorName appMsg)
        , description : String
        }
toMeta =
    Internal.logMessageToMeta
