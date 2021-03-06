﻿;// AGENT


(defmodule AGENT (import MAIN ?ALL)(export ?ALL))

(deftemplate K-cell
  (slot sound (allowed-values yes no unknown) (default unknown)) ; non serve
  (slot pos-r)
  (slot pos-c)
  (slot contains)
  (slot injured (allowed-values yes no unknown)) ; non serve
  (slot discovered) ; non serve
  (slot checked)    ; non serve
  (slot clear)      ;non serve
)

(deftemplate K-agent
	(slot step)
  (slot time)
	(slot pos-r)
	(slot pos-c)
	(slot direction)
  (slot loaded)
	(multislot content)
        (slot free)
        (slot waste)
)

(deftemplate K-person
  (slot step)
  (slot time)
  (slot pos-r)
  (slot pos-c)
)

(deftemplate goal
  (slot ident)
  (slot priority)
  (slot action)
  (slot status )
)

; sono i fatti di cui Ã¨ formato un piano che verrano poi convertite in exec
(deftemplate plan-action
  (slot plan-step)
  (slot action  (allowed-values Forward Turnright Turnleft Wait
                                      LoadMeal LoadPill LoadDessert
                                      DeliveryMeal DeliveryPill DeliveryDessert
                                      CleanTable EmptyRobot ReleaseTrash CheckId
                                      Inform Done))
  (slot param1)
  (slot param2)
  (slot param3)
)

(deftemplate plan-action-aux
  (slot plan-step)
  (slot action  (allowed-values Forward Turnright Turnleft Wait
                                      LoadMeal LoadPill LoadDessert
                                      DeliveryMeal DeliveryPill DeliveryDessert
                                      CleanTable EmptyRobot ReleaseTrash CheckId
                                      Inform Done))
  (slot param1)
  (slot param2)
  (slot param3)
)


; arriva da rescue, non so cosa serva

; step dell'ultima percezione esaminata
(deftemplate last-perc (slot step))
(deftemplate last-perc-vision (slot step))

; arriva da rescue, non so cosa serva
(deftemplate exec-mode (slot step))

; Ci dice se l'inizializzazione dell'agente Ã¨ conclusa
(deftemplate init-agent (slot done (allowed-values yes no)))

; Contiene condizioni particolari che si possono verificare in corsa
(deftemplate special-condition (slot bumped (allowed-values yes no)))

; Serve per ricordarsi qual Ã¨ il prossimo modulo da attivare
(deftemplate go (slot module (allowed-values perception deliberation reasoning action none)))

;  ---------------------------------------------
;  --- Template per tracciare lo stato dei tavoli  ---
;  ---------------------------------------------

(deftemplate K-table-seat
  (slot t_pos-r)
  (slot t_pos-c)
  (slot s_pos-r)
  (slot s_pos-c)
  )

(deftemplate K-tablestatus
	(slot step)
  (slot time)
	(slot pos-r)
	(slot pos-c)
	(slot clean (allowed-values yes no) (default yes))
	(slot occupied-by)
        )

;  ---------------------------------------------
;  --- Template per tracciare le risposte ai vecchietti   ---
;  ---------------------------------------------

(deftemplate K-mealstatus
	(slot step)
        (slot time)
	(slot arrivaltime)	;// momento in cui é arrivata l'ordinazione
	(slot requested-by)
	(slot type)
        (slot tpos-r)
        (slot tpos-c)
        (slot delivered)
        (slot delivertime)
        (slot answer (allowed-values pending yes wait reject))
)

(deftemplate K-dessertstatus
	(slot step)
        (slot time)
	(slot arrivaltime)	;// momento in cui é arrivata l'ordinazione
	(slot requested-by)
        (slot tpos-r)
        (slot tpos-c)
        (slot delivered)
        (slot answer (allowed-values pending yes wait reject))
)

(deftemplate K-pillstatus
	(slot step)
        (slot time)			;// tempo corrente
	(slot for)
        (slot delivered)
        (slot when (allowed-values before after no))
)

