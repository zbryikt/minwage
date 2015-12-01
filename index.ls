
angular.module \main, <[]>
  ..controller \main, <[$scope $timeout]> ++ ($scope, $timeout) ->
    $scope.income = 50000
    $scope.spend = do
      housing: 10000
      basic: 4000
      transport: 10000
      medical: 2000
      debt: 0
      tax: 2000
      food: 20000
      other: 0
    $scope.update = ->
      if $scope.handler => $timeout.cancel $scope.handler
      $scope.handler = $timeout (->
        $scope.handler = null
        $scope.sum = [parseInt(v) for k,v of $scope.spend].reduce(((a,b) -> a + b),0)
        $(\#money).0.value = $scope.income - $scope.sum
        console.log $(\#money).0.value
        window.change!
      ), 1000
    $scope.$watch 'spend', $scope.update, true
    $scope.$watch 'income', $scope.update, true

window.change = -> 
  if !window.change-range? => return
  window.change-range document.getElementById(\money).value, false

<- $ document .ready

base = {}


easer = do
  linear: -> it
  quadratic: -> it*it
  ease-in-out: -> 
    if it <= 0.5 => return 4 * it**3
    return 1 - 4 * (1 - it)**3

transition = (it, config, des) ->
  src = {}
  it.transition = {src, des, config, start: new Date!getTime!}
  for k,v of des => src[k] = it[k]

step = (it) ->
  if !(it.transition?) => return
  {src,des,config,start} = it.transition{src,des,config,start}
  {dur,ease,delay} = config{dur,ease,delay}
  now = new Date!getTime!
  if delay? and now < start + delay => return
  percent = ( now - start - (if delay? => delay else 0)) / dur
  percent >?= 0
  percent <?= 1
  if ease => percent = ease percent
  for k,v of des => it[k] = src[k] + ( ( des[k] - src[k] ) * percent )
  if percent >= 1 => delete it.transition

bricks = do
  pos: []
  neg: []
brick-class = (idx, isPos = true) -> 
  @reset idx, isPos
  @

config = do
  w: 0
  h: 0
  c: 40000
  dur: 1000
  step: 10

brick-class.prototype = bcp = do
  mod: 100
  w: 2
  h: 2
  m: 1
  c: r: 200, g: 90, b: 90
  alpha: 1
  iteration: 0
  idx: 0
  pos: (isPos = true) -> 
    ret = do
      x: ( @idx % @mod ) * (@w + @m) + @m 
      y: parseInt( @idx / @mod ) * (@h + @m) + 10
    if isPos => ret.y = config.h - ret.y
    ret
    
  reset: (idx, isPos = true) ->
    if idx? => @idx = idx
    @ <<< alpha: 1, iteration: 0
    @ <<< @pos isPos
    @y = if isPos => -5 else config.h

setup = ->
  container = $(\#container)
  [w,h] = [config.w, config.h] = [container.width!, container.height!]
  bcp.mod = parseInt(w / ( bcp.w + bcp.m))
  base.renderer = renderer = new PIXI.WebGLRenderer w, h
  $(\#container).0.appendChild renderer.view
  base.graphics = graphics = new PIXI.Graphics!
  graphics.beginFill 0xFFFF00
  base.stage = stage = new PIXI.Container!
  stage.addChild graphics
  batch1 = new PIXI.ParticleContainer 20000
  batch2 = new PIXI.ParticleContainer 20000
  stage.addChild batch1
  stage.addChild batch2
  size = {x: 5, y: 4}
  offset = {x: 10, y: 10}pos
  tpos = PIXI.Texture.fromImage \dot-pos.png
  tneg = PIXI.Texture.fromImage \dot-neg.png
  for i from 0 til config.c
    obj = new brick-class i, false
    sprite1 = new PIXI.Sprite tneg
    obj.sprite = sprite1
    batch1.addChild sprite1
    bricks.neg.push obj
    obj = new brick-class i, true
    sprite2 = new PIXI.Sprite tpos
    obj.sprite = sprite2
    batch2.addChild sprite2
    bricks.pos.push obj
  window.change!

draw = (has-next = false) ->
  base.graphics.beginFill 0xFFFFFF
  base.graphics.drawRect 0, 0, config.w, config.h

  for brick in bricks.neg
    if brick.transition => 
      has-next = true
      step brick
    brick.sprite <<< brick{x,y,alpha}
  for brick in bricks.pos
    if brick.transition => 
      has-next = true
      step brick
    brick.sprite <<< brick{x,y,alpha}
  base.renderer.render base.stage
  if has-next => requestAnimationFrame -> draw false

change-range-side = (money, list, isPos = true, instant = false) ->
  count = parseInt(money / config.step)
  if !isPos => count = -count
  count <?= config.c
  count >?= 0
  dur = if instant => 0 else config.dur
  for i from 0 til count =>
    b = list[i]
    {x,y} = b.pos isPos
    transition(
      b,
      {delay: (if instant => 0 else parseInt(1000*Math.random!)), dur, ease: easer.ease-in-out},
      {y, alpha: 1}
    )
  for i from count til config.c =>
    b = list[i]
    transition(
      b,
      {delay: (if instant => 0 else parseInt(1000*Math.random!)), dur, ease: easer.ease-in-out},
      {y: (if isPos => -5 else config.h), alpha: 1}
    )

window.change-range = change-range = (money, instant = false) ->
  change-range-side money, bricks.neg, false, instant
  change-range-side money, bricks.pos, true, instant
  draw true


setup!
