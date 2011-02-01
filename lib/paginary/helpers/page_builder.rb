module Paginary
  module Helpers
    class PageBuilder
      attr_reader :template # @private :nodoc:

      # The paginated relation. You should use this to iterate over all items
      # on the current page.
      attr_reader :relation
      alias_method :items, :relation

      ##
      # Returns the number of the current page.
      delegate :current_page, :to => :relation

      ##
      # Returns the total number of pages.
      delegate :page_count, :to => :relation

      ##
      # Returns +true+ if #current_page equals +1+, that is if the current
      # page is the first page.
      delegate :first_page?, :to => :relation

      ##
      # Returns +true+ if #current_page equals #page_count, that is if the
      # current page is the last page.
      delegate :last_page?, :to => :relation

      def initialize(template, relation, options = {}) # @private :nodoc:
        @template = template
        @param_name = options.delete(:param) || :page
        @link_range = options.delete(:link_range) || 10
        @relation = relation.paginated? ? relation : relation.paginate(template.params[@param_name], options)
      end

      # Returns a URL for the given page number.
      def page_url(page)
        template.url_for template.params.merge(@param_name => page)
      end

      # Returns a URL for the page before the current page. This URL may not
      # be valid if called from the first page. Consider checking if
      # +first_page?+ returns +true+.
      def previous_url
        page_url current_page - 1
      end

      # Returns a URL for the page after the current page. This URL may not
      # be valid if called from the last page. Consider checking if
      # +last_page?+ returns +true+.
      def next_url
        page_url current_page + 1
      end

      # Returns page navigation links if there is more than one page. The
      # navigation links start with a link to the previous page, then a number
      # of links to specific pages around the current page (a maximum of 10 on
      # either side), followed by a link to the next page.
      def links
        return unless @relation.paginated?
        template.content_tag :div, previous_link + page_links + next_link, :class => "pagination"
      end

      # Returns navigation links to specific pages around the current page.
      # A maximum of 10 links are returned on either side of the current page
      # by default.
      def page_links
        page_numbers.collect do |page|
          page_link(page)
        end.inject(:+)
      end

      # Returns a page link for the given page number.
      def page_link(page)
        template.link_to template.content_tag(:span, page), page_url(page), :class => "page#{current_page == page ? " selected" : ""}"
      end

      # Returns a link to the previous page. The link is replaced by a +span+
      # element if this is the first page.
      def previous_link
        text = template.content_tag(:span, template.translate("previous", :default => "< Previous"))
        unless first_page?
          template.link_to text, previous_url, :class => "previous"
        else
          template.content_tag :span, text, :class => "previous disabled"
        end
      end

      # Returns a link to the next page. The link is replaced by a +span+
      # element if this is the last page.
      def next_link
        text = template.content_tag(:span, template.translate("previous", :default => "Next >"))
        unless last_page?
          template.link_to text, next_url, :class => "next"
        else
          template.content_tag :span, text, :class => "next disabled"
        end
      end

      protected

      # Returns a range of page numbers that should be displayed in the
      # navigation links. By default, a maximum of 10 links on either side of
      # the current page is returned. This should only be used from methods
      # in subclasses of this class.
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
