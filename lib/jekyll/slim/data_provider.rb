require 'delegate'

module Jekyll
  module Slim
    class DataProvider

      class PseudoLiquidWrapper < ::SimpleDelegator
        def method_missing(method, *args, &block)
          return super if !args.empty? || block_given?
          object = __getobj__
          liquid = object.to_liquid
          result =
            if liquid.respond_to?(:[]) && liquid.respond_to?(:key?) &&
                (liquid.key?(method.to_s) || liquid.key?(method))
              liquid[method.to_s] || liquid[method]
            else
              super
            end
          if result.respond_to?(:[]) && !result.is_a?(String)
            result =
              if result.is_a?(Array)
                result.map { |item| PseudoLiquidWrapper.new(item) }
              else
                PseudoLiquidWrapper.new(result)
              end
          end
          result
        end
      end

      def initialize(context: nil, config: {})
        @context = context && PseudoLiquidWrapper.new(context)
        @config = config
        @jekyll_site = Jekyll.sites.first
      end

      def site
        @site ||= PseudoLiquidWrapper.new(@jekyll_site.site_payload.site)
      end

      def capture(var, enumerable = nil, &block)
        value = enumerable ? enumerable.map(&block) : yield
        block.binding.eval("lambda {|x| #{var} = x }").call(value)
        nil
      end

      def include_template(name, vars = {})
        Converter.convert(@config, File.read(name), include: vars)
      end

      def render_liquid(liquid_string, vars = {})
        Liquid::Template.parse("{{ #{liquid_string} }}").render(
          Jekyll::Utils.stringify_hash_keys(vars),
          registers: { site: @jekyll_site }
        )
      end

      def method_missing(method, *args, &block)
        @context.send(method, *args, &block)
      end

    end
  end
end
