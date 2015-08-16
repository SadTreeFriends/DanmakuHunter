class DanmakuHunter

  require 'nokogiri'

  f = File.open('danmaku.xml')
  @doc = Nokogiri::XML(f).slop! do |option|
    option.strict.nonet
  end
  f.close

  @danmaku_storage = Array.new

  class Danmaku
    attr_accessor :font,:time,:color,:type, :content
    def initialize(font,time,color,type,content)
      @font = font_formatter font
      @time = time_formatter time
      @color = color_formatter color
      @type = type_formatter type
      @content = content
    end

    def time_formatter time
      hour, residue = time.to_f.divmod(3600)
      minute, second = residue.divmod(60)
      readable_time = ["%02d" % hour, "%02d" % minute, "%2.2f" % second].join(':')
    end

    def font_formatter font
      font.to_i > 19 ? "BIG": "SMALL"
    end

    def color_formatter(color)
      "%06X" % color
    end

    def type_formatter(type)
      case type
        when "1"
          "R -> L Danmaku"
        when "4"
          "StationaryBottomDanmaku"
        when "5"
          "StationaryTopDanmaku"
        else
          "ExceptionalDanmaku"
      end
    end
  end

  @doc.i.d.each do |line|
    attr = line["p"].split(",")
    @danmaku_storage << Danmaku.new(attr[2],attr[0],attr[3],attr[1],line.content)
  end

  @danmaku_storage.each do |element|
    p element
  end


end