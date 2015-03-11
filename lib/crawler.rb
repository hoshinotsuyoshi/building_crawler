class Crawler
  def initialize(start_at: nil)
    @start_at = start_at
  end

  def current_page
    @start_at
  end
end
