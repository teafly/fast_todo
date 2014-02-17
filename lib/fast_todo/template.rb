require_relative 'base'
require 'stringio'

module FastTodo::Template

  class Template

    def initialize

      @sio = StringIO.new
    end

    def render

      before_render if self.class.method_defined? :before_render
      @sio.string
    end

    def append(info)

      @sio.puts info
    end

    def clean

      @sio.truncate 0
    end

    def merge(template)

      strs = template.render
      @sio.puts strs unless strs.empty?
    end
  end

end

include FastTodo::Template