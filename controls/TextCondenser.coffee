###
Shows text in a condensed font if necessary to squeeze in more text.
###

class window.TextCondenser extends Control

  inherited:
    # Flip between two copies of text text: one normal, one condensed. 
    content: [
      html: "<span/>", ref: "normal"
    ,
      html: "<span/>", ref: "condensed"
    ]

  # The font family to use for condensed text.
  condensedFontFamily: Control.chain "$condensed", "css/font-family"

  content: Control.chain( "$normal", "content", ( content ) ->
    @$condensed().content content # Make a copy of the text.
    @checkForSizeChange()
  )
  
  initialize: ->
    @on "layout sizeChanged", => @layout()

  layout: Control.iterator ->
    tooWide = ( @$normal().width() > @width() )
    @applyClass "condensed", tooWide
