require 'mechanize'

class Crawler < Mechanize
  def initialize(start_at: nil)
    super
    @start_at = start_at
  end

  def scheme_and_host
    @start_at.split('/')[0, 3].join('/')
  end

  def current_page
    @start_at
  end

  def next_page_url
    if next_page_link_element
      scheme_and_host + next_page_link_element.attr(:href)
    end
  end

  def next_page_link_element
    (page/("//*[@id='list1']/div/a")).find{|e| e.text =~ /次のページ/ }
  end

  def visit_start_page
    get(@start_at)
  end

  def visit_next_page
    (url = next_page_url) && get(url)
  end

  def offices
    selector = "//*[@id='result']/div[@class='result_box clearfix']"
    offices = page / selector
    offices = offices.select{|e| e.text.include?('物件No.')} # 別のリンクも含んでしまうため
    offices.map{|e| Office.new(e) }
  end
end

class Office
  extend Forwardable
  def initialize(element)
    @element = element
    build_content
  end

  def_delegators :@content, :[], :keys, :values

  private

  def scrape(arg)
    case arg
    when 'link'
      (@element/"a[@class='buildingname']").attr('href').value
    when '物件No.'
      (@element/"span[@class='buildingno']").text.delete '物件No.'
    when 'ビル名'
      (@element/"a[@class='buildingname']").text
    end
  end

  def build_content
    @content = {}
    %w(link 物件No. ビル名).each do |e|
      @content[e] = scrape(e)
    end
  end
end

class Printer
  def print_header(office)
    header = office.keys.join("\t")
    puts header
  end

  def print(office)
    row = office.values.join("\t")
    puts row
  end
end
