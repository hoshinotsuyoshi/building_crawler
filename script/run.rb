$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'crawler'
require 'pry'

c = Crawler.new(start_at: 'http://www.officeiten.jp/addr/aa3/ha20/')
#c = Crawler.new(start_at: 'http://www.officeiten.jp/addr/aa3/ha20/za219/')
p = Printer.new

c.visit_start_page

p.print_header(c.offices.first)

c.offices.each do |o|
  p.print(o)
end

while c.visit_next_page do
  c.offices.each do |o|
    p.print(o)
  end
end
