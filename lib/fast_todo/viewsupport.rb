 require_relative 'base'

 module FastTodo::ViewSupport

  def draw_hr(config = {})

    config[:line_chr] = '-' if config[:line_chr].nil?
    config[:len] = FastTodo::DEFAULT_LINE_LENGTH if config[:len].nil?

    config[:line_chr] * config[:len]
  end

  def underline(info)

    style(info, underline: true)
  end

  def center(info)

    style(info, text_align: :center)
  end

  def thick_hr

    draw_hr(line_chr: '=')
  end

  def thin_hr

    draw_hr(line_chr: '-')
  end

  def color(info, type)

    style(info, color: type)
  end

  def style(str, type = {})

    code = ''
    
    underline_mod = type[:underline]
    code += get_code(:underline) + ";" if underline_mod

    col = type[:color]
    col_code = get_code(col)
    code += col_code + ";" unless col_code.nil?

    str = "\e[#{code}m#{str}\e[0m" unless code.empty?

    align = type[:text_align]
    size = type[:text_size].nil? ? FastTodo::DEFAULT_LINE_LENGTH : type[:text_size]
    case align
    when :center
      str = str.center(size, ' ')
    end

    return str
  end

  private
  def get_code(type)

    case type
    when :black
      code = '30'
    when :red
      code = '31'
    when :green
      code = '32'
    when :yellow
      code = '33'
    when :blue
      code = '34'
    when :purple
      code = '35'
    when :cyan
      code = '36'
    when :white
      code = '37'
    when :underline
      code = '4'
    else
      code = nil
    end

    return code
  end
end
