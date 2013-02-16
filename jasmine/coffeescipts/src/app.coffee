window.App = 
  Routers: {}
  Collections: {}
  Models: {}
  Views: {}

class App.Models.Note extends Backbone.Model
  defaults:
    author: ""
    text: ""
    
  validate: (attrs, options) ->
    return {author: 'Author is required.'} if attrs.author.length == 0
    return {text: 'Text is required.'} if attrs.text.length == 0

class App.Collections.Notes extends Backbone.Collection
  model: App.Models.Note
  
  nextId: ->
    return 1 if @length == 0
    @max((model)-> model.id).id + 1

class App.Views.NoteEdit extends Backbone.View
  events:
    "click button.save": "save"

  initialize: (options) ->
    @note = options.note

  save: (event) ->
    event.stopPropagation()
    event.preventDefault()

    @note.set(
      author: @$el.find('input[name=author]').val()
      text: @$el.find('textarea[name=text]').val()
    )
    window.location.hash = "notes/index"

  render: ->
    @$el.html(_.template($('#formTemplate').html(), @note.toJSON()))
    @$el.find('h2').text('Edit Note')
    @

class App.Views.NoteRow extends Backbone.View
  tagName: "tr",
  events: 
    "click a.delete": "destroy"

  initialize: (options) ->
    @note = options.note
    @notes = options.notes

  render: ->
    @$el.html(_.template($('#rowTemplate').html(), @note.toJSON()))
    @

  destroy: (event) ->
    event.preventDefault()
    event.stopPropagation()
    @notes.remove(@note)
    @$el.remove()

class App.Views.NoteNew extends Backbone.View
  events: 
    "click button.save": "save"

  initialize: (options) ->
    @note = options.note
    @notes = options.notes

  save: (event) ->
    event.stopPropagation()
    event.preventDefault()

    @note.set(
      author: @$el.find('input[name=author]').val()
      text: @$el.find('textarea[name=text]').val()
      id: @notes.nextId()
    )
    errors = @note.validate(@note.attributes)
    if errors
      @handleErrors(errors)
    else
      @notes.add(@note)
      window.location.hash = "notes/index"
      
  handleErrors: (errors) ->
    for field in _.keys(errors)
      @$el.find("[name=#{field}]").closest('.control-group').addClass('error')

  render: ->
    @$el.html(_.template($('#formTemplate').html(), @note.toJSON()))
    @$el.find('h2').text('Create New Note')
    @

class App.Views.NoteIndex extends Backbone.View

  initialize: (options) ->
    @notes = options.notes
    @notes.bind('reset', @addAll, @)

  render: -> 
    @$el.html($('#indexTemplate').html())
    @addAll()
    @

  addAll: ->
    @$el.find('tbody').children().remove()
    _.each(@notes.models, $.proxy(@, 'addOne'))

  addOne: (note) ->
    view = new App.Views.NoteRow(notes: @notes, note: note)
    @$el.find("tbody").append(view.render().el)

class App.Routers.Notes extends Backbone.Router
  routes:
    "": "index"
    "notes/index": "index"
    "notes/new": "create"
    "notes/:id/edit": "edit"

  initialize: (options) ->
    @notes = options.notes if options

  index: ->
    @currentView = new App.Views.NoteIndex(notes: @notes)
    $('#primary-content').html(@currentView.render().el)

  create: ->
    @currentView = new App.Views.NoteNew(notes: @notes, note: new App.Models.Note())
    $('#primary-content').html(@currentView.render().el)

  edit: (id) ->
    note = @notes.get(id)
    @currentView = new App.Views.NoteEdit(note: note)
    $('#primary-content').html(@currentView.render().el)

