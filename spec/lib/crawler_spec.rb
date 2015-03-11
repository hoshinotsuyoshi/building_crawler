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

  describe '#next_page_link_element' do
    it do
      fixture_path = PROJECT_ROOT + 'spec/fixtures/ha20.html'
      WebMock.stub_request(
        :get,
        'http://www.officeiten.jp/addr/aa3/ha20/'
      ).to_return(
        body: fixture_path.read,
        headers: { content_type: 'text/html' }
      )

      c = Crawler.new(start_at: 'http://www.officeiten.jp/addr/aa3/ha20/')
      c.visit_start_page
      link_element = c.next_page_link_element

      expect(link_element).to be_a Nokogiri::XML::Element
      expect(link_element.attr(:href)).to eq '/addr/aa3/ha20/za2/'
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
