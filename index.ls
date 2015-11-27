
bricks = []
setup = ->
  create-canvas 800,600
  size = {x: 5, y: 4}
  offset = {x: 10, y: 10}
  for i from 0 til 1000
    obj = do
      idx: i
      x: offset.x + size.x * (i % 100)
      y: offset.y + size.y * parseInt(i / 100)
      opacity: 1
      decay: 0.5 + Math.random!*0.5
    bricks.push obj
draw = ->
  fill \#fff
  rect 0,0,800,600
  for brick in bricks
    stroke "rgba(200,80,80,#{brick.opacity})"
    fill "rgba(200,80,80,#{brick.opacity})"
    rect brick.x, brick.y, 3, 2
  for i from 800 til 1000
    brick = bricks[i]
    brick.x = (250 - brick.x) * 0.05 * brick.decay + brick.x
    brick.y = (800 - brick.y) * 0.05 * brick.decay + brick.y
    brick.opacity *= 0.95
