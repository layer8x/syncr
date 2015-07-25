$(function () {
  $(".button-collapse").sideNav();

  var top_block = $('#logo-block-top');
  var bottom_block = $('#logo-block-bottom');

  var top_block_left = top_block.css('left');
  var bottom_block_left = bottom_block.css('left');

  var speed = 400;

  top_block.css({
    left: '100em',
    opacity: 0
  });

  bottom_block.css({
    left: '-100em',
    opacity: 0
  });

  top_block.animate({
    opacity: 1,
    left: top_block_left
  }, speed);

  bottom_block.animate({
    opacity: 1,
    left: bottom_block_left
  }, speed);

  $('#logo-text').fadeIn('slow');

  $('.code-card > .highlight').addClass('z-depth-1');
});
