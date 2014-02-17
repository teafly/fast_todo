require_relative 'base'
require_relative 'controller'

module FastTodo::Console

  def run

    FastTodo::Model.init("/tmp/test.ftd")

    request_homepage
    while(cmd = show_cmd)
      execute_cmd(cmd)
    end

  end
  
  def show_cmd

    Readline.readline("> ", true)
  end
end

include FastTodo::Console

run