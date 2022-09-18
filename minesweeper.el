(defun minesweeper ()
  "Start playing minesweeper"
  (interactive)
  (switch-to-buffer "minesweeper")
  (minesweeper-mode)
  (minesweeper-init 8 8 10))

(define-derived-mode minesweeper-mode special-mode "minesweeper"
  (evil-local-mode -1))

(defvar *minesweeper-mines* nil)
(defvar *minesweeper-discovered* nil)

(defconst *minesweeper-flag* ?\>)

(defun minesweeper-init (width height num-mines)
  ""
  (minesweeper-init-mines width height num-mines)
  (minesweeper-init-discovered width height)
  (minesweeper-draw-board width height)
)

(defun minesweeper-init-discovered (width height)
  ""
  (setq *minesweeper-discovered* (make-vector (* width height) ?\▓)))

(defun minesweeper-init-mines (width height num-mines)
  "Initializes a (width x height) minesweeper board with num-mines mines"
  (setq *minesweeper-mines* (make-vector (* width height) ?\.))
  (while (< (minesweeper-mines-on-board-count) num-mines)
    (minesweeper-place-mine)))

(defun minesweeper-mines-on-board-count ()
  "Returns the number of mines in *minesweeper-mines*"
  (seq-count (lambda (elt) (not (char-equal elt ?\.))) *minesweeper-mines*))

(defun minesweeper-place-mine ()
  "Places a single mine, randomly, in *minesweeper-mines"
  (let ((index (% (random) (length *minesweeper-mines*))))
    (setq *minesweeper-mines*
	  (seq-concatenate
	   'vector
	   (seq-subseq *minesweeper-mines* 0 index)
	   (list ?\*)
	   (seq-subseq *minesweeper-mines* (+ 1 index))
	   )
	  )
  )
)

(defun minesweeper-draw-board (width height)
  "Draw the board in the buffer"
  (let ((inhibit-read-only t))
    (erase-buffer)
    (dotimes (row height)
      (dotimes (column height)
	(insert (minesweeper-get-square width row column)))
      (insert "\n"))))

(defun minesweeper-get-square (width row column)
  ""
  (elt *minesweeper-discovered* (+ column (* width row))))

(message "Loaded minesweeper")
