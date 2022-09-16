{-# LANGUAGE GADTs #-}
module Main(main) where

import Network
import Layers
import ResNet
import Op


main :: IO ()
main = do

  let i = [10]

  let h = [30]

  let o = [4]


  let model = In --> denseRelu i h --> denseRelu h h  --> resNet h --> denseRelu h h --> dense (h ++ o) o --| Out



  print (case solve i model of
    Right td -> "Model is correct, output shape: " ++ show td
    Left err -> "Got an error : " ++ err)
