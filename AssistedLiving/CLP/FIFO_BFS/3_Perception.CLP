(defmodule PERCEPTION (import MAIN ?ALL) (import AGENT ?ALL) (export ?ALL))

; -----------------------------------
; --- deftemplate ---
; -----------------------------------
(deftemplate updated-K-cell
  (slot done (allowed-values yes no))
)

(defrule create-update-K-cell
	(declare (salience 100))
	(not(updated-K-cell))
	=>
	(assert (updated-K-cell (done no)))
)

;pulizia perc-vision
(defrule clean-old-perc-vision
  (declare (salience 100))
  (status (time ?time))
  ?k <- (perc-vision (time ?time-old))
  (test (> ?time (+ ?time-old 1)))
  =>
  (retract ?k)
)

; -----------------------------------
; --- aggiornamento perc-vision ---
; -----------------------------------

(defrule update-K-cell-north
  (declare (salience 10))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c))
  (last-perc (step =(- ?step 1)))
  ?d <- (updated-K-cell (done no))
  (perc-vision (step ?step) (time ?time) (pos-r ?r) (pos-c ?c) (direction north)
    (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
    (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
    (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)
  )
  ?k1 <- (K-cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)))
  ?k2 <- (K-cell (pos-r =(+ ?r 1)) (pos-c ?c))
  ?k3 <- (K-cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)))
  ?k4 <- (K-cell (pos-r ?r) (pos-c =(- ?c 1)))
  ?k5 <- (K-cell (pos-r ?r) (pos-c ?c))
  ?k6 <- (K-cell (pos-r ?r) (pos-c =(+ ?c 1)))
  ?k7 <- (K-cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)))
  ?k8 <- (K-cell (pos-r =(- ?r 1)) (pos-c ?c))
  ?k9 <- (K-cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)))
  =>
  (modify ?k1 (contains ?x1))
  (modify ?k2 (contains ?x2))
  (modify ?k3 (contains ?x3))
  (modify ?k4 (contains ?x4))
  (modify ?k5 (contains ?x5))
  (modify ?k6 (contains ?x6))
  (modify ?k7 (contains ?x7))
  (modify ?k8 (contains ?x8))
  (modify ?k9 (contains ?x9))
  (modify ?d (done yes))
)

(defrule update-K-cell-south
  (declare (salience 10))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c))
  (last-perc (step =(- ?step 1)))
  ?d <- (updated-K-cell (done no))
  (perc-vision (step ?step) (time ?time) (pos-r ?r) (pos-c ?c) (direction south)
    (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
    (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
    (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)
  )
  ?k1 <- (K-cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)))
  ?k2 <- (K-cell (pos-r =(- ?r 1)) (pos-c ?c))
  ?k3 <- (K-cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)))
  ?k4 <- (K-cell (pos-r ?r) (pos-c =(+ ?c 1)))
  ?k5 <- (K-cell (pos-r ?r) (pos-c ?c))
  ?k6 <- (K-cell (pos-r ?r) (pos-c =(- ?c 1)))
  ?k7 <- (K-cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)))
  ?k8 <- (K-cell (pos-r =(+ ?r 1)) (pos-c ?c))
  ?k9 <- (K-cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)))
  =>
  (modify ?k1 (contains ?x1))
  (modify ?k2 (contains ?x2))
  (modify ?k3 (contains ?x3))
  (modify ?k4 (contains ?x4))
  (modify ?k5 (contains ?x5))
  (modify ?k6 (contains ?x6))
  (modify ?k7 (contains ?x7))
  (modify ?k8 (contains ?x8))
  (modify ?k9 (contains ?x9))
  (modify ?d (done yes))
)

(defrule update-K-cell-east
  (declare (salience 10))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c))
  (last-perc (step =(- ?step 1)))
  ?d <- (updated-K-cell (done no))
  (perc-vision (step ?step) (time ?time) (pos-r ?r) (pos-c ?c) (direction east)
    (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
    (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
    (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)
  )
  ?k1 <- (K-cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)))
  ?k2 <- (K-cell (pos-r ?r) (pos-c =(+ ?c 1)))
  ?k3 <- (K-cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)))
  ?k4 <- (K-cell (pos-r =(+ ?r 1)) (pos-c ?c))
  ?k5 <- (K-cell (pos-r ?r) (pos-c ?c))
  ?k6 <- (K-cell (pos-r =(- ?r 1)) (pos-c ?c))
  ?k7 <- (K-cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)))
  ?k8 <- (K-cell (pos-r ?r) (pos-c =(- ?c 1)))
  ?k9 <- (K-cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)))
  =>
  (modify ?k1 (contains ?x1))
  (modify ?k2 (contains ?x2))
  (modify ?k3 (contains ?x3))
  (modify ?k4 (contains ?x4))
  (modify ?k5 (contains ?x5))
  (modify ?k6 (contains ?x6))
  (modify ?k7 (contains ?x7))
  (modify ?k8 (contains ?x8))
  (modify ?k9 (contains ?x9))
  (modify ?d (done yes))
)

