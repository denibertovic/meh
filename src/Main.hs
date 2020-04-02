{-# LANGUAGE OverloadedStrings #-}

module Main where

import Graphics.Aosd.Pango

markup = pBold $ pMono $ pSized 200 (pUnlines ["MEH", "¯\\_(ツ)_/¯"])

main =
    withAosd
        defaultOpts
        (textRenderer markup) { alignment = Just AlignCenter, colour = orange }
        (\a -> aosdFlash a (symDurations 1000 1000))

