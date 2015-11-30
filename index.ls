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
  c: 1000
  dur: 2000
  step: 10

brick-class.prototype = bcp = do
  mod: 100
  w: 4
  h: 2
  m: 2
  c: r: 200, g: 90, b: 90
  opacity: 1
  iteration: 0
  idx: 0
  pos: (isPos = true) -> 
    ret = do
      x: ( @idx % @mod ) * (@w + @m) + @m
      y: parseInt( @idx / @mod ) * (@h + @m)
    if isPos => ret.y = config.h - ret.y
    ret
    
  reset: (idx, isPos = true) ->
    if idx? => @idx = idx
    @ <<< opacity: 1, iteration: 0
    @ <<< @pos isPos

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
  size = {x: 5, y: 4}
  offset = {x: 10, y: 10}
  for i from 0 til config.c
    obj = new brick-class i, false
    bricks.neg.push obj
    obj = new brick-class i, true
    bricks.pos.push obj
  change-range $(\#money).0.value, true
  renderer.render stage

/*
window.setup = ->
  container = $(\#container)
  [w,h] = [config.w, config.h] = [container.width!, container.height!]
  cvs = create-canvas w, h, \webgl
  bcp.mod = parseInt(w / ( bcp.w + bcp.m))
  document.body.removeChild cvs.elt
  container.append cvs.elt
  size = {x: 5, y: 4}
  offset = {x: 10, y: 10}
  for i from 0 til config.c
    obj = new brick-class i, false
    bricks.neg.push obj
    obj = new brick-class i, true
    bricks.pos.push obj
  change-range $(\#money).0.value, true
*/

draw = ->
  requestAnimationFrame draw
  base.graphics.beginFill 0xFFFFFF
  base.graphics.drawRect 0, 0, config.w, config.h
  base.graphics.beginFill 0xCC555500
  for brick in bricks.neg
    #fill "rgba(200,80,80,#{brick.opacity})"
    if brick.transition => step brick
    base.graphics.drawRect brick.x, brick.y, 3, 2
  base.graphics.beginFill 0x55CC5500
  for brick in bricks.pos
    #fill "rgba(80,200,80,#{brick.opacity})"
    if brick.transition => step brick
    base.graphics.drawRect brick.x, brick.y, 3, 2
  base.renderer.render base.stage

/*
window.draw = ->
  fill \#fff
  rect -1,-1,802,602
  for brick in bricks.neg
    stroke "rgba(200,80,80,#{brick.opacity})"
    fill "rgba(200,80,80,#{brick.opacity})"
    if brick.transition => step brick
    rect brick.x, brick.y, 3, 2
  for brick in bricks.pos
    stroke "rgba(80,200,80,#{brick.opacity})"
    fill "rgba(80,200,80,#{brick.opacity})"
    if brick.transition => step brick
    rect brick.x, brick.y, 3, 2
*/

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
      {y, opacity: 1}
    )
  for i from count til config.c =>
    b = list[i]
    transition(
      b,
      {delay: (if instant => 0 else parseInt(1000*Math.random!)), dur, ease: easer.ease-in-out},
      {y: (if isPos => 0 else config.h), opacity: 0}
    )

change-range = (money, instant = false) ->
  change-range-side money, bricks.neg, false, instant
  change-range-side money, bricks.pos, true, instant

window.change = -> change-range document.getElementById(\money).value

setup!
draw!
