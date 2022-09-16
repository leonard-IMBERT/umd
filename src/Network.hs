{-# LANGUAGE GADTs #-}
module Network(
  Net(..),
  (-->),
  (>--),
  (--<),
  (>->),
  (--|)
) where

import Op

--- Network ---

data Net where
  In :: Net
  Forward :: Op op => Net -> op -> Net
  Merge :: Op op => Net -> Net -> op -> Net
  Out :: Net -> Net

instance Show Net where
  show In = "I"
  show (Forward net _) = show net ++ " --> "
  show (Merge net1 net2 _) = "(" ++ show net1 ++ "\n" ++ show net2 ++ ")"
  show (Out net) = show net ++ "O"

instance Op Net where
  solve t_in (Out nTail) = solve t_in nTail
  solve t_in (Forward nTail op) = solve t_in nTail >>= (`solve` op)
  solve t_in In = Right t_in
  solve t_in (Merge n1 n2 op) = case (solve t_in n1, solve t_in n2) of
    (Right t1, Right t2) -> if t1 == t2 then solve t1 op else Left "[Bug] For the moment, merge need the two branch to return tensors of the same rank and dimensions"
    (Left e1, Left e2) -> Left $ e1 ++ " | " ++ e2
    (Left e1, _) -> Left e1
    (_, Left e2) -> Left e2

(-->) :: Op op => Net -> op -> Net
(-->) = Forward

(>--) :: Op op => (Net, Net) -> op -> Net
(>--) (inn1, inn2) = Merge inn1 inn2

(--<) :: Net -> (Net -> Net, Net -> Net) -> (Net, Net)
(--<) a (f1, f2) = (f1 a, f2 a)

(>->) :: Net -> Net
(>->) a = a

(--|) :: Net -> (Net -> Net) -> Net
(--|) a b = b a
