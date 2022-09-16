module Layers (
  dense,
  relu,
  denseRelu
) where

import Network
import TensorType
import Op

--- Layer ---

dense :: TensorDef -> TensorDef -> Net
dense w b =  In --> Dot w --> Sum b --| Out

relu :: TensorDef -> Net
relu i =  In --> Fun i --| Out

denseRelu :: [Int] -> [Int] -> Net
denseRelu i o  = In --> dense (i ++ o) o --> relu o --| Out
