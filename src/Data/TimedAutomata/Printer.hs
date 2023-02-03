{-# LANGUAGE OverloadedStrings #-}

module Data.TimedAutomata.Printer where
import Data.TimedAutomata.Types
import Data.GraphViz.Printing
import qualified Data.Text.Lazy as T
import qualified Data.GraphViz as Dot
import Data.GraphViz.Attributes.Complete
import Data.List
import Data.Maybe

-- |
-- Print the timed automaton
-- Maybe instanciating Show is better
print :: OutputTimedAutomaton -> T.Text
print = printIt

nodeAsTikz :: OutputState -> T.Text
nodeAsTikz (Dot.DotNode nodeID attributes) =
  T.concat ["\\node[", attributesAsText, "state] (", T.pack nodeID, ") [align=center]{$", T.pack nodeID, "$};\n"]
  where
    checkProperty name = case find (sameAttribute (UnknownAttribute name "1")) attributes of
      Nothing -> False
      Just (UnknownAttribute name "false") -> False
      Just (UnknownAttribute name "0") -> False
      Just (UnknownAttribute name _) -> True
      Just _ -> False
    isMatch = isJust $ find (sameAttribute (UnknownAttribute "match" "1")) attributes
    initString :: String
    initString = if checkProperty "init" then "initial," else ""
    matchString :: String
    matchString = if checkProperty "match"  then "accepting," else ""
    attributesAsText =
      T.pack $ initString ++ matchString

edgeAsTikz :: OutputTransition -> T.Text
edgeAsTikz (Dot.DotEdge fromNode toNode attributes) =
  T.concat ["(", T.pack fromNode, ") edge node {", label, "} (", T.pack toNode, ")\n"]
  where
    label = T.concat [event, guardSep, guard, resetSep, reset]
    event = case find (sameAttribute (Label (StrLabel ""))) attributes of
      Nothing -> "empty"
      Just (Label (StrLabel str)) -> str
      Just _ -> "empty"
    guardSep = if guard == "" then "" else ", "
    resetSep = if reset == "" then "" else " / "
    guard = case find (sameAttribute (UnknownAttribute "guard" "")) attributes of
      Nothing -> ""
      Just (UnknownAttribute "guard" str) ->
        if (T.head str) == '{' && (T.last str) == '}' then
          T.init $ T.tail str
        else
          ""
      Just _ -> ""
    reset = case find (sameAttribute (UnknownAttribute "reset" "")) attributes of
      Nothing -> ""
      Just (UnknownAttribute "reset" str) -> 
        if (T.head str) == '{' && (T.last str) == '}' then
          foldl (\l r -> if l == "" then r else T.concat [l, ", " ,r]) "" $ T.split (==',') $ T.init $ T.tail str
        else
          ""
      Just _ -> ""

asTikz :: OutputTimedAutomaton -> Maybe T.Text
asTikz (Dot.DotGraph False True _ (Dot.DotStmts _ _ nodes edges)) =
  Just $ T.concat [headerText, nodeText, edgeText, footerText]
  where
    nodeText :: T.Text
    nodeText = T.concat $ Prelude.map nodeAsTikz nodes
    edgeText :: T.Text
    edgeText = T.concat $ ("\\path[->]\n" : (Prelude.map edgeAsTikz edges)) ++ [";\n"]
    headerText :: T.Text
    headerText = "\\begin{tikzpicture}\n"
    footerText :: T.Text
    footerText = "\\end{tikzpicture}\n"

asTikz _ = Nothing
