class @PodsLoader
  delegate: null
  requests: []
  running: 0
  finished: 0
  progress: ->
    @finished / (@finished + @running)
  cancel: ->
    for request in @requests
      request.abort()
    @requests = []
    @running = 0
    @finished = 0
  loadPods: ->
    @cancel()
    for chunk in gon.pods_index
      @loadPodsChunk(chunk[0])
  loadPodsChunk: (chunk_id) ->
    controller = @
    xhr = new XMLHttpRequest()
    xhr.open('GET', '/pods/'+chunk_id+'.mpac', true)
    xhr.responseType = 'arraybuffer'
    xhr.onload = (e) ->
      pods = msgpack.decode(@response)
      controller.podsChunkDidLoad(chunk_id, pods)
    xhr.send()
    @requests.push(xhr)
    @running += 1
  podsChunkDidLoad: (chunk_id, pods) ->
    @running -= 1
    @finished += 1
    if @delegate
      if @delegate.didLoad
        @delegate.didLoad(chunk_id, pods)
      if @delegate.didLoadAll
        if @progress() == 1
          @delegate.didLoadAll()
