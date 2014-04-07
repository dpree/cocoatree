class @PodsList
  constructor: (totalCount, currentPods, index, maxPerPage) ->
    @totalCount = totalCount
    @currentPods = currentPods
    @maxPerPage = maxPerPage
    @index = index
  pods: ->
    @currentPods
  has_next: ->
    @next_offset() < @totalCount
  has_prev: ->
    @index > 0
  next_offset: ->
    @index + @maxPerPage
  previous_offset: ->
    @index - @maxPerPage
  displayPageLink: (index) ->
    if index == @index
      'current'
    else if index > @index
      barrier = (@index + 3*@maxPerPage)
      if index < barrier || index > (@totalCount - 3*@maxPerPage)
        'within'
      else if index == barrier
        'barrier'
      else
        'without'
    else if index < @index
      barrier = (@index - 3*@maxPerPage)
      if index > barrier || index < 3*@maxPerPage
        'within'
      else if index == barrier
        'barrier'
      else
        'without'




