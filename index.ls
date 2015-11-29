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

bricks = []
brick-class = (idx) -> 
  @reset idx
  @

brick-class.prototype = do
  mod: 100
  w: 4
  h: 2
  m: 2
  c: r: 200, g: 90, b: 90
  opacity: 1
  iteration: 0
  idx: 0
  reset: (idx) ->
    if idx? => @idx = idx
    @ <<< do
      x: ( @idx % 100 ) * (@w + @m) + 10
      y: parseInt( @idx / 100 ) * (@h + @m) + 100
      opacity:  1
      iteration: 0

setup = ->
  create-canvas 800,600
  size = {x: 5, y: 4}
  offset = {x: 10, y: 10}
  for i from 0 til 1000
    obj = new brick-class i
    bricks.push obj

draw = ->
  fill \#fff
  rect -1,-1,802,602
  for brick in bricks
    stroke "rgba(200,80,80,#{brick.opacity})"
    fill "rgba(200,80,80,#{brick.opacity})"
    if brick.transition => 
      step brick
    rect brick.x, brick.y, 3, 2

setTimeout (->
  for i from 500 til 1000 =>
    b = bricks[i]
    transition b, {delay: parseInt(1000*Math.random!), dur: 2000, ease: easer.ease-in-out}, {x: 400, y: 600}
), 1000
