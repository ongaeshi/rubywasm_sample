require "js"

module P5
  # https://github.com/processing/p5.js/blob/main/src/math/p5.Vector.js
  Vector = JS.global[:p5][:Vector]
end

v = P5::Vector.random2D
p v
v.set(2, 0)
p v
p v.mag
puts v.toString()

include P5
p Vector.random2D
