describe "Test Suite", ->
  it "has expectations", ->
    expect(1 + 2).toBe(3)


describe "Disabled", ->
  xdescribe "disabled suite", ->
    it "will not run", ->
      expect(true).toBe(true)
    
  xit "is disabled", ->
    expect(true).toBe(true)
    
  
describe "Matchers", ->
  it "compares using ===", ->
    expect(1 + 2).toBe(3)
    
  it "compares variables and objects", ->
    a = {x: 8, y: 9}
    b = {x: 8, y: 9}
    expect(a).toEqual(b)
    expect(a).not.toBe(b) # negation - a is not b

  it "checks value to be defined", ->
    expect(window.document).toBeDefined()

  it "checks value to be undefined", ->
    expect(window.notExists).toBeUndefined()

  it "checks value to be null", ->
    a = null
    expect(a).toBeNull()

  it "checks value to be true", ->
    expect(5 > 0).toBeTruthy()

  it "checks value to be false", ->
    expect(5 < 0).toBeFalsy()

  it "checks value to be less than", ->
    expect(1 + 2).toBeLessThan(5)
    
  it "checks value to be greater than", ->
    expect(1 + 2).toBeGreaterThan(0)
  
  it "checks value to be close to", ->
    expect(1.2345).toBeCloseTo(1.2, 1)

  it "checks RegEx match", ->
    expect("some string").toMatch(/string/)

  it "checks inclusion", ->
    expect([1, 2, 3]).toContain(2)
    expect("some string").toContain("some")

  it "throws error", ->
    func = -> window.notExists.value
    expect(func).toThrow()
      

describe "Setup/Teardown", ->
  a = 0 # init variable in test suite context
  
  beforeEach ->
    a += 1
    
  afterEach ->
    a = 0
    
  it "uses val", ->
    expect(a).toEqual(1)


describe "Asynchronous", ->
  a = 0
  
  async = ->
    setTimeout((-> a = 5), 1000)
    
  it "async executes code", ->
    runs(-> async())
    waitsFor((-> a == 5), 3000)
    
