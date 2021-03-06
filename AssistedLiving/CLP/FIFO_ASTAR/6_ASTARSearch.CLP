(defmodule A-STAR (import REASONING ?ALL)(export ?ALL))
(deftemplate node  (slot ident)  (slot gcost)  (slot fcost)  (slot father)  (slot pos-r)  (slot pos-c)  (slot direction)  (slot open))(deftemplate newnode  (slot ident)  (slot gcost)  (slot fcost)  (slot father)  (slot pos-r)  (slot pos-c)  (slot direction));Regola al posto dei deffacts iniziali(defrule create-initial-state  (declare (salience 200))  (not (temp-goal))  ?k-agent <- (K-agent (pos-r ?r) (pos-c ?c) (direction ?direction))  ?current-sub-goal <- (current-sub-goal (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do ?action-to-do) (param1 ?param1) (param2 ?param2) (param3 ?param3))  =>  (assert (node (ident 0) (gcost 0) (father NA) (fcost 0) (pos-r ?r) (pos-c ?c) (direction ?direction) (open yes)))  (assert (current 0))  (assert (lastnode 0))  (assert (open-worse 0))  (assert (open-better 0))  (assert (alreadyclosed 0))  (assert (numberofnodes 0))  (assert (temp-goal ?pos-r-target ?pos-c-target)))(defrule clear-failure  (declare (salience 198))  ?f <- (failure)  =>  (retract ?f))
(defrule achieved-goal (declare (salience 100))    (current ?id)    (temp-goal ?r ?c)    (node (ident ?id) (pos-r ?pos-r) (pos-c ?pos-c) (direction ?direction) (gcost ?g))    (test (= ?r (getForwardR ?direction ?pos-r)))    (test (= ?c (getForwardC ?direction ?pos-c)))    ?current-sub-goal <- (current-sub-goal (id ?ident) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do ?action-to-do) (param1 ?param1) (param2 ?param2) (param3 ?param3))    ?sub-goal <- (sub-goal (id ?ident))   => (printout t " Esiste soluzione per goal (" ?pos-r "," ?pos-c ") con costo "  ?g crlf)    (assert (plan-action-aux (plan-step (+ ?g 1)) (action ?action-to-do) (param1 ?param1) (param2 ?param2) (param3 ?param3)))    (assert (stampa ?id))   ;  (retract ?current-sub-goal) ; eliminiamo il current sub goal   ;  (retract ?sub-goal) ; eliminiamo il sub goal (che è uguale al current))(defrule create-plan-actions-aux
  (declare (salience 101))
  ?f<- (stampa ?id)
      (node (ident ?id) (father ?anc&~NA) (gcost ?g))
  ?exec-temp <- (exec-temp ?anc ?id ?action ?r ?c ?d)
  =>
     (assert (stampa ?anc))
     (assert (plan-action-aux (plan-step ?g)(action ?action)))
     (retract ?f)
     (retract ?exec-temp)
)

(defrule sub-goal-reached
(declare (salience 102))
      (stampa ?id)
      (node (ident ?id) (father ?anc&NA))
      (open-worse ?worse)
      (open-better ?better)
      (alreadyclosed ?closed)
      (numberofnodes ?n )
=>
   (assert (clear-all))
)

(defrule clear-nodes
  (declare (salience 200))
  (clear-all)
  ?node <- (node)
  =>
  (retract ?node)
)

(defrule clear-exec-temp
  (declare (salience 200))
  (clear-all)
  ?exec-temp <- (exec-temp $?)
  =>
  (retract ?exec-temp)
)

(defrule clear-initial-state
  (declare (salience 199))
  ?clear-all <-(clear-all)
  ?stampa <- (stampa ?id)
  ?open-worse <- (open-worse ?worse)
  ?open-better <- (open-better ?better)
  ?alreadyclosed <- (alreadyclosed ?closed)
  ?numberofnodes <- (numberofnodes ?n)
  ?temp-goal <- (temp-goal $?)
  ?current <- (current $?)
  ?lastnode <- (lastnode $?)
  =>
  (retract ?stampa)
  (retract ?open-worse)
  (retract ?open-better)
  (retract ?alreadyclosed)
  (retract ?numberofnodes)
  (retract ?temp-goal)
  (retract ?current)
  (retract ?lastnode)
  (retract ?clear-all)
  (pop-focus)
)

