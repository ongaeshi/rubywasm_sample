require "js"

class Hash
  def to_js
    js = JS.eval("return {}")
    self.each do |k, v|
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

def render(t)
  t = t / 1000; # ms to sec
  $glsl.call({t:}, "UV,cos(t*TAU),1")
  JS.global.requestAnimationFrame(->(t) { render(t.to_f) });
end

render(rand * 1000)

