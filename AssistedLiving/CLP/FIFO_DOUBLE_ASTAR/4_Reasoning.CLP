; ;; Modulo per la definizione dei meccanismi di reasoning dell'agente

; ;; MODULO REASONING

(defmodule REASONING (import MAIN ?ALL)(import AGENT ?ALL)(export ?ALL))

(deftemplate main-goal
  (slot id)
  (slot k-request)
  (slot request-type (allowed-values  LoadMeal LoadPill LoadDessert
                                      DeliveryMeal DeliveryPill DeliveryDessert
                                      CleanTable EmptyRobot ReleaseTrash CheckId
                                      Inform Done))
)

(deftemplate sub-goal
  (slot goal-ref)
  (slot id)
  (slot pos-r-target)
  (slot pos-c-target)
  (slot action-to-do)
  (slot param1)
  (slot param2)
  (slot param3)
  (slot param4)
)

;prossimo sub-goal di cui stiamo creando il piano
(deftemplate current-sub-goal
  (slot goal-ref)
  (slot id)
  (slot pos-r-target)
  (slot pos-c-target)
  (slot action-to-do)
  (slot param1)
  (slot param2)
  (slot param3)
  (slot param4)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                         REPLANNING                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;la prossima azione è una Forward
(defrule action-unfeasible
  (declare (salience 80))
  (not (replanning))
  (status (time ?time))
  (perc-vision (step ?step) (time ?time) (perc2 PersonStanding))
  (plan-action (plan-step ?ps) (action Forward))
  (not (plan-action (plan-step ?plan-step&:(< ?plan-step ?ps))))
  =>
  (printout t "Non puoi eseguire Forward!" crlf)
  (assert (replanning))
)

(defrule cancel-plan
  (declare (salience 80))
  (replanning)
  ?k <- (plan-action)
  =>
  (printout t "Cancello piano" crlf)
  (retract ?k)
)

(defrule create-new-plan
  (declare (salience 80))
  ?k <- (replanning)
  (not (plan-action))
  =>
  (retract ?k)
  (printout t "Entro in A-STAR" crlf)
  (focus A-STAR)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                    END REPLANNING                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defrule clear-sub-goal-failure
  (declare (salience 70))
  (failure)
  ?current-sub-goal <- (current-sub-goal)
  =>
  (retract ?current-sub-goal)
)

(defrule create-meal-inform
  (declare (salience 100))
  (not (plan-action (plan-step 0) (action Inform) (param1 ?patient) (param2 meal)))
  ?K-mealstatus <- (K-mealstatus (arrivaltime ?request-time) (requested-by ?patient) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered no) (answer pending))
  ?prescription <- (prescription (patient ?patient) (pills ?pills))  ;prendo le prescription del paziente
  =>
  (if (eq ?pills before) then
    (assert (plan-action (plan-step 0) (action Inform) (param1 ?patient) (param2 meal) (param3 wait)))  ;plan-step 1 perchè è semplicemente una singola plan action e viene fatta se non ci sono altre plan action
  else
    (assert (plan-action (plan-step 0) (action Inform) (param1 ?patient) (param2 meal) (param3 yes)))  ;plan-step 1 perchè è semplicemente una singola plan action e viene fatta se non ci sono altre plan action
  )
)

(defrule create-dessert-inform-YES
  (declare (salience 100))
  (not (plan-action (plan-step 0) (action Inform) (param1 ?patient) (param2 dessert)))
  ?K-dessertstatus <- (K-dessertstatus (arrivaltime ?request-time) (requested-by ?patient) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered no) (answer pending))
  ?K-pillstatus <- (K-pillstatus (for ?patient) (delivered ?pillsdelivered))
  ?prescription <- (prescription (patient ?patient) (pills ?pills) (dessert yes))  ;prendo le prescription del paziente
  =>
  (if (and (eq ?pills after) (eq ?pillsdelivered no)) then
    (assert (plan-action (plan-step 0) (action Inform) (param1 ?patient) (param2 dessert) (param3 wait)))  ;plan-step 1 perchè è semplicemente una singola plan action e viene fatta se non ci sono altre plan action
  else
    (assert (plan-action (plan-step 0) (action Inform) (param1 ?patient) (param2 dessert) (param3 yes)))  ;plan-step 1 perchè è semplicemente una singola plan action e viene fatta se non ci sono altre plan action
  )
)

