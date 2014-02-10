require(['app/assets/javascripts/home.coffee', 'spec_helper'], function(home) {
  return describe("Scroll Blur effect", function() {
    return it("should set opacity based on scroll ratio", function() {
      var dividend, element;
      spyOn($(window), "scrollTop()").andReturn(10);
      dividend = 10;
      element = $(".element").css;
      home.setOpacityWithScrollValue(element, dividend);
      return expect(element('opacity')).toBe(1);
    });
  });
});
