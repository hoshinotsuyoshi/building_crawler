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
    context 'when next_page_link_element is not nil' do
      it do
        c = Crawler.new(start_at: 'http://example.com/hogehoge')
        link_element = double(:link_element)
        allow(c).to receive(:next_page_link_element).and_return(link_element)
        allow(c).to receive(:scheme_and_host).and_return('http://www.officeiten.jp')

        expect(link_element).to receive(:attr).with(:href).and_return('/addr/aa3/ha20/za2/')
        expect(c.next_page_url).to eq('http://www.officeiten.jp/addr/aa3/ha20/za2/')
      end
    end

    context 'when next_page_link_element is nil' do
      it do
        c = Crawler.new(start_at: 'http://example.com/hogehoge')
        allow(c).to receive(:next_page_link_element).and_return(nil)
        allow(c).to receive(:scheme_and_host).and_return('http://www.officeiten.jp')

        expect(c.next_page_url).to be nil
      end
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

  describe '#visit_next_page' do
    it do
      c = Crawler.new(start_at: 'http://example.com/hogehoge')

      expect(c).to receive(:next_page_url).and_return('http://example.com/hogehoge2')
      expect(c).to receive(:get).with('http://example.com/hogehoge2').and_return(true)

      expect(c.visit_next_page).to be_truthy
    end
  end

  describe '#offices' do
    it 'returns 10-Office collection' do
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
      expect(offices).to be_all{ |office| office.is_a? Office }
      expect(offices.first['link']).to eq('/detail/3/30001/52429.html')
    end
  end
end

describe Office do
  describe '#[]' do
    context 'given "link"' do
      it do
        fixture_path = PROJECT_ROOT + 'spec/fixtures/office.html'
        o = Office.new(Nokogiri::XML.parse fixture_path.read)

        expect(o['link']).to eq('/detail/3/30001/52429.html')
      end
    end

    context 'given "物件No."' do
      it do
        fixture_path = PROJECT_ROOT + 'spec/fixtures/office.html'
        o = Office.new(Nokogiri::XML.parse fixture_path.read)

        expect(o['物件No.']).to eq('FVL52429')
      end
    end

    context 'given "ビル名"' do
      it do
        fixture_path = PROJECT_ROOT + 'spec/fixtures/office.html'
        o = Office.new(Nokogiri::XML.parse fixture_path.read)

        expect(o['ビル名']).to eq('中村ビル')
      end
    end
  end
end

describe Printer do
  describe '#print_header' do
    it do
      p = Printer.new
      office = { 'a' => '1', 'b' => '2', 'c' => '3' }
      expect(STDOUT).to receive(:puts).with("a\tb\tc")
      p.print_header(office)
    end
  end

  describe '#print' do
    it do
      p = Printer.new
      office = { 'a' => '1', 'b' => '2', 'c' => '3' }
      expect(STDOUT).to receive(:puts).with("1\t2\t3")
      p.print(office)
    end
  end
end
