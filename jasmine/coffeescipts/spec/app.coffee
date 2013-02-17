describe "App", ->
  it "is defined", ->
    expect(App).toBeDefined()

describe "App.Models.Note", ->
  it "is defined", ->
    expect(App.Models.Note).toBeDefined()

  it "sets default values", ->
    note = new App.Models.Note
    expect(note.get("author")).toEqual("")
    expect(note.get("text")).toEqual("")
    
  describe "Validation", ->
    beforeEach ->
      @attrs = {author: "John", text: "Sometext"}
        
    afterEach ->
      note = new App.Models.Note(@attrs)
      expect(note.isValid()).toBeFalsy()
      
    it "validates the presence of author", ->
      @attrs["author"] = ""

    it "validates the presence of text", ->
      @attrs["text"] = ""

describe "App.Collections.Notes", ->
  it "is defined", ->
    expect(App.Collections.Notes).toBeDefined()

  it "use Note model", ->
    notes = new App.Collections.Notes
    expect(notes.model).toEqual(App.Models.Note)
    
  describe "nextId", ->
    it "returns 1 if collection is empty", ->
      notes = new App.Collections.Notes
      expect(notes.nextId()).toEqual(1)

    it "returns max(id) + 1 if collection is not empty", ->
      notes = new App.Collections.Notes([{id: 3}, {id: 7}])
      expect(notes.nextId()).toEqual(8)
      
describe "App.Routers.Notes", ->
  it "is defined", ->
    expect(App.Routers.Notes).toBeDefined()

  describe "routes firing", ->
    beforeEach ->
      @notes = new App.Collections.Notes([id: 1, author: "John", text: "Lorem ipsum"])
      @router = new App.Routers.Notes(notes: @notes)
      @spy = jasmine.createSpy('ROUTER')
      try 
        Backbone.history.start(silent: true)
      catch e
        false
      @router.navigate("away")

    afterEach ->
      $('#primary-content').empty()
      
    it "fires the index route with a blank hash", ->
      @router.bind("route:index", @spy)
      @router.navigate("", true)
      expect(@spy).toHaveBeenCalled()
      expect(@spy).toHaveBeenCalledWith()
  
    it "fires the index route with notes/index hash", ->
      @router.bind("route:index", @spy)
      @router.navigate("notes/index", true)
      expect(@spy).toHaveBeenCalled()
      expect(@spy).toHaveBeenCalledWith()
      
    it "fires the create route with notes/new hash", ->
      @router.bind("route:create", @spy)
      @router.navigate("notes/new", true)
      expect(@spy).toHaveBeenCalled()
      expect(@spy).toHaveBeenCalledWith()
  
    it "fires the edit route with notes/:id/edit hash", ->
      @router.bind("route:edit", @spy)
      @router.navigate("notes/1/edit", true)
      expect(@spy).toHaveBeenCalled()
      expect(@spy).toHaveBeenCalledWith('1')
  
  describe "routes methods", ->
    beforeEach ->
      @notes = new App.Collections.Notes([id: 1, author: "John", text: "Lorem ipsum"])
      @router = new App.Routers.Notes(notes: @notes)
      
    afterEach ->
      $('#primary-content').empty()
    
    it "creates index view", ->
      @router.index()
      expect(@router.currentView).toEqual(jasmine.any(App.Views.NoteIndex))
      expect($('#primary-content').text()).toContain('Notes List')

    it "creates new view", ->
      @router.create()
      expect(@router.currentView).toEqual(jasmine.any(App.Views.NoteNew))
      expect($('#primary-content').text()).toContain('Create New Note')

    it "creates edit view", ->
      @router.edit('1')
      expect(@router.currentView).toEqual(jasmine.any(App.Views.NoteEdit))
      expect($('#primary-content').text()).toContain('Edit Note')
      
describe "App.Views.NoteIndex", ->
  it "is defined", ->
    expect(App.Views.NoteIndex).toBeDefined()

  describe "rendering", ->  
    beforeEach ->  
      @notes = new App.Collections.Notes([id: 1, author: "John", text: "Lorem ipsum"])
      @view = new App.Views.NoteIndex(notes: @notes)

    it "renders notes", ->
      $el = @view.render().$el
      expect($el.find('h2').text()).toContain('Notes List')
      expect($el.text()).toContain("John")

describe "App.Views.NoteRow", ->
  it "is defined", ->
    expect(App.Views.NoteRow).toBeDefined()

  describe "methods", ->  
    beforeEach ->  
      @note = new App.Models.Note(id: 1, author: "John", text: "Lorem ipsum")
      @notes = new App.Collections.Notes([@note])
      @view = new App.Views.NoteRow(notes: @notes, note: @note)
      @$el = @view.render().$el

    it "renders note", ->
      expect(@$el.find("td:first-child").text()).toContain("John")
      
    it "destroy note", ->
      spyOn(@notes, 'remove').andCallThrough()
      spyOn(@$el, 'remove')
      @$el.find("a.delete").trigger('click')
      expect(@notes.remove).toHaveBeenCalled()
      expect(@$el.remove).toHaveBeenCalled()

describe "App.Views.NoteEdit", ->
  it "is defined", ->
    expect(App.Views.NoteEdit).toBeDefined()

  describe "methods", ->  
    beforeEach ->  
      @note = new App.Models.Note(id: 1, author: "John", text: "Lorem ipsum")
      @view = new App.Views.NoteEdit(note: @note)
      @$el = @view.render().$el
      window.location.hash = "away"

    it "renders note", ->
      expect(@$el.find("h2").text()).toContain("Edit Note")
      expect(@$el.find("input[name=author]").val()).toEqual(@note.get("author"))
      
    it "saves note", ->
      @$el.find("input[name=author]").val("Dan")
      @$el.find("button.save").trigger("click")
      expect(@note.get("author")).toEqual("Dan")
      expect(window.location.hash).toEqual("#notes/index")
      
describe "App.Views.NoteNew", ->
  it "is defined", ->
    expect(App.Views.NoteNew).toBeDefined()

  describe "methods", ->  
    beforeEach ->  
      @note = new App.Models.Note()
      @notes = new App.Collections.Notes([@note])
      @view = new App.Views.NoteNew(notes: @notes, note: @note)
      @$el = @view.render().$el
      window.location.hash = "away"

    it "renders form", ->
      expect(@$el.find("h2").text()).toContain("Create New Note")
      
    it "saves note", ->
      @$el.find("input[name=author]").val("Dan")
      @$el.find("textarea[name=text]").val("Test text")
      @$el.find("button.save").trigger("click")
      expect(@notes.models[0].get("author")).toEqual("Dan")
      expect(window.location.hash).toEqual("#notes/index")
      
    it "fails to save note", ->
      @$el.find("button.save").trigger("click")
      expect(@notes.models[0].get("author")).toEqual("")
      expect(@$el.find("input[name=author]").closest('.control-group').hasClass('error')).toBeTruthy()
      expect(window.location.hash).not.toEqual("#notes/index")
    
# Runner
jasmineEnv = jasmine.getEnv()
jasmineEnv.updateInterval = 250

currentWindowOnload = window.onload

window.onload = ->
  currentWindowOnload() if currentWindowOnload
  execJasmine()

execJasmine = -> jasmineEnv.execute()

# Reporter
htmlReporter = new jasmine.HtmlReporter()
jasmineEnv.addReporter(htmlReporter)
jasmineEnv.specFilter = (spec) -> htmlReporter.specFilter(spec)

