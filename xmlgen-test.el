;;; xmlgen-test.el --- unit tests for xmlgen -*- lexical-binding: t; -*-

;; Copyright (C) 2017  Google Inc.

;; Author: Google Inc.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 2 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Unit tests for xmlgen.el.

;;; Code:

(require 'xmlgen)

(ert-deftest xmlgen-extract-plist ()
  (should (equal (xmlgen-extract-plist '(h1 :class "big" "A Title"))
                 '((h1 "A Title") (:class "big"))))
  (should (equal (xmlgen-extract-plist '(hello :big "world"))
                 '((hello) (:big "world"))))
  (should (equal (xmlgen-extract-plist '(big :one 1 :two 2 :three 3))
                 '((big) (:one 1 :two 2 :three 3))))
  (should-error (xmlgen-extract-plist '(hello "world" :how))))

(ert-deftest xmlgen-attr-to-string ()
  (should (equal (xmlgen-attr-to-string '(:one "1" :two "2")) " one=\"1\" two=\"2\"")))

(ert-deftest xmlgen-string-escape ()
  (should (equal "This &amp; this" (xmlgen-string-escape "This & this")))
  (should (equal "This &lt;&amp;&gt; this" (xmlgen-string-escape "This <&> this"))))

(ert-deftest xmlgen ()
  (should (equal (xmlgen '(p "this & this")) "<p>this &amp; this</p>"))
  (should (equal (xmlgen '(p :class "big")) "<p class=\"big\"/>"))
  (should (equal (xmlgen '(p :class "big" "hi")) "<p class=\"big\">hi</p>"))
  (should (equal (xmlgen '(h1)) "<h1/>"))
  (should (equal (xmlgen '(h1 "Title")) "<h1>Title</h1>"))
  (should (equal (xmlgen '(h1 :class "something" "hi"))
                 (should "<h1 class=\"something\">hi</h1>")))
  (should (equal (xmlgen '(div (p "Escaped: &") (!unescape (p "Unescaped: &") (!escape
                                                                               (p "& escaped")))))
                 "<div><p>Escaped: &amp;</p><p>Unescaped: &</p><p>&amp; escaped</p></div>"))
  (should (equal (xmlgen '(p "hello" "again")) "<p>helloagain</p>")))

(ert-deftest xmlgen--more-complex ()
  (should (equal (xmlgen
                  '(html
                    (head
                     (title "hello")
                     (meta :something "hi"))))
                 (concat "<html><head><title>hello</title><meta something=\"hi\"/></head></html>"))))

;;; xmlgen-test.el ends here
