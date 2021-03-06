class @CategoriesController
  totalPodsCount: 0
  constructor: (store) ->
    @store = store
  load: () ->
    @store.countPods().then (count) =>
      @totalPodsCount = count
    @store.findCategories()
  render: (categories) ->
    list = []
    for c in categories
      list.push(new Category(c))
    (new CategoriesView).render(list, @totalPodsCount)
  