(defrule update-K-cell-west
  (declare (salience 10))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c))
  (last-perc (step =(- ?step 1)))
  ?d <- (updated-K-cell (done no))
  (perc-vision (step ?step) (time ?time) (pos-r ?r) (pos-c ?c) (direction west)
    (perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
    (perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
    (perc7 ?x7) (perc8 ?x8) (perc9 ?x9)
  )
  ?k1 <- (K-cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)))
  ?k2 <- (K-cell (pos-r ?r) (pos-c =(- ?c 1)))
  ?k3 <- (K-cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)))
  ?k4 <- (K-cell (pos-r =(- ?r 1)) (pos-c ?c))
  ?k5 <- (K-cell (pos-r ?r) (pos-c ?c))
  ?k6 <- (K-cell (pos-r =(+ ?r 1)) (pos-c ?c))
  ?k7 <- (K-cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)))
  ?k8 <- (K-cell (pos-r ?r) (pos-c =(+ ?c 1)))
  ?k9 <- (K-cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)))
  =>
  (modify ?k1 (contains ?x1))
  (modify ?k2 (contains ?x2))
  (modify ?k3 (contains ?x3))
  (modify ?k4 (contains ?x4))
  (modify ?k5 (contains ?x5))
  (modify ?k6 (contains ?x6))
  (modify ?k7 (contains ?x7))
  (modify ?k8 (contains ?x8))
  (modify ?k9 (contains ?x9))
  (modify ?d (done yes))
)

; non ci servono step e time, li prendiamo da status
(defrule newmeal-request
  ?msg-to-agent <- (msg-to-agent (request-time ?request-time) (sender ?sender) (request meal) (t_pos-r ?t_pos-r) (t_pos-c ?t_pos-c))
  ?tablestatus <- (K-tablestatus (pos-r ?t_pos-r) (pos-c ?t_pos-c))
  =>
  (assert (K-mealstatus (arrivaltime ?request-time) (requested-by ?sender) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered no) (answer pending)))
  (modify ?tablestatus (occupied-by ?sender))
  (retract ?msg-to-agent)
)


(defrule newdessert-request-moved
  ?msg-to-agent <- (msg-to-agent (request-time ?request-time) (sender ?sender) (request dessert) (t_pos-r ?t_pos-r) (t_pos-c ?t_pos-c))
  ?tablestatus-old <- (K-tablestatus (pos-r ?t_pos-r-old) (pos-c ?t_pos-c-old) (occupied-by ?sender)) ;posizione vecchia del paziente
  ?tablestatus-new <- (K-tablestatus (pos-r ?t_pos-r) (pos-c ?t_pos-c)) ;posizione corrente del paziente
  (test (neq ?t_pos-r-old ?t_pos-r))
  (test (neq ?t_pos-c-old ?t_pos-c))
  =>
  (assert (K-dessertstatus (arrivaltime ?request-time) (requested-by ?sender) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered no) (answer pending)))
  (modify ?tablestatus-old (occupied-by no))
  (modify ?tablestatus-new (occupied-by ?sender))
  (retract ?msg-to-agent)
)

;
(defrule newdessert-request-not-moved
  ?msg-to-agent <- (msg-to-agent (request-time ?request-time) (sender ?sender) (request dessert) (t_pos-r ?t_pos-r) (t_pos-c ?t_pos-c))
  ?tablestatus <- (K-tablestatus (pos-r ?t_pos-r) (pos-c ?t_pos-c) (occupied-by ?sender))
  =>
  (assert (K-dessertstatus (arrivaltime ?request-time) (requested-by ?sender) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered no) (answer pending)))
  (retract ?msg-to-agent)
)

(defrule newpill-request
  (status (step ?step) (time ?time))
  (prescription (patient ?patient) (pills ?pills))
  (not (K-pillstatus (for ?patient)))
  =>
  (assert (K-pillstatus (for ?patient) (delivered no) (when ?pills)))
)

;fixme:
; -----------------------------------
; --- Ultime regole di perception ---
; -----------------------------------
(defrule update-last-perc
  (declare (salience -1))
  (status (step ?s))
  ?updated-K-cell <- (updated-K-cell)
  ?last-perc <- (last-perc (step ?l))
  (test (> ?s ?l))
  =>
  (modify ?last-perc (step ?s))
  (modify ?updated-K-cell (done no))
)
