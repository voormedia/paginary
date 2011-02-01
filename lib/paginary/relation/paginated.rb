require "active_support/core_ext/array/extract_options"

module Paginary
  class PageNotFound < StandardError; end

  module Relation # @private :nodoc:
    module Paginated
      attr_accessor :items_per_page, :current_page

      def paginate!(*args)
        options = args.extract_options!
        self.items_per_page = options[:per_page] || 50
        self.current_page   = args.first || 1
        self.limit_value    = items_per_page
        self.offset_value   = items_per_page * (current_page - 1)
      end

      def current_page=(page)
        number = page.to_i
        unless number.to_s == page.to_s && number.between?(1, page_count)
          raise PageNotFound, "Unknown page #{page}, expected 1..#{page_count}"
        end
        @current_page = number
      end

      def paginated?
        page_count > 1
      end

      def page_count
        # Integer arithmetic is simpler and faster.
        @page_count ||= item_count > 0 ? (item_count - 1) / items_per_page + 1 : 1
      end

      def item_count
        @item_count ||= except(:includes, :limit, :offset).count
      end

      def first_page?
        current_page == 1
      end

      def last_page?
        current_page == page_count
      end
    end
  end
end
