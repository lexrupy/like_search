# Current db connection through config
# ActiveRecord::Base.connection_config[:adapter] => "mysql2"

module FuzzySearch
  DB = {
    :postgres => "{field} ilike ?",
    :sqlite => 'LOWER({field}) like LOWER(?)'
  }
  DB.default = "{field} like ?"

  extend ActiveSupport::Concern

  module ClassMethods
    def has_fuzzy_search(attribute)
      class_attribute :fuzzy_search_attribute
      self.fuzzy_search_attribute = attribute

      extend FuzzySearch::SearchMethods
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

    def fuzzy_search(query)
      query.to_s.split.inject(scoped) do |current_scope, term|
        term.size > 3 ? current_scope.search(term) : current_scope
      end
    end

    private

    def format_search_sql
      if FuzzySearch::DB[current_db_adapter].nil?
        query_string = DB.default
      else
        query_string = FuzzySearch::DB[current_db_adapter]
      end
      query_string.gsub(/\{field\}/, fuzzy_search_attribute.to_s)
    end

    def current_db_adapter
      ActiveRecord::Base.connection_config[:adapter].to_sym
    end
  end
end

ActiveRecord::Base.send :include, FuzzySearch