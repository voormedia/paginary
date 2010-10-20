module Paginary
  class Railtie < Rails::Railtie
    initializer "paginary.query_methods" do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Relation.send :include, Paginary::Relation::QueryMethods
        ActiveRecord::Base.singleton_class.delegate :paginate, :paginated?, :to => :scoped
      end
    end
    
    initializer "paginary.pagination_helper" do
      ActiveSupport.on_load(:action_view) do
        ActionView::Base.send :include, Paginary::Helpers::PaginationHelper
      end
    end
  end
end
