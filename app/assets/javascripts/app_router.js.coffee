@AppRouter = Backbone.Router.extend
  routes:
    "reload": "reload"
    "pods/:filter": "pods"
    "pods/:filter/:sort_by": "pods"
    "pods/:filter/:sort_by/:idx": "pods"
  pods: (filter, sort_by, idx) ->
    if !filter
      filter = 'all'
    if !sort_by
      sort_by = 'stars'
    if !idx
      idx = 0
    window.podsNavigation.pods(parseInt(idx), filter, sort_by)
  reload: ->
    window.podsController.loadPods()
