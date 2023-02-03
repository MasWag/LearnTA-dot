module Main (main) where

import Data.Text.Lazy

import Data.TimedAutomata.Parser
import qualified Data.TimedAutomata.Printer as P
import Data.TimedAutomata.Translating

main :: IO ()
main = do
  inputTA <- parse.pack <$> getContents
  -- case P.asTikz inputTA of 
  --   Just text -> (putStrLn.unpack) $ text
  --   Nothing -> putStrLn "The given TA is invalid."  
  case translateTimedAutomaton inputTA of 
    Just outputTA -> (putStrLn.unpack) $ P.print outputTA
    Nothing -> putStrLn "The given TA is invalid."
