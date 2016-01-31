inv = (f) ->
  () ->
    res = f.apply(null, arguments)
    not res

isChar = (char) ->
  (c) -> c == char

dropWhile = (pred, list) ->
  i = 0
  while i < list.length && pred list[i]
    i++
  list.slice i

takeWhile = (pred, list) ->
  i = 0
  while i < list.length && pred list[i]
    i++
  list.slice 0, i

reverse = (list) ->
  list[list.length - i - 1] for item, i in list

isSpace = isChar ' '

isNotSpace = inv (isChar ' ')

list = (arr) ->
  () ->
    arr1 = (func.apply(null, arguments) for func in arr)
    orFunc = (a, b) -> a or b
    fold orFunc, false, arr1

isNewline = list [(isChar '\n'), (isChar '\r')]

isWhitespace = list [isSpace, (isChar '\n'), (isChar '\r')]

map = (func, list) ->
  (func item for item in list)

filter = (pred, list) ->
  item for item in list when pred item

fold = (func, init, list) ->
  len = list.length
  traverse ((i) ->
    init = func init, list[i]
    ), 0, less len
  init

split = (delim, list) ->
  j = 0
  res = []
  res[0] = []
  traverse (
    (i) ->
      if list[i] == delim
        res[++j] = []
      else
        res[j].push list[i]
    ), 0, less list.length
  res

trim = (str) ->
  ###
  s1 = dropWhile isWhitespace, str
  s2 = reverse s1
  s3 = dropWhile isWhitespace, s2
  s4 = reverse s3
  ###
  reverse (dropWhile isWhitespace, (reverse (dropWhile isWhitespace, str)))

repeat = (x, n) ->
  if n == 0
    []
  else
    x for i in [1..n]

less = (x) ->
  (y) -> y < x

intersperse = (x, ys) ->
  res = []
  if ys.length > 1
    traverse (
      (i) ->
        res.push(ys[i])
        res.push(x)
      ), 0, less(ys.length - 1)

    res.push(ys[ys.length-1])
  res

traverse = (func, beg, pred) ->
  i = beg
  while pred i
    func i
    i++

# Apply fb first. Oppa Haskell Style.
compose = (fa, fb) ->
  () ->
    fa (fb.apply null, arguments)

module.exports =
  map: map
  filter: filter
  fold: fold
  dropWhile: dropWhile
  takeWhile: takeWhile
  reverse: reverse
  trim: trim
  isSpace: isSpace
  isChar: isChar
  inv: inv
  split: split
  repeat: repeat
  intersperse: intersperse
  less: less
  traverse: traverse
  list: list
  isNewline: isNewline
  isNotSpace: isNotSpace
  compose: compose