(defrule create-dessert-inform-NO
  (declare (salience 100))
  (not (plan-action (plan-step 0) (action Inform) (param1 ?patient) (param2 dessert)))
  ?K-dessertstatus <- (K-dessertstatus (arrivaltime ?request-time) (requested-by ?patient) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered no) (answer pending))
  ?prescription <- (prescription (patient ?patient) (pills ?pills) (dessert no))  ;prendo le prescription del paziente
  =>
  (assert (plan-action (plan-step 0) (action Inform) (param1 ?patient) (param2 dessert) (param3 reject)))  ;plan-step 1 perchè è semplicemente una singola plan action e viene fatta se non ci sono altre plan action
)

(defrule create-goal-wait
  (declare (salience 10))
  (not (plan-action))
  =>
  (assert (plan-action (plan-step -1) (action Wait)))
)

(defrule create-goal-done
  (declare (salience 80))
  (status (time ?time))
  (maxduration ?maxduration)
  (test (> ?time (- ?maxduration 30)))
  =>
  (assert (plan-action (plan-step -2) (action Done)))
)

;se il vecchio ha chiesto il dessert possiamo pulire subito il tavolo
(defrule create-first-goal-clean-dessert-table
  (declare (salience 40))
  (status (time ?time))
  ?K-mealstatus <- (K-mealstatus (tpos-r ?tpos-r) (tpos-c ?tpos-c) (delivered yes) (delivertime ?deliveredtime) (requested-by ?patient))
  ?K-tablestatus <- (K-tablestatus (pos-r ?tpos-r) (pos-c ?tpos-c) (clean no))
  ?K-dessertstatus <- (K-dessertstatus (requested-by ?patient))
  (test (> ?time (+ ?deliveredtime 1)))
  (not (main-goal (id 2) (k-request ?K-tablestatus)))
  (not (main-goal (id 2) (request-type DeliveryMeal|DeliveryDessert|DeliveryPill)))
  (not (main-goal (id 1)))
  =>
  (assert (main-goal (id 1) (k-request ?K-tablestatus) (request-type CleanTable)))
  (printout t "create-first-goal-clean-dessert-table")
)

(defrule create-second-goal-clean-dessert-table
  (declare (salience 40))
  (status (time ?time))
  ?K-mealstatus <- (K-mealstatus (tpos-r ?tpos-r) (tpos-c ?tpos-c) (delivered yes) (delivertime ?deliveredtime) (requested-by ?patient))
  ?K-tablestatus <- (K-tablestatus (pos-r ?tpos-r) (pos-c ?tpos-c) (clean no))
  ?K-dessertstatus <- (K-dessertstatus (requested-by ?patient))
  (test (> ?time (+ ?deliveredtime 1)))
  (not (main-goal (id 1) (k-request ?K-tablestatus)))
  (not (main-goal (id 1) (request-type DeliveryMeal|DeliveryDessert|DeliveryPill)))
  (not (main-goal (id 2)))
  =>
  (assert (main-goal (id 2) (k-request ?K-tablestatus) (request-type CleanTable)))
  (printout t "create-second-goal-clean-dessert-table")
)

;se non ha chiesto dessert allora per pulire deve essere passato 500 time
(defrule create-first-goal-clean-table
  (declare (salience 40))
  (status (time ?time))
  ?K-mealstatus <- (K-mealstatus (tpos-r ?tpos-r) (tpos-c ?tpos-c) (delivered yes) (delivertime ?deliveredtime) (requested-by ?patient))
  ?K-tablestatus <- (K-tablestatus (pos-r ?tpos-r) (pos-c ?tpos-c) (clean no))
  (test (> ?time (+ ?deliveredtime 500)))
  (not (main-goal (id 2) (k-request ?K-tablestatus)))
  (not (main-goal (id 2) (request-type DeliveryMeal|DeliveryDessert|DeliveryPill)))
  (not (main-goal (id 1)))
  =>
  (assert (main-goal (id 1) (k-request ?K-tablestatus) (request-type CleanTable)))
  (printout t "create-first-goal-clean-table")
)

(defrule create-second-goal-clean-table
  (declare (salience 40))
  (status (time ?time))
  ?K-mealstatus <- (K-mealstatus (tpos-r ?tpos-r) (tpos-c ?tpos-c) (delivered yes) (delivertime ?deliveredtime) (requested-by ?patient))
  ?K-tablestatus <- (K-tablestatus (pos-r ?tpos-r) (pos-c ?tpos-c) (clean no))
  (test (> ?time (+ ?deliveredtime 500)))
  (not (main-goal (id 1) (k-request ?K-tablestatus)))
  (not (main-goal (id 1) (request-type DeliveryMeal|DeliveryDessert|DeliveryPill)))
  (not (main-goal (id 2)))
  =>
  (assert (main-goal (id 2) (k-request ?K-tablestatus) (request-type CleanTable)))
  (printout t "create-second-goal-clean-table")
)

