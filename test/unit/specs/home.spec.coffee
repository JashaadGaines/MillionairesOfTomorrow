require ['app/assets/javascripts/home.coffee', 'spec_helper'], (home) ->

  describe "Scroll Blur effect", ->
    it "should set opacity based on scroll ratio", ->

      spyOn($(window),"scrollTop()").andReturn 10

      dividend = 10
      element = $(".element").css
      home.setOpacityWithScrollValue(element,dividend)

      expect(element('opacity')).toBe 1