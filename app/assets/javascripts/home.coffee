
setOpacityWithScrollValue = (element,dividend) ->
  oVal = ($(window).scrollTop() / 240)
  $(".blur").css "opacity", oVal

title: "Millionaires of Tomorrow"


init: $(window).scroll ->
        setOpacityWithScrollValue((".blur").css, 240)