;crea il piano generale per servire le richieste di meal
(defrule create-first-goal-meal
  (declare (salience 50))
  ?K-mealstatus <- (K-mealstatus (arrivaltime ?request-time) (requested-by ?sender) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered no) (answer wait | yes) )
  (not (main-goal (id 2) (k-request ?K-mealstatus)))
  (not (K-mealstatus (arrivaltime ?request-time2&:(< ?request-time2 ?request-time)) (delivered no) (answer wait | yes)))
  (not (main-goal (id 1)))
  =>
  (assert (main-goal (id 1) (k-request ?K-mealstatus) (request-type DeliveryMeal)))
)

(defrule create-second-goal-meal
  (declare (salience 50))
  ?K-mealstatus <- (K-mealstatus (arrivaltime ?request-time) (requested-by ?sender) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered no) (answer wait | yes) )
  (not (main-goal (id 1) (k-request ?K-mealstatus)))
  (not (K-mealstatus (arrivaltime ?request-time2&:(< ?request-time2 ?request-time)) (delivered no) (answer wait | yes)))
  (not (main-goal (id 2)))
  =>
  (assert (main-goal (id 2) (k-request ?K-mealstatus) (request-type DeliveryMeal)))
)

(defrule create-first-goal-dessert-pillafter
  (declare (salience 50))
  (K-mealstatus (arrivaltime ?request-time) (requested-by ?sender) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered yes))
  (K-pillstatus (for ?sender) (when after) (delivered yes))
  ?k-dessertstatus <- (K-dessertstatus (delivered no) (requested-by ?sender) (answer wait | yes))
  (not (main-goal (id 1)))
  (not (main-goal (id 2) (k-request ?k-dessertstatus)))
  =>
  (assert (main-goal (id 1) (k-request ?k-dessertstatus) (request-type DeliveryDessert)))
)

(defrule create-first-goal-dessert
  (declare (salience 50))
  (K-mealstatus (arrivaltime ?request-time) (requested-by ?sender) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered yes))
  (K-pillstatus (for ?sender) (when ~after))
  ?k-dessertstatus <- (K-dessertstatus (delivered no) (requested-by ?sender) (answer wait | yes))
  (not (main-goal (id 1)))
  (not (main-goal (id 2) (k-request ?k-dessertstatus)))
  =>
  (assert (main-goal (id 1) (k-request ?k-dessertstatus) (request-type DeliveryDessert)))
)

(defrule create-second-goal-dessert-pillafter
  (declare (salience 50))
  (K-mealstatus (arrivaltime ?request-time) (requested-by ?sender) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered yes))
  (K-pillstatus (for ?sender) (when after) (delivered yes))
  ?k-dessertstatus <- (K-dessertstatus (delivered no) (requested-by ?sender) (answer wait | yes))
  (not (main-goal (id 2)))
  (not (main-goal (id 1) (k-request ?K-dessertstatus)))
  =>
  (assert (main-goal (id 2) (k-request ?k-dessertstatus) (request-type DeliveryDessert)))
)

(defrule create-second-goal-dessert
  (declare (salience 50))
  (K-mealstatus (arrivaltime ?request-time) (requested-by ?sender) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered yes))
  ?k-dessertstatus <- (K-dessertstatus (delivered no) (requested-by ?sender) (answer wait | yes))
  (K-pillstatus (for ?sender) (when ~after))
  (not (main-goal (id 2)))
  (not (main-goal (id 1) (k-request ?K-dessertstatus)))
  =>
  (assert (main-goal (id 2) (k-request ?k-dessertstatus) (request-type DeliveryDessert)))
)

(defrule create-sub-goals-clean-table
  (declare (salience 50))
  ?main-goal <- (main-goal (id ?id) (k-request ?x))
  (not (sub-goal (goal-ref ?id)))
  ?y <- (K-tablestatus (pos-r ?tpos-r) (pos-c ?tpos-c))
  (test (eq ?x ?y))
  ?trashbasket <- (K-cell (pos-r ?trash_pos_r) (pos-c ?trash_pos_c) (contains TrashBasket))
  =>
  (assert (sub-goal (goal-ref ?id) (id 1) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do CleanTable) (param1 ?tpos-r) (param2 ?tpos-c)))
  (assert (sub-goal (goal-ref ?id) (id 2) (pos-r-target ?trash_pos_r) (pos-c-target ?trash_pos_c) (action-to-do ReleaseTrash) (param1 ?trash_pos_r) (param2 ?trash_pos_c)))
)

