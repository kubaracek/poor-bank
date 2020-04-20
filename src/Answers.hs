module Answers (run) where

import Data.List (groupBy, minimumBy)
import Data.Ord (comparing)
import Types (Customer(..), TimeSeries(..))
import qualified Data.Map.Strict as Map
import Text.Printf
 
import Simulation (simulate)

run = do
  [red, yellow, blue] <- mapM (simulate 1000) [Red, Yellow, Blue]

  let waitingAll = (map tWaiting) <$> [red, yellow, blue]
  let averageMaxWaitingAll = map averageMax waitingAll
  let waiting = Map.fromList $ zip ["Red", "Yellow", "Blue"] averageMaxWaitingAll 

  uncurry (printf "(Yellow waiting) avg: %.2f max: %.2f\n") $ waiting Map.! "Yellow"

  let redQueues = averageMax' $ map length $ queues (map tWaiting red)
  uncurry (printf "(Red in queues) avg: %d max: %d\n") redQueues

  let closest = minimumBy (comparing snd) $ Map.toAscList $ Map.map diffTuple waiting
  printf "(Closest average to maximum): %s" $ fst closest
  return ()

queues :: [Double] -> [[Double]]
queues =
  filter ((/=) [0.0])                              -- filter out no queues
  . (groupBy (\x y -> x >= 0 && x /= 0 && y /= 0)) -- group anything above 0 (waiting timDouble) togeDoubleheDouble

averageMax  l = (sum l / fromIntegral (length l) , maximum l)
averageMax' l = (div (sum l) (length l), maximum l)

diffTuple :: (Double, Double) -> Double
diffTuple (a, b) = abs(b - a)
