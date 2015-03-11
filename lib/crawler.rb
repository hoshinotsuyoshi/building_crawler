require 'mechanize'

class Crawler < Mechanize
  def initialize(start_at: nil)
    @start_at = start_at
  end

  def current_page
    @start_at
  end

  def visit_start_page
    get(@start_at)
  end
end
