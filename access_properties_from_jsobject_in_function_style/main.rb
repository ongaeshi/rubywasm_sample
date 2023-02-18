require "js"

class JS::Object
  def method_missing(sym, *args, &block)
    ret = self[sym]
  
    case ret.typeof
    when "function"
      self.call(sym, *args, &block).to_r
    when "undefined"
      super
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

document = JS.global[:document]
content = document.querySelector('div#content')

content[:innerHTML] = <<~HTML
  <div class="info">
    <p>Powered by <a href="https://github.com/ruby/ruby.wasm">ruby.wasm</a> (<a href="https://ruby.github.io/ruby.wasm/">doc</a>)</p>
    <p>#{RUBY_DESCRIPTION}</p>
  </div>
  </div>
HTML

p content.innerHTML
