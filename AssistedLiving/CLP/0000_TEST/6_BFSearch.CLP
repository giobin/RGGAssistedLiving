


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
  (declare (salience 200))
  (not (temp-goal))
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
  (assert (temp-goal ?pos-r-target ?pos-c-target))
)


(defrule achieved-goal
  (declare (salience 100))
     (current ?id)
     (temp-goal ?r ?c)
     (node (ident ?id) (pos-r ?pos-r) (pos-c ?pos-c) (direction ?direction) (gcost ?g))
     (test (= ?r (getForwardR ?direction ?pos-r)))
     (test (= ?c (getForwardC ?direction ?pos-c)))
    => (printout t " Esiste soluzione per goal (" ?pos-r "," ?pos-c ") con costo "  ?g crlf)
      (assert (stampa ?id))
)

(defrule stampaSol
  (declare (salience 101))
  ?f<-(stampa ?id)
      (node (ident ?id) (father ?anc&~NA) (gcost ?g))
      (exec-temp ?anc ?id ?action ?r ?c ?d)
  => (printout t " Eseguo azione " ?action " da stato (" ?r "," ?c "), direzione: " ?d crlf)
     (assert (stampa ?anc))
     (assert (plan-action-aux (plan-step ?g)(action ?action)))
     (retract ?f)
)

(defrule sub-goal-reached
(declare (salience 102))
       (stampa ?id)
       (node (ident ?id) (father ?anc&NA))
       (open-worse ?worse)
       (open-better ?better)
       (alreadyclosed ?closed)
       (numberofnodes ?n )
=> (printout t " stati espansi " ?n crlf)
   (printout t " stati generati gia in closed " ?closed crlf)
   (printout t " stati generati gia in open (open-worse) " ?worse crlf)
   (printout t " stati generati gia in open (open-better) " ?better crlf)
   (pop-focus)
)

(defrule turnLeft-apply
  (declare (salience 50))
  (current ?curr)
  (node (ident ?curr) (pos-r ?pos-r) (pos-c ?pos-c) (direction ?direction) (open yes))
  => (assert (apply ?curr Turnleft ?pos-r ?pos-c ?direction))
)

(defrule turnRight-apply
  (declare (salience 50))
  (current ?curr)
  (node (ident ?curr) (pos-r ?pos-r) (pos-c ?pos-c) (direction ?direction) (open yes))
  => (assert (apply ?curr Turnright ?pos-r ?pos-c ?direction))
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
  ?f1<-  (apply ?curr Turnleft ?r ?c ?dir)
  (node (ident ?curr) (gcost ?g))
  => (assert (exec-temp ?curr (+ ?n 1) Turnleft ?r ?c ?dir)
             (newnode (ident (+ ?n 1)) (pos-r ?r) (pos-c ?c) (gcost (+ ?g 1)) (direction (getDirectionTurnLeft ?dir)) (father ?curr)))
     (retract ?f1)
     (focus NEW)
)

(defrule turnRight-exec
  (declare (salience 50))
  (current ?curr)
  (lastnode ?n)
  ?f1<-  (apply ?curr Turnright ?r ?c ?dir)
  (node (ident ?curr) (gcost ?g))
  => (assert (exec-temp ?curr (+ ?n 2) Turnright ?r ?c ?dir)
             (newnode (ident (+ ?n 2)) (pos-r ?r) (pos-c ?c) (gcost (+ ?g 1)) (direction (getDirectionTurnRight ?dir)) (father ?curr)))
     (retract ?f1)
     (focus NEW)
)

(defrule forward-exec
  (declare (salience 50))
  (current ?curr)
  (lastnode ?n)
  ?f1<-  (apply ?curr Forward ?r ?c ?dir)
  (node (ident ?curr) (gcost ?g))
  => (assert (exec-temp ?curr (+ ?n 3) Forward ?r ?c ?dir)
             (newnode (ident (+ ?n 3)) (pos-r (getForwardR ?dir ?r)) (pos-c (getForwardC ?dir ?c)) (gcost (+ ?g 1)) (direction ?dir) (father ?curr)))
     (retract ?f1)
     (focus NEW)
)

