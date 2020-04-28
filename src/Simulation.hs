module Simulation (simulate, holala) where

import Types
import Math (inverse, betaDistribution)
import System.Random (randomRIO)
import Control.Monad
import Conduit
import Data.Conduit
import Data.List
import Text.Printf (printf)
import qualified Data.Conduit.Combinators as C
import qualified Data.Conduit.List as L

import Control.Monad (forever)
import Control.Monad.IO.Class (liftIO, MonadIO)

randomStream :: MonadIO m => (Double, Double) -> ConduitT () Double m ()
randomStream range = forever $ liftIO (randomRIO range) >>= yield

calculateWaiting :: (Double, Double) -> TimeSeries -> TimeSeries
calculateWaiting (arr, pro) acc =
  let
    waitingCalc =  tProcessing acc - arr
    waitingFn =
      if waitingCalc < 0 then
        0
      else
        waitingCalc
  in
  TimeSeries arr pro waitingFn
 
getTimeSeries :: Customer -> ConduitT () TimeSeries IO ()
getTimeSeries customer =
    randomStream (0.0, 1.0)
    .| C.map (\r -> (r, inverse Bank r))                   -- Get inverse CDF
    .| C.map (\(r, a) -> (a, betaDistribution customer r)) -- Get Beta Distributions
    .| void ( L.scan calculateWaiting (TimeSeries 0 0 0) ) -- fold to calculate waiting time
 
average :: Monad m => ConduitT Double Void m Double
average =
    getZipSink (go <$> ZipSink sumC <*> ZipSink lengthC)
  where
    go total len = total / fromIntegral len
 
averageWaiting :: MonadIO m => ConduitT TimeSeries Void m Double
averageWaiting =
     C.map tWaiting
  .| average

simulate :: Int -> Customer -> IO [TimeSeries]
simulate simCount cus = do
  -- runConduit $ simulationPipeline simCount cus
  return $ map id [TimeSeries 0 0 0]

waitingAll :: ConduitT TimeSeries Double IO ()
waitingAll = C.map tWaiting

holala :: IO Double
holala =
  runConduit
    $ getTimeSeries Red
    .| C.take 10000000
    .| averageWaiting
