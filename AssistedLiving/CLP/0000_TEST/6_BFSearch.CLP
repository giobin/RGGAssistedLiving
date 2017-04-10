


(defmodule BFSEARCH (import REASONING ?ALL)(export ?ALL))

(deftemplate node
  (slot ident)
  (slot gcost)
  (slot father)
  (slot pos-r)
  (slot pos-c)
  (slot direction)
  (slot open)
)

(deftemplate newnode
  (slot ident)
  (slot gcost)
  (slot father)
  (slot pos-r)
  (slot pos-c)
  (slot direction)
)



;Regola al posto dei deffacts iniziali
(defrule create-initial-state
  ?k-agent <- (K-agent (pos-r ?r) (pos-c ?c) (direction ?direction))
  ?current-sub-goal <- (current-sub-goal (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target))
  =>
  (assert (node (ident 0) (gcost 0) (father NA) (pos-r ?r) (pos-c ?c) (direction ?direction) (open yes)))
  (assert (current 0))
  (assert (lastnode 0))
  (assert (open-worse 0))
  (assert (open-better 0))
  (assert (alreadyclosed 0))
  (assert (numberofnodes 0))
  (assert (temp-goal ?r ?c))
)


(defrule achieved-goal
  (declare (salience 100))
     (current ?id)
     (temp-goal ?r ?c)
     (node (ident ?id) (pos-r ?r) (pos-c ?c) (direction ?direction) (gcost ?g))
    => (printout t " Esiste soluzione per goal (" ?r "," ?c ") con costo "  ?g crlf)
      (assert (stampa ?id))
)

(defrule turnLeft-apply
  (declare (salience 50))
  (current ?curr)
  (node (ident ?curr) (pos-r ?pos-r) (pos-c ?pos-c) (direction ?direction) (open yes))
  => (assert (apply ?curr TurnLeft ?pos-r ?pos-c ?direction))
)

(defrule turnRight-apply
  (declare (salience 50))
  (current ?curr)
  (node (ident ?curr) (pos-r ?pos-r) (pos-c ?pos-c) (direction ?direction) (open yes))
  => (assert (apply ?curr TurnRight ?pos-r ?pos-c ?direction))
)

(defrule forward-apply
  (declare (salience 50))
  (current ?curr)
  (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction ?dir) (open yes))
  (K-cell (pos-r =(getForwardR ?dir ?r)) (pos-c =(getForwardC ?dir ?c)) (contains Empty|Parking))
  => (assert (apply ?curr Forward ?r ?c ?dir))
)

(defrule turnLeft-exec
  (declare (salience 50))
  (current ?curr)
  (lastnode ?n)
  ?f1<-  (apply ?curr TurnLeft ?r ?c ?dir)
  (node (ident ?curr) (gcost ?g))
  => (assert (exec-temp ?curr (+ ?n 1) TurnLeft ?r ?c ?dir)
             (newnode (ident (+ ?n 1)) (pos-r ?r) (pos-c ?c) (gcost (+ ?g 1)) (direction (getDirectionTurnLeft ?dir)) (father ?curr)))
     (retract ?f1)
     ;(focus NEW)
)

(defrule turnRight-exec
  (declare (salience 50))
  (current ?curr)
  (lastnode ?n)
  ?f1<-  (apply ?curr TurnRight ?r ?c ?dir)
  (node (ident ?curr) (gcost ?g))
  => (assert (exec-temp ?curr (+ ?n 1) TurnRight ?r ?c ?dir)
             (newnode (ident (+ ?n 1)) (pos-r ?r) (pos-c ?c) (gcost (+ ?g 1)) (direction (getDirectionTurnRight ?dir)) (father ?curr)))
     (retract ?f1)
     ;(focus NEW)
)

(defrule forward-exec
  (declare (salience 50))
  (current ?curr)
  (lastnode ?n)
  ?f1<-  (apply ?curr Forward ?r ?c ?dir)
  (node (ident ?curr) (gcost ?g))
  => (assert (exec-temp ?curr (+ ?n 1) Forward ?r ?c ?dir)
             (newnode (ident (+ ?n 1)) (pos-r (getForwardR ?dir ?r)) (pos-c (getForwardC ?dir ?c)) (gcost (+ ?g 1)) (direction ?dir) (father ?curr)))
     (retract ?f1)
     ;(focus NEW)
)
