require 'spec_helper'

describe Crawler do
  describe '#current_page' do
    it do
      c = Crawler.new(start_at: 'http://www.officeiten.jp/addr/aa3/ha20/')
      expect(c.current_page).to eq('http://www.officeiten.jp/addr/aa3/ha20/')
    end
  end
end
