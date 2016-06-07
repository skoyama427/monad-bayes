{-# LANGUAGE
  GeneralizedNewtypeDeriving
 #-}

module Control.Monad.Bayes.Rejection (
                  Rejection,
                  runRejection) where

import Control.Monad
import Control.Monad.Trans.Class
import Control.Monad.Trans.Maybe

import Control.Monad.Bayes.Class

-- | A wrapper for 'MaybeT' that uses it for conditioning.
-- Only hard conditioning is allowed, that is
-- 'condition' works correctly, while 'factor' and'observe'
-- result in an error.
newtype Rejection m a = Rejection {toMaybeT :: (MaybeT m a)}
    deriving (Functor, Applicative, Monad, MonadTrans, MonadDist)

-- | Equivalent to 'runMaybeT'
runRejection :: Rejection m a -> m (Maybe a)
runRejection = runMaybeT . toMaybeT

instance MonadDist m => MonadBayes (Rejection m) where
    factor _ = error "Rejection does not support soft conditioning"
    condition b = unless b (fail "")