(defrule create-sub-goals-meal
  (declare (salience 50))
  ?main-goal <- (main-goal (id ?id) (k-request ?x))
  (not (sub-goal (goal-ref ?id)))  ;controllo che non ci siano già dei sub-goal da portare a termine
  ?y <- (K-mealstatus (arrivaltime ?arrivaltime) (type ?type) (requested-by ?requested-by) (tpos-r ?tpos-r) (tpos-c ?tpos-c) (delivered ?delivered) (delivertime ?delivertime) (answer ?answer))
  (test (eq ?x ?y))
  ?k-tablestatus <- (K-tablestatus (pos-r ?tpos-r) (pos-c ?tpos-c) (clean ?clean))  ;mi serve per sapere se il tavolo è pulito e le sue coordinate
  ?prescription <- (prescription (patient ?requested-by) (pills ?pills) (meal ?meal))  ;prendo le prescription del paziente
  ?trashbasket <- (K-cell (pos-r ?trash_pos_r) (pos-c ?trash_pos_c) (contains TrashBasket))  ;coordinate spazzatura
  ?pilldispenser <- (K-cell (pos-r ?pill_pos_r) (pos-c ?pill_pos_c) (contains PillDispenser))  ;coordinate pilldispenser
  ?mealdispenser <- (K-cell (pos-r ?meal_pos_r) (pos-c ?meal_pos_c) (contains MealDispenser))  ;coordinate mealdispenser
  =>
  ; (if (eq ?pills before) then
  ;   (assert (sub-goal (goal-ref 1) (id 0) (action-to-do Inform) (param1 ?requested-by) (param2 meal) (param3 wait)))
  ; else
  ;   (assert (sub-goal (goal-ref 1) (id 0) (action-to-do Inform) (param1 ?requested-by) (param2 meal) (param3 yes)))
  ; )
  (if (neq ?clean yes) then
    (assert (sub-goal (goal-ref ?id) (id 1) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do CleanTable) (param1 ?tpos-r) (param2 ?tpos-c)))
    (assert (sub-goal (goal-ref ?id) (id 2) (pos-r-target ?trash_pos_r) (pos-c-target ?trash_pos_c) (action-to-do ReleaseTrash) (param1 ?trash_pos_r) (param2 ?trash_pos_c))))
  (if (eq ?pills before) then
    (assert (sub-goal (goal-ref ?id) (id 3) (pos-r-target ?pill_pos_r) (pos-c-target ?pill_pos_c) (action-to-do LoadPill) (param1 ?pill_pos_r) (param2 ?pill_pos_c) (param3 ?requested-by)))
    (assert (sub-goal (goal-ref ?id) (id 4) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do DeliveryPill) (param1 ?tpos-r) (param2 ?tpos-c) (param3 ?requested-by)))
    (assert (sub-goal (goal-ref ?id) (id 5) (pos-r-target ?meal_pos_r) (pos-c-target ?meal_pos_c) (action-to-do LoadMeal) (param1 ?meal_pos_r) (param2 ?meal_pos_c) (param3 ?meal)))
    (assert (sub-goal (goal-ref ?id) (id 6) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do DeliveryMeal) (param1 ?tpos-r) (param2 ?tpos-c) (param3 ?meal))))
  (if (eq ?pills after) then
    (assert (sub-goal (goal-ref ?id) (id 3) (pos-r-target ?meal_pos_r) (pos-c-target ?meal_pos_c) (action-to-do LoadMeal) (param1 ?meal_pos_r) (param2 ?meal_pos_c) (param3 ?meal)))
    (assert (sub-goal (goal-ref ?id) (id 4) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do DeliveryMeal) (param1 ?tpos-r) (param2 ?tpos-c) (param3 ?meal)))
    (assert (sub-goal (goal-ref ?id) (id 5) (pos-r-target ?pill_pos_r) (pos-c-target ?pill_pos_c) (action-to-do LoadPill) (param1 ?pill_pos_r) (param2 ?pill_pos_c) (param3 ?requested-by)))
    (assert (sub-goal (goal-ref ?id) (id 6) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do DeliveryPill) (param1 ?tpos-r) (param2 ?tpos-c) (param3 ?requested-by))))
  (if (eq ?pills no) then
    (assert (sub-goal (goal-ref ?id) (id 3) (pos-r-target ?meal_pos_r) (pos-c-target ?meal_pos_c) (action-to-do LoadMeal) (param1 ?meal_pos_r) (param2 ?meal_pos_c) (param3 ?meal)))
    (assert (sub-goal (goal-ref ?id) (id 4) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do DeliveryMeal) (param1 ?tpos-r) (param2 ?tpos-c) (param3 ?meal))))
)

