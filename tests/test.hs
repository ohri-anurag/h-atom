data Card = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King

func :: Card -> Maybe a -> Int
func Ace _ =
  let
    helper :: Maybe a -> Card -> Int
    helper _ Two = 2
    helper _ Nine = 9
  in
    1
func Ten _ = 10
  where
    helper :: Maybe a -> Card -> Int
    helper _ Two = 2
    helper _ Nine = 9

data Tree a = Leaf | Node (Maybe a) (Tree a) (Tree a)

data MyTree a = MyLeaf | MyNode {
  val :: Maybe a,
  left :: MyTree a,
  right :: MyTree a
}

size1 :: Tree a -> Maybe a -> Int

size2 :: Maybe a -> Tree a -> Int

size3 :: MyTree a -> Maybe a -> Int

size4 :: Maybe a -> MyTree a -> Int
