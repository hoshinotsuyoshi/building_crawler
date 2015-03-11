$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'crawler'
require 'pry'

c = Crawler.new(start_at: 'http://www.officeiten.jp/addr/aa3/ha20/')
p = Printer.new

c.visit_start_page

p.print_header(c.offices.first)

c.offices.each do |o|
  p.print(o)
end
