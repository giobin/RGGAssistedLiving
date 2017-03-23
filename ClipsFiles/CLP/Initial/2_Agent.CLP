;// AGENT
(defmodule AGENT (import MAIN ?ALL) (export ?ALL))

;modella lo stato della cella secondo l'agente
(deftemplate K-cell  (slot pos-r) (slot pos-c) (slot contains))

;modella lo stato dell'agente secondo l'agente
(deftemplate K-agent
	(slot step)
  (slot time)
	(slot pos-r)
	(slot pos-c)
	(slot direction)
	;quattro simboli:
	; -dietetic-meals -> dietetic
	; -normal-meals   -> normal
	; -desserts       -> dessert
	; -pills          -> ?person
	(multislot content)
  (slot free)
  (slot waste)
)

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  indispensabili per clips monitor
(deftemplate last-status (slot step))
(deftemplate init-agent (slot done))
(deffacts init-monitor (last-status (step 0)))

(defrule  beginagent1
	(declare (salience 11))
  (status (step 0))
  (not (exec (step 0)))
  (prior-cell (pos-r ?r) (pos-c ?c) (contains ?x))
	(not (K-cell (pos-r ?r) (pos-c ?c) (contains ?x)))
	=>
  (assert (K-cell (pos-r ?r) (pos-c ?c) (contains ?x)))
)

(defrule  beginagent2
  (declare (salience 10))
	(status (step 0))
	(not (exec (step 0)))
	(K-cell (pos-r ?r) (pos-c ?c) (contains Parking))
	=>
	(assert (K-agent (time 0) (step 0) (pos-r ?r) (pos-c ?c) (direction north)
	                    (free 2) (waste no)))
	(assert (deliberate 0))
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ASSERT INDISPENSABILE PER CLIPSMONITOR
	(assert (init-agent (done yes)))
)


(defrule ask_act
	(declare (salience 2))
	?f <- (status (step ?i))
	(exec (action ?a) (step ?i))
	?f2<-(print-action ?i)
	=>
	(printout t crlf crlf)
	(printout t "action to be executed at step:" ?i " -> " ?a)
	(printout t crlf crlf)
	(retract ?f2)
	(modify ?f (work on))
)

(defrule exec_act
	(status (step ?i))
	(exec (step ?i))
	=>
	(assert (deliberate (+ ?i 1)))
	(pop-focus)
 )
