module CMIS
  module Utils
    module_function

    def build_query_statement(type_id, properties, *queried_properties)
      QueryStatementBuilder.new(type_id, properties, queried_properties).build
    end

    class QueryStatementBuilder
      def initialize(type_id, properties, queried_properties)
        @type_id = type_id
        @properties = properties
        @queried_properties = Array(queried_properties).join(', ')
        @queried_properties = '*' if @queried_properties.empty?
      end

      def build
        statement = "select #{@queried_properties} from #{@type_id}"
        clause = @properties.map { |k, v| build_predicate(k, v) }.join(' and ')
        statement << " where #{clause}" unless clause.empty?
        statement
      end

      private

      def build_predicate(k, v)
        if v.nil?
          "#{k} is null"
        else
          [k, normalize(v)].join('=')
        end
      end

      def normalize(value)
        if value.respond_to?(:strftime) # datetime literal
          value = value.strftime('%Y-%m-%dT%H:%M:%S.%L')
          "TIMESTAMP '#{value}'"

        elsif value.is_a?(Numeric) # signed numeric literal
          value

        elsif value.is_a?(TrueClass) || value.is_a?(FalseClass) # boolean literal
          value

        else # treat as a character string literal
          value = value.to_s
          value.gsub!(/\\/, Regexp.escape('\\\\'))
          value.gsub!(/'/, Regexp.escape('\\\''))
          "'#{value}'"
        end
      end
    end
  end
end
