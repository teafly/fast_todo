require 'readline'
require_relative 'base'
require_relative 'template'
require_relative 'viewsupport'

module FastTodo::View

  class View
    include FastTodo::ViewSupport

    attr_accessor :template

    def initialize

      @template = Template.new
    end

    def show

      return if @template.nil? || !@template.is_a?(Template)

      merge_template if self.class.method_defined? :merge_template
      puts @template.render
    end
  end

  class ErrorView <View

    attr_accessor :err_msg

    def merge_template

      @template.append style(@err_msg, color: :red)
      @template.append color(thick_hr, :cyan)
    end
  end


  class DefaultView < View

    attr_accessor :title_info, :nav_info, :stat_info

    def initialize

      super()
      @title_info = "FTD - Fast Todo ( Power by orgteafly@gmail.com)" if @title_info.nil?
      @stat_info = "Use [help] command to see detail document, Pre Input: [ctrl+p], Next Input: [ctrl+n]" if @stat_info.nil?
      @nav_info = "FTD" if @nav_info.nil?
    end

    protected

    def merge_template

      @template.append style(@title_info, text_align: :center, color: :white) unless @title_info.nil?
      @template.append color(thin_hr, :cyan)
      @template.append style(@nav_info, underline: true, color: :cyan) unless @nav_info.nil?
      @template.append color(thick_hr, :cyan)

      merge_content if self.class.method_defined?(:merge_content)

      @template.append color(stat_info, :white) unless @stat_info.nil?
      @template.append color(thick_hr, :cyan)
    end

  end

  class ListView < DefaultView

    attr_accessor :projs

    def initialize(projs)

      super()
      @projs = projs
    end

    protected

    def merge_content

      @projs.each_with_index do |proj, index|

        @template.append color("Project[#{proj.index}]:".rjust(12, ' ') + " #{proj.name}", :blue)

        proj.records.each do |record|

          col = record.done? ? :gray : :green
          @template.append color("[#{record.index}]:".rjust(12, ' ') + " #{record.content}", col)
        end
        @template.append(color(index == (@projs.length - 1) ? thick_hr : thin_hr, :cyan))
      end
    end
  end

  class HelpView < DefaultView

    protected

    def merge_content

      rf = File.open('help.txt','r')
      rf.each_line do |line|

        @template.append style(line.chomp!, color: :green)
      end
      @template.append color(thick_hr, :cyan)
    end
  end
end

include FastTodo::View