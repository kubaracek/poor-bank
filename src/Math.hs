module Math (BetaDistribution, CumulativeDistribution, distribution, alfa, inverse, betaDistribution) where

class BetaDistribution a where
  betaDistribution :: a -> Double -> Double
  betaDistribution typ x =
    let (alfa, beta) = distribution typ
    in
    200 * x ** (alfa - 1) * (1 - x) ** (beta - 1)

  distribution :: a -> (Double, Double)

class CumulativeDistribution a where
  inverse :: a -> Double -> Double
  inverse typ p = - log (1 - p) / ( 1 / alfa typ)

  alfa :: a -> Double
