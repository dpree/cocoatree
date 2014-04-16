#= require lunr.js
class @AppController
  current: null
  constructor: (podsSyncWorkerClient, store) ->
    @store = store
    @store.delegates.push @
    @podsController = new PodsController(@store)
    @categoriesController = new CategoriesController(@store)
    @progressBar = new PodsProgressBar()
    @podsSyncWorkerClient = podsSyncWorkerClient
    @podsSyncWorkerClient.delegate = @
    navigation = new Navigation()
    navigation.render()
    @renderEmptyView()
  loadPods: ->
    @podsSyncWorkerClient.loadPods()
    @progressBar.start()
  didLoad: (chunk_id, pods) ->
    logger.verbose 'AppController#didLoad', chunk_id
    @progressBar.update(@podsSyncWorkerClient.progress)
    @store.update pods
  didLoadAll: ->
    @store.updateCategories()
    @update()
  didUpdate: () ->
    @update()
  update: () ->
    logger.verbose 'AppController#update'
    if @current == 'categories'
      @displayCategories()
    else if @current == 'pods'
      @displayPods()
    else if @current == 'about'
      @displayAbout()
    else if @current == 'contribute'
      @displayContribute()
  displayPodsAndUpdateScope: (index, filterBy, sortBy) ->
    @podsController.updateScope(filterBy, sortBy, index)
    @displayPods()
  displayPods: ->
    logger.verbose 'AppController#displayPods'
    @current = 'pods'
    @podsController.load().then (result) =>
      if result.pods.length
        @podsController.render(result.count, result.pods)
      else
        @renderEmptyView()
  displayCategories: () ->
    @current = 'categories'
    @categoriesController.load().then (categories) =>
      if categories.length
        @categoriesController.render(categories)
      else
        @renderEmptyView()
  displayAbout: () ->
    @current = 'about'
    new AboutView().render()
  displayContribute: () ->
    @current = 'contribute'
    new ContributeView().render()
  renderEmptyView: () ->
    (new EmptyView).render()
