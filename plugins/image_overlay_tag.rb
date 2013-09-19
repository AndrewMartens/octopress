# Title: Image tag with caption for Jekyll
# Description: Easily output images with captions

module Jekyll

  class OverlayImageTag < Liquid::Tag
    @img = nil
    @overlaystyle = nil

    def initialize(tag_name, markup, tokens)
      attributes = ['class', 'src', 'width', 'height', 'title']

      if markup =~ /(?<class>\S.*\s+)?(?<src>(?:https?:\/\/|\/|\S+\/)\S+)(?:\s+(?<width>\d+))?(?:\s+(?<height>\d+))?(?<title>\s+.+)?/i
        @img = attributes.reduce({}) { |img, attr| img[attr] = $~[attr].strip if $~[attr]; img }
        if /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ @img['title']
          @img['title']  = title
          @img['alt']    = alt
        else
          @img['alt']    = @img['title'].gsub!(/"/, '&#34;') if @img['title']
        end
        @img['class'].gsub!(/"/, '') if @img['class']
        if @img['class'] =~ /left/
          @overlaystyle = 'width:' + @img['width'] + 'px;margin-right: auto;'
        elsif @img['class'] =~ /center/
          @overlaystyle = 'width:' + @img['width'] + 'px;margin-left: auto;margin-right: auto;'
        elsif @img['class'] =~ /right/
          @overlaystyle = 'width:' + @img['width'] + 'px;margin-left: auto;'
        end
        # reset image class because I screwed something up
        @img['class'] = 'center'
      end
      super
    end

    def render(context)
      if @img
        "<div class='overlay-wrapper' style='#{@overlaystyle}'>" +
        "<img #{@img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")}>" +
        "<div class='overlay-description'>" +
        "<p class='overlay-description-content'>#{@img['title']}</p>" +
        "</div>" +
        "</div>" +
        "<div style='clear:both;'></div>"
      else
        "Error processing input, expected syntax: {% imgover [class name(s)] [http[s]:/]/path/to/image [width [height]] [title text | \"title text\" [\"alt text\"]] %}"
      end
    end
  end
end

Liquid::Template.register_tag('imgover', Jekyll::OverlayImageTag)

