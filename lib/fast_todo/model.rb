require "oj"
require "fileutils"
require_relative "base"

module FastTodo::Model

  INDEX_SYM = "-"

  def self.init(path)

    unless File.exist? path

      dirname = File.dirname path
      FileUtils.mkpath(dirname) unless File.directory?(dirname)
      FileUtils.touch path
    end
    $td = Todo.load_from_file(path)
  end

  def todos
    $td
  end

  class Todo

    attr_accessor :projs, :local_path, :mode

     def initialize(args={})

      args.each do |k,v|
        self.instance_variable_set(k, v)
      end

      @projs = [] if args[:@projs].nil?
      @mode = :view if args[:@mode].nil?
    end

    def self.load_from_file(path)

      td = Todo.new(:@mode => :local)
      td.local_path = path
      datas = Oj.load_file(td.local_path)
      td.projs = datas.nil? ? [] : datas
      td.refresh_index
      return td
    end

    def refresh_index

      @projs.each_with_index do |proj, i|

        proj.index = i.to_s
        proj.records.each_with_index do |record, j|

          record.index = i.to_s + INDEX_SYM + j.to_s
        end
      end
    end

    def save_to_file

      refresh_index
      Oj.to_file(@local_path, projs)
    end

    def todo(list_str)

      list_str.split(",").each do |list|

        arr = list.split(INDEX_SYM)

        if arr.size == 1

          @projs[arr[0].to_i].todo
        elsif arr.size == 2
          
          @projs[arr[0].to_i].records[arr[1].to_i].todo
        end
      end
    end

    def done(list_str)

      list_str.split(",").each do |list|

        arr = list.split(INDEX_SYM)

        if arr.size == 1

          @projs[arr[0].to_i].done
        elsif arr.size == 2
          
          @projs[arr[0].to_i].records[arr[1].to_i].done
        end
      end
    end

    def add_proj(name)

      _proj = Project.new(:@name => name)
      @projs.push _proj
      refresh_index
      return _proj
    end

    def update_proj(index, name)

      @projs[index.to_i].name = name
    end

    def update(p_index, index, content)

      @projs[p_index.to_i].records[index.to_i].content = content
    end

    def add(p_index, content)

      _record = Record.new(:@content => content)
      @projs[p_index.to_i].records.push _record
      refresh_index
      return _record
    end

    def del_proj(index)

      @projs.delete_at index.to_i
      refresh_index
    end

    def del(p_index, index)

      @projs[p_index.to_i].records.delete_at index.to_i
      refresh_index
    end

    def list_todo

      _todo = Todo.new(:@mode => :view)
      todos.projs.each do |proj|

        next if proj.done?

        _proj = proj.gen_vo
        _todo.projs.push _proj
        proj.records.each do |record|

          next if record.done?
          _record = record.gen_vo
          _proj.records.push _record
        end
      end
      return _todo
    end

    def list_done

      _todo = Todo.new(:@mode => :view)
      todos.projs.each do |proj|

        next if proj.all_todo?

        _proj = proj.gen_vo
        _todo.projs.push _proj
        proj.records.each do |record|

          next if record.todo?
          _record = record.gen_vo
          _proj.records.push _record
        end
      end
      return _todo
    end
  end

  class Project

    attr_accessor :index, :name, :records

    def initialize(args={})

      args.each do |k,v|
        self.instance_variable_set(k, v)
      end

      @records = [] if @records.nil?
    end


    def done?

      @records.each {|val| return false unless val.done? }
      return true
    end

    def all_todo?

      @records.each {|val| return false unless val.todo? }
      return true
    end

    def gen_vo

      Project.new(:@name => @name, :@index => @index, :@records => [])
    end
  end

  class Record

    attr_accessor :index, :content, :stat

    def initialize(args={})

      args.each do |k,v|
        self.instance_variable_set(k, v)
      end
      @stat = :todo if @stat.nil?
    end

    def gen_vo

      Record.new(:@content => @content, :@index => @index, :@stat => @stat)
    end

    def todo

      @stat = :todo
    end

    def todo?

      @stat == :todo
    end

    def done

      @stat = :done
    end

    def done?

      @stat == :done
    end
  end
end

include FastTodo::Model