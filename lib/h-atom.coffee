HAtomView = require './h-atom-view'
{CompositeDisposable} = require 'atom'

module.exports = HAtom =
  hAtomView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    #@hAtomView = new HAtomView(state.hAtomViewState)
    @hAtomView = new HAtomView()

    # @modalPanel = atom.workspace.addModalPanel(item: @hAtomView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'h-atom:toggle': => @toggle()

  deactivate: ->
    @hAtomView.destroy()
    @subscriptions.dispose()
    ###
    @modalPanel.destroy()
    ###

  serialize: ->
    hAtomViewState: @hAtomView.serialize()

  toggle: ->
    console.log 'H-Atom was toggled!'

    editor = atom.workspace.getActiveTextEditor()
    if editor
      text = editor.getText()
      newText = @hAtomView.destruct text
      if text != newText
        editor.setText newText
