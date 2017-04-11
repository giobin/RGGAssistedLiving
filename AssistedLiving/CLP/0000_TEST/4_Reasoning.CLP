; ;; Modulo per la definizione dei meccanismi di reasoning dell'agente

; ;; MODULO REASONING

(defmodule REASONING (import MAIN ?ALL)(import AGENT ?ALL)(export ?ALL))

(deftemplate main-goal
  (slot id)
  (slot k-request)
  (slot request-type)
)

(deftemplate sub-goal
  (slot goal-ref)
  (slot id)
  (slot pos-r-target)
  (slot pos-c-target)
  (slot action-to-do)
)

;prossimo sub-goal di cui stiamo creando il piano
(deftemplate current-sub-goal
  (slot goal-ref)
  (slot id)
  (slot pos-r-target)
  (slot pos-c-target)
  (slot action-to-do)
)

(defrule piano-di-prova
  (not(plan-action))
  =>
  (assert (current-sub-goal (goal-ref 1) (id 1) (pos-r-target 4) (pos-c-target 4)))
  (focus BFSEARCH)
)

(defrule create-plan
  ?f <- (plan-action-aux (plan-step ?ps) (action ?action) (param1 ?p1) (param2 ?p2) (param3 ?p3))
  =>
  (assert (plan-action (plan-step ?ps) (action ?action) (param1 ?p1) (param2 ?p2) (param3 ?p3)))
  (retract ?f)
)



; Crea uno stupido piano di prova
; (defrule create-test-plan
;   (not
;     (plan-action)
;   )
;   =>
;   (assert
;     (plan-action (plan-step -1)(action Wait) )
;     (plan-action (plan-step 0)(action Turnleft) )
;     (plan-action (plan-step 1)(action Turnleft) )
;     (plan-action (plan-step 2)(action Forward) )
;     (plan-action (plan-step 3)(action Inform) (param1 P2) (param2 meal) (param3 yes) )
;     (plan-action (plan-step 4)(action Forward) )
;     (plan-action (plan-step 5)(action Turnleft) )
;     (plan-action (plan-step 6)(action Forward) )
;     (plan-action (plan-step 7)(action Turnleft) )
;     (plan-action (plan-step 8)(action Forward) )
;     (plan-action (plan-step 9)(action LoadMeal) (param1 8) (param2 7) (param3 normal) )
;     (plan-action (plan-step 10)(action Turnleft) )
;     (plan-action (plan-step 11) (action Turnleft) )
;     (plan-action (plan-step 12)(action Forward) )
;     (plan-action (plan-step 13)(action Forward) )
;     (plan-action (plan-step 14)(action Turnright) )
;     (plan-action (plan-step 15)(action Forward) )
;     (plan-action (plan-step 16)(action Forward) )
;     (plan-action (plan-step 17) (action Forward) )
;     (plan-action (plan-step 18)(action Turnleft) )
;     (plan-action (plan-step 19)(action DeliveryMeal)(param1 4) (param2 4) (param3 normal) )
;     (plan-action (plan-step 20)(action Turnleft) )
;     (plan-action (plan-step 21)(action Forward) )
;     (plan-action (plan-step 22)(action Turnleft) )
;     (plan-action (plan-step 23)(action Forward) )
;     (plan-action (plan-step 24)(action Forward) )
;     (plan-action (plan-step 25)(action LoadDessert)(param1 8) (param2 5) )
;     (plan-action (plan-step 26)(action Turnleft) )
;     (plan-action (plan-step 27)(action Turnleft) )
;     (plan-action (plan-step 28)(action Forward) )
;     (plan-action (plan-step 29)(action Forward) )
;     (plan-action (plan-step 30)(action Turnright) )
;     (plan-action (plan-step 31)(action Forward) )
;     (plan-action (plan-step 32) (action Turnleft) )
;     (plan-action (plan-step 33)(action DeliveryDessert)(param1 4)(param2 4) )
;     (plan-action (plan-step 34)(action Turnleft) )
;     (plan-action (plan-step 35)(action Forward) )
;     (plan-action (plan-step 36)(action Forward) )
;     (plan-action (plan-step 37)(action Turnleft) )
;     (plan-action (plan-step 38)(action Turnleft) )
;     (plan-action (plan-step 39)(action Forward) )
;     (plan-action (plan-step 40)(action Forward) )
;     (plan-action (plan-step 41)(action Turnleft) )
;     (plan-action (plan-step 42)(action CleanTable)(param1 4) (param2 4) )
;     (plan-action (plan-step 43)(action Turnleft) )
;     (plan-action (plan-step 44)(action Forward) )
;     (plan-action (plan-step 45)(action Forward) )
;     (plan-action (plan-step 46)(action Turnleft) )
;     (plan-action (plan-step 47)(action Forward) )
;     (plan-action (plan-step 48)(action Forward) )
;     (plan-action (plan-step 49)(action Forward) )
;     (plan-action (plan-step 50)(action ReleaseTrash)(param1 9) (param2 6) )
;     (plan-action (plan-step 51)(action Turnleft) )
;     (plan-action (plan-step 52)(action Turnleft) )
;     (plan-action (plan-step 53)(action Forward) )
;     (plan-action (plan-step 54)(action Done) )
;    )
; )
