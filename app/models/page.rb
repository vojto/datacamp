class Page < ActiveRecord::Base
    translates :body, :title
    
    def html_body
        doc = RedCloth.new(self.body || "")
        return doc.to_html
    end
    
    def to_param
      page_name
    end
    
    def self.find_by_page_name(page_name)
      @pages = Page.find :all, :include => :globalize_translations
      @pages.find_all{|page|page.page_name == page_name}.first
    end
end
