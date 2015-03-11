describe Crawler do
  describe '#scheme_and_host' do
    it do
      c = Crawler.new(start_at: 'http://www.officeiten.jp/addr/aa3/ha20/')
      expect(c.scheme_and_host).to eq('http://www.officeiten.jp')
    end
  end

  describe '#current_page' do
    it do
      c = Crawler.new(start_at: 'http://www.officeiten.jp/addr/aa3/ha20/')
      expect(c.current_page).to eq('http://www.officeiten.jp/addr/aa3/ha20/')
    end
  end

  describe '#next_page_url' do
    it do
      c = Crawler.new(start_at: 'http://example.com/hogehoge')
      link_element = double(:link_element)
      allow(c).to receive(:next_page_link_element).and_return(link_element)
      allow(c).to receive(:scheme_and_host).and_return('http://www.officeiten.jp')

      expect(link_element).to receive(:attr).with(:href).and_return('/addr/aa3/ha20/za2/')
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

  describe '#offices' do
    it 'returns 10 offices' do
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
      offices = c.offices

      expect(offices.size).to be 10
      expect(offices).to be_all{ |office| office.is_a? Nokogiri::XML::Element }
    end
  end
end
