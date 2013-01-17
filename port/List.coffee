###
Creates a set of controls, one for each item in a list.
###

class window.List extends Control

  # collection of controls in the list generated by setting the items() property.
  # Read-only. This is always returned as an instance of itemClass.
  controls: ->
    itemClass = @itemClass()
    itemClass( this ).children()

  # True if the control should mark itself dirty when it gets a change event.
  # The default is false.
  dirtyOnChange: Control.property.bool( null, false )

  initialize: ->
    @change ( event ) =>
      if @dirtyOnChange()
        # Assume the list is dirty.
        @isDirty true

  # Insert a new item before the existing item at the given index.
  insertItemBefore: Control.iterator ( item, index ) ->
    
    # Create the control.
    itemClass = @itemClass()
    $control = itemClass.create()
    @_mapAndSetup $control, item
    
    # Add the control to the list.
    children = @children()
    if index >= children.length
      @append $control
    else
      children.eq( index ).before $control
    
    # Update the cached item array as well.
    items = @_itemsCache() ? []
    items.splice index, 0, item
    @_itemsCache items

  # True if the list's items have been changed since the controls were first created.
  isDirty: Control.property.bool( null, true )

  # The class used to render items in the list as controls.
  itemClass: Control.property.class( ->    
    # Get the existing items.
    items = if @isDirty()
      @items()
    else
      @_itemsCache()
    @empty() # Throw out the existing controls.
    @items items # Create new controls.
  , Control )

  # The array of items in the list.
  items: ( items ) ->
    if items is undefined
      if @isDirty()
        @_itemsCache( @_getItemsFromControls() ).isDirty false
      @_itemsCache()
    else
      # Cache a copy of the items array. We use a copy because the array may
      # later be manipulated withour knowledge.
      itemsCopy = items.slice 0
      @_itemsCache itemsCopy
      @_createControlsForItems itemsCopy
      @isDirty false

  # Used to map an incoming list item to property setters on the control class
  # indicated by itemClass. The map specifies a relationship between control
  # property getter/setter functions and the item. This map can take several
  # forms:
  #
  # 1. A simple string like "foo". This indicates that the item itself
  #    should be passed to the control property called foo().
  # 2. A JavaScript dictionary with entries of the form
  #        { controlProperty: itemProperty }
  #    For each entry, the indicated item.itemProperty will be passed to
  #    or from the corresponding control.controlProperty().
  # 3. A function of the form:
  #
  #      function foo( item ) { ... }
  #
  #    If item is undefined, the map function is being invoked as a getter,
  #    and should extract the item from the control (available via "this").
  #    If item is defined, the map function is being invoked as a setter, and
  #    should pass the item to the control (e.g., by setting properties on
  #    it).
  #
  # If no map function is identified, a default map function is used. This
  # function does the following:
  # * If the item is a plain JavaScript object with keys of the form
  #       { property: value }
  #   The indicate value will be passed to and from control.property()
  # * Otherwise, the item is passed to and from the control's content()
  #   property.
  mapFunction: Control.property ->
    # TODO: Before storing new mapFunction, use old one to extract items if the
    # list is dirty. For now, if the mapFunction of a dirty list is updated, the
    # unsaved changes are thrown away.
    items = @_itemsCache()
    @items items # Force refresh.

  # Remove the item at the indicated index.
  removeItemAt: Control.iterator ( index ) ->
    items = @_itemsCache()
    if index >= 0 and index < items.length
      # Remove the control at that index.
      @children().eq( index ).remove()
      # Remove our cached copy of the corresponding item.
      items.splice index, 1

  # Apply a simple dictionary map to the given item. The map should contain a
  # mapping of { itemProperty: controlProperty } entries. When invoked as a
  # setter, this invokes
  #    control.controlProperty( item.itemProperty )
  # When invokes as a getter, this returns a new object with keys of the form
  #    { itemProperty: control.controlProperty() }
  #
  # Note: This function should be called with this = the given control.
  @_applyDictionaryMap: ( map, item ) ->
    if item is undefined
      # Getter
      result = {}
      for itemProperty, controlProperty of map
        result[ itemProperty ] = @[ controlProperty ]()
      result
    else
      # Setter
      for itemProperty, controlProperty of map
        @[ controlProperty ]( item[ itemProperty ] )

  # Create a control for each item in the items array. Subclasses can override
  # this is they want to perform additional work when controls are being
  # created.
  _createControlsForItems: ( items ) ->
    itemsCount = items.length
    itemClass = @itemClass()
    mapFunction = @_getMapFunction()
    
    # Create (or reuse) a control for each item.
    $existingControls = @controls()
    existingControlsCount = $existingControls.length
    $control = undefined
    i = 0
    while i < itemsCount and i < existingControlsCount
      $control = $existingControls.eq i
      @_mapAndSetup $control, items[i], mapFunction
      i++
    
    # Create new controls for additional items.
    newControls = []
    while i < itemsCount
      $control = itemClass.create()
      @_mapAndSetup $control, items[i], mapFunction
      newControls.push $control[0]
      i++
    if newControls.length > 0
      @append.apply @, newControls
    
    # Remove leftover controls.
    leftoverControls = $existingControls.slice items.length
    if leftoverControls.length > 0
      $( leftoverControls ).remove()
    @

  # This map function is used if the host does not provide one.
  @_defaultMapFunction: ( item ) ->
    map = undefined
    if item is undefined
      # Getter
      map = @data "_map"
      if map?
        # Reconstruct an item using the previously-generated map.
        List._applyDictionaryMap.call @, map
      else
        @content()
    else
      # Setter
      if $.isPlainObject item
        # Generate a map from the item and save it for later use.
        map = {}
        for key of item when item.hasOwnProperty key
          map[ key ] = key
        @data "_map", map
        List._applyDictionaryMap.call @, map, item
      else
        # Map to content()
        @content item

  # Reconstruct the set of items from the controls.
  _getItemsFromControls: ->
    mapFunction = @_getMapFunction()
    ( mapFunction.call control for control in @controls().segments() )

  # Return a map function that can be applied to a control to get/set its
  # corresponding item. See mapFunction() for a description of the supported
  # means of identifying the map function.
  _getMapFunction: ->
    mapFunction = @mapFunction()
    if mapFunction is undefined
      # No map function supplied; used the default.
      List._defaultMapFunction
    else if typeof mapFunction is "string"
      # The map function should invoke the property with the given name.
      ( item ) -> @[ mapFunction ] item
    else if $.isFunction mapFunction
      # An explicit map function has been supplied; use that.
      mapFunction
    else
      # An dictionary map has been supplied; return a function that lets it map
      # item members -> control properties and vice versa.
      ( item ) -> List._applyDictionaryMap.call @, mapFunction, item
  
  # A copy of the items the last time they were created or refreshed.
  _itemsCache: Control.property()
  
  # Apply the map function and let the control set itself up.
  _mapAndSetup: ( $control, item, mapFunction ) ->
    if mapFunction is undefined
      mapFunction = @_getMapFunction()
    mapFunction.call $control, item
    @_setupControl $control

  # This can be extended by subclasses who want to perform per-control set-up.
  _setupControl: ( $control ) ->
