;// AGENT


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

; arriva da rescue, non so cosa serva
(deftemplate K-person
  (slot step)
  (slot time)
  (slot pos-r)
  (slot pos-c)
)

; arriva da rescue, non so cosa serva
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
