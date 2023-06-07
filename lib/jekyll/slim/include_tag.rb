module Jekyll
  module Slim
    class IncludeTag < Jekyll::Tags::IncludeTag
      def read_file(file, context)
        content = super
        return content unless file =~ /\.slim\Z/i

        config = context.registers[:site].config

        if @params
          Converter.convert(config, content, include: parse_params(context))
        else
          Converter.convert(config, content)
        end
      end
    end
  end
end

Liquid::Template.register_tag('slim', Jekyll::Slim::IncludeTag)
Liquid::Template.register_tag('include', Jekyll::Slim::IncludeTag)
