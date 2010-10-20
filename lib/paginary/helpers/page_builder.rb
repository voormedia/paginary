module Paginary
  module Helpers
    class PageBuilder
      attr_reader :template, :relation
      alias_method :items, :relation
      
      delegate :content_tag, :link_to, :params, :translate, :to => :template
      delegate :current_page, :page_count, :first_page?, :last_page?, :to => :relation
      
      def initialize(template, relation, options = {})
        @template = template
        @param_name = options.delete(:param) || :page
        @link_range = options.delete(:link_range) || 10
        @relation = relation.paginated? ? relation : relation.paginate(params[@param_name], options)
      end
      
      def page_url(page)
        template.url_for params.merge(@param_name => page)
      end

      def previous_url
        page_url current_page - 1
      end
      
      def next_url
        page_url current_page + 1
      end
      
      def links
        return unless @relation.paginated?
        content_tag :div, previous_link + page_links + next_link, :class => "pagination"
      end

      def page_links
        page_numbers.collect do |page|
          page_link(page)
        end.inject(:+)
      end
      
      def page_link(page)
        link_to content_tag(:span, page), page_url(page), :class => "page#{current_page == page ? " selected" : ""}"
      end

      def previous_link
        text = content_tag(:span, translate("previous", :default => "< Previous"))
        unless first_page?
          link_to text, previous_url, :class => "previous"
        else
          content_tag :span, text, :class => "previous disabled"
        end
      end

      def next_link
        text = content_tag(:span, translate("previous", :default => "Next >"))
        unless last_page?
          link_to text, next_url, :class => "next"
        else
          content_tag :span, text, :class => "next disabled"
        end
      end
      
      protected
      
      def page_numbers
        start  = current_page - @link_range
        finish = current_page + @link_range

        if start < 1
          finish = [finish + 1 - start, page_count].min
          start = 1
        elsif finish > page_count
          start = [start + page_count - finish, 1].max
          finish = page_count
        end
        
        (start..finish).to_a
      end
    end
  end
end
