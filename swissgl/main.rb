require "js"

class JS::Object
  def method_missing(sym, *args, &block)
    ret = self[sym]

    case ret.typeof
    when "undefined"
      str = sym.to_s
      if str[-1] == "="
        self[str.chop.to_sym] = args.first
        return args.first
      end

      super
    when "function"
      self.call(sym, *args, &block).to_r
    else
      ret.to_r
    end
  end

  def respond_to_missing?(sym, include_private)
    return true if super
    self[sym].typeof != "undefined"
  end

  def to_r
    case self.typeof
    when "number"
      self.to_f
    when "string"
      self.to_s
    else
      self
    end
  end
end

$JS = JS.global
canvas = $JS.document.getElementById('c')
$JS.glsl = $JS.SwissGL(canvas)

class Hash
  def to_js
    js = JS.eval("return {}")
    self.each do |k, v|
      js[k] = v
    end
    js
  end
end

def render(t)
  t = t / 1000; # ms to sec
  $JS.glsl({t:}.to_js, "UV,cos(t*TAU),1")
  $JS.requestAnimationFrame(->(t) { render(t.to_r) });
end

render(rand * 1000)

