module GrapeLogging
  module Loggers
    class FilterParameters < GrapeLogging::Loggers::Base
      def initialize(filter_parameters = nil, replacement = '[FILTERED]')
        @filter_parameters = filter_parameters || (defined?(Rails.application) ? Rails.application.config.filter_parameters : [])
        @replacement = replacement
      end

      def parameters(request, _)
        { params: replace_parameters(request.params.clone) }
      end

      private
      def replace_parameters(parameters)
        parameters.each do |key, value|
          if @filter_parameters.collect(&:to_s).include?(key.to_s)
            parameters[key] = @replacement
          elsif value.respond_to?(:keys)
            parameters[key] = replace_parameters(value)
          end
        end

        parameters
      end
    end
  end
end
