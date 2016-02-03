Basics = require './h-atom-basics'
module.exports =
class HAtomView
  ###
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('h-atom')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The HAtom package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)
  ###
  constructor: () ->

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    # @element.remove()

  getElement: ->
    # @element

  destruct: (text) ->
    # Firstly,  we need to split the text into separate lines
    lines = text.split('\n')
    #console.log((Basics.intersperse(' ', Basics.repeat '_', 3)).join(''))
    #console.log(Basics.repeat '_', 3)

    adtDeclarations = getAdtDeclarations lines

    #text
    # For each declaration, check out the functions related to it.
    text = Basics.fold this.autoFill, text, adtDeclarations

  autoFill: (text, declaration) ->
    typeName = getTypeName declaration

    types = getTypes declaration, typeName

    funcDeclarations = []

    typeOrdering = {}
    typeOrdering[item[0].join('')] = i for item, i in types

    lines = text.split('\n')

    lines = Basics.map (
      (line) ->
        # Only proceed if the line marks a function definition which includes the given type
        if line.indexOf('::') > -1 && line.indexOf(typeName) > -1
          functionInputOutputTypes = getTypesInFunction line
          if(functionInputOutputTypes.indexOf(typeName) > -1)
            # Here we do the actual work.

            # Retrieve the function name.
            funcName = getFunctionName line

            # Add this function's type definition  to the list of processed function names.
            funcDeclarations.push line

            funcDefLines = getFunctionLines lines, typeName, line

            indentation = Basics.takeWhile Basics.isSpace, line

            # Filter the types whose definitions are already present
            typesUndefined = Basics.filter ((t) -> (Basics.filter ((fdl) -> fdl.indexOf(t[0].join('')) > -1), funcDefLines).length == 0), types

            # console.log types
            # Create stubs for all types for which function has not yet been defined.
            typeDefs = Basics.map showStub.bind(null, indentation, funcName, (functionInputOutputTypes.length-1), functionInputOutputTypes.indexOf(typeName)), typesUndefined

            appendStr = Basics.fold ((i, t) -> i + "\n" + t), line, typeDefs
          else
            line
        else
          line
        ), lines

    # console.log typeName
    newText = lines.join('\n')

    newLines = newText.split('\n')

    # For each processed function, sort the function definitions.
    Basics.traverse ((i) ->
      fn = funcDeclarations[i]

      # Function Lines.
      fnLn = getFunctionLines newLines, typeName, fn

      # Function Definition Lines.
      fnDfLns = fnLn.slice(1)
      fnDfLns.sort(
        (a, b) ->
          ta = Basics.takeWhile (Basics.inv (Basics.isChar '=')), a
          tb = Basics.takeWhile (Basics.inv (Basics.isChar '=')), b
          ta = (Basics.filter ((t) -> t.join('') != '_'), (Basics.split ' ', (Basics.trim ta)))[1].join('')
          tb = (Basics.filter ((t) -> t.join('') != '_'), (Basics.split ' ', (Basics.trim tb)))[1].join('')
          if typeOrdering[ta] < typeOrdering[tb]
            -1
          else if typeOrdering[ta] > typeOrdering[tb]
            1
          else
            0
        )

      # Function Declaration Statement.
      fnDec = fnLn[0]

      index = newLines.indexOf(fnDec) + 1

      # Copy the sorted Function Definition Lines.
      Basics.traverse (
        (j) -> newLines[j + index] = fnDfLns[j]
        ), 0, Basics.less fnDfLns.length
    ), 0, Basics.less funcDeclarations.length

    # Return after sort
    newLines.join('\n')

getAdtDeclarations = (lines) ->
  adtDeclarations = []
  Basics.traverse (
    (i) ->
      # Check if the line actually contains a declaration.
      if lines[i].indexOf('data') == 0
        declaration = lines[i]
        # Process multi - line declarations
        Basics.traverse (
          (j) ->
            #console.log lines[j]
            declaration += lines[j]
          ), i+1, ((k) -> lines[k][0] == ' ')

        # Remove deriving instances from each declaration.
        drIndex = declaration.indexOf('deriving')
        if drIndex > -1
          declaration = declaration.substring 0, drIndex

        adtDeclarations.push declaration
    ), 0, Basics.less lines.length
  adtDeclarations

