require 'helper'

module CSSPool
  module Visitors
    class TestToCSS < CSSPool::TestCase
      def test_font_serialization
        doc = CSSPool.CSS 'p { font: 14px/30px Tahoma; }'

        assert_equal 3, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 3, doc.rule_sets.first.declarations[0].expressions.length

        assert_equal 'font: 14.0px / 30.0px Tahoma;',
          doc.rule_sets.first.declarations.first.to_css.strip
      end
      
      def test_descendant_selector_serialization
        doc = CSSPool.CSS 'p a { font: 14px/30px Tahoma; }'
        assert_equal 'p a', doc.rule_sets.first.selectors.first.to_css
      end
      
      def test_descendant_selector_with_id_serialization
        doc = CSSPool.CSS 'p#a a#b { font: 14px/30px Tahoma; }'
        assert_equal 'p#a a#b', doc.rule_sets.first.selectors.first.to_css
      end
      
      def test_descendent_universal_id_selector_serialization
        doc = CSSPool.CSS '#a #b { font: 14px/30px Tahoma; }'
        assert_equal '#a #b', doc.rule_sets.first.selectors.first.to_css
      end
      
      def test_descendant_selector_with_class_serialization
        doc = CSSPool.CSS 'p.a a.b { font: 14px/30px Tahoma; }'
        assert_equal 'p.a a.b', doc.rule_sets.first.selectors.first.to_css
      end
      
      def test_descendent_universal_class_selector_serialization
        doc = CSSPool.CSS '.a .b { font: 14px/30px Tahoma; }'
        assert_equal '.a .b', doc.rule_sets.first.selectors.first.to_css
      end
      
      def test_descendant_child_selector_serialization
        doc = CSSPool.CSS 'p > a { font: 14px/30px Tahoma; }'
        assert_equal 'p > a', doc.rule_sets.first.selectors.first.to_css
      end
      
      def test_descendant_child_selector_with_id_serialization
        doc = CSSPool.CSS 'p#a > a#b { font: 14px/30px Tahoma; }'
        assert_equal 'p#a > a#b', doc.rule_sets.first.selectors.first.to_css
      end
      
      def test_descendant_child_selector_universal_id_serialization
        doc = CSSPool.CSS '#a > #b { font: 14px/30px Tahoma; }'
        assert_equal '#a > #b', doc.rule_sets.first.selectors.first.to_css
      end

      def test_descendant_child_selector_universal_class_serialization
        doc = CSSPool.CSS '.a > .b { font: 14px/30px Tahoma; }'
        assert_equal '.a > .b', doc.rule_sets.first.selectors.first.to_css
      end     
      

      # FIXME: this is a bug in libcroco
      #def test_ident_followed_by_id
      #  doc = CSSPool.CSS 'p#div { font: foo, #666; }'
      #  assert_equal 'p#div', doc.rule_sets.first.selectors.first.to_css

      #  p doc.rule_sets.first.selectors

      #  doc = CSSPool.CSS 'p #div { font: foo, #666; }'

      #  p doc.rule_sets.first.selectors
      #  assert_equal 'p #div', doc.rule_sets.first.selectors.first.to_css
      #end

      def test_hash_operator
        doc = CSSPool.CSS 'p { font: foo, #666; }'
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_uri_operator
        doc = CSSPool.CSS 'p { font: foo, url(http://example.com/); }'
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_string_operator
        doc = CSSPool.CSS 'p { font: foo, "foo"; }'
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_function_operator
        doc = CSSPool.CSS 'p { font: foo, foo(1); }'
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_rgb_operator
        doc = CSSPool.CSS 'p { font: foo, rgb(1,2,3); }'
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_includes
        doc = CSSPool.CSS <<-eocss
          div[bar ~= 'adsf'] { background: red, blue; }
        eocss

        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_dashmatch
        doc = CSSPool.CSS <<-eocss
          div[bar |= 'adsf'] { background: red, blue; }
        eocss

        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length
      end

      def test_media
        doc = CSSPool.CSS <<-eocss
          @media print {
            div { background: red, blue; }
          }
        eocss
        assert_equal 1, doc.rule_sets.first.media.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 1, doc.rule_sets.first.media.length
      end

      def test_multiple_media
        doc = CSSPool.CSS <<-eocss
          @media print, screen {
            div { background: red, blue; }
          }

          @media all {
            div { background: red, blue; }
          }
        eocss
        assert_equal 2, doc.rule_sets.first.media.length
        assert_equal 1, doc.rule_sets[1].media.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.media.length
        assert_equal 1, doc.rule_sets[1].media.length
      end

      def test_import
        doc = CSSPool.CSS <<-eocss
          @import "test.css";
          @import url("test.css");
          @import url("test.css") print, screen;
        eocss

        assert_equal 3, doc.import_rules.length
        assert_equal 2, doc.import_rules.last.media.length

        doc = CSSPool.CSS(doc.to_css)

        assert_equal 3, doc.import_rules.length
        assert_equal 2, doc.import_rules.last.media.length
      end

      def test_charsets
        doc = CSSPool.CSS <<-eocss
          @charset "UTF-8";
        eocss

        assert_equal 1, doc.charsets.length

        doc = CSSPool.CSS(doc.to_css)

        assert_equal 1, doc.charsets.length
      end
    end
  end
end
