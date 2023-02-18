require "js"

class JS::Object
  def method_missing(sym, *args, &block)
    ret = self[sym]

    case ret.typeof
    when "undefined"
      str = sym.to_s
      if str[-1] == "="
        self[str.chop.to_sym] = args[0]
        return args[0]
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

# Get propery via getter
p "src".length

# Set propery via setter
content = JS.global.document.querySelector('div#content')
content.innerHTML = <<~HTML
  <div class="info">
    <p>Powered by <a href="https://github.com/ruby/ruby.wasm">ruby.wasm</a></p>
  </div>
HTML

# Add to property
content.innerHTML += "<div><p>#{RUBY_DESCRIPTION}</p></div>"
