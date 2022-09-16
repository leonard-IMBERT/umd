module Op (
  Op,
  solve,
  AtomicTOp(..),
  convOp,
  dotOp,
  Fun(..)
) where

import TensorType
import Data.List (isSuffixOf)

class Op operator where
  solve :: TensorDef -> operator -> Either String TensorDef

data AtomicTOp = Sum TensorDef | Prod TensorDef | Dot TensorDef | Conv TensorDef

dotOp :: TensorDef -> TensorDef -> TensorDef
-- dotOp xs ys = [x | (x, y) <- zip xs $ reverse ys, x /= y] ++ [y | (y, x) <- zip ys $ reverse xs, x /= y]
dotOp xs ys = case (reverse xs, ys) of
  ([], []) -> [1]
  ([], bs) -> bs
  (as, []) -> as
  (as, bs)
    | a == b -> dotOp (tail as) (tail bs)
    | otherwise -> reverse as ++ bs
    where a = head as
          b = head bs

convOp :: TensorDef -> TensorDef -> TensorDef
convOp xs _ = xs

instance Op AtomicTOp where
  solve [] _                       = Left "Cannot solve an operator with an empty tensor as input"

  solve t_in (Sum dims)
    | dims `isSuffixOf` t_in || sum dims == 1 = Right t_in
    | otherwise                               = Left "The dimension of the sum are not compatible"

  solve t_in (Prod dims)
    | dims `isSuffixOf` t_in || sum dims == 1 = Right t_in
    | otherwise                               = Left "The dimension of the product are not compatible"

  solve t_in (Dot dims)
    | joint /= t_in ++ dims = Right joint
    | otherwise             = Left "No possible dot operation"
    where joint = dotOp t_in dims

  solve t_in (Conv dims)
    | length dims <= length t_in = Right $ convOp t_in dims
    | otherwise                  = Left "The dimension of the conv are not compatible"


data Fun = Fun TensorDef

instance Op Fun where
  solve _ (Fun t_out) = Right t_out
