require 'mechanize'

class Crawler < Mechanize
  def initialize(start_at: nil)
    super
    @start_at = start_at
  end

  def current_page
    @start_at
  end

  def visit_start_page
    get(@start_at)
  end

  def next_page_link_element
    (page/("//*[@id='list1']/div/a")).find{|e| e.text =~ /次のページ/ }
  end

  def next_page_url
  end
end