(defrule create-sub-goals-dessert-YES
  (declare (salience 50))
  ?main-goal <- (main-goal (id ?id) (k-request ?x))
  (not (sub-goal (goal-ref ?id)))  ;controllo che non ci siano già dei sub-goal da portare a termine
  ?y <- (K-dessertstatus (arrivaltime ?arrivaltime) (requested-by ?requested-by) (tpos-r ?tpos-r) (tpos-c ?tpos-c) (delivered ?delivered) (answer ?answer))
  (test (eq ?x ?y))
  ?prescription <- (prescription (patient ?requested-by) (dessert yes))
  ?dessertdispenser <- (K-cell (pos-r ?dessert_pos_r) (pos-c ?dessert_pos_c) (contains DessertDispenser))  ;coordinate dessert dispender
  =>
  (assert (sub-goal (goal-ref ?id) (id 3) (pos-r-target ?dessert_pos_r) (pos-c-target ?dessert_pos_c) (action-to-do LoadDessert) (param1 ?dessert_pos_r) (param2 ?dessert_pos_c)))
  (assert (sub-goal (goal-ref ?id) (id 4) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do DeliveryDessert) (param1 ?tpos-r) (param2 ?tpos-c)))
)

; (defrule create-sub-goals-dessert-NO
;   (declare (salience 50))
;   ?main-goal <- (main-goal (id 1) (k-request ?x))
;   (not (sub-goal))  ;controllo che non ci siano già dei sub-goal da portare a termine
;   ?y <- (K-dessertstatus (arrivaltime ?arrivaltime) (requested-by ?requested-by) (tpos-r ?tpos-r) (tpos-c ?tpos-c) (delivered ?delivered) (answer ?answer))
;   (test (eq ?x ?y))
;   ?prescription <- (prescription (patient ?requested-by) (dessert no))
;   =>
;   (assert (sub-goal (goal-ref 1) (id 1) (action-to-do Inform) (param1 ?requested-by) (param2 dessert) (param3 reject)))
; )

(defrule create-current-sub-goal-clean
  (declare (salience 49))
  (not(plan-action))
  ?last-current <- (last-current ? ?)
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do CleanTable) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  =>
  (retract ?last-current)
  (assert (last-current ?goalid CleanTable))
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do CleanTable) (param1 ?param1) (param2 ?param2) (param3 ?param3)))
  (focus A-STAR)
)

(defrule create-current-sub-goal-relase-KO
  (declare (salience 48))
  (not(plan-action))
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do ReleaseTrash) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  ?last-current <- (last-current ? ReleaseTrash)
  =>
  (retract ?sub-goal)
)

(defrule create-current-sub-goal-relase-OK-twotrashbasket
  (declare (salience 48))
  (not(plan-action))
  ?last-current <- (last-current ? ~ReleaseTrash)
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (action-to-do ReleaseTrash) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  ?trashbasket <- (K-cell (pos-r ?trash_pos_r) (pos-c ?trash_pos_c) (contains TrashBasket))
  ?trashbasket2 <- (K-cell (pos-r ?trash_pos_r2) (pos-c ?trash_pos_c2) (contains TrashBasket))
  (K-agent (pos-r ?r-agent) (pos-c ?c-agent))
  (test (neq ?trashbasket ?trashbasket2))
  (not (test (< (+ (abs (- ?trash_pos_r2 ?r-agent)) (abs (- ?trash_pos_c2 ?c-agent))) (+ (abs (- ?trash_pos_r ?r-agent )) (abs (- ?trash_pos_c ?c-agent))))))
  =>
  (retract ?last-current)
  (assert (last-current ?goalid ReleaseTrash))
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?trash_pos_r) (pos-c-target ?trash_pos_c) (action-to-do ReleaseTrash) (param1 ?trash_pos_r) (param2 ?trash_pos_c) (param3 ?param3)))
  (focus A-STAR)
)

(defrule create-current-sub-goal-relase-OK
  (declare (salience 48))
  (not(plan-action))
  ?last-current <- (last-current ? ~ReleaseTrash)
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (action-to-do ReleaseTrash) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  =>
  (retract ?last-current)
  (assert (last-current ?goalid ReleaseTrash))
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?param1) (pos-c-target ?param2) (action-to-do ReleaseTrash) (param1 ?param1) (param2 ?param2) (param3 ?param3)))
  (focus A-STAR)
)