(deffacts initial-fact-agent
  (last-perc (step -1))
  (last-perc-vision (step -1))
)


;  ---------------------------------------------
;  --- Regole iniziali per creare la mappa   ---
;  ---------------------------------------------

(defrule  beginagent1

    (declare (salience 11))
    (status (step 0))
    (not (exec (step 0)))
    (real_cell (pos-r ?r) (pos-c ?c) (contains ?x))
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
                          (free 2) (waste no) (loaded no))
             (init-agent (done yes)))
)

; inizializzazione fatti k-table-seat
(defrule  beginagent3

    (declare (salience 11))
    (status (step 0))
    (not (exec (step 0)))
    (table-seat (t_pos-r ?tr) (t_pos-c ?tc) (s_pos-r ?sr) (s_pos-c ?sc))
=>
    (assert (K-table-seat (t_pos-r ?tr) (t_pos-c ?tc) (s_pos-r ?sr) (s_pos-c ?sc)))
    (assert (K-tablestatus (step 0) (time 0) (pos-r ?tr) (pos-c ?tc) (clean yes) (occupied-by no)))
)

; ;  -----------------------------------------------------
; ;  --- Regole per gestire l'attivazione dei moduli   ---
; ;  -----------------------------------------------------

(defrule first-module
  (declare (salience 9))
  (init-agent (done yes))
  (not (go (module ?)))
  =>
  (assert (go (module perception)))
)

(defrule go-perception
  (declare (salience 5))
  ?f <- (go (module perception))
  =>
  (modify ?f (module reasoning))
  (focus PERCEPTION)
)

(defrule go-reasoning
  (declare (salience 5))
  ?f <- (go (module reasoning))
  =>
  (modify ?f (module action))
  (focus REASONING)
)

(defrule go-action
  (declare (salience 5))
  ?f <- (go (module action))
  =>
  (modify ?f (module none))
  (focus ACTION)
)


; ;  ------------------------------------------------
;  --- Regole da eseguire alla fine dell'agent  ---
;  ------------------------------------------------

; Esegue l'azione dello step corrente, lasciando il controllo al main

(defrule exec_act
    (declare (salience 0))
    (status (step ?i))
    (exec (step ?i))
    ?go <- (go (module none))
  =>
    (retract ?go)
    (pop-focus)
)

; L'agent non sa cosa fare. Halt per evitare di far crashare CLIPS
(defrule nothing-to-do
  (declare (salience -1000))
  =>
  (printout t "Don't know what to do")
  (assert (clips-monitor stop))
  (halt)
)


; ;  ------------------------------------------------
;  --- Funzioni  ---
;  ------------------------------------------------

(deffunction getLoaded(?free)
  (if (= ?free 2) then
    no
    else yes)
)

(deffunction getDirectionTurnLeft(?a)
  (if (eq ?a north) then
    west
    else
      (if (eq ?a west) then
       south
       else
        (if (eq ?a south) then
          east
          else north)))
)

(deffunction getDirectionTurnRight(?a)
  (if (eq ?a north) then
    east
    else
      (if (eq ?a west) then
       north
       else
        (if (eq ?a south) then
          west
          else south)))
)

(deffunction getForwardR(?dir ?r)
  (if (eq ?dir north) then
    (+ ?r 1)
    else
      (if (eq ?dir south) then
       (- ?r 1)
        else ?r))
)

(deffunction getForwardC(?dir ?c)
  (if (eq ?dir east) then
    (+ ?c 1)
    else
      (if (eq ?dir west) then
       (- ?c 1)
        else ?c))
)

; ;  ------------------------------------------------
;  --- Regole per il movimento  ---
;  ------------------------------------------------

(defrule  wait
  (declare (salience 10))
  (exec (step ?step) (action Wait))
  ?k <- (K-agent (time ?time) (step ?step))
  =>
  (modify ?k (time (+ ?time 5)) (step (+ ?step 1)))
)

