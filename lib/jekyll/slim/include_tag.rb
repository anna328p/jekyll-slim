module Jekyll
  module Slim
    class IncludeTag < Jekyll::Tags::IncludeTag
      def read_file(file, context)
        content = super
        if file =~ /\.slim\Z/i
          Converter.convert(context.registers[:site].config, content, include: parse_params(context))
        else
          content
        end
      end
    end
  end
end

Liquid::Template.register_tag('slim', Jekyll::Slim::IncludeTag)
Liquid::Template.register_tag('include', Jekyll::Slim::IncludeTag)
