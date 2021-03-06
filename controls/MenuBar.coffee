###
A standard menu bar.

Note: The menu bar places a Overlay instance underneath itself to absorb
clicks outside the menu. If you're using a MenuBar on a page with elements
that have an explicit z-index, you'll want to give the MenuBar a higher z-index
so that it ( and its overlay ) end up above all other elements when any menus
are open. See notes in the source for the Overlay class.
###

class window.MenuBar extends Control

  inherited:
    generic: "true"

  # Close currently open any menus.
  close: Control.iterator ->    
    unless @opened()
      # Already closed
      return
    $overlay = @_overlay()
    if $overlay
      $overlay.remove()
      @_overlay null
    @_closeOpenPopups().opened false

  # The menus in the menu bar. These are typically PopupSource controls,
  # including subclasses like Menu. Other types of controls can be safely placed
  # in the content as well.
  content: ( content ) ->
    result = super content
    if content isnt undefined
      # Since we're managing our own overlay, we suppress the overlays on the
      # individual menus in our content.
      popups = @find( ".PopupSource" ).control()
      if popups
        popups.overlayClass null
    result

  initialize: ->
    @on
      "closed canceled": ( event ) =>
        unless @_openPopups()?
          # No longer any open popups.
          @close()
      opened: ( event ) =>
        @open()
        # Close open popups other than the one which just opened.
        newMenu = $( event.target ).closest( ".PopupSource" ).control()
        @_closeOpenPopups newMenu

    @on "mouseenter", ".PopupSource", ( event ) =>
      if @opened()
        # Riffing: Implicitly open the popup the user hovered into if it's not
        # already open.
        newMenu = $( event.target ).closest( ".PopupSource" ).control()
        if newMenu and not newMenu.opened()
          newMenu.open()

  # Returns true if any of the menu bar's menus are currently open.
  opened: Control.chain "applyClass/opened"
  open: Control.iterator ->
    if @opened()
      # Already open
      return
    $overlay = Overlay.create().target this
    @_overlay $overlay
    @opened true
    @
    
  # Close open popups. If a keepPopup is specified, leave that menu open.
  _closeOpenPopups: ( keepPopup ) ->
    openMenus = @_openPopups()
    if openMenus
      openMenus = openMenus.not keepPopup
      if openMenus.length > 0
        openMenus.close()
    this

  # Return the currently open popups.
  _openPopups: Control.chain "children", "filter/.PopupSource.opened", "control"
  
  # The overlay behind the menu bar.    
  _overlay: Control.property()
  
  # Hint for documentation tools.
  _requiredClasses: [ "Menu", "Overlay" ]
