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

      def self.convert config, content
        config = config['slim'] || {}
        config.keys.each do |k|
          config[k.to_sym] = config.delete k
        end

        ::Slim::Template.new(config){ content }.render
      end
    end
  end
end