(defrule create-current-sub-goal1-loadpill-twopilldispenser
  (declare (salience 47))
  (not(plan-action))
  ?last-current<- (last-current ?last-goalid ?)
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do LoadPill) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (test (neq ?last-goalid ?goalid))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  (K-agent (pos-r ?r-agent) (pos-c ?c-agent))
  ?pilldispenser <- (K-cell (pos-r ?pill_pos_r) (pos-c ?pill_pos_c) (contains PillDispenser))
  ?pilldispenser2 <- (K-cell (pos-r ?pill_pos_r2) (pos-c ?pill_pos_c2) (contains PillDispenser))
  (test (neq ?pilldispenser ?pilldispenser2))
  (not (test (< (+ (abs (- ?pill_pos_r2 ?r-agent)) (abs (- ?pill_pos_c2 ?c-agent))) (+ (abs (- ?pill_pos_r ?r-agent )) (abs (- ?pill_pos_c ?c-agent))))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pill_pos_r) (pos-c-target ?pill_pos_c) (action-to-do LoadPill) (param1 ?pill_pos_r) (param2 ?pill_pos_c) (param3 ?param3)))
  (assert (last-current ?goalid LoadPill))
  (retract ?last-current)
  (focus A-STAR)
)

(defrule create-current-sub-goal1-loadmeal-twomealdispenser
  (declare (salience 47))
  (not(plan-action))
  ?last-current<- (last-current ?last-goalid ?)
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do LoadMeal) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (test (neq ?last-goalid ?goalid))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  (K-agent (pos-r ?r-agent) (pos-c ?c-agent))
  ?mealdispenser <- (K-cell (pos-r ?meal_pos_r) (pos-c ?meal_pos_c) (contains MealDispenser))
  ?mealdispenser2 <- (K-cell (pos-r ?meal_pos_r2) (pos-c ?meal_pos_c2) (contains MealDispenser))
  (test (neq ?mealdispenser ?mealdispenser2))
  (not (test (< (+ (abs (- ?meal_pos_r2 ?r-agent)) (abs (- ?meal_pos_c2 ?c-agent))) (+ (abs (- ?meal_pos_r ?r-agent )) (abs (- ?meal_pos_c ?c-agent))))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?meal_pos_r) (pos-c-target ?meal_pos_c) (action-to-do LoadMeal) (param1 ?meal_pos_r) (param2 ?meal_pos_c) (param3 ?param3)))
  (assert (last-current ?goalid LoadMeal))
  (retract ?last-current)
  (focus A-STAR)
)

(defrule create-current-sub-goal1-loaddessert-twodessertdispenser
  (declare (salience 47))
  (not(plan-action))
  ?last-current<- (last-current ?last-goalid ?)
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do LoadDessert) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (test (neq ?last-goalid ?goalid))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  (K-agent (pos-r ?r-agent) (pos-c ?c-agent))
  ?dessertdispenser <- (K-cell (pos-r ?dessert_pos_r) (pos-c ?dessert_pos_c) (contains DessertDispenser))
  ?dessertdispenser2 <- (K-cell (pos-r ?dessert_pos_r2) (pos-c ?dessert_pos_c2) (contains DessertDispenser))
  (test (neq ?dessertdispenser ?dessertdispenser2))
  (not (test (< (+ (abs (- ?dessert_pos_r2 ?r-agent)) (abs (- ?dessert_pos_c2 ?c-agent))) (+ (abs (- ?dessert_pos_r ?r-agent )) (abs (- ?dessert_pos_c ?c-agent))))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?dessert_pos_r) (pos-c-target ?dessert_pos_c) (action-to-do LoadDessert) (param1 ?dessert_pos_r) (param2 ?dessert_pos_c) (param3 ?param3)))
  (assert (last-current ?goalid LoadDessert))
  (retract ?last-current)
  (focus A-STAR)
)

(defrule create-current-sub-goal1
  (declare (salience 47))
  (not(plan-action))
  ?last-current<- (last-current ?last-goalid ?)
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do ?action-to-do) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (test (neq ?last-goalid ?goalid))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do ?action-to-do) (param1 ?param1) (param2 ?param2) (param3 ?param3)))
  (assert (last-current ?goalid ?action-to-do))
  (retract ?last-current)
  (focus A-STAR)
)

(defrule create-current-sub-goal2-loadpill-twopilldispenser
  (declare (salience 46))
  (not(plan-action))
  (not (last-current ? ?))
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do LoadPill) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  (K-agent (pos-r ?r-agent) (pos-c ?c-agent))
  ?pilldispenser <- (K-cell (pos-r ?pill_pos_r) (pos-c ?pill_pos_c) (contains PillDispenser))
  ?pilldispenser2 <- (K-cell (pos-r ?pill_pos_r2) (pos-c ?pill_pos_c2) (contains PillDispenser))
  (test (neq ?pilldispenser ?pilldispenser2))
  (not (test (< (+ (abs (- ?pill_pos_r2 ?r-agent)) (abs (- ?pill_pos_c2 ?c-agent))) (+ (abs (- ?pill_pos_r ?r-agent )) (abs (- ?pill_pos_c ?c-agent))))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pill_pos_r) (pos-c-target ?pill_pos_c) (action-to-do LoadPill) (param1 ?pill_pos_r) (param2 ?pill_pos_c) (param3 ?param3)))
  (assert (last-current ?goalid LoadPill))
  (focus A-STAR)
)