(defrule clear-initial-state-failure
   (declare (salience 199))
   ?failure <- (failure)
   ?clear-all <-(clear-all)
   ;?stampa <- (stampa ?id)
   ?open-worse <- (open-worse ?worse)
   ?open-better <- (open-better ?better)
   ?alreadyclosed <- (alreadyclosed ?closed)
   ?numberofnodes <- (numberofnodes ?n)
   ?temp-goal <- (temp-goal $?)
   ;?current <- (current $?)
   ?lastnode <- (lastnode $?)
   =>
   ;(retract ?stampa)
   (retract ?open-worse)
   (retract ?open-better)
   (retract ?alreadyclosed)
   (retract ?numberofnodes)
   (retract ?temp-goal)
   ;(retract ?current)
   (retract ?lastnode)
   (retract ?clear-all)
   (pop-focus)
 )
(defrule turnLeft-apply  (declare (salience 50))  (current ?curr)  (node (ident ?curr) (pos-r ?pos-r) (pos-c ?pos-c) (direction ?direction) (open yes))  => (assert (apply ?curr Turnleft ?pos-r ?pos-c ?direction)))
(defrule turnRight-apply
  (declare (salience 50))
  (current ?curr)
  (node (ident ?curr) (pos-r ?pos-r) (pos-c ?pos-c) (direction ?direction) (open yes))
  => (assert (apply ?curr Turnright ?pos-r ?pos-c ?direction))
)

;tenta di applicare la forward nel caso in cui la cella in cui vuole andare è nello spazio di visione del k-agent
(defrule forward-inside-apply
  (declare (salience 50))
  (current ?curr)
  (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction ?dir) (open yes))
  ?k-agent <- (K-agent (pos-r ?agent-r) (pos-c ?agent-c))
  (K-cell (pos-r ?new-r&=(getForwardR ?dir ?r)) (pos-c ?new-c&=(getForwardC ?dir ?c)) (contains Empty|Parking))
  (test (<= (abs(- ?new-r ?agent-r)) 1))
  (test (<= (abs(- ?new-c ?agent-c)) 1))
  => (assert (apply ?curr Forward ?r ?c ?dir))
)

;tenta di applicare la forward nel caso in cui la cella in cui vuole andare è FUORI dallo spazio di visione del k-agent
;se poi la cella in cui vuole andare è ancora occupata allora in esecuzione fa replanning
(defrule forward-outside-apply
  (declare (salience 50))
  (current ?curr)
  (node (ident ?curr) (pos-r ?r) (pos-c ?c) (direction ?dir) (open yes))
  ?k-agent <- (K-agent (pos-r ?agent-r) (pos-c ?agent-c))
  (K-cell (pos-r ?new-r&=(getForwardR ?dir ?r)) (pos-c ?new-c&=(getForwardC ?dir ?c)) (contains Empty|Parking|PersonStanding))
  (or (test (> (abs(- ?new-r ?agent-r)) 1))
  (test (> (abs(- ?new-c ?agent-c)) 1)))
  => (assert (apply ?curr Forward ?r ?c ?dir))
)

(defrule turnLeft-exec
  (declare (salience 50))
  (current ?curr)
  (lastnode ?n)
  ?f1<-  (apply ?curr Turnleft ?r ?c ?dir)
  (node (ident ?curr) (gcost ?g))
  (temp-goal ?pos-r-target ?pos-c-target)
  => (assert (exec-temp ?curr (+ ?n 1) Turnleft ?r ?c ?dir)
             (newnode (ident (+ ?n 1)) (pos-r ?r) (pos-c ?c) (gcost (+ ?g 2)) (fcost (+ (abs (- ?pos-r-target ?r)) (abs (- ?pos-c-target ?c)) ?g 1)) (direction (getDirectionTurnLeft ?dir)) (father ?curr)))
     (retract ?f1)
     (focus NEW)
)

(defrule turnRight-exec
  (declare (salience 50))
  (current ?curr)
  (lastnode ?n)
  ?f1<-  (apply ?curr Turnright ?r ?c ?dir)
  (node (ident ?curr) (gcost ?g))
  (temp-goal ?pos-r-target ?pos-c-target)
  => (assert (exec-temp ?curr (+ ?n 2) Turnright ?r ?c ?dir)
             (newnode (ident (+ ?n 2)) (pos-r ?r) (pos-c ?c) (gcost (+ ?g 2)) (fcost (+ (abs (- ?pos-r-target ?r)) (abs (- ?pos-c-target ?c)) ?g 1)) (direction (getDirectionTurnRight ?dir)) (father ?curr)))
     (retract ?f1)
     (focus NEW)
)

