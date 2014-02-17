require_relative "base"
require_relative "model"
require_relative "page"
require_relative "action"

module FastTodo::Controller

  def execute_cmd(cmd_line)

    case cmd_line.strip
    when 'home', 'list'

      request_homepage
    when /^list\stodo/

      request_page ListPage.new(:todo)
    when /^list\sdone/

      request_page ListPage.new(:done)
    when /^add\s"(.*)"$/

      action :ADD_PROJ, :name => $1
    when /^add\s"(.*)"\sto\s(.*)$/

      action :ADD_RECORD, :content => $1, :p_index => $2
    when /^update\s"(.*)"\son\s(\d+)$/

      action :UPDATE_PROJ, :name => $1, :index => $2
    when /^update\s"(.*)"\son\s(\d+)-(\d+)$/

      action :UPDATE_RECORD, :content => $1, :p_index => $2, :index => $3
    when /^del\s(\d+)$/

      action :DEL_PROJ, :index => $1
    when /^del\s(\d+)-(\d+)$/

      action :DEL_RECORD, :p_index => $1, :index => $2
    when /^done\s(.+)$/

      action :DONE, :list => $1
    when /^todo\s(.+)$/

      action :TODO, :list => $1
    when 'help'

      request_page HelpPage.new
    when 'exit', 'quit'
      exit 0
    else
      refresh :invalid_cmd
    end
  end

  def request_homepage(err_code = nil)

    page = ListPage.new(:all)
    request_page page, err_code
  end

  private

  def request_page(page, err_code = nil)

    page.err_code = err_code
    page.display
    $cur_page = page
  end

  def action(sym, args = {})

    ac = Action.new
    ac.execute sym, args
    refresh if args[:need_refresh].nil? || args[:need_refresh]
    return ac
  end

  def refresh(err_code = nil)

    if $cur_page.nil?
      request_homepage
    else
      request_page($cur_page, err_code)
    end
  end
end

include FastTodo::Controller