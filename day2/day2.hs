#!/usr/bin/env stack
-- stack --resolver lts-18.8 script
import           Data.List   (foldl')
import           Text.Parsec

type Parser a = Parsec String () a
type Point = (Int,Int)
type Aim = (Int, Point)
data Direction = Forward Int | Up Int | Down Int
  deriving(Show)

main :: IO ()
main = interact $ show . solve2 (0,(0,0)) . parses

solve2 :: Aim -> [Direction] -> Int
solve2 aim dirs = let (_, (x,y)) = foldl' f aim dirs
                  in x * y
  where f (aim, (p1,p2)) (Down i)    = (aim + i, (p1,p2))
        f (aim, (p1,p2)) (Up i)      = (aim-i, (p1,p2))
        f (aim, (p1,p2)) (Forward i) = (aim, (p1 + i, p2 + aim * i))

pos :: Point -> Direction -> Point
pos (p1,p2) (Forward i) = (p1 + i, p2)
pos (p1,p2) (Up i)      = (p1, p2 - i)
pos (p1,p2) (Down i)    = (p1, p2 + i)

solve :: Point -> [Direction] -> Int
solve point@(p1,p2) dirs = let (x,y) = foldl' pos point dirs
                           in x * y

parses str = case (parse (between scn eof (many1 directionparser)) "" str) of
               Left err -> error "failed"
               Right xs -> xs

directionparser :: Parser Direction
directionparser = choice [ fmap Forward (dir "forward")
                         , fmap Up (dir "up")
                         , fmap Down (dir "down")
                         ]
  where
    dir d = do
      lexeme (string d)
      lexeme $ many1 digit >>= return . read

lexeme :: Parser a -> Parser a
lexeme = (<* scn)

scn :: Parser ()
scn = skipMany $ ws
  where
    ws :: Parser ()
    ws = do satisfy (`elem` " \n\t") >> return ()