(defrule forward-exec
  (declare (salience 50))
  (current ?curr)
  (lastnode ?n)
  ?f1<-  (apply ?curr Forward ?r ?c ?dir)
  (node (ident ?curr) (gcost ?g))
  (temp-goal ?pos-r-target ?pos-c-target)
  => (assert (exec-temp ?curr (+ ?n 3) Forward ?r ?c ?dir)
             (newnode (ident (+ ?n 3)) (pos-r (getForwardR ?dir ?r)) (pos-c (getForwardC ?dir ?c))
                      (gcost (+ ?g 1)) (fcost (+ (abs (- ?pos-r-target (getForwardR ?dir ?r))) (abs (- ?pos-c-target (getForwardC ?dir ?c))) ?g 1))
                      (direction ?dir) (father ?curr)))
     (retract ?f1)
     (focus NEW)
)

; scegliamo quale nodo espandere(defrule change-current  (declare (salience 49))  ?f1 <- (current ?curr)  ?f2 <- (node (ident ?curr))  (node (ident ?best&:(neq ?best ?curr)) (fcost ?bestcost) (open yes))  (not (node (ident ?id&:(neq ?id ?curr)) (fcost ?gg&:(< ?gg ?bestcost)) (open yes)))  ?f3 <- (lastnode ?last)  =>  (assert (current ?best) (lastnode (+ ?last 4)))  (retract ?f1 ?f3)  (modify ?f2 (open no)))
; non ci sono nodi più nodi da espandere quindi ci fermiamo (caso in cui fallisce)(defrule close-empty (declare (salience 49)) ?f1 <- (current ?curr) ?f2 <- (node (ident ?curr)) (not (node (ident ?id&:(neq ?id ?curr))  (open yes))) => (retract ?f1) (modify ?f2 (open no)) (printout t " fail (last  node expanded " ?curr ")" crlf) (assert (plan-action-aux (plan-step 0) (action Wait))) (assert (clear-all)) (assert (failure)) ;) ;(halt) )
(defmodule NEW (import A-STAR ?ALL) (export ?ALL)); controllo per evitare loop(defrule check-closed (declare (salience 50)) ?f1 <- (newnode (ident ?id) (pos-r ?r) (pos-c ?c) (direction ?dir)) (node (ident ?old) (pos-r ?r) (pos-c ?c) (open no) (direction ?dir)) ?f2 <- (alreadyclosed ?a) => (assert (alreadyclosed (+ ?a 1))) (retract ?f1) (retract ?f2) (pop-focus)); controllo che genero un nodo uguale ad uno gia esistente, ma con costo maggiore(defrule check-open-worse (declare (salience 50)) ?f1 <- (newnode (ident ?id) (pos-r ?r) (pos-c ?c) (gcost ?g) (father ?anc) (direction ?dir)) (node (ident ?old) (pos-r ?r) (pos-c ?c) (gcost ?g-old) (open yes) (direction ?dir)) (test (or (> ?g ?g-old) (= ?g-old ?g))) ?f2 <- (open-worse ?a) => (assert (open-worse (+ ?a 1))) (retract ?f1) (retract ?f2) (pop-focus))
; controllo che genero un nodo uguale ad uno gia esistente, ma con costo minore (nel nostro caso non dovrebbe mai succedere)
(defrule check-open-better
 (declare (salience 50))
 ?f1 <- (newnode (ident ?id) (pos-r ?r) (pos-c ?c) (gcost ?g) (fcost ?f) (father ?anc) (direction ?dir))
 ?f2 <- (node (ident ?old) (pos-r ?r) (pos-c ?c) (gcost ?g-old) (open yes) (direction ?dir))
 (test (<  ?g ?g-old))
 ?f3 <- (open-better ?a)
 =>
 (assert (node (ident ?id) (pos-r ?r) (pos-c ?c) (gcost ?g) (fcost ?f) (father ?anc) (open yes) (direction ?dir)))
 (assert (open-better (+ ?a 1)))
 (retract ?f1 ?f2 ?f3)
 (pop-focus))

; trasforma il newnode in node normale(defrule add-open (declare (salience 49)) ?f1 <- (newnode (ident ?id) (pos-r ?r) (pos-c ?c) (gcost ?g) (fcost ?f) (father ?anc) (direction ?dir)) ?f2 <- (numberofnodes ?a) => (assert (node (ident ?id) (pos-r ?r) (pos-c ?c) (gcost ?g) (fcost ?f) (father ?anc) (open yes) (direction ?dir))) (assert (numberofnodes (+ ?a 1))) (retract ?f1 ?f2) (pop-focus))