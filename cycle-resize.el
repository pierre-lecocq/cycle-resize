;;; cycle-resize.el --- cycle resize the current window horizontally or vertically

;; Copyright (C) 2015 Pierre Lecocq

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

;; Author: Pierre Lecocq
;; URL: http://qsdfgh.com/
;; Version: 0.5.0

;;; Commentary:

;; Load this package
;;
;; (require 'cycle-resize)
;;
;; You can then call these two methods, once you have at least 2 windows:
;;
;; M-x cycle-resize-window-vertically
;; M-x cycle-resize-window-horizontally
;;
;; and eventually bind some keys like:
;;
;; (global-set-key (kbd "C-M-v") 'cycle-resize-window-vertically)
;; (global-set-key (kbd "C-M-h") 'cycle-resize-window-horizontally)

;;; Change Log:
;;
;; 201502-04
;;    * First public release, beta version

;;; Code:

(defvar cr/resize-steps '(20 50 80 50)
  "The steps used to resize the current frame")

(defun first-element-at-the-end(alist)
  "Take the first element and place it at the end"
  (append (cdr alist) (list (car alist))))

(defun cr/calculate-window-size(percentage direction)
  "Calculate the window size according to the frame size"
  (if (string= direction "vertical")
      (* (frame-height) (/ percentage 100.0))
    (* (frame-width) (/ percentage 100.0))))

(defun cr/calculate-window-delta(new-size direction)
  "Calculate the window delta according to the window size"
  (if (string= direction "vertical")
      (truncate (- new-size (window-body-height)))
    (truncate (- new-size (window-body-width)))))

(defun cr/cycle-resize-window(direction)
  "Cycle resize the current window"

  (setq new-size (cr/calculate-window-size (car cr/resize-steps) direction))
  (setq delta (cr/calculate-window-delta new-size direction))

  (if (>= (length (window-list)) 2)
      (progn
        (if (string= direction "vertical")
            (enlarge-window delta)
          (enlarge-window-horizontally delta))
        (setq cr/resize-steps (first-element-at-the-end cr/resize-steps)))
    (message "Not enough window to cycle resize")))

(defun cycle-resize-window-vertically()
  "Cycle resize vertically the current window"
  (interactive)
  (cr/cycle-resize-window "vertical"))

(defun cycle-resize-window-horizontally()
  "Cycle resize horizontally the current window"
  (interactive)
  (cr/cycle-resize-window "horizontal"))

(provide 'cycle-resize)

;;; cycle-resize.el ends here
