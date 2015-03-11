describe Crawler do
  describe '#current_page' do
    it do
      c = Crawler.new(start_at: 'http://www.officeiten.jp/addr/aa3/ha20/')
      expect(c.current_page).to eq('http://www.officeiten.jp/addr/aa3/ha20/')
    end
  end

  xdescribe '#next_page_url' do
    it do
      c = Crawler.new(start_at: 'http://www.officeiten.jp/addr/aa3/ha20/')
      c.visit_start_page
      expect(c.next_page_url).to eq('http://www.officeiten.jp/addr/aa3/ha20/za2/')
    end
  end

  describe '#visit_start_page' do
    it do
      c = Crawler.new(start_at: 'http://www.officeiten.jp/addr/aa3/ha20/')

      expect(c).to receive(:get).with('http://www.officeiten.jp/addr/aa3/ha20/')
      c.visit_start_page
    end
  end
end
