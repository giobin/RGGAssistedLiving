


(defmodule BFSEARCH (import REASONING ?ALL)(export ?ALL))

(deftemplate node
  (slot ident)
  (slot gcost)
  (slot father)
  (slot pos-r)
  (slot pos-c)
  (slot open)
)

(deftemplate newnode
  (slot ident)
  (slot gcost)
  (slot father)
  (slot pos-r)
  (slot pos-c)
)

(defrule create-initial-state
  ?k-agent <- (K-agent (pos-r ?r) (pos-c ?c))
  ?f <- (current-sub-goal (pos-r-target) (pos-c-target))
  =>
  (assert (node (ident 0) (gcost 0) (father NA) (pos-r ?r) (pos-c ?c) (open yes)))
  (assert (current 0))
  (assert (lastnode 0))
  (assert (open-worse 0))
  (assert (open-better 0))
  (assert (alreadyclosed 0))
  (assert (numberofnodes 0))
  (assert (goal ?r ?c))
)
