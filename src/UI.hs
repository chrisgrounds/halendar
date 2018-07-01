module UI where

import Brick
import qualified Data.Time as Time
import qualified Data.Time.Calendar.MonthDay as MonthDay
import Data.Monoid 
import Graphics.Vty

import Calendar

instance Monoid (Widget a) where
    mempty = emptyWidget
    mappend a b = a <+> b

getDaysInMonth :: Calendar -> [Int]
getDaysInMonth c = [1..(MonthDay.monthLength (Time.isLeapYear $ currentYear c) (currentMonth c))]

padRightWithSpaces :: Int -> Widget a -> Widget a
padRightWithSpaces n = (padRight (Pad n))

-- TODO: Refactor this mess of code
dateToWidget :: Calendar -> String -> Widget a
dateToWidget c d
  | length d == 1 && (read d :: Int) == focusedDay c = (padRightWithSpaces 3) . styleToday . str $ d
  | length d == 1 = (padRightWithSpaces 3) . str $ d
  | length d == 2 && (read d :: Int) == focusedDay c = (padRightWithSpaces 2) . styleToday . str $ d
  | otherwise = (padRightWithSpaces 2) . str $ d

styleToday :: Widget a -> Widget a
styleToday = withAttr (attrName "focusedDay")

widgetsToLines :: [[Widget a]] -> [Widget a]
widgetsToLines w = foldr (<>) mempty <$> w

splitAtAll :: Int -> [Int] -> [[Int]]
splitAtAll _ [] = []
splitAtAll c xs = [(fst $ splitAt c xs)] ++ splitAtAll c (drop c xs)

datesUI :: Calendar -> [[Int]] -> Widget a 
datesUI c dates = vBox $ widgetsToLines $ ((<$>) . (<$>)) ((dateToWidget c) . show) dates

ui :: Calendar -> Widget a
ui c = do  
    str "June" 
    <=> datesUI c (splitAtAll 7 (getDaysInMonth c))

drawUI :: Calendar -> [Widget a]
drawUI c = return $ ui c