getTypeName = (declaration) -> (Basics.trim (Basics.takeWhile (Basics.inv (Basics.list [Basics.isNewline, (Basics.isChar '=')])), (Basics.dropWhile Basics.isSpace, declaration.substring(4)))).join ''

getTypes = (declaration, typeName) ->
  # Split the type declaration at '|'.
  types = declaration.substring(declaration.indexOf('=')+1).split('|')

  # A type can be of the following form
  # N1, N1 N2, N1 N2 N3
  # N1 (N2 a), N1 (N2 a b)
  types = Basics.map (Basics.compose parseType, Basics.trim), types

parseType = (td) ->
  # A single type will consist of a Data Constructor, and then the consisting types.
  dc = Basics.takeWhile Basics.isNotSpace, td

  # Consisting Types.
  rest = Basics.dropWhile Basics.isSpace, Basics.dropWhile Basics.isNotSpace, td
  func = (t, xs) ->
    if t.length == 0
      xs
    else
      if t[0] == '('
        t1 = Basics.takeWhile (Basics.inv (Basics.isChar ')')), t.slice 1
        _rest = Basics.dropWhile Basics.isSpace, (Basics.dropWhile Basics.isNotSpace, (Basics.dropWhile (Basics.inv (Basics.isChar ')')), t))
      else
        t1 = Basics.takeWhile Basics.isNotSpace, t
        _rest = Basics.dropWhile Basics.isSpace, (Basics.dropWhile Basics.isNotSpace, t)
      xs.push t1
      func _rest, xs

  if rest[0] == '{'
    rest = Basics.trim (Basics.takeWhile (Basics.inv (Basics.isChar '}')), rest.slice 1)
    restTypes = Basics.map Basics.trim, (Basics.split ',', rest)
    [dc].concat (Basics.map ((t) -> Basics.trim (Basics.takeWhile (Basics.inv (Basics.isChar ':')), t)), restTypes)
  else
    func rest, [dc]

showStub = (indentation, funcName, functionTypesLength, typeIndex, t) ->
  funcStub = Basics.repeat '_', functionTypesLength
  funcStub[typeIndex] =
    (if (t.length > 1) then '(' else '') +
      t[0].join('') + space(t) +
      (if checkType t
        (Basics.map ((a) -> a.join ''), t.slice 1).join ' '
      else
        Basics.intersperse(' ', Basics.repeat '_', (t.length-1)).join('')) +
      (if (t.length > 1) then ')' else '')
  indentation + funcName + ' ' + funcStub.join(' ') + ' = undefined'

checkType = (t) ->
  res = true
  Basics.traverse (
    (i) ->
      res = res and t[i][0] == t[i][0].toLowerCase()
    ), 1, Basics.less t.length
  res

space = (t) ->
  if t.length > 1
    ' '
  else
    ''

getFunctionLines = (lines, typeName, fn) ->
  # Drop all the lines before the function type definition.
  fnLines = Basics.dropWhile ((l) -> l != fn), lines

  # Get the function name.
  fnName = getFunctionName fn

  indentation = getIndentation fn

  # Now keep all the lines that fulfill the 2 criteria mentioned below:
  # 1. It contains the function name.
  # 2. It has the same indentation.
  fnLines = Basics.filter ((l) -> l.indexOf(fnName) > -1 && getIndentation(l) == indentation), fnLines

  # We may have 2 functions having the same name defined at the same level of indentation.
  # Keep the fnLines until the second appearance of '::', as it signifies the starting of another function definition.
  definitionCount = 0
  j = 0
  Basics.traverse (
    (i) ->
      if fnLines[i].indexOf('::') > -1
        definitionCount++

      if definitionCount == 2
        j = i
    ), 0, Basics.less fnLines.length

  if definitionCount == 1
    # Only one function definition.
    fnLines
  else
    fnLines.slice 0, j

getIndentation = (line) ->
  (Basics.takeWhile Basics.isSpace, line).length

getFunctionName = (line) ->
  temp = Basics.takeWhile Basics.isNotSpace, (Basics.dropWhile Basics.isSpace, line)

  if temp.indexOf('::') > -1
    temp = temp.substring 0, temp.indexOf('::')

  temp

getTypesInFunction = (line) ->
  line = line.substring line.indexOf('::') + 2
  line = line.split '->'
  Basics.map ((l) -> (Basics.trim l).join('')), line