(defrule create-current-sub-goal2-loadmeal-twomealdispenser
  (declare (salience 46))
  (not(plan-action))
  (not (last-current ? ?))
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do LoadMeal) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  (K-agent (pos-r ?r-agent) (pos-c ?c-agent))
  ?mealdispenser <- (K-cell (pos-r ?meal_pos_r) (pos-c ?meal_pos_c) (contains MealDispenser))
  ?mealdispenser2 <- (K-cell (pos-r ?meal_pos_r2) (pos-c ?meal_pos_c2) (contains MealDispenser))
  (test (neq ?mealdispenser ?mealdispenser2))
  (not (test (< (+ (abs (- ?meal_pos_r2 ?r-agent)) (abs (- ?meal_pos_c2 ?c-agent))) (+ (abs (- ?meal_pos_r ?r-agent )) (abs (- ?meal_pos_c ?c-agent))))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?meal_pos_r) (pos-c-target ?meal_pos_c) (action-to-do LoadMeal) (param1 ?meal_pos_r) (param2 ?meal_pos_c) (param3 ?param3)))
  (assert (last-current ?goalid LoadMeal))
  (focus A-STAR)
)

(defrule create-current-sub-goal2-loaddessert-twodessertdispenser
  (declare (salience 46))
  (not(plan-action))
  (not (last-current ? ?))
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do LoadDessert) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  (K-agent (pos-r ?r-agent) (pos-c ?c-agent))
  ?dessertdispenser <- (K-cell (pos-r ?dessert_pos_r) (pos-c ?dessert_pos_c) (contains DessertDispenser))
  ?dessertdispenser2 <- (K-cell (pos-r ?dessert_pos_r2) (pos-c ?dessert_pos_c2) (contains DessertDispenser))
  (test (neq ?dessertdispenser ?dessertdispenser2))
  (not (test (< (+ (abs (- ?dessert_pos_r2 ?r-agent)) (abs (- ?dessert_pos_c2 ?c-agent))) (+ (abs (- ?dessert_pos_r ?r-agent )) (abs (- ?dessert_pos_c ?c-agent))))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?dessert_pos_r) (pos-c-target ?dessert_pos_c) (action-to-do LoadDessert) (param1 ?dessert_pos_r) (param2 ?dessert_pos_c) (param3 ?param3)))
  (assert (last-current ?goalid LoadDessert))
  (focus A-STAR)
)

(defrule create-current-sub-goal2
  (declare (salience 46))
  (not(plan-action))
  (not (last-current ? ?))
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do ?action-to-do) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do ?action-to-do) (param1 ?param1) (param2 ?param2) (param3 ?param3)))
  (assert (last-current ?goalid ?action-to-do))
  (focus A-STAR)
)

(defrule create-current-sub-goal3-loadpill-twopilldispenser
  (declare (salience 45))
  (not(plan-action))
  (not (and (main-goal (id 1)) (main-goal (id 2))))
  ?last-current <- (last-current ? ?)
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do LoadPill) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  (K-agent (pos-r ?r-agent) (pos-c ?c-agent))
  ?pilldispenser <- (K-cell (pos-r ?pill_pos_r) (pos-c ?pill_pos_c) (contains PillDispenser))
  ?pilldispenser2 <- (K-cell (pos-r ?pill_pos_r2) (pos-c ?pill_pos_c2) (contains PillDispenser))
  (test (neq ?pilldispenser ?pilldispenser2))
  (not (test (< (+ (abs (- ?pill_pos_r2 ?r-agent)) (abs (- ?pill_pos_c2 ?c-agent))) (+ (abs (- ?pill_pos_r ?r-agent )) (abs (- ?pill_pos_c ?c-agent))))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pill_pos_r) (pos-c-target ?pill_pos_c) (action-to-do LoadPill) (param1 ?pill_pos_r) (param2 ?pill_pos_c) (param3 ?param3)))
  (assert (last-current ?goalid LoadPill))
  (retract ?last-current)
  (focus A-STAR)
)

