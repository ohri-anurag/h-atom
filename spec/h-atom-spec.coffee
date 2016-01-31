HAtom = require '../lib/h-atom'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "HAtom", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('h-atom')

  describe "when the H-Atom:Destruct event is triggered", ->
    it "Generates stubs for functions that are defined on ADTs.", ->
      ###
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.h-atom')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'h-atom:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.h-atom')).toExist()

        hAtomElement = workspaceElement.querySelector('.h-atom')
        expect(hAtomElement).toExist()

        hAtomPanel = atom.workspace.panelForItem(hAtomElement)
        expect(hAtomPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'h-atom:toggle'
        expect(hAtomPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.h-atom')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'h-atom:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        hAtomElement = workspaceElement.querySelector('.h-atom')
        expect(hAtomElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'h-atom:toggle'
        expect(hAtomElement).not.toBeVisible()
    ###