; scegliamo quale nodo espandere
(defrule change-current
  (declare (salience 49))
  ?f1 <- (current ?curr)
  ?f2 <- (node (ident ?curr))
  (node (ident ?best&:(neq ?best ?curr)) (gcost ?bestcost) (open yes))
  (not (node (ident ?id&:(neq ?id ?curr)) (gcost ?gg&:(< ?gg ?bestcost)) (open yes)))
  ?f3 <- (lastnode ?last)
  =>
  (assert (current ?best) (lastnode (+ ?last 4)))
  (retract ?f1 ?f3)
  (modify ?f2 (open no)))

; non ci sono nodi più nodi da espandere quindi ci fermiamo (caso in cui fallisce)
(defrule close-empty
  (declare (salience 49))
  ?f1 <- (current ?curr)
  ?f2 <- (node (ident ?curr))
  (not (node (ident ?id&:(neq ?id ?curr))  (open yes)))
  =>
  (retract ?f1)
  (modify ?f2 (open no))
  (printout t " fail (last  node expanded " ?curr ")" crlf)
  (halt))

(defmodule NEW (import BFSEARCH ?ALL) (export ?ALL))

; controllo per evitare loop
(defrule check-closed
  (declare (salience 50))
  ?f1 <- (newnode (ident ?id) (pos-r ?r) (pos-c ?c) (direction ?dir))
  (node (ident ?old) (pos-r ?r) (pos-c ?c) (open no) (direction ?dir))
  ?f2 <- (alreadyclosed ?a)
  =>
  (assert (alreadyclosed (+ ?a 1)))
  (retract ?f1)
  (retract ?f2)
  (pop-focus))

; controllo che genero un nodo uguale ad uno gia esistente, ma con costo minore (nel nostro caso non dovrebbe mai succedere)
(defrule check-open-better
  (declare (salience 50))
  ?f1 <- (newnode (ident ?id) (pos-r ?r) (pos-c ?c) (gcost ?g) (father ?anc) (direction ?dir))
  ?f2 <- (node (ident ?old) (pos-r ?r) (pos-c ?c) (gcost ?g-old) (open yes) (direction ?dir))
  (test (<  ?g ?g-old))
  ?f3 <- (open-better ?a)
  =>
  (assert (node (ident ?id) (pos-r ?r) (pos-c ?c) (gcost ?g) (father ?anc) (open yes) (direction ?dir)))
  (assert (open-better (+ ?a 1)))
  (retract ?f1 ?f2 ?f3)
  (pop-focus))

; controllo che genero un nodo uguale ad uno gia esistente, ma con costo maggiore
(defrule check-open-worse
  (declare (salience 50))
  ?f1 <- (newnode (ident ?id) (pos-r ?r) (pos-c ?c) (gcost ?g) (father ?anc) (direction ?dir))
  (node (ident ?old) (pos-r ?r) (pos-c ?c) (gcost ?g-old) (open yes) (direction ?dir))
  (test (or (> ?g ?g-old) (= ?g-old ?g)))
  ?f2 <- (open-worse ?a)
  =>
  (assert (open-worse (+ ?a 1)))
  (retract ?f1)
  (retract ?f2)
  (pop-focus))

; trasforma il newnode in node normale
(defrule add-open
  (declare (salience 49))
  ?f1 <- (newnode (ident ?id) (pos-r ?r) (pos-c ?c) (gcost ?g) (father ?anc) (direction ?dir))
  ?f2 <- (numberofnodes ?a)
  =>
  (assert (node (ident ?id) (pos-r ?r) (pos-c ?c) (gcost ?g) (father ?anc) (open yes) (direction ?dir)))
  (assert (numberofnodes (+ ?a 1)))
  (retract ?f1 ?f2)
  (pop-focus))
