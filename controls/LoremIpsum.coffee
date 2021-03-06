###
Generates Lorem Ipsum placeholder paragraphs.
###

class window.LoremIpsum extends Control

  initialize: ->
    unless LoremIpsum._usedLorem
      # This is the first LoremIpsum control instance, so it gets the special
      # lead sentence by default.
      @lorem true
      LoremIpsum._usedLorem = true
    if @content()?.length == 0
      @_refresh()

  # True if the first sentence should definitely be (or not be) the standard
  # "Lorem ipsum dolor sit amet..." If this is undefined, the first instance of
  # this control class will start with this sentence; subsequent instances
  # won't.
  lorem: Control.property.bool ->
    @_refresh()

  @loremSentence: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."

  # The number of paragraphs to show. Default is one paragraph.
  paragraphs: Control.property.integer( ( paragraphs ) ->
    @_refresh()
  , 1 )

  # A specific number of sentences to show per paragraph.
  # If not set, each paragraph will have a variable number of sentences.
  sentences: Control.property.integer ( sentences ) ->
    @_refresh()

  @sentences: [
    "Duis et adipiscing mi."
    "Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
    "Mauris vestibulum orci sed justo lobortis viverra."
    "Suspendisse blandit dolor nunc, nec facilisis metus."
    "Ut vestibulum ornare eros id vestibulum."
    "Phasellus aliquam pellentesque urna, eu ullamcorper odio sollicitudin vel."
    "Aliquam lacinia dolor at elit viverra ullamcorper."
    "Vestibulum ac quam augue."
    "Fusce tortor risus, commodo in molestie vitae, rutrum eu metus."
    "Nunc tellus justo, consequat in ultrices elementum, gravida a mi."
    "Praesent in lorem erat, quis dictum magna."
    "Aenean et eros ligula, quis sodales justo."
    "Quisque egestas imperdiet dignissim."
    "Aenean commodo nulla sit amet urna ornare quis dignissim libero tristique."
    "Praesent non justo metus."
    "Nam ut adipiscing enim."
    "In hac habitasse platea dictumst."
    "Nulla et enim sit amet leo laoreet lacinia ut molestie magna."
    "Vestibulum bibendum venenatis eros sit amet eleifend."
    "Fusce eget metus orci."
    "Fusce tincidunt laoreet lacinia."
    "Proin a arcu purus, nec semper quam."
    "Mauris viverra vestibulum sagittis."
    "Ut commodo, dolor malesuada aliquet lacinia, dui est congue massa, vel sagittis metus quam vel elit."
    "Nulla vel condimentum odio."
    "Aliquam cursus velit ut tellus ultrices rutrum."
    "Vivamus sollicitudin rhoncus purus, luctus lobortis dui viverra vitae."
    "Nam mauris elit, aliquet at congue sed, volutpat feugiat eros."
    "Nulla quis nulla ac lectus dapibus viverra."
    "Pellentesque commodo mauris vitae sapien molestie sit amet pharetra quam pretium."
    "Maecenas scelerisque rhoncus risus, in pharetra dui euismod ac."
    "Mauris ut turpis sapien, sed molestie odio."
    "Vivamus nec lectus nunc, vel ultricies felis."
    "Mauris iaculis rhoncus dictum."
    "Vivamus at mi tellus."
    "Etiam nec dui eu risus placerat adipiscing non at nisl."
    "Curabitur commodo nunc accumsan purus hendrerit mollis."
    "Fusce lacinia urna nec eros consequat sed tempus mi rhoncus."
    "Morbi eu tortor sit amet tortor elementum dapibus."
    "Suspendisse tincidunt lorem quis urna sollicitudin lobortis."
    "Nam eu ante ut tellus vulputate ultrices eu sed mi."
    "Aliquam lobortis ultricies urna, in imperdiet lacus tempus a."
    "Duis nec velit eros, ut volutpat neque."
    "Sed quam purus, tempus vitae porta eget, porta sit amet eros."
    "Vestibulum dignissim ullamcorper est id molestie."
    "Nunc erat ante, lobortis id dictum in, ultrices sit amet nisl."
    "Nunc blandit pellentesque sapien, quis egestas risus auctor quis."
    "Fusce quam quam, ultrices quis convallis sed, pulvinar auctor tellus."
    "Etiam dolor velit, hendrerit et auctor sit amet, ornare nec erat."
    "Nam tellus mi, rutrum a pretium et, dignissim sed sapien."
    "Sed accumsan dapibus ipsum ut facilisis."
    "Curabitur vel diam massa, ut ultrices est."
    "Sed nec nunc arcu."
    "Nullam lobortis, enim nec gravida molestie, orci risus blandit orci, et suscipit nunc odio eget nisl."
    "Praesent lectus tellus, gravida ut sagittis non, convallis a leo."
    "Mauris tempus feugiat fermentum."
    "Phasellus nibh mi, convallis eu pulvinar eget, posuere in nunc."
    "Morbi volutpat laoreet mauris vel porta."
    "Aenean vel venenatis nisi."
    "Ut tristique mauris sed libero malesuada quis rhoncus augue convallis."
    "Fusce pellentesque turpis arcu."
    "Nunc bibendum, odio id faucibus malesuada, diam leo congue urna, sed sodales orci turpis id sem."
    "Ut convallis fringilla dapibus."
    "Ut quis orci magna."
    "Mauris nec erat massa, vitae pellentesque tortor."
    "Sed in ipsum nec enim feugiat aliquam et id arcu."
    "Nunc ut massa sit amet nisl semper ultrices eu id lacus."
    "Integer eleifend aliquam interdum."
    "Cras a sapien sapien."
    "Duis non orci lacus."
    "Integer commodo pharetra nulla eget ultrices."
    "Etiam congue, enim at vehicula posuere, urna lorem hendrerit erat, id condimentum quam lectus ac ipsum."
    "Aliquam lorem purus, tempor ac mollis in, varius eget metus."
    "Nam faucibus accumsan sapien vitae ultrices."
    "Morbi justo velit, bibendum non porta vel, tristique quis odio."
    "In id neque augue."
    "Cras interdum felis sed dui ultricies laoreet sit amet eu elit."
    "Vestibulum condimentum arcu in massa lobortis vitae blandit neque mattis."
    "Nulla imperdiet luctus mollis."
    "Donec eget lorem ipsum, eu posuere mi."
    "Duis lorem est, iaculis sit amet molestie a, tincidunt rutrum magna."
    "Integer facilisis suscipit tortor, id facilisis urna dictum et."
    "Suspendisse potenti."
    "Aenean et mollis arcu."
    "Nullam at nulla risus, vitae fermentum nisl."
    "Nunc faucibus porta volutpat."
    "Sed pretium semper libero, vitae luctus erat lacinia vel."
    "Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
    "Integer facilisis tempus tellus, rhoncus pretium orci semper sed."
    "Morbi non lectus leo, quis semper diam."
    "Suspendisse ac urna massa, vitae egestas metus."
    "Pellentesque viverra mattis semper."
    "Cras tristique bibendum leo, laoreet ultrices urna condimentum at."
    "Praesent at tincidunt velit."
    "Nam fringilla nibh quis nulla volutpat lacinia."
    "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas."
    "Sed ultrices sollicitudin neque ut molestie."
    "Sed at lectus in lacus scelerisque suscipit non id risus."
    "Aliquam lorem nibh, convallis vitae molestie in, commodo feugiat nibh."
  ]

  # Generate a random paragraph.
  _generateParagraph: ( useLorem ) ->
    # Default is 5 to 12 sentences per paragraph.
    sentenceCount = @sentences() or Math.floor( Math.random() * 8 ) + 5
    sentencesAvailable = LoremIpsum.sentences.length
    paragraph = ""
    if sentenceCount > 0
      # Use special first sentence?
      if useLorem
        paragraph = LoremIpsum.loremSentence
        sentenceCount--
      # Pick remaining sentences.
      for i in [ 0 .. sentenceCount - 1 ]
        paragraph += " "  if paragraph.length > 0
        sentenceIndex = Math.floor Math.random() * sentencesAvailable
        paragraph += LoremIpsum.sentences[ sentenceIndex ]
    "<p>#{paragraph}</p>"

  _refresh: ->
    content = ( for i in [ 0 .. @paragraphs() - 1 ]
      useLorem = ( i == 0 and @lorem() )
      @_generateParagraph useLorem
    )
    @content content

  @_usedLorem: false
