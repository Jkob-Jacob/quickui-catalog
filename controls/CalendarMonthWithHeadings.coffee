###
Month calendar with headings for month name and year, plus days of week 
###

class window.CalendarMonthWithHeadings extends Control

  inherited:
    content: [
      control: "MonthAndYear", ref: "monthAndYear"
    ,
      html: "<div/>", ref: "monthTable",  content: [
        control: "DaysOfWeek", ref: "daysOfWeek", format: "namesShort"
      , 
        control: "CalendarMonth", ref: "calendar"
      ]
    ]
    generic: "true"

  # The control's current culture.
  culture: Control.iterator ( culture ) ->
    # Inside iterator, so can't simply do result = super culture
    result = @constructor.__super__.culture.call @, culture
    if culture isnt undefined
      @$monthAndYear().culture culture
      @$daysOfWeek().culture culture
      @$calendar().culture culture
      date = @date()
      @date date  if date
    result
  
  # The date shown in the calendar 
  date: Control.chain( "$calendar", "date", ( date ) ->
    @$monthAndYear().date date
  )

  # The class used to represent days in the month.
  dayClass: Control.chain "$calendar", "dayClass"

  # The controls used for the days in the calendar.
  days: Control.chain "$calendar", "days"

  # Returns the control currently showing the given date.
  dayControlForDate: ( date ) ->
    @$calendar().dayControlForDate date

  # The format used to show day headings. See DaysOfWeek.
  dayNameFormat: Control.chain "$daysOfWeek", "format"
  initialize: ->
    if @date()?
      # Sync month and year with calendar.
      @$monthAndYear().date @date()
    else
      # By default, show current month.
      @date CalendarDay.today()
    
  # True if the month name and year should be shown.
  showMonthAndYear: Control.chain "$monthAndYear", "visibility"
