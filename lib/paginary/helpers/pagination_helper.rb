module Paginary
  module Helpers
    module PaginationHelper
      def paginate(relation, *args, &block)
        capture(PageBuilder.new(self, relation, *args), &block)
      end
    end
  end
end
