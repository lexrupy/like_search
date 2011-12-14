# Current db connection through config
# ActiveRecord::Base.connection_config[:adapter] => "mysql2"

module LikeSearch
  DB = {
    :postgres => "{field} ilike ?",
    :sqlite => 'LOWER({field}) like LOWER(?)'
  }
  DB.default = "{field} like ?"



  extend ActiveSupport::Concern

  module ClassMethods
    def has_like_search(attribute)
      class_attribute :like_search_attribute
      self.like_search_attribute = attribute

      extend LikeSearch::SearchMethods
    end
  end

  module SearchMethods
    def search(query)
      if query.present?
        where(format_search_sql, "%#{query}%")
      else
        scoped # TODO: test if only self works here
      end
    end

    def token_search(query, token_size=2)
      query.to_s.split.inject(scoped) do |current_scope, term|
        term.size > token_size ? current_scope.search(term) : current_scope
      end
    end

    private

    def format_search_sql
      if LikeSearch::DB[current_db_adapter].nil?
        query_string = DB.default
      else
        query_string = LikeSearch::DB[current_db_adapter]
      end
      query_string.gsub(/\{field\}/, like_search_attribute.to_s)
    end

    def current_db_adapter
      ActiveRecord::Base.connection_config[:adapter].to_sym
    end
  end
end

ActiveRecord::Base.send :include, LikeSearch