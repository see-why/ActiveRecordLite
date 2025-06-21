
module ActiveRecordLite
  class Base
    def self.inherited(subclass)
      subclass.initialize_relation_delegate_cache
    end

    def self.iniherited_relation_delegate_cache
      @relation_delegaate_cache = {}
      Delegation::DELEGATED_CLASSES.each do |klass|
        delegate =
          Class.new(klass) do
            include ClassSpecificRelation
          end

        mangled_name = Klass.name.gsub("::", "_")
        const_set mangled_name, delegate

        private_constant mangled_name

        @relation_delegate_cache[Klass] = delegate

        current_scope.scope = relation_delegate_cache[Relation].new(self)
      end
    end

    def self.relation_delegate_cache = @relation_delegate_cache

    def self.where(conditions) = current_scope.scope.where(conditions)

    def self.order(ordering) = current_scope.scope.order(ordering)

    def self.count
      sql = current_scope.to_sql
      query = "SELECT COUNT(*) FROM #{table_name} #{sql}"

      puts "Executing SQL: #{query}"

      flush_current_scope
      DatabaseConnection.instance.execute(query).first["COUNT(*)"]
    end

    def self.to_a
      sql = current_scope.scope.to_sql
      query = "SELECT * FROM #{table_name} #{sql}"

      puts "Executing SQL: #{query}"

      flush_current_scope
      DatabaseConnection.instance.execute(query)
    end

    def self.table_name
      name.downcase + "s"
    end

    def self.current_scope
      @current_scope ||= CurrentScope.new
    end

    def self.flush_current_scope
      current_scope.scope = relation_delegate_cache[Relation].new(self)
    end
  end
end
