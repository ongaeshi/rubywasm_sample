require "js"

class Array
  def to_js
    js = JS.eval("return []")
    self.each do |e|
      js.push(e)
    end
    js
  end
end

class Hash
  def to_js
    js = JS.eval("return {}")
    self.each do |k, v|
      v = v.to_js if v.is_a?(Array)
      js[k] = v
    end
    js
  end
end

class SwissGL
  def initialize(canvas_gl)
    @obj = JS.eval("return {}")
    @obj[:glsl] = JS.global.SwissGL(canvas_gl)
  end

  def call(params, code = nil, target = nil)
    # process arguments
    if params.is_a?(String)
      params, code, target = {}, params, code
    elsif code.nil?
      params, code, target = {}, "", params
    end

    if target.nil?
      @obj.glsl(params.to_js, code)
    elsif target.is_a?(Hash)
      @obj.glsl(params.to_js, code, target.to_js)
    else
      @obj.glsl(params.to_js, code, target)
    end
  end
end

canvas = JS.global[:document].getElementById('c')
$glsl = SwissGL.new(canvas)

# # Hello
# def render(t)
#   t = t / 1000; # ms to sec
#   $glsl.call({t:}, "UV,cos(t*TAU),1")
#   # $glsl.call({t:, k:9}, "1-((I.x+int(t*40.))/4^(I.y+int(t*20.))/4)%int(k)");
#   JS.global.requestAnimationFrame(->(t) { render(t.to_f) })
# end

# render(0)

# Bit Field
def render(t)
  t = t / 1000; # ms to sec
  $glsl.call({t:, k:9}, "1-((I.x+int(t*40.))/4^(I.y+int(t*20.))/4)%int(k)");
  JS.global.requestAnimationFrame(->(t) { render(t.to_f) })
end

render(0)

# Particle life
# K = 6 # number of particle types
# F = $glsl.call(<<-EOS, {size:[K,K], format:'r16f'})
# float(I.x==I.y) + 0.1*float(I.x==I.y+1)
# EOS
# $glsl.call({F:}, "F(I/20).x*3.0");

# points = $glsl.call({size:[30,10], story:3, format:'rgba32f', tag:'points'})

# (0...2).each do |i|
#   $glsl.call({K:, seed:123}, <<-EOS, points)
# vec2 pos = (hash(ivec3(I, seed)).xy-0.5)*10.0;
# float color = floor(UV.x*K);
# out0 = vec4(pos, 0.0, color);
# EOS
# end

