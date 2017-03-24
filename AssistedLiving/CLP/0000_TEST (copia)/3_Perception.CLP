(defmodule PERCEPTION (import MAIN ?ALL) (import AGENT ?ALL) (export ?ALL))



;fixme: 
; -----------------------------------
; --- Ultime regole di perception ---
; -----------------------------------
(defrule update-last-perc
  (declare (salience -1))
  (status (step ?s))
  ?last-perc <- (last-perc (step ?l))
  (test (> ?s ?l))
  =>
  (modify ?last-perc (step ?s))
)
