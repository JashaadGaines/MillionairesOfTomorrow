(function() {
  var appendToClass, setOpacityWithScrollValue;

  setOpacityWithScrollValue = function(element, dividend) {
    var oVal;
    oVal = $(window).scrollTop() / 240;
    return $(".blur").css("opacity", oVal);
  };

  appendToClass = function(name, newClassName) {
    var element;
    element = document.getElementsByClassName(name);
    return element.className += " " + newClassName;
  };

  ({
    title: "Millionadires of Tomorrow",
    init: $(window).scroll(function() {
      appendToClass("hero-unit", "blur");
      return setOpacityWithScrollValue(".image .blur".css, 240);
    })
  });

}).call(this);
