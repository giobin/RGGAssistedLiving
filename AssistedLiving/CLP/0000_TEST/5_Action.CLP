; ;; Modulo per la definizione delle azioni da eseguire

; ;; MODULO ACTION




(defmodule ACTION (import MAIN ?ALL)(import AGENT ?ALL)(export ?ALL))

(defrule agent-bumped
  (status (step ?step))
  ?f <- (special-condition
    (bumped yes)
  )
  =>
  (retract ?f)
)

; genera le exec in base alle plan-action
(defrule make-exec-action
   ?plan-action <- (plan-action (action ?action) (plan-step ?ps)(param1 ?p1) (param2 ?p2) (param3 ?p3))
   (status (step ?s))
   (not ( and
           (plan-action (plan-step ?ps2))
           (test (< ?ps2 ?ps))
        )
   )
   (not (exec (step ?s)))
   =>
   (assert (exec (action ?action) (step ?s) (param1 ?p1) (param2 ?p2) (param3 ?p3)))
   (retract ?plan-action)
)
