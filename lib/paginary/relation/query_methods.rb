module Paginary
  module Relation
    module QueryMethods
      # Returns a paginated relation. The returned relation has the Paginated
      # module mixed in, which allows easy access to common properties.
      def paginate(*args)
        clone.extending(Paginated).tap do |relation|
          relation.paginate!(*args)
        end
      end

      # Returns if the relation is paginated. A relation is paginated if it
      # represents a subset of the total number of rows that would otherwise
      # be returned.
      def paginated?
        false
      end
    end
  end
end
