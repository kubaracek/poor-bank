module Simulation (simulate) where

import Types
import Math (inverse, betaDistribution)
import System.Random (randomRIO)
import Control.Monad
import Data.Conduit
import Data.List
import Text.Printf (printf)
import qualified Data.Conduit.Combinators as C
import qualified Data.Conduit.List as L

import Control.Monad (forever)
import Control.Monad.IO.Class (liftIO, MonadIO)

randomStream :: MonadIO m => (Double, Double) -> ConduitT a Double m b
randomStream range = forever $ liftIO (randomRIO range) >>= yield

calculateWaiting :: [TimeSeries] -> (Double, Double) -> [TimeSeries]
calculateWaiting [] _ = []
calculateWaiting acc (arr, pro) =
  let
    waitingCalc =  tProcessing (last acc) - arr
    waitingFn =
      if waitingCalc < 0 then
        0
      else
        waitingCalc
  in
  acc ++ [TimeSeries arr pro waitingFn]

simulationPipeline :: Int -> Customer -> ConduitM () c IO [TimeSeries]
simulationPipeline numberOfSimulations customer =
   randomStream (0.0,1.0)
    .| C.take numberOfSimulations
    .| C.map (\r -> (r, inverse Bank r))                   -- Get inverse CDF
    .| C.map (\(r, a) -> (a, betaDistribution customer r)) -- Get Beta Distributions
    .| C.foldl calculateWaiting [TimeSeries 0 0 0]         -- fold to calculate waiting times

simulate :: Int -> Customer -> IO [TimeSeries]
simulate simCount cus =
  runConduit $ simulationPipeline simCount cus
