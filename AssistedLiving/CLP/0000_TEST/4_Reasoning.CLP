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

;crea il piano generale per servire le richieste di meal
(defrule create-goal-meal
  (declare (salience 50))
  ?K-mealstatus <- (K-mealstatus (arrivaltime ?request-time) (requested-by ?sender) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered no) (answer pending))
  (not (K-mealstatus (arrivaltime ?request-time2&:(< ?request-time2 ?request-time)) (delivered no) (answer pending)))
  (not (main-goal))
  =>
  (assert (main-goal (id 1) (k-request ?K-mealstatus) (request-type DeliveryMeal)))
)

(defrule create-goal-dessert-YES
  (declare (salience 50))
  (K-mealstatus (arrivaltime ?request-time) (requested-by ?sender) (tpos-r ?t_pos-r) (tpos-c ?t_pos-c) (delivered yes))
  ?prescription <- (prescription (patient ?sender) (dessert yes))
  ?k-dessertstatus <- (K-dessertstatus (delivered no) (patient ?sender) (answer pending))
  (not (main-goal))
  =>
  (assert (main-goal (id 1) (k-request ?k-dessertstatus) (request-type DeliveryDessert)))
)

(defrule create-sub-goals-meal
  (declare (salience 50))
  ?main-goal <- (main-goal (id 1) (k-request ?x))
  (not (sub-goal))  ;controllo che non ci siano già dei sub-goal da portare a termine
  ?y <- (K-mealstatus (arrivaltime ?arrivaltime) (type ?type) (requested-by ?requested-by) (tpos-r ?tpos-r) (tpos-c ?tpos-c) (delivered ?delivered) (delivertime ?delivertime) (answer ?answer))
  (test (eq ?x ?y))
  ?k-tablestatus <- (K-tablestatus (pos-r ?tpos-r) (pos-c ?tpos-c) (clean ?clean))  ;mi serve per sapere se il tavolo è pulito e le sue coordinate
  ?prescription <- (prescription (patient ?requested-by) (pills ?pills) (meal ?meal))  ;prendo le prescription del paziente
  ?trashbasket <- (K-cell (pos-r ?trash_pos_r) (pos-c ?trash_pos_c) (contains TrashBasket))  ;coordinate spazzatura
  ?pilldispenser <- (K-cell (pos-r ?pill_pos_r) (pos-c ?pill_pos_c) (contains PillDispenser))  ;coordinate pilldispenser
  ?mealdispenser <- (K-cell (pos-r ?meal_pos_r) (pos-c ?meal_pos_c) (contains MealDispenser))  ;coordinate mealdispenser
  =>
  (if (neq ?clean yes) then
    (assert (sub-goal (goal-ref 1) (id 1) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do CleanTable) (param1 ?tpos-r) (param2 ?tpos-c)))
    (assert (sub-goal (goal-ref 1) (id 2) (pos-r-target ?trash_pos_r) (pos-c-target ?trash_pos_c) (action-to-do ReleaseTrash) (param1 ?trash_pos_r) (param2 ?trash_pos_c))))
  (if (eq ?pills before) then
    (assert (sub-goal (goal-ref 1) (id 3) (pos-r-target ?pill_pos_r) (pos-c-target ?pill_pos_c) (action-to-do LoadPill) (param1 ?pill_pos_r) (param2 ?pill_pos_c) (param3 ?requested-by)))
    (assert (sub-goal (goal-ref 1) (id 4) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do DeliveryPill) (param1 ?tpos-r) (param2 ?tpos-c) (param3 ?requested-by)))
    (assert (sub-goal (goal-ref 1) (id 5) (pos-r-target ?meal_pos_r) (pos-c-target ?meal_pos_c) (action-to-do LoadMeal) (param1 ?meal_pos_r) (param2 ?meal_pos_c) (param3 ?meal)))
    (assert (sub-goal (goal-ref 1) (id 6) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do DeliveryMeal) (param1 ?tpos-r) (param2 ?tpos-c) (param3 ?meal))))
  (if (eq ?pills after) then
    (assert (sub-goal (goal-ref 1) (id 3) (pos-r-target ?meal_pos_r) (pos-c-target ?meal_pos_c) (action-to-do LoadMeal) (param1 ?meal_pos_r) (param2 ?meal_pos_c) (param3 ?meal)))
    (assert (sub-goal (goal-ref 1) (id 4) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do DeliveryMeal) (param1 ?tpos-r) (param2 ?tpos-c) (param3 ?meal)))
    (assert (sub-goal (goal-ref 1) (id 5) (pos-r-target ?pill_pos_r) (pos-c-target ?pill_pos_c) (action-to-do LoadPill) (param1 ?pill_pos_r) (param2 ?pill_pos_c) (param3 ?requested-by)))
    (assert (sub-goal (goal-ref 1) (id 6) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do DeliveryPill) (param1 ?tpos-r) (param2 ?tpos-c) (param3 ?requested-by))))
  (if (eq ?pills no) then
    (assert (sub-goal (goal-ref 1) (id 3) (pos-r-target ?meal_pos_r) (pos-c-target ?meal_pos_c) (action-to-do LoadMeal) (param1 ?meal_pos_r) (param2 ?meal_pos_c) (param3 ?meal)))
    (assert (sub-goal (goal-ref 1) (id 4) (pos-r-target ?tpos-r) (pos-c-target ?tpos-c) (action-to-do DeliveryMeal) (param1 ?tpos-r) (param2 ?tpos-c) (param3 ?meal))))
)

