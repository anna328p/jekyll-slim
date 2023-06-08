require 'delegate'

module Jekyll
  module Slim
    class DataProvider

      class PseudoLiquidWrapper < ::SimpleDelegator
        def method_missing(method, *args, &block)
          return super if args.any? || block_given?

          object = __getobj__
          liquid = object.to_liquid

          acts_like_hash = liquid.respond_to?(:[]) && liquid.respond_to?(:key?)

          result = self.class.get_by_key(liquid, method) if acts_like_hash
          result ||= super

          return result.map { PseudoLiquidWrapper.new(_1) } if result.is_a?(Array)

          acts_like_array = result.respond_to?(:[]) && !result.is_a?(String)
          return PseudoLiquidWrapper.new(result) if acts_like_array

          result
        end

        def self.get_by_key(obj, key)
          return obj[key.to_s] if obj.key?(key.to_s)
          return obj[key] if obj.key?(key)

          nil
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
