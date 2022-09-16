module ResNet (
  resNet
) where

import Network
import Op
import Layers
import TensorType

resNet :: TensorDef -> Net
resNet s = In --< (\net -> net --> denseRelu s s --> denseRelu s s, (>->)) >-- Sum s --| Out
