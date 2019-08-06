module Jekyll
  module Slim
    class Converter < ::Jekyll::Converter
      safe true
      priority :low

      def matches(ext)
        ext =~ /slim/i
      end

      def output_ext(ext)
        '.html'
      end

      def convert(content)
        self.class.convert(@config, content)
      end

      def self.convert(full_config, content, context = {})
        config = ::Jekyll::Utils.symbolize_hash_keys(full_config['slim'] || {})
        ::Slim::Template.new(config){ content }.render(DataProvider.new(context: context, config: full_config))
      end
    end
  end
end
