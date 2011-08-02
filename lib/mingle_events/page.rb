module MingleEvents
  
  # A page of Atom events. I.e., *not* a Mingle page. Most users of this library
  # will not use this class to access the Mingle Atom feed, but will use the 
  # ProjectFeed class which handles paging transparently.
  class Page
  
    attr_accessor :url
    
    def initialize(url, mingle_access)
      @url = url
      @mingle_access = mingle_access
    end
  
    def entries
      @entries ||= page_as_document.search('feed/entry').map do |entry_element|
        Entry.new(entry_element, @url)
      end
    end
  
    def next
      @next ||= construct_next_page
    end
    
    def previous
      @previous ||= construct_previous_page
    end
  
    private
    
    def construct_next_page
      next_url_element = page_as_document.at("feed/link[@rel='next']")
      if next_url_element.nil?
        nil
      else
        Page.new(next_url_element.attribute('href').text, @mingle_access)
      end
    end
    
    def construct_previous_page
      previous_url_element = page_as_document.at("feed/link[@rel='previous']")
      if previous_url_element.nil?
        nil
      else
        Page.new(previous_url_element.attribute('href').text, @mingle_access)
      end
    end
    
  
    def page_as_document
      @page_as_document ||= Nokogiri::XML(@mingle_access.fetch_page(@url))
    end
    
  end
end