(defrule turnLeft
    (declare (salience 10))
    (exec (step ?step) (action Turnleft))
    ?k <- (K-agent (time ?time) (step ?step) (direction ?dir))
    =>
    (modify ?k (time (+ ?time 2)) (step (+ ?step 1)) (direction (getDirectionTurnLeft ?dir)))
)

(defrule turnRight
    (declare (salience 10))
    (exec (step ?step) (action Turnright))
    ?k <- (K-agent (time ?time) (step ?step) (direction ?dir))
    =>
    (modify ?k (time (+ ?time 2)) (step (+ ?step 1)) (direction (getDirectionTurnRight ?dir)))
)

(defrule forward
  (declare (salience 10))
  (exec (step ?step) (action Forward))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir))
  (perc-vision (step ?step) (time ?time) (perc2 Empty|Parking))
  =>
  (modify ?k (time (+ ?time 1)) (step (+ ?step 1)) (pos-r (getForwardR ?dir ?r)) (pos-c (getForwardC ?dir ?c)))
)

(defrule loadMeal
  (declare (salience 10))
  (exec (step ?step) (action LoadMeal) (param1 ?y) (param2 ?x) (param3 ?type))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (waste no) (content $?cont))
  (test (> ?free 0))
  (perc-vision (step ?step) (time ?time) (perc2 MealDispenser))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  =>
  (modify ?k (time (+ ?time 15)) (step (+ ?step 1)) (loaded yes) (free (- ?free 1)) (content (insert$ $?cont 1 ?type)))
)

(defrule loadPill
  (declare (salience 10))
  (exec (step ?step) (action LoadPill) (param1 ?y) (param2 ?x) (param3 ?patient))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (waste no) (content $?cont))
  (test (> ?free 0))
  (perc-vision (step ?step) (time ?time) (perc2 PillDispenser))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  =>
  (modify ?k (time (+ ?time 10)) (step (+ ?step 1)) (loaded yes) (free (- ?free 1)) (content (insert$ $?cont 1 ?patient)))
)

(defrule loadDessert
  (declare (salience 10))
  (exec (step ?step) (action LoadDessert) (param1 ?y) (param2 ?x))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (waste no) (content $?cont))
  (test (> ?free 0))
  (perc-vision (step ?step) (time ?time) (perc2 DessertDispenser))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  =>
  (modify ?k (time (+ ?time 15)) (step (+ ?step 1)) (loaded yes) (free (- ?free 1)) (content (insert$ $?cont 1 dessert)))
)

(defrule deliveryMealBefore-same-meal
  (declare (salience 11))
  (exec (step ?step) (action DeliveryMeal) (param1 ?y) (param2 ?x) (param3 ?type))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (waste no) (content ?type ?type))
  (perc-vision (step ?step) (time ?time) (perc2 Table))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  ?k-mealstatus <- (K-mealstatus (tpos-r ?y) (tpos-c ?x) (delivered no))
  ?k-tablestatus <- (K-tablestatus (pos-r ?y) (pos-c ?x) (clean yes) (occupied-by ?id))
  ?k-pillstatus <- (K-pillstatus (for ?id) (when before) (delivered yes))
  =>
  (modify ?k (time (+ ?time 12)) (step (+ ?step 1)) (content ?type) (loaded (getLoaded (+ ?free 1))) (free (+ ?free 1)))
  (modify ?k-mealstatus (delivered yes) (delivertime (+ ?time 12)))
  (modify ?k-tablestatus (time ?time) (step ?step) (clean no))
)

