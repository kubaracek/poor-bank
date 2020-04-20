module Types (Customer(..), Establishment(..), TimeSeries(..)) where

import Math (BetaDistribution, CumulativeDistribution, distribution, alfa)

data Customer
   = Red
   | Yellow
   | Blue

data Establishment = Bank

data TimeSeries = TimeSeries
  { tArrival    :: Double -- After the previous visitior
  , tProcessing :: Double
  , tWaiting    :: Double -- Waiting for the previous visitor to process
  } deriving (Show)

instance BetaDistribution Customer where
  distribution Yellow = (2, 5)
  distribution Red    = (2, 2)
  distribution Blue   = (5, 1)

instance CumulativeDistribution Establishment where
  alfa Bank = 100
