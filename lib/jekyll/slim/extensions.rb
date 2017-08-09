module Jekyll
  class Layout
    alias old_initialize initialize

    def initialize(*args)
      old_initialize(*args)
      self.content = transform
    end

    def transform
      _renderer.convert(content)
    end

    def extname
      ext
    end
  end
end