(defrule deliveryMealBefore
  (declare (salience 10))
  (exec (step ?step) (action DeliveryMeal) (param1 ?y) (param2 ?x) (param3 ?type))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (waste no) (content $?cont))
  (test (member$ ?type $?cont))
  (perc-vision (step ?step) (time ?time) (perc2 Table))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  ?k-mealstatus <- (K-mealstatus (tpos-r ?y) (tpos-c ?x) (delivered no))
  ?k-tablestatus <- (K-tablestatus (pos-r ?y) (pos-c ?x) (clean yes) (occupied-by ?id))
  ?k-pillstatus <- (K-pillstatus (for ?id) (when before) (delivered yes))
  =>
  (modify ?k (time (+ ?time 12)) (step (+ ?step 1)) (content (delete-member$ $?cont ?type)) (loaded (getLoaded (+ ?free 1))) (free (+ ?free 1)))
  (modify ?k-mealstatus (delivered yes) (delivertime (+ ?time 12)))
  (modify ?k-tablestatus (time ?time) (step ?step) (clean no))
)

(defrule deliveryMealNoBefore-same-meal
  (declare (salience 11))
  (exec (step ?step) (action DeliveryMeal) (param1 ?y) (param2 ?x) (param3 ?type))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (waste no) (content ?type ?type))
  (perc-vision (step ?step) (time ?time) (perc2 Table))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  ?k-mealstatus <- (K-mealstatus (tpos-r ?y) (tpos-c ?x) (delivered no))
  ?k-tablestatus <- (K-tablestatus (pos-r ?y) (pos-c ?x) (clean yes) (occupied-by ?id))
  ?k-pillstatus <- (K-pillstatus (for ?id) (when no|after))
  =>
  (modify ?k (time (+ ?time 12)) (step (+ ?step 1)) (content ?type) (loaded (getLoaded (+ ?free 1))) (free (+ ?free 1)))
  (modify ?k-mealstatus (delivered yes) (delivertime (+ ?time 12)))
  (modify ?k-tablestatus (time ?time) (step ?step) (clean no))
)

(defrule deliveryMealNoBefore
  (declare (salience 10))
  (exec (step ?step) (action DeliveryMeal) (param1 ?y) (param2 ?x) (param3 ?type))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (waste no) (content $?cont))
  (test (member$ ?type $?cont))
  (perc-vision (step ?step) (time ?time) (perc2 Table))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  ?k-mealstatus <- (K-mealstatus (tpos-r ?y) (tpos-c ?x) (delivered no))
  ?k-tablestatus <- (K-tablestatus (pos-r ?y) (pos-c ?x) (clean yes) (occupied-by ?id))
  ?k-pillstatus <- (K-pillstatus (for ?id) (when no|after))
  =>
  (modify ?k (time (+ ?time 12)) (step (+ ?step 1)) (content (delete-member$ $?cont ?type)) (loaded (getLoaded (+ ?free 1))) (free (+ ?free 1)))
  (modify ?k-mealstatus (delivered yes) (delivertime (+ ?time 12)))
  (modify ?k-tablestatus (time ?time) (step ?step) (clean no))
)

(defrule deliveryDessert-two-dessert
  (declare (salience 11))
  (exec (step ?step) (action DeliveryDessert) (param1 ?y) (param2 ?x))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (waste no) (content dessert dessert))
  (perc-vision (step ?step) (time ?time) (perc2 Table))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  ?k-dessertstatus <- (K-dessertstatus (delivered no) (tpos-r ?y) (tpos-c ?x))
  =>
  (modify ?k (time (+ ?time 12)) (step (+ ?step 1)) (content dessert) (loaded (getLoaded (+ ?free 1))) (free (+ ?free 1)))
  (modify ?k-dessertstatus (time ?time) (step ?step) (delivered yes))
)

(defrule deliveryDessert
  (declare (salience 10))
  (exec (step ?step) (action DeliveryDessert) (param1 ?y) (param2 ?x))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (waste no) (content $?cont))
  (test (member$ dessert $?cont))
  (perc-vision (step ?step) (time ?time) (perc2 Table))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  ?k-dessertstatus <- (K-dessertstatus (delivered no) (tpos-r ?y) (tpos-c ?x))
  =>
  (modify ?k (time (+ ?time 12)) (step (+ ?step 1)) (content (delete-member$ $?cont dessert)) (loaded (getLoaded (+ ?free 1))) (free (+ ?free 1)))
  (modify ?k-dessertstatus (time ?time) (step ?step) (delivered yes))
)

