module Paginary
  module Relation # @private :nodoc:
    module QueryMethods
      def paginate(*args)
        clone.extending(Paginated).tap do |relation|
          relation.paginate!(*args)
        end
      end

      def paginated?
        false
      end
    end
  end
end
