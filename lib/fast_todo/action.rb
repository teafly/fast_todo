require_relative 'base'
require_relative 'model'

module FastTodo::Action

  class Action

    def execute(sym, args = {})

      eval(sym.to_s).call(args)
    end
  end

  ADD_PROJ = lambda do |args|

    todos.add_proj args[:name]
    todos.save_to_file
  end

  ADD_RECORD = lambda do |args|

    todos.add args[:p_index], args[:content]
    todos.save_to_file
  end

  DEL_PROJ = lambda do |args|

    todos.del_proj args[:index]
    todos.save_to_file
  end

  DEL_RECORD = lambda do |args|

    todos.del args[:p_index], args[:index]
    todos.save_to_file
  end

  UPDATE_PROJ = lambda do |args|

    todos.update_proj args[:index], args[:name]
    todos.save_to_file
  end

  UPDATE_RECORD = lambda do |args|

    todos.update args[:p_index], args[:index], args[:content]
    todos.save_to_file
  end

  TODO = lambda do |args|

    todos.todo args[:list]
    todos.save_to_file
  end

  DONE = lambda do |args|

    todos.done args[:list]
    todos.save_to_file
  end
end

include FastTodo::Action