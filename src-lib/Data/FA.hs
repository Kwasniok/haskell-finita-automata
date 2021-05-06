module Data.FA (
State,
    Symbol,
    FARead,
    FAAccept,
    accepts,
    DFA (MkDFA),
    NFA (MkNFA),
    dfaToNfa,
) where

import Prelude hiding (map)
import Data.Maybe
import Data.Collection.Finite
import Data.Collection.FiniteSet
import Data.FA.State
import Data.FA.Symbol
import Data.FA.Base (FARead, FAAccept, readSymbol, readWord, accepts)
import Data.FA.DFA (DFA (MkDFA))
import Data.FA.NFA (NFA (MkNFA))
import qualified Data.FA.DFA as DFA
import qualified Data.FA.NFA as NFA

-- transforms f :: (a -> b) to h ::(Maybe a -> c)
-- with a transformation g :: (b -> c) and a default value d ::c
-- such that:
-- h Nothing = d :: c)
-- h (Just x) = g (f x)
maybefy :: (a -> b) -> (b -> c) -> c -> (Maybe a -> c)
maybefy _ _ d Nothing = d
maybefy f g _ (Just x) = g (f x)

-- converts a DFA to an equivalent NFA
dfaToNfa :: (State a, Symbol b, Ord b) => DFA a b -> NFA a b
dfaToNfa (MkDFA t1 qi qas) = (MkNFA t2 qi qas) where
    t2 q = maybefy (t1 q) singleton Empty
