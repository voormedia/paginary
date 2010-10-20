require "active_support/core_ext/array/extract_options"

module Paginary
  module Relation
    module Paginated
      attr_accessor :items_per_page, :current_page
    
      def paginate!(*args)
        options = args.extract_options!
        self.items_per_page = options[:per_page] || 50
        self.current_page   = args.first ? args.first.to_i : 1
        self.limit_value    = items_per_page
        self.offset_value   = items_per_page * (current_page - 1)
      end
      
      def current_page=(page)
        raise ActiveRecord::RecordNotFound, "page #{page} out of bounds, expected 1..#{page_count}" unless page.between?(1, page_count)
        @current_page = page
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