(defrule deliveryPill
  (declare (salience 10))
  (exec (step ?step) (action DeliveryPill) (param1 ?y) (param2 ?x) (param3 ?patient))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (waste no) (content $?cont))
  (test (member$ ?patient $?cont))
  (perc-vision (step ?step) (time ?time) (perc2 Table))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  ?k-pillstatus <- (K-pillstatus (for ?patient))
  =>
  (modify ?k (time (+ ?time 8)) (step (+ ?step 1)) (content (delete-member$ $?cont ?patient)) (loaded (getLoaded (+ ?free 1))) (free (+ ?free 1)))
  (modify ?k-pillstatus (time ?time) (step ?step) (delivered yes))
)

(defrule cleanTable
  (declare (salience 10))
  (exec (step ?step) (action CleanTable) (param1 ?y) (param2 ?x))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (loaded no))
  (perc-vision (step ?step) (time ?time) (perc2 Table))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  ?k-tablestatus <- (K-tablestatus (pos-r ?y) (pos-c ?x) (clean no))
  =>
  (modify ?k (waste yes) (time (+ ?time 30)) (step (+ ?step 1)))
  (modify ?k-tablestatus (clean yes))
)

(defrule emptyRobot
  (declare (salience 10))
  (exec (step ?step) (action EmptyRobot) (param1 ?y) (param2 ?x))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (loaded yes))
  (perc-vision (step ?step) (time ?time) (perc2 TrashBasket))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  =>
  (modify ?k (time (+ ?time 20)) (step (+ ?step 1)) (loaded no) (free 2))
)

(defrule releaseTrash
  (declare (salience 10))
  (exec (step ?step) (action ReleaseTrash) (param1 ?y) (param2 ?x))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir) (free ?free) (waste yes))
  (perc-vision (step ?step) (time ?time) (perc2 TrashBasket))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  =>
  (modify ?k (time (+ ?time 10)) (step (+ ?step 1)) (waste no))
)

(defrule done
  (declare (salience 10))
  (exec (step ?step) (action Done))
  ?k <- (K-agent (step ?step))
  =>
  (halt)
)

(defrule checkId
  (declare (salience 10))
  (exec (step ?step) (action CheckId) (param1 ?y) (param2 ?x))
  ?k <- (K-agent (time ?time) (step ?step) (pos-r ?r) (pos-c ?c) (direction ?dir))
  (perc-vision (step ?step) (time ?time) (perc2 PersonSeated|PersonStanding))
  (test (= ?x (getForwardC ?dir ?c)))
  (test (= ?y (getForwardR ?dir ?r)))
  =>
  (modify ?k (time (+ ?time 20)) (step (+ ?step 1)))
)

(defrule informMeal
  (declare (salience 10))
  (exec (step ?step) (action Inform) (param1 ?receiver) (param2 meal) (param3 ?answer))
  ?k <- (K-agent (time ?time) (step ?step))
  ?k-mealstatus <- (K-mealstatus (requested-by ?receiver))
  =>
  (printout t "inform meal to " ?receiver ", answer: " ?answer)
  (modify ?k (time (+ ?time 1)) (step (+ ?step 1)))
  (modify ?k-mealstatus (time ?time) (step ?step) (answer ?answer))
)

(defrule informDessert
  (declare (salience 10))
  (exec (step ?step) (action Inform) (param1 ?receiver) (param2 dessert) (param3 ?answer))
  ?k <- (K-agent (time ?time) (step ?step))
  ?k-dessertstatus <- (K-dessertstatus (requested-by ?receiver))
  =>
  (printout t "inform dessert to " ?receiver ", answer: " ?answer)
  (modify ?k (time (+ ?time 1)) (step (+ ?step 1)))
  (modify ?k-dessertstatus (time ?time) (step ?step) (answer ?answer))
)
