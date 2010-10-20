module Paginary
  module Helpers
    class PageBuilder
      attr_reader :template, :relation
      alias_method :items, :relation
      
      delegate :content_tag, :link_to, :params, :translate, :to => :template
      
      def initialize(template, relation, options = {})
        @template = template
        @param_name = options.delete(:param) || :page
        @relation = relation.paginated? ? relation : relation.paginate(params[@param_name], options)
      end
      
      def page_url(page)
        template.url_for params.merge(@param_name => page)
      end

      def previous_url
        page_url @relation.current_page - 1
      end
      
      def next_url
        page_url @relation.current_page + 1
      end
      
      def links
        return unless @relation.paginated?
        content_tag :div, previous_link + page_links + next_link, :class => "pagination"
      end

      def page_links
        (1..@relation.page_count).collect do |page|
          link_to content_tag(:span, page), page_url(page), :class => "page#{@relation.current_page == page ? " selected" : ""}"
        end.inject(:+)
      end

      def previous_link
        text = content_tag(:span, translate("previous", :default => "< Previous"))
        unless @relation.first_page?
          link_to text, previous_url, :class => "previous"
        else
          content_tag :span, text, :class => "previous disabled"
        end
      end

      def next_link
        text = content_tag(:span, translate("previous", :default => "Next >"))
        unless @relation.last_page?
          link_to text, next_url, :class => "next"
        else
          content_tag :span, text, :class => "next disabled"
        end
      end
    end
  end
end
