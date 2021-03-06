###
A text region that can be clicked to edit its contents. 
###

class window.EditableText extends Editable

  inherited:
    editClass: "TextBox"

  # True if the pressing Escape in edit mode cancels edit mode.
  # The default is true.
  cancelOnEscape: Control.property( null, true )

  editing: ( editing ) ->
    result = super editing
    if editing
      # Switching to edit mode; put focus in the text box.
      @editControl().find( "input" ).addBack().focus()
    result

  # True if the control should switch to editing mode when it's clicked.
  # Default is true.
  editOnClick: Control.property( null, true )

  initialize: ->
    @click =>
      if @editOnClick() and not @editing()
        @editing true

  # True if pressing the Enter key in edit mode saves changes and switches back
  # to read mode. The default is true.
  saveOnEnter: Control.property( null, true )
  
  _createEditControl: ->
    result = super()
    # Wire up events bound to input elements.
    @editControl().find( "input" ).addBack().on
      blur: =>
        if @editing()
          @save() # Implicitly save when control loses focus.
      keydown: ( event ) =>
        if @editing()
          switch event.which
            when 13 # Enter
              if @saveOnEnter()
                @save()
                event.preventDefault()
            when 27 # Escape
              @cancel()  if @cancelOnEscape()
    result
