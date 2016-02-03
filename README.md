# h-atom package

This package is an attempt to recreate the functionality provided by the destruct command of the Merlin plugin for Vi/Emacs.

What It Does
------------

Suppose you have an ADT definition in a file. While defining a function that takes the ADT as an input, you would normally have to pattern match all the cases yourself.

The Destruct functionality of H-Atom would create all these function stubs for you.

It also works when you are working on an already existing ADT. Suppose you extended an existing ADT to add two more definitions. You would have to go through all the functions defined on that type, adding definitions for each function. But using Destruct, all you need to do is press Ctrl-Atl-o, and it will automatically add stubs for the missing clauses.

Dependencies
------------
This package is not dependent on any other package.

Assumptions
-----------
1. All functions have type definitions. Even functions not defined using 'where' or 'let'.

Support
-------
Currently this functionality is limited to ADTs defined within the same file that is being worked upon. Also, case statements are not supported.

Future Support
--------------
1. Case Statements.
2. ADTs defined in other files and other modules.

Images
------

Before:
![Preview](https://cloud.githubusercontent.com/assets/10478280/12701651/ae281908-c835-11e5-9128-38172138f337.png)

After:
![Preview](https://cloud.githubusercontent.com/assets/10478280/12701649/ade7cbb4-c835-11e5-8ba7-755ebba5f674.png)

![Preview](https://cloud.githubusercontent.com/assets/10478280/12701650/adf506ee-c835-11e5-831a-c577b7094adf.png)
