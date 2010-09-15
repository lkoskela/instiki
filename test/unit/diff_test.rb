#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'diff'

class DiffTest < Test::Unit::TestCase

  include Diff

  def test_html_diff_simple
    a = 'this was the original string'
    b = 'this is the new string'
    assert_equal("<span> this<del class='diffmod'> was</del><ins class='diffmod'> is</ins> the" +
           "<del class='diffmod'> original</del><ins class='diffmod'> new</ins> string</span>",
          diff(a, b))
  end

  def test_html_diff_with_multiple_paragraphs
    a = "<p>this was the original string</p>"
    b = "<p>this is</p>\n<p> the new string</p>\n<p>around the world</p>"
    assert_equal(
        "<p><span> this<del class='diffmod'> was</del><ins class='diffmod'> is</ins>" +
        "<del class='diffdel'> the</del><del class='diffdel'> original</del><del class='diffdel'> string</del></span></p>" +
        "<ins class='diffins'>\n</ins><ins class='diffins'><p> the new string</p></ins>" +
        "<ins class='diffins'>\n</ins><ins class='diffins'><p>around the world</p></ins>",
        diff(a, b))
  end

  def test_html_diff_deleting_a_paragraph
    a = "<p>this is a paragraph</p>\n<p>this is a second paragraph</p>\n<p>this is a third paragraph</p>"
    b = "<p>this is a paragraph</p>\n<p>this is a third paragraph</p>"
    assert_equal(
         "<p>this is a paragraph</p>\n<del class='diffdel'><p>this is a second paragraph</p></del>" +
         "<del class='diffdel'>\n</del><p>this is a third paragraph</p>",
        diff(a, b))
  end

  def test_split_paragraph_into_two
     a = "<p>foo bar</p>"
     b = "<p>foo</p><p>bar</p>"
     assert_equal(
       "<p><span> foo<del class='diffdel'> bar</del></span></p>" +
       "<ins class='diffins'><p>bar</p></ins>",
      diff(a,b))
  end

  def test_join_two_paragraphs_into_one
     a = "<p>foo</p><p>bar</p>"
     b = "<p>foo bar</p>"
     assert_equal(
       "<p><span> foo<ins class='diffins'> bar</ins></span></p>" +
       "<del class='diffdel'><p>bar</p></del>",
      diff(a,b))
  end

  def test_add_inline_element
     a = "<p>foo bar</p>"
     b = "<p>foo <b>bar</b></p>"
     assert_equal(
        "<p><span> foo<del class='diffdel'> bar</del></span>" +
        "<ins class='diffins'><b>bar</b></ins></p>",
       diff(a,b))
  end

  def test_html_diff_with_tags
    a = ""
    b = "<div>foo</div>"
    assert_equal "<ins class='diffins'><div>foo</div></ins>", diff(a, b)
  end
  
  def test_diff_for_tag_change
    a = "<a>x</a>"
    b = "<b>x</b>"
    assert_equal "<del class='diffmod'><a>x</a></del><ins class='diffmod'><b>x</b></ins>", diff(a, b)
  end

  def test_diff_for_tag_change_II
    a = "<ul>\n<li>x</li>\n<li>y</li>\n</ul>"
    b = "<ol>\n<li>x</li>\n<li>y</li>\n</ol>"
    assert_equal "<del class='diffmod'><ul>\n<li>x</li>\n<li>y</li>\n</ul>" +
          "</del><ins class='diffmod'><ol>\n<li>x</li>\n<li>y</li>\n</ol></ins>", diff(a, b)
  end

  # FIXME this test fails (ticket #67, http://dev.instiki.org/ticket/67)
  def test_html_diff_preserves_endlines_in_pre
    a = "<pre>a\nb\nc\n</pre>"
    b = "<pre>a\n</pre>"
    assert_equal(
        "<pre><span> a\n<del class='diffdel'>b\nc\n</del></span></pre>",
        diff(a, b))
  end

end