(defrule create-current-sub-goal3-loadmeal-twomealdispenser
  (declare (salience 45))
  (not(plan-action))
  (not (and (main-goal (id 1)) (main-goal (id 2))))
  ?last-current <- (last-current ? ?)
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do LoadMeal) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  (K-agent (pos-r ?r-agent) (pos-c ?c-agent))
  ?mealdispenser <- (K-cell (pos-r ?meal_pos_r) (pos-c ?meal_pos_c) (contains MealDispenser))
  ?mealdispenser2 <- (K-cell (pos-r ?meal_pos_r2) (pos-c ?meal_pos_c2) (contains MealDispenser))
  (test (neq ?mealdispenser ?mealdispenser2))
  (not (test (< (+ (abs (- ?meal_pos_r2 ?r-agent)) (abs (- ?meal_pos_c2 ?c-agent))) (+ (abs (- ?meal_pos_r ?r-agent )) (abs (- ?meal_pos_c ?c-agent))))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?meal_pos_r) (pos-c-target ?meal_pos_c) (action-to-do LoadMeal) (param1 ?meal_pos_r) (param2 ?meal_pos_c) (param3 ?param3)))
  (assert (last-current ?goalid LoadMeal))
  (retract ?last-current)
  (focus A-STAR)
)

(defrule create-current-sub-goal3-loaddessert-twodessertdispenser
  (declare (salience 45))
  (not(plan-action))
  (not (and (main-goal (id 1)) (main-goal (id 2))))
  ?last-current <- (last-current ? ?)
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do LoadDessert) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  (K-agent (pos-r ?r-agent) (pos-c ?c-agent))
  ?dessertdispenser <- (K-cell (pos-r ?dessert_pos_r) (pos-c ?dessert_pos_c) (contains DessertDispenser))
  ?dessertdispenser2 <- (K-cell (pos-r ?dessert_pos_r2) (pos-c ?dessert_pos_c2) (contains DessertDispenser))
  (test (neq ?dessertdispenser ?dessertdispenser2))
  (not (test (< (+ (abs (- ?dessert_pos_r2 ?r-agent)) (abs (- ?dessert_pos_c2 ?c-agent))) (+ (abs (- ?dessert_pos_r ?r-agent )) (abs (- ?dessert_pos_c ?c-agent))))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?dessert_pos_r) (pos-c-target ?dessert_pos_c) (action-to-do LoadDessert) (param1 ?dessert_pos_r) (param2 ?dessert_pos_c) (param3 ?param3)))
  (assert (last-current ?goalid LoadDessert))
  (retract ?last-current)
  (focus A-STAR)
)

(defrule create-current-sub-goal3
  (declare (salience 45))
  (not(plan-action))
  (not (and (main-goal (id 1)) (main-goal (id 2))))
  ?last-current <- (last-current ? ?)
  ?sub-goal <- (sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do ?action-to-do) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (not (sub-goal (goal-ref ?goalid) (id ?id1&:(< ?id1 ?id))))
  =>
  (assert (current-sub-goal (goal-ref ?goalid) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do ?action-to-do) (param1 ?param1) (param2 ?param2) (param3 ?param3)))
  (assert (last-current ?goalid ?action-to-do))
  (retract ?last-current)
  (focus A-STAR)
)

; (defrule create-current-sub-goal-inform
;   (declare (salience 60))
;   (not(plan-action))
;   ?sub-goal <- (sub-goal (id ?id) (action-to-do Inform) (param1 ?patient) (param2 ?request) (param3 ?answer))
;   (not (sub-goal (id ?id1&:(< ?id1 ?id))))
;   =>
;   (assert (current-sub-goal (goal-ref 1) (id ?id) (action-to-do Inform) (param1 ?patient) (param2 ?request) (param3 ?answer))) ;asserito per clear-sub-goal
;   (assert (plan-action (plan-step 1) (action Inform) (param1 ?patient) (param2 ?request) (param3 ?answer)))  ;plan-step 1 perchè è semplicemente una singola plan action e viene fatta se non ci sono altre plan action
; )

(defrule create-action-plan
  (declare (salience 50))
  ?f <- (plan-action-aux (plan-step ?ps) (action ?action) (param1 ?p1) (param2 ?p2) (param3 ?p3))
  =>
  (assert (plan-action (plan-step ?ps) (action ?action) (param1 ?p1) (param2 ?p2) (param3 ?p3)))
  (retract ?f)
)

(defrule clear-sub-goal
  (declare (salience 60))
  (not (plan-action-aux))
  (not (plan-action))
  (not (failure))
  ?f1 <- (current-sub-goal (goal-ref ?goalid) (id ?ident))
  ?f2 <- (sub-goal (goal-ref ?goalid) (id ?ident))
  =>
  (retract ?f1)
  (retract ?f2)
  (printout t " Cancella current-sub-goal " ?ident crlf)
)

(defrule clear-main-goal
  (declare (salience 20))
  ?f <- (main-goal (id ?id))
  (not (sub-goal (goal-ref ?id)))
  =>
  (retract ?f)
)
