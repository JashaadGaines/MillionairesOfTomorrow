
setOpacityWithScrollValue = (element,dividend) ->
  oVal = ($(window).scrollTop() / 240)
  $(".blur").css "opacity", oVal

appendToClass = (name ,newClassName) ->
    element = document.getElementsByClassName name ;
    element.className += " " + newClassName

title: "Millionadires of Tomorrow"


init:
  $(window).scroll ->
        appendToClass("hero-unit", "blur")
        setOpacityWithScrollValue((".image .blur").css, 240)


