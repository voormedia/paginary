module Paginary
  module Helpers
    module PaginationHelper
      # Paginates the given relation. The current page is retrieved from the
      # query string parameter +page+, by default. An instance of
      # PageBuilder is yielded to the given block, which can be used to
      # retrieve all items on the page or display navigation links.
      def paginate(relation, options = {})
        builder = options.delete(:builder) || PageBuilder
        capture(builder.new(self, relation, options), &Proc.new)
      end
    end
  end
end
