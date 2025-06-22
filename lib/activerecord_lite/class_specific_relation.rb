module ActiveRecordLite
  module ClassSpecificRelation
    def method_missing(method, *args, &block)
      if @model.respond_to?(method)
        self.class.define_method(method) {
          |*args, &block| @model.public_send(method, *args, &block)
        }

        public_send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @model.respond_to?(method_name) || super
    end
  end
end