(defrule create-current-sub-goal
  (declare (salience 50))
  (not(plan-action))
  ?sub-goal <- (sub-goal (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do ?action-to-do) (param1 ?param1) (param2 ?param2) (param3 ?param3))
  (not (sub-goal (id ?id1&:(< ?id1 ?id))))
  =>
  (assert (current-sub-goal (goal-ref 1) (id ?id) (pos-r-target ?pos-r-target) (pos-c-target ?pos-c-target) (action-to-do ?action-to-do) (param1 ?param1) (param2 ?param2) (param3 ?param3)))
  (focus BFSEARCH)
)

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
  ?f1 <- (current-sub-goal (id ?ident))
  ?f2 <- (sub-goal (id ?ident))
  =>
  (retract ?f1)
  (retract ?f2)
  (printout t " Cancella current-sub-goal " ?ident crlf)
)

(defrule clear-main-goal
  (declare (salience 20))
  (not (sub-goal))
  ?f <- (main-goal)
  =>
  (retract ?f)

)

;Crea uno stupido piano di prova
(defrule create-test-plan
  (declare (salience 10))
  (not
    (plan-action)
  )
  =>
  (assert
    (plan-action (plan-step -1)(action Wait))
    ; (plan-action (plan-step 0)(action Turnleft) )
    ; (plan-action (plan-step 1)(action Turnleft) )
    ; (plan-action (plan-step 2)(action Forward) )
    ; (plan-action (plan-step 3)(action Inform) (param1 P2) (param2 meal) (param3 yes) )
    ; (plan-action (plan-step 4)(action Forward) )
    ; (plan-action (plan-step 5)(action Turnleft) )
    ; (plan-action (plan-step 6)(action Forward) )
    ; (plan-action (plan-step 7)(action Turnleft) )
    ; (plan-action (plan-step 8)(action Forward) )
    ; (plan-action (plan-step 9)(action LoadMeal) (param1 8) (param2 7) (param3 normal) )
    ; (plan-action (plan-step 10)(action Turnleft) )
    ; (plan-action (plan-step 11) (action Turnleft) )
    ; (plan-action (plan-step 12)(action Forward) )
    ; (plan-action (plan-step 13)(action Forward) )
    ; (plan-action (plan-step 14)(action Turnright) )
    ; (plan-action (plan-step 15)(action Forward) )
    ; (plan-action (plan-step 16)(action Forward) )
    ; (plan-action (plan-step 17) (action Forward) )
    ; (plan-action (plan-step 18)(action Turnleft) )
    ; (plan-action (plan-step 19)(action DeliveryMeal)(param1 4) (param2 4) (param3 normal) )
    ; (plan-action (plan-step 20)(action Turnleft) )
    ; (plan-action (plan-step 21)(action Forward) )
    ; (plan-action (plan-step 22)(action Turnleft) )
    ; (plan-action (plan-step 23)(action Forward) )
    ; (plan-action (plan-step 24)(action Forward) )
    ; (plan-action (plan-step 25)(action LoadDessert)(param1 8) (param2 5) )
    ; (plan-action (plan-step 26)(action Turnleft) )
    ; (plan-action (plan-step 27)(action Turnleft) )
    ; (plan-action (plan-step 28)(action Forward) )
    ; (plan-action (plan-step 29)(action Forward) )
    ; (plan-action (plan-step 30)(action Turnright) )
    ; (plan-action (plan-step 31)(action Forward) )
    ; (plan-action (plan-step 32) (action Turnleft) )
    ; (plan-action (plan-step 33)(action DeliveryDessert)(param1 4)(param2 4) )
    ; (plan-action (plan-step 34)(action Turnleft) )
    ; (plan-action (plan-step 35)(action Forward) )
    ; (plan-action (plan-step 36)(action Forward) )
    ; (plan-action (plan-step 37)(action Turnleft) )
    ; (plan-action (plan-step 38)(action Turnleft) )
    ; (plan-action (plan-step 39)(action Forward) )
    ; (plan-action (plan-step 40)(action Forward) )
    ; (plan-action (plan-step 41)(action Turnleft) )
    ; (plan-action (plan-step 42)(action CleanTable)(param1 4) (param2 4) )
    ; (plan-action (plan-step 43)(action Turnleft) )
    ; (plan-action (plan-step 44)(action Forward) )
    ; (plan-action (plan-step 45)(action Forward) )
    ; (plan-action (plan-step 46)(action Turnleft) )
    ; (plan-action (plan-step 47)(action Forward) )
    ; (plan-action (plan-step 48)(action Forward) )
    ; (plan-action (plan-step 49)(action Forward) )
    ; (plan-action (plan-step 50)(action ReleaseTrash)(param1 9) (param2 6) )
    ; (plan-action (plan-step 51)(action Turnleft) )
    ; (plan-action (plan-step 52)(action Turnleft) )
    ; (plan-action (plan-step 53)(action Forward) )
    ; (plan-action (plan-step 54)(action Done) )
   )
)
