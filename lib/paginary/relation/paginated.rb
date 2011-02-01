require "active_support/core_ext/array/extract_options"

module Paginary
  # This error is raised if the requested page is not available. This
  # happens if the given page number is less than one or greater than the
  # total number of pages.
  class PageNotFound < StandardError; end

  module Relation
    module Paginated
      # The maximum number of items that should be displayed on one page.
      attr_accessor :items_per_page

      # The number of the current page.
      attr_accessor :current_page

      # Force-paginates this relation. Usually only called from the #paginate
      # method (see the QueryMethods module).
      def paginate!(*args) # @private :nodoc:
        options = args.extract_options!
        self.items_per_page = options[:per_page] || 50
        self.current_page   = args.first || 1
        self.limit_value    = items_per_page
        self.offset_value   = items_per_page * (current_page - 1)
      end

      # Returns if the relation is paginated. A relation is paginated if it
      # represents a subset of the total number of rows that would otherwise
      # be returned.
      def paginated?
        page_count > 1
      end

      # Returns the total number of pages.
      def page_count
        # Integer arithmetic is simpler and faster.
        @page_count ||= item_count > 0 ? (item_count - 1) / items_per_page + 1 : 1
      end

      # Returns the total number of items represented by the original relation.
      def item_count
        @item_count ||= except(:includes, :limit, :offset).count
      end

      # Returns +true+ if #current_page equals +1+, that is if the current
      # page is the first page.
      def first_page?
        current_page == 1
      end

      # Returns +true+ if #current_page equals #page_count, that is if the
      # current page is the last page.
      def last_page?
        current_page == page_count
      end

      private

      # Set the current page. A sanity check is performed. If the given page
      # does not exist, a Paginary::PageNotFound error is raised.
      def current_page=(page)
        number = page.to_i
        unless number.to_s == page.to_s && number.between?(1, page_count)
          raise PageNotFound, "Unknown page #{page}, expected 1..#{page_count}"
        end
        @current_page = number
      end
    end
  end
end
