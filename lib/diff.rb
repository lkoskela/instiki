require 'xhtmldiff'

module Diff
  def diff(a, b)
    previous_content = "<div>" + a + "</div>"
    current_content = "<div>" + b  + "</div>"

    diff_doc = REXML::Document.new
    div = REXML::Element.new('div', nil, {:respect_whitespace =>:all})
    div.attributes['class'] = 'xhtmldiff_wrapper'
    diff_doc << div
    hd = XHTMLDiff.new(div)

    parsed_previous_revision = REXML::HashableElementDelegator.new(
         REXML::XPath.first(REXML::Document.new(previous_content), '/div'))
    parsed_display_content = REXML::HashableElementDelegator.new(
         REXML::XPath.first(REXML::Document.new(current_content), '/div'))
    Diff::LCS.traverse_balanced(parsed_previous_revision, parsed_display_content, hd)

    diffs = ''
    diff_doc.write(diffs, -1, true, true)
    diffs.gsub(/\A<div class='xhtmldiff_wrapper'>(.*)<\/div>\Z/m, '\1').html_safe
  end
end