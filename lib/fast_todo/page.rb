require_relative 'base'
require_relative 'view'
require_relative 'model'

module FastTodo::Page

  class BasePage

    attr_accessor :err_code

    def clear

      print "\x1b\x5b\x48\x1b\x5b\x32\x4a"
    end

    def display

      clear
      view_page if self.class.method_defined?(:view_page)
      show_err
    end

    private 

    def show_err

      return if err_code.nil?

      case err_code
      when :invalid_cmd
        err_msg = "Invalid command, see 'help'."
      when :add_proj_err
        err_msg = "Add project occor error!"
      else
        err_msg = "System error, see 'help'."
      end

      errView = ErrorView.new
      errView.err_msg = err_msg
      errView.show
    end

  end

  class HelpPage < BasePage

    def view_page
      HelpView.new.show
    end
  end

  class ListPage < BasePage

    attr_accessor :projs, :mode 

    def initialize(mode = :all)

      @mode = mode
    end

    protected

    def view_page

      _nav_info = "HOME"
      case mode
      when :all
        _projs = todos.projs
      when :todo
        _projs = todos.list_todo.projs
      _nav_info = "TODO"
      when :done
        _projs = todos.list_done.projs
      _nav_info = "DONE"
      end

      view = ListView.new(_projs)
      view.nav_info = _nav_info
      view.show
    end


  end
end

include FastTodo::Page