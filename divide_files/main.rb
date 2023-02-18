p JS.eval("return 1 + 2") # => 3

document = JS.global.document
# document.write("Hello, world!")
div = document.createElement("div")
div.innerText = "click me"
document.body.appendChild(div)

c = 0
div.addEventListener("click") do |event|
  puts event          # => # [object MouseEvent]
  # puts event[:detail] # => 1
  puts event.detail # => 1.0
  c += 1
  div.innerText = "clicked! #{c}"
end
