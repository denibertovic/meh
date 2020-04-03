{-# LANGUAGE OverloadedStrings #-}

module Main where

import Graphics.Aosd.Pango hiding (version)
import Data.Version (showVersion)
import System.Environment (getArgs)
import Options.Applicative
import Paths_meh (version)


data MyArgs = MyArgs { xOffset :: Maybe Int, yOffset :: Maybe Int  }

xOffsetOpt :: Parser (Maybe Int)
xOffsetOpt =
  optional $
  option auto
    (long "xoffset" <> short 'x' <> metavar "OFFSET" <>
     help "X Offset. Useful with Xinerama and multiple screens..")

yOffsetOpt :: Parser (Maybe Int)
yOffsetOpt =
  optional $
  option auto
    (long "yoffset" <> short 'y' <> metavar "OFFSET" <>
     help "Y Offset. Useful with Xinerama and multiple screens..")

versionOpt :: Parser (a -> a)
versionOpt =
  infoOption
    (showVersion version)
    (long "version" <> short 'v' <> help "Show version.")

myArgs :: Parser MyArgs
myArgs = MyArgs <$> xOffsetOpt <*> yOffsetOpt


markup = pBold $ pMono $ pSized 200 (pUnlines ["MEH", "¯\\_(ツ)_/¯"])

main :: IO ()
main = do
      execParser opts >>= \(MyArgs x y ) -> do
        withAosd
            defaultOpts { offset = (maybe 0 fromIntegral x, maybe 0 fromIntegral y), classHint = Just $ XClassHint { resName = "meh", resClass = "meh" } }
            (textRenderer markup) { alignment = Just AlignCenter, colour = orange }
            (\a -> aosdFlash a (symDurations 1000 1000))

  where opts =
          info
            (helper <*> versionOpt <*> myArgs )
            (fullDesc <> progDesc "meh - For when you really need it." <>
             header "meh - MEH")
