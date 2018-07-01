{-# LANGUAGE OverloadedStrings #-}
module Main where

import Brick
import qualified Data.Time as Time
import Graphics.Vty

import Calendar
import UI
import Events

getToday :: IO (Integer, Int, Int)
getToday = Time.getCurrentTime >>= return . Time.toGregorian . Time.utctDay

attributeMap :: AttrMap
attributeMap = attrMap defAttr [("focusedDay", (black `on` white))]

type A = ()
type B = ()

app :: App Calendar A B
app = App { appDraw = drawUI
          , appChooseCursor = neverShowCursor
          , appHandleEvent = handleEvent
          , appStartEvent = return
          , appAttrMap = const attributeMap
          }

main :: IO Calendar
main = do
    (year, month, day) <- getToday
    let calendar = Calendar { 
        currentYear = year
        , currentMonth = month
        , currentDay = day
        , focusedDay = day
        }
    defaultMain app calendar

