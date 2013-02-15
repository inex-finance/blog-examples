class Person
  name: null
  age:  0
  constructor: (@name, @age) ->
  getName: -> @name
  setName: (value) -> @name = value
  getAge: -> @age
  addYear: -> @age += 1

describe "Spy", ->
  person = null

  beforeEach ->
    person = new Person("Jim", 25)

  it "was called", ->
    spyOn(person, 'getName')
    person.getName()
    expect(person.getName).toHaveBeenCalled()
    
  it "checks number of calls", ->
    spyOn(person, 'addYear')
    person.addYear()
    person.addYear()
    expect(person.addYear.calls.length).toEqual(2)

  it "checks call arguments", ->
    spyOn(person, 'setName')
    person.setName("Ira")
    expect(person.setName).toHaveBeenCalledWith("Ira") # can have multiple parameters
    
  it "has access to last call", ->
    spyOn(person, 'setName')
    person.setName("Ira")
    expect(person.setName.mostRecentCall.args[0]).toEqual("Ira")

  it "has access to all calls", ->
    spyOn(person, 'setName')
    person.setName("Ira")
    expect(person.setName.calls[0].args[0]).toEqual("Ira")
    
  it "calls original function", ->
    spyOn(person, 'getName').andCallThrough()
    expect(person.getName()).toEqual("Jim")
    expect(person.getName).toHaveBeenCalled()

  it "returns fake value", ->
    spyOn(person, 'getName').andReturn("Dan")
    expect(person.getName()).toEqual("Dan")
    expect(person.getName).toHaveBeenCalled()
    
  it "calls fake function", ->
    spyOn(person, 'getAge').andCallFake(-> return 5 * 11)
    expect(person.getAge()).toEqual(55)
    expect(person.getAge).toHaveBeenCalled()
    
  it "creates fake function", ->
    concat = jasmine.createSpy('CONCAT')
    concat("one", "two")
    expect(concat.identity).toEqual('CONCAT') # has name to identify
    expect(concat).toHaveBeenCalledWith("one", "two")
    expect(concat.calls.length).toEqual(1)

  it "creates fake object", ->
    button = jasmine.createSpyObj('BUTTON', ['click', 'setTitle', 'getTitle'])
    button.click()
    button.setTitle("Help")
    expect(button.click).toBeDefined()
    expect(button.click).toHaveBeenCalled()
    expect(button.setTitle).toHaveBeenCalledWith("Help")
    expect(button.getTitle).not.toHaveBeenCalled()

describe "Clock", ->
  callback = null
  
  beforeEach ->
    callback = jasmine.createSpy('TIMER')
    jasmine.Clock.useMock()
    
  it "calls timeout function synchronously", ->
    setTimeout((-> callback()), 100) # set timeout 100ms
    expect(callback).not.toHaveBeenCalled()
    jasmine.Clock.tick(101) # move clock 101ms
    expect(callback).toHaveBeenCalled()

describe "Any", ->
  person = null
  
  beforeEach ->
    person = new Person("Jim", 25)

  it "checks type name", ->
    spyOn(person, 'setName')
    person.setName("Ira")
    expect(person.setName).toHaveBeenCalledWith(jasmine.any(String))
    
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

