module Paginary
  module Helpers
    module PaginationHelper
      def paginate(relation, options = {}, &block)
        builder = options.delete(:builder) || PageBuilder
        capture(builder.new(self, relation, options), &block)
      end
    end
  end
end
