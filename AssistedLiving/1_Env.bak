;; *************************************
;; *************************************
;; MODULO ENV
;;
;; *************************************


(defmodule ENV (import MAIN ?ALL)(export ?ALL))





(deftemplate cell  
        (slot pos-r) 
        (slot pos-c) 
        (slot contains (allowed-values robot wall Robot Wall PersonSeated PersonStanding  
                                                  Empty Parking Table Seat TrashBasket
                                                  DessertDispenser PillDispenser MealDispenser))
        (slot previous)

)


(deftemplate agentstatus
    (slot step)
    (slot time)
    (slot pos-r)
    (slot pos-c)
    (slot direction)
    (multislot content)
    (slot free)
    (slot waste)
)

(deftemplate agentstatusdisplayed 
	(slot step)
        (slot time) 
	(slot pos-r) 
	(slot pos-c) 
	(slot direction) 
	(slot loaded)
)

(deftemplate tablestatus	
	(slot step)
        (slot time)
	(slot pos-r) 
	(slot pos-c) 
	(slot clean (allowed-values yes no stop))
	(slot occupied-by)
        )

(deftemplate mealstatus	;// 
	(slot step)
        (slot time)			;// tempo corrente
	(slot arrivaltime)	;// momento in cui é arrivata l'ordinazione
	(slot requested-by)	;// 
	(slot type)
        (slot tpos-r)
        (slot tpos-c)
        (slot delivered)
        (slot delivertime)
        (slot answer (allowed-values pending yes wait reject))	
)

(deftemplate dessertstatus	;// 
	(slot step)
        (slot time)			;// tempo corrente
	(slot arrivaltime)	;// momento in cui é arrivata l'ordinazione
	(slot requested-by)	;// 
        (slot tpos-r)
        (slot tpos-c)
        (slot delivered)
        (slot answer (allowed-values pending yes wait reject))	
)

(deftemplate pillstatus	;// 
	(slot step)
        (slot time)			;// tempo corrente
	(slot for)	;// 
        (slot delivered)
        (slot when (allowed-values before after no))	
)

(deftemplate initpersonpos	;// informazioni sulla posizione degli anziani
	(slot ident)
	(slot type (allowed-values staff patient))
        (slot pos-r)
	(slot pos-c)			
)

(deftemplate personstatus 	;// informazioni sulla posizione delle persone
  (slot step)
  (slot time)
  (slot ident)
  (slot pos-r)
  (slot pos-c)
  (slot activity)   ;// activity out se soccorritore � outdoor, stand se in piedi, oppure path
  (slot move)
)

(deftemplate staffstatus 	;// informazioni sulla posizione delle persone
	(slot step)
        (slot time)
	(slot ident)
	(slot pos-r)
	(slot pos-c)
	(slot activity)   ;// activity  stand se in piedi, oppure path  		
        (slot move)			
)

(deftemplate personmove		;// modella i movimenti delle persone. l'environment deve tenere conto dell'interazione di tanti agenti. Il mondo cambia sia per le azioni del robot, si per le azioni degli operatori. Il modulo environment deve gestire le interazioni.
  (slot step)
  (slot ident)
  (slot path-id)
)

(deftemplate event   		;// gli eventi sono le richieste meal dessert
	(slot step)
	(slot type (allowed-values meal dessert))
	(slot person)
	
)

(deftemplate pillrepository
        (slot id)
        (multislot content))

;// DEFRULE

;//imposta il valore iniziale di ciascuna cella 


(defrule create1
  (declare (salience 28))
  ?f<-(create-map)
  =>
  (load-facts "RealMap.txt")
  (load-facts "Prescription.txt")
  (assert
   (create-real-map)
   (create-initial-setting)
   (create-history)
  )
  (retract ?f)
)



(defrule  create2
  (declare (salience 27))
  (create-real-map)
  (real_cell (pos-r ?r) (pos-c ?c) (contains ?x) )
=>
  (assert
    (cell
      (pos-r ?r)
      (pos-c ?c)
      (contains ?x)
      (previous ?x)
    )
  )
)

(defrule creation12	
     (declare (salience 25))
        (create-real-map)
?f1 <-  (cell (pos-r ?r) (pos-c ?c) (contains Parking))
        
=>
     (modify ?f1 (contains Robot) (previous Parking))
     (assert (agentstatus (time 0) (step 0) (pos-r ?r) (pos-c ?c) (direction north)
                          (free 2) (waste no))
             (agentstatusdisplayed (time 0) (step 0) (pos-r ?r) (pos-c ?c) (direction north)
                          (loaded no))
             (pillrepository (id PD1) (content)))
            
)



;(defrule  create3-2
;  (declare (salience 25))
;  (create-init-map)
;; [adeguamentoAL]
;;  (real_cell (pos-r ?r) (pos-c ?c) (contains ?x&wall|gate|debris|seat|table|dessertdispenser|parking|mealdispenser|trashbasket|pilldispenser))
; (real_cell (pos-r ?r) (pos-c ?c) (contains ?x&Wall|Parking|Table|Seat|TrashBasket|DessertDispenser|PillDispenser|MealDispenser))

;  =>
;  (assert (init_cell (pos-r ?r) (pos-c ?c) (contains ?x)))
;)


; Questa regola inzializza le celle empty. Per costruzione del mondo iniziale le celle
; empty sono solo celle interne all'ambiente, se fossero vicino all'esterno sarebbero
; di tipo gate



;(defrule  create3-3
;  (declare (salience 25))
;  (create-init-map)
;  (real_cell (pos-r ?r) (pos-c ?c) (contains Empty))
;=>
;  (assert (init_cell (pos-r ?r) (pos-c ?c) (contains unknown)))
;)



;(defrule  create3-4
;  (declare (salience 24))
;  (create-init-map)
;; [adeguamentoAL]
;;  (real_cell (pos-r ?r) (pos-c ?c) (contains ?x&wall|gate|debris|seat|table|dessertdispenser|parking|mealdispenser|trashbasket|pilldispenser))
;   (real_cell (pos-r ?r) (pos-c ?c) (contains ?x&Wall|Parking|Table|Seat|TrashBasket|DessertDispenser|PillDispenser|MealDispenser))
;  (not (init_cell (pos-r ?r) (pos-c ?c)))
;  =>
;  (assert (init_cell (pos-r ?r) (pos-c ?c) (contains unknown)))
;)



(defrule creation4
  (declare (salience 23))
  ?f1<-	(create-history)
  =>
  (load-facts "history.txt")
  (retract ?f1)
)

(defrule creation31	
	(declare (salience 23))
        (create-initial-setting)
        (initpersonpos (ident ?p) (type patient) (pos-r ?r) (pos-c ?c))
=>
   	(assert (personstatus (step 0) (time 0) (ident ?p) 
                              (pos-r ?r) (pos-c ?c)
                              (activity seated) (move NA)))
)

(defrule creation32	
	(declare (salience 23))
        (create-initial-setting)
        (initpersonpos (ident ?p) (type staff) (pos-r ?r) (pos-c ?c))
?f1<-   (cell (pos-r ?r) (pos-c ?c) (contains Empty))
=>
   	(assert (staffstatus (step 0) (time 0) (ident ?p) 
                              (pos-r ?r) (pos-c ?c)
                              (activity stand) (move NA)))
        (modify ?f1 (contains PersonStanding) (previous Empty))
)

(defrule creation331
      (declare (salience 23))
      (create-initial-setting)
      (prescription (patient ?id) (pills ?pills&~no))
      (not (pillstatus (step 0) (for ?id)))
?f<-  (pillrepository (content $?cont))
=> 
      (assert (pillstatus (step 0) (time 0) (for ?id) (delivered no) 
                          (when ?pills)))
      (modify ?f (content (insert$ $?cont 1 ?id)))
)

(defrule creation332
      (declare (salience 23))
      (create-initial-setting)
      (prescription (patient ?id) (pills no))
      (not (pillstatus (step 0) (for ?id)))
?f<-  (pillrepository (content $?cont))
=> 
      (assert (pillstatus (step 0) (time 0) (for ?id) (delivered no) 
                          (when no)))
)


(defrule creation41
         (declare (salience 22))
         (create-initial-setting)
         (cell (pos-r ?r) (pos-c ?c) (contains Table))
         (table-seat (t_pos-r ?r) (t_pos-c ?c)(s_pos-r ?rr) (s_pos-c ?cc))
         (personstatus (step 0)(ident ?p) (pos-r ?rr) (pos-c ?cc) (activity seated))
?f <-    (cell (pos-r ?rr) (pos-c ?cc) (contains Seat))

=> 
         (assert (tablestatus (step 0) (time 0) (pos-r ?r) (pos-c ?c) (clean yes) (occupied-by ?p)))
         (modify ?f (contains PersonSeated))
                  
)
   

(defrule creation42
         (declare (salience 22))
         (create-initial-setting)
         (cell (pos-r ?r) (pos-c ?c) (contains Table))
         (table-seat (t_pos-r ?r) (t_pos-c ?c)(s_pos-r ?rr) (s_pos-c ?cc))
         (not (personstatus (step 0)(ident ?p) (pos-r ?rr) (pos-c ?cc) (activity seated)))

=> 
         (assert (tablestatus (step 0) (time 0) (pos-r ?r) (pos-c ?c) (clean yes) (occupied-by no)))
)



(defrule creation5
         (declare (salience 21))
?f1 <-   (create-initial-setting)
?f2 <-   (create-real-map)
=> 
         (assert (status (step 0) (time 0) (result on))
                 (penalty 0))
         (retract ?f1 ?f2)
)






;// __________________________________________________________________________________________
;// REGOLE PER GESTIONE EVENTI    
;// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;//

(defrule newmeal   
	(declare (salience 200))
	(status (step ?i) (time ?t))
?f1<-	(event (step ?i) (type meal) (person ?p))
	(tablestatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (clean yes) (occupied-by ?p))
        (prescription (patient ?p) (meal ?mm) (pills ?pills))
        (not (mealstatus (step ?i) (time ?t) (requested-by ?p))) 
=> 
	(assert (mealstatus (step ?i) (time ?t) (arrivaltime ?t) (requested-by ?p) 
                            (type ?mm) (tpos-r ?r) (tpos-c ?c) (delivered no)
                             (answer pending))   
                (msg-to-agent (request-time ?t) (step ?i) (sender ?p) (request meal)
                              (t_pos-r ?r) (t_pos-c ?c))
	)
	(retract ?f1)		
	(printout t crlf " ENVIRONMENT:" crlf)
	(printout t " - " ?p " asks for  meal in table " ?r " and " ?c crlf)
)


(defrule alreadyaskedmeal     
	(declare (salience 200))
	(status (step ?i) (time ?t))
?f1<-	(event (step ?i) (type meal) (person ?p))
        (mealstatus (step ?i) (time ?t) (requested-by ?p))	
=>
	(retract ?f1)		

)

(defrule newdessert1  
	(declare (salience 200))
	(status (step ?i) (time ?t))
?f1<-	(event (step ?i) (type dessert) (person ?p))
	(tablestatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (occupied-by ?p))
        (not (dessertstatus (step ?i) (time ?t) (requested-by ?p)))
        (mealstatus (step ?i) (time ?t) (requested-by ?p) (delivered yes))
=> 
	(assert (dessertstatus (step ?i) (time ?t) (arrivaltime ?t) (requested-by ?p) 
                             (tpos-r ?r) (tpos-c ?c) (delivered no)
                             (answer pending))
                (msg-to-agent (request-time ?t) (step ?i) (sender ?p) (request dessert)
                              (t_pos-r ?r) (t_pos-c ?c))
	)
	(retract ?f1)		
	(printout t crlf " ENVIRONMENT:" crlf)
	(printout t " - " ?p " asks for  dessert in table " ?r " and " ?c crlf)
)


(defrule newdessert2  
	(declare (salience 200))
	(status (step ?i) (time ?t))
?f1<-	(event (step ?i) (type dessert) (person ?p))
	(tablestatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (occupied-by ?p))
        (not (dessertstatus (step ?i) (time ?t) (requested-by ?p)))
        (mealstatus (step ?i) (time ?t) (requested-by ?p) (delivered no))
=>	
	(modify  ?f1 (step (+ ?i 1)))		
)

(defrule alreadyaskeddessert     
	(declare (salience 200))
	(status (step ?i) (time ?t))
?f1<-	(event (step ?i) (type meal) (person ?p))
        (dessertstatus (step ?i) (time ?t) (requested-by ?p))
	
=>
	(retract ?f1)		

)


;// __________________________________________________________________________________________
;// GENERA EVOLUZIONE TEMPORALE       
;// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯  

;// per ogni istante di tempo che intercorre fra la request e la inform, 
; l'agente prende 30 penalità

(defrule RequestEvolution1       
	(declare (salience 10))
	(status (time ?t) (step ?i))
?f1<-	(mealstatus (step = (- ?i 1)) (time ?tt) (arrivaltime ?at) (requested-by ?p)
                     (answer pending))
	(not (mealstatus (step ?i) (time ?t) (arrivaltime ?at) (requested-by ?p)
                     (answer ~pending)))
?f2<- (penalty ?penalty)
=> 
	(modify ?f1 (time ?t) (step ?i))
	(assert (penalty (+ ?penalty (* (- ?t ?tt) 30))))
	(retract ?f2)
)

(defrule RequestEvolution2       
	(declare (salience 10))
	(status (time ?t) (step ?i))
?f1<-	(dessertstatus (step = (- ?i 1)) (time ?tt) (arrivaltime ?at) (requested-by ?p)
                     (answer pending))
	(not (dessertstatus (step ?i) (time ?t) (arrivaltime ?at) (requested-by ?p)
                     (answer ~pending)))
?f2<- (penalty ?penalty)
=> 
	(modify ?f1 (time ?t) (step ?i))
	(assert (penalty (+ ?penalty (* (- ?t ?tt) 30))))
	(retract ?f2)
)

;// penalità perchè c'è request di tipo meal  e meal non è ancora stato delivered 
;// caso di answer yes 

(defrule MealEvolution1
       
	(declare (salience 10))
        (status (time ?t) (step ?i))
?f1<-	(mealstatus (step = (- ?i 1)) (time ?tt) (arrivaltime ?at) (requested-by ?p)
                     (answer yes) (delivered no))             
        (not (mealstatus (step ?i) (arrivaltime ?at) (requested-by ?p) (delivered yes)))
?f2<-	(penalty ?penalty)
=> 
        (modify ?f1 (time ?t) (step ?i))
	(assert (penalty (+ ?penalty (* (- ?t ?tt) 3))))
	(retract ?f2)
)


;// penalità perchè c'è request di tipo meal  e meal non è ancora stato delivered 
;// caso di answer wait

(defrule MealEvolution2
       
	(declare (salience 10))
        (status (time ?t) (step ?i))
?f1<-	(mealstatus (step = (- ?i 1)) (time ?tt) (arrivaltime ?at) (requested-by ?p)
                     (answer wait) (delivered no))             
        (not (mealstatus (step ?i) (arrivaltime ?at) (requested-by ?p) (delivered yes)))
?f2<-	(penalty ?penalty)
=> 
        (modify ?f1 (time ?t) (step ?i))
	(assert (penalty (+ ?penalty (* (- ?t ?tt) 2))))
	(retract ?f2)
)

;//  meal è già stato delivered

(defrule MealEvolution3
       
	(declare (salience 10))
        (status (time ?t) (step ?i))
?f1<-	(mealstatus (step = (- ?i 1)) (time ?tt) (arrivaltime ?at) (requested-by ?p)
                     (delivered yes))             
        (not (mealstatus (step ?i) (arrivaltime ?at) (requested-by ?p) (delivered yes)))
=> 
        (modify ?f1 (time ?t) (step ?i))
)


;// penalità perchè c'è request di tipo dessert  e dessert non è ancora stato delivered 
;// caso di answer yes 

(defrule DessertEvolution1
       
	(declare (salience 10))
        (status (time ?t) (step ?i))
?f1<-	(dessertstatus (step = (- ?i 1)) (time ?tt) (arrivaltime ?at) (requested-by ?p)
                     (answer yes)(delivered no))             
        (not (dessertstatus (step ?i) (arrivaltime ?at) (requested-by ?p) (delivered yes)))
?f2<-	(penalty ?penalty)
=> 
        (modify ?f1 (time ?t) (step ?i))
	(assert (penalty (+ ?penalty (* (- ?t ?tt) 2))))
	(retract ?f2)
)


;// penalità perchè c'è request di tipo dessert  e dessert non è ancora stato delivered 
;// caso di answer wait 

(defrule DessertEvolution2
       
	(declare (salience 10))
        (status (time ?t) (step ?i))
?f1<-	(dessertstatus (step = (- ?i 1)) (time ?tt) (arrivaltime ?at) (requested-by ?p)
                     (answer wait) (delivered no))             
        (not (dessertstatus (step ?i) (arrivaltime ?at) (requested-by ?p) (delivered yes)))
?f2<-	(penalty ?penalty)
=> 
        (modify ?f1 (time ?t) (step ?i))
	(assert (penalty (+ ?penalty (* (- ?t ?tt) 1))))
	(retract ?f2)
)

;//  dessert è già stato delivered

(defrule DessertEvolution3
       
	(declare (salience 10))
        (status (time ?t) (step ?i))
?f1<-	(dessertstatus (step = (- ?i 1)) (time ?tt) (arrivaltime ?at) (requested-by ?p)
                     (delivered yes))             
        (not (dessertstatus (step ?i) (arrivaltime ?at) (requested-by ?p) (delivered yes)))
=> 
        (modify ?f1 (time ?t) (step ?i))
)

;//  la richiesta di dessert è stata rifiutata (answer reject)

(defrule DessertEvolution4
       
	(declare (salience 10))
        (status (time ?t) (step ?i))
?f1<-	(dessertstatus (step = (- ?i 1)) (time ?tt) (arrivaltime ?at) (requested-by ?p)
                     (answer reject))             
        (not (dessertstatus (step ?i) (arrivaltime ?at) (requested-by ?p) (answer reject)))
=> 
        (modify ?f1 (time ?t) (step ?i))
)

;// fa avanzare tablestatus se nulla avviene. la regole ha priorità bassa perchè movimento 
;// delle persone può alterare table status

(defrule RequestEvolution4       
	(declare (salience 8))
        (status (time ?t) (step ?i))
?f1<-	(tablestatus (step = (- ?i 1)) (time ?tt) (pos-r ?r) (pos-c ?c)) 
        (not (tablestatus (step ?i)  (pos-r ?r) (pos-c ?c)))
=> 
        (modify ?f1 (time ?t) (step ?i))
)

;// fa avanzare pillstatus se nulla avviene

(defrule PillsEvolution
       
	(declare (salience 10))
        (status (time ?t) (step ?i))
?f1<-	(pillstatus (step = (- ?i 1)) (time ?tt) (for ?p))             
        (not (pillstatus (step ?i) (for ?p)))
=> 
        (modify ?f1 (time ?t) (step ?i))
	
)

;// __________________________________________________________________________________________
;// GENERA MOVIMENTI PERSONE                    
;// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;// Persona ferma non arriva comando di muoversi


(defrule MovePerson1		
	(declare (salience 9))    
	(status (step ?i) (time ?t)) 
?f1<-	(personstatus (step =(- ?i 1)) (ident ?id) (activity seated|stand))
	(not (personmove (step ?i) (ident ?id)))
=> 
	(modify ?f1 (time ?t) (step ?i))
) 


(defrule MoveStaff1		
	(declare (salience 9))    
	(status (step ?i) (time ?t)) 
?f1<-	(staffstatus (step =(- ?i 1)) (ident ?id) (activity stand))
	(not (personmove (step ?i) (ident ?id)))
=> 
	(modify ?f1 (time ?t) (step ?i))
) 

         
;//;//Persona ferma ma arriva comando di muoversi
(defrule MovePerson2
   (declare (salience 10))    
        (status (step ?i) (time ?t))  
 ?f1 <- (personstatus (step =(- ?i 1)) (ident ?id) (activity seated|stand))
 ?f2 <- (personmove (step  ?i) (ident ?id) (path-id ?m))
        => (modify  ?f1 (time ?t) (step ?i) (activity ?m) (move 0))
           (retract ?f2)
)            
          
(defrule MoveStaff2
   (declare (salience 10))    
        (status (step ?i) (time ?t))  
 ?f1 <- (staffstatus (step =(- ?i 1)) (ident ?id) (activity stand))
 ?f2 <- (personmove (step  ?i) (ident ?id) (path-id ?m))
        => (modify  ?f1 (time ?t) (step ?i) (activity ?m) (move 0))
           (retract ?f2)
)  
  

;// La cella in cui deve  andare la persona è libera. Persona si muove. 
;// La cella di partenza è un seat in cui si trovava la persona

(defrule MovePerson3
   (declare (salience 10))    
        (status (step ?i) (time ?t))   
 ?f1 <- (personstatus (step =(- ?i 1)) (ident ?id) (pos-r ?x) (pos-c ?y) 
                      (activity ?m&~seated&~stand) (move ?s))
 ?f4 <- (cell (pos-r ?x) (pos-c ?y) (contains PersonSeated) (previous Seat))
 ?f3 <- (move-path ?m =(+ ?s 1) ?id ?r ?c)
 ?f2 <- (cell (pos-r ?r) (pos-c ?c) (contains Empty))
 ?f5 <- (tablestatus (step =(- ?i 1)) (occupied-by ?id))	
	
        => (modify  ?f1  (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (move (+ ?s 1)))
           (modify ?f2 (contains PersonStanding) (previous Empty))
           (modify ?f4 (contains Seat))
           (modify ?f5 (step ?i) (time ?t) (occupied-by no))
           (retract ?f3)		
)


;// La cella in cui deve  andare la persona è libera. Persona si muove. 
;// La cella di partenza è occupata da Person, per cui dopo lo spostamento 
;// della persona la cella di partenza diventa libera e quella di arrivo contiene person

(defrule MovePerson4
   (declare (salience 10))    
        (status (step ?i) (time ?t)) 
 ?f1 <- (personstatus (step =(- ?i 1)) (ident ?id) (pos-r ?x) (pos-c ?y) 
                      (activity ?m&~seated|~stand) (move ?s))
 ?f4 <- (cell (pos-r ?x) (pos-c ?y) (contains PersonStanding) (previous ?prev))
 ?f3 <- (move-path ?m =(+ ?s 1) ?id ?r ?c)
 ?f2 <- (cell (pos-r ?r) (pos-c ?c) (contains Empty))
        => (modify  ?f1  (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (move (+ ?s 1)))
           (modify ?f2 (contains PersonStanding) (previous Empty))
           (modify ?f4 (contains ?prev))
           (retract ?f3))

(defrule StaffPerson4
   (declare (salience 10))    
        (status (step ?i) (time ?t)) 
 ?f1 <- (staffstatus (step =(- ?i 1)) (ident ?id) (pos-r ?x) (pos-c ?y) 
                      (activity ?m&~stand) (move ?s))
 ?f4 <- (cell (pos-r ?x) (pos-c ?y) (contains PersonStanding) (previous ?prev))
 ?f3 <- (move-path ?m =(+ ?s 1) ?id ?r ?c)
 ?f2 <- (cell (pos-r ?r) (pos-c ?c) (contains Empty))
        => (modify  ?f1  (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (move (+ ?s 1)))
           (modify ?f2 (contains PersonStanding) (previous Empty))
           (modify ?f4 (contains ?prev))
           (retract ?f3))

;// La cella in cui deve andare person è un seat e il seat non è occupata da altra persona.
;// La cella di partenza diventa libera, e l'attivita della persona diventa seated
 
(defrule MovePerson5
   (declare (salience 10))    
        (status (step ?i) (time ?t)) 
 ?f1 <- (personstatus (step =(- ?i 1)) (ident ?id) (pos-r ?x) (pos-c ?y) 
                       (activity ?m&~seated&~stand) (move ?s))
 ?f3 <- (move-path ?m =(+ ?s 1) ?id ?r ?c)
        (not (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)))
 ?f2 <- (cell (pos-r ?r) (pos-c ?c) (contains Seat))
        (table-seat (t_pos-r ?rr) (t_pos-c ?cc)(s_pos-r ?r) (s_pos-c ?c))
 ?f5 <- (tablestatus (step =(- ?i 1)) (pos-r ?rr) (pos-c ?cc)) 
 ?f4 <- (cell (pos-r ?x) (pos-c ?y) (contains PersonStanding) (previous ?prev))
        => (modify  ?f1  (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (activity seated) (move NA))
           (modify ?f4 (contains ?prev))
           (modify ?f2 (contains PersonSeated) (previous Seat))
           (modify ?f5 (step ?i) (time ?t) (occupied-by ?id))
           (retract ?f3))

 

;// La cella in cui deve  andare la persona è occupata dal robot. 
;// Persona non si muove. Scattano penalità           

(defrule MovePerson_wait1
	(declare (salience 10))    
	(status (step ?i) (time ?t))
?f1<-	(personstatus (step =(- ?i 1)) (time ?tt) (ident ?id) (activity ?m&~seated&~stand) (move ?s))
	(move-path ?m =(+ ?s 1) ?id ?r ?c)
?f3 <-  (cell (pos-r ?r) (pos-c ?c) (contains Robot))
?f2<-	(penalty ?penalty)
=> 
	(modify  ?f1 (time ?t) (step ?i))
	(assert (penalty (+ ?penalty (* (- ?t ?tt) 15))))
	(retract ?f2)
;	(printout t " - penalità aumentate" ?id " attende che il robot si sposti)" crlf)
)
                  
(defrule MoveStaff_wait1
	(declare (salience 10))    
	(status (step ?i) (time ?t))
?f1<-	(staffstatus (step =(- ?i 1)) (time ?tt) (ident ?id) (activity ?m&~seated&~stand) (move ?s))
	(move-path ?m =(+ ?s 1) ?id ?r ?c)
?f3 <-  (cell (pos-r ?r) (pos-c ?c) (contains Robot))
?f2<-	(penalty ?penalty)
=> 
	(modify  ?f1 (time ?t) (step ?i))
	(assert (penalty (+ ?penalty (* (- ?t ?tt) 15))))
	(retract ?f2)
;	(printout t " - penalità aumentate" ?id " attende che il robot si sposti)" crlf)
)


;// La cella in cui deve  andare la persona non è libera (ma non è occupata da robot). Persona non si muove           
    
(defrule MovePerson_wait2
	(declare (salience 10))    
	(status (step ?i) (time ?t))
?f1<-	(personstatus (step =(- ?i 1)) (time ?tt) (ident ?id) (activity ?m&~seated&~stand) (move ?s))
	(move-path ?m =(+ ?s 1) ?id ?r ?c)
        (cell (pos-r ?r) (pos-c ?c) (contains PersonStanding))
=>
	(modify  ?f1 (time ?t) (step ?i))

)

(defrule MoveStaff_wait2
	(declare (salience 10))    
	(status (step ?i) (time ?t))
?f1<-	(staffstatus (step =(- ?i 1)) (time ?tt) (ident ?id) (activity ?m&~seated&~stand) (move ?s))
	(move-path ?m =(+ ?s 1) ?id ?r ?c)
        (cell (pos-r ?r) (pos-c ?c) (contains PersonStanding))
=>
	(modify  ?f1 (time ?t) (step ?i))

)

;// La cella in cui deve andare la persona è un seat ma il seat è occupata da altri.
;// la persona resta ferma

(defrule MovePerson_wait3
   (declare (salience 10))    
        (status (step ?i) (time ?t)) 
 ?f1 <- (personstatus (step =(- ?i 1)) (ident ?id) (pos-r ?x) (pos-c ?y) 
                       (activity ?m&~seated&~stand) (move ?s))
 ?f3 <- (move-path ?m =(+ ?s 1) ?id ?r ?c)
 ?f2 <- (cell (pos-r ?r) (pos-c ?c) (contains PersonSeated))

        => (modify  ?f1  (step ?i) (time ?t))
           ) 

;//La serie di mosse è stata esaurita, la persona rimane ferma dove si trova

(defrule MovePerson_end
   (declare (salience 9))    
        (status (step ?i) (time ?t)) 
?f1<-	(personstatus (step =(- ?i 1)) (ident ?id) (activity ?m&~seated&~stand) (move ?s))
	(not (move-path ?m =(+ ?s 1) ?id ?r ?c))
        => (modify  ?f1  (time ?t) (step ?i) (activity stand) (move NA)) 
        )
          

(defrule MoveStaff_end
   (declare (salience 9))    
        (status (step ?i) (time ?t)) 
?f1<-	(staffstatus (step =(- ?i 1)) (ident ?id) (activity ?m&~stand) (move ?s))
	(not (move-path ?m =(+ ?s 1) ?id ?r ?c))
        => (modify  ?f1  (time ?t) (step ?i) (activity stand) (move NA)) 
        )

;;;;******************************
;;;;******************************
;;;;          DONE



(defrule done-meal_pending
   (declare (salience 21))    
        (status (step ?i) (time ?t)) 
        (exec (step ?i) (action  Done))
  ?f3<- (mealstatus (step ?i) (time ?t) (requested-by ?id) (delivered no))
  ?f1<- (penalty ?p)
        => (assert (penalty (+ ?p 5000000)))
           (retract ?f1)
           (modify ?f3 (delivered stop))
           )

(defrule done-dessert_pending
   (declare (salience 21))    
        (status (step ?i) (time ?t)) 
        (exec (step ?i) (action  Done))
  ?f3<- (dessertstatus (step ?i) (time ?t) (requested-by ?id) (delivered no) 
                       (answer yes|wait))
  ?f1<- (penalty ?p)
        => (assert (penalty (+ ?p 2000000)))
           (modify ?f3 (delivered stop))
           (retract ?f1)
           )

(defrule done-pill_pending
   (declare (salience 21))    
        (status (step ?i) (time ?t)) 
        (exec (step ?i) (action  Done))
  ?f3<- (pillstatus (step ?i) (time ?t) (for ?id) (delivered no) 
                       (when before|after))
  ?f1<- (penalty ?p)
        => (assert (penalty (+ ?p 10000000)))
           (modify ?f3 (delivered stop))
           (retract ?f1)
           )

(defrule done-table-dirty
   (declare (salience 21))    
        (status (step ?i) (time ?t)) 
        (exec (step ?i) (action  Done))
  ?f3<- (tablestatus (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (clean no))
  ?f1<- (penalty ?p)
        => (assert (penalty (+ ?p 500000)))
           (modify ?f3 (clean stop))
           (retract ?f1)
           )

(defrule done-exit
   (declare (salience 20))
  ?f2<- (status (step ?i) (time ?t))
        (exec (step ?i) (action Done))
        =>
          (modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)) (result stop))
           (focus MAIN)
)

;// __________________________________________________________________________________________
;// REGOLE PER GESTIONE INFORM (in caso di request) DALL'AGENTE 
;// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;//

;// l'agente ha inviato inform che meal è yes (e va bene)
(defrule msg-meal-yes-OK    
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 meal) (param3 yes))
?f2<-	(mealstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
?f4<-   (pillstatus (step ?i) (time ?t) (for ?p) (when no|after))		
?f3<-	(agentstatus (step ?i) (time ?t))	
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer yes))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (modify ?f4 (time (+ ?t 1)) (step (+ ?i 1)))
)


;// l'agente ha inviato inform che l'ordine è yes (e ma non sono vere le condizioni)
(defrule msg-meal-yes-KO1        
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 meal) (param3 yes))
?f2<-	(mealstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
?f4<-   (pillstatus (step ?i) (time ?t) (for ?p) (when before))		
?f3<-	(agentstatus (step ?i) (time ?t))
?f5<-	(penalty ?penalty)	
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer yes))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (modify ?f4 (time (+ ?t 1)) (step (+ ?i 1)))
        (assert (penalty (+ ?penalty 200000)))
	(retract ?f5)
)



;// l'agente ha inviato inform che meal è wait (e va bene)

(defrule msg-meal-wait-OK    
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 meal) (param3 wait))
?f2<-	(mealstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
?f4<-   (pillstatus (step ?i) (time ?t) (for ?p) (when before))			
?f3<-	(agentstatus (step ?i) (time ?t))	
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer wait))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (modify ?f4 (time (+ ?t 1)) (step (+ ?i 1)))
)


;// l'agente ha inviato inform che meal è wait (e non va bene dovrebbe essere yes)

(defrule msg-meal-wait-KO1    
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 meal) (param3 wait))
?f2<-	(mealstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
?f4<-   (pillstatus (step ?i) (time ?t) (for ?p) (when no|after))		
?f3<-	(agentstatus (step ?i) (time ?t))
?f5<-	(penalty ?penalty)	
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer wait))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (modify ?f4 (time (+ ?t 1)) (step (+ ?i 1)))
        (assert (penalty (+ ?penalty 200000)))
	(retract ?f5)
)

;// l'agente ha inviato inform che meal è reject (e non va bene)

(defrule msg-meal-reject-KO1    
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 meal) (param3 reject))
?f2<-	(mealstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))		
?f3<-	(agentstatus (step ?i) (time ?t))
?f5<-	(penalty ?penalty)	
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer reject))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (assert (penalty (+ ?penalty 500000)))
	(retract ?f5)
)

;// l'agente ha inviato inform che dessert è yes (e va bene)

(defrule msg-dessert-yes-OK1    
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 dessert) (param3 yes))
?f2<-	(dessertstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
        (prescription (patient ?p) (dessert yes))
?f4<-   (pillstatus (step ?i) (time ?t) (for ?p) (when no))
?f5<-   (mealstatus (step ?i) (time ?t) (requested-by ?p) (delivered yes))		
?f3<-	(agentstatus (step ?i) (time ?t))	
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer yes))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (modify ?f4 (time (+ ?t 1)) (step (+ ?i 1)))
        (modify ?f5 (time (+ ?t 1)) (step (+ ?i 1)))
)

(defrule msg-dessert-yes-OK2    
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 dessert) (param3 yes))
?f2<-	(dessertstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
        (prescription (patient ?p) (dessert yes))
?f4<-   (pillstatus (step ?i) (time ?t) (for ?p) (delivered yes))		
?f3<-	(agentstatus (step ?i) (time ?t))
?f5<-   (mealstatus (step ?i) (time ?t) (requested-by ?p) (delivered yes))		
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer yes))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (modify ?f4 (time (+ ?t 1)) (step (+ ?i 1)))
        (modify ?f5 (time (+ ?t 1)) (step (+ ?i 1)))
)


;// l'agente ha inviato inform che dessert è yes   (ma non sono vere le condizioni)

(defrule msg-dessert-yes-KO        
	(declare (salience 19))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 dessert) (param3 yes))
?f2<-	(dessertstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
?f3<-	(agentstatus (step ?i) (time ?t))
?f5<-	(penalty ?penalty)	
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer yes))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (assert (penalty (+ ?penalty 200000)))
	(retract ?f5)
)  



;// l'agente ha inviato inform che dessert è wait (e va bene)

(defrule msg-dessert-wait-OK1    
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 dessert) (param3 wait))
?f2<-	(dessertstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
        (prescription (patient ?p) (dessert yes))
?f4<-   (pillstatus (step ?i) (time ?t) (for ?p) (when after) (delivered no))			
?f5<-   (mealstatus (step ?i) (time ?t) (requested-by ?p) (delivered yes))
?f3<-	(agentstatus (step ?i) (time ?t))	
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer wait))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (modify ?f4 (time (+ ?t 1)) (step (+ ?i 1)))
)

;(defrule msg-dessert-wait-OK2    
;	(declare (salience 20))
;?f1<-	(status (step ?i) (time ?t))
;	(exec (step ?i) (action Inform) (param1 ?p) (param2 dessert) (param3 wait))
;?f2<-	(dessertstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
;        (prescription (patient ?p) (dessert yes))
;?f4<-   (pillstatus (step ?i) (time ?t) (for ?p) (when no))
;?f5<-   (mealstatus (step ?i) (time ?t) (requested-by ?p) (delivered no))		
;?f3<-	(agentstatus (step ?i) (time ?t))	
;=> 
;	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
;	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer wait))
;	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
;        (modify ?f4 (time (+ ?t 1)) (step (+ ?i 1)))
;        (modify ?f5 (time (+ ?t 1)) (step (+ ?i 1)))
;)


;// l'agente ha inviato inform che dessert è wait (ma non va bene )

(defrule msg-dessert-wait-KO        
	(declare (salience 19))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 dessert) (param3 wait))
?f2<-	(dessertstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
?f5<-	(penalty ?penalty)
?f3<-	(agentstatus (step ?i) (time ?t))	
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer wait))
        (assert (penalty (+ ?penalty 200000)))
	(retract ?f5)
        (modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
)




;// l'agente ha inviato inform che dessert è reject (e va bene)

(defrule msg-dessert-reject-OK1    
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 dessert) (param3 reject))
?f2<-	(dessertstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
        (prescription (patient ?p) (dessert no))		
?f3<-	(agentstatus (step ?i) (time ?t))	
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer reject))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
)

;(defrule msg-dessert-reject-OK2    
;	(declare (salience 20))
;f1<-	(status (step ?i) (time ?t))
;	(exec (step ?i) (action Inform) (param1 ?p) (param2 dessert) (param3 reject))
;?f2<-	(dessertstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
;        (prescription (patient ?p) (dessert yes))
;        (not (mealstatus (step ?i) (time ?t) (requested-by ?p))) 		
;?f3<-	(agentstatus (step ?i) (time ?t))	
;=> 
;	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
;	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer yes))
;	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
;)


;// l'agente ha inviato inform che dessert è reject (ma NON va bene)

(defrule msg-dessert-reject-KO        
	(declare (salience 19))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 dessert) (param3 reject))
?f2<-	(dessertstatus (step ?i) (time ?t) (requested-by ?p) (answer pending))
?f3<-	(agentstatus (step ?i) (time ?t))
?f5<-	(penalty ?penalty)	
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)) (answer reject))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (assert (penalty (+ ?penalty 200000)))
	(retract ?f5)
)

;// l'agente invia un'inform  per un servizio che non è più pending


(defrule msg-meal-useless    
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 meal))
?f2<-	(mealstatus (step ?i) (time ?t) (requested-by ?p) (answer ~pending))		
?f3<-	(agentstatus (step ?i) (time ?t))
?f4<-	(penalty ?penalty)
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)))
        (modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (assert (penalty (+ ?penalty 50000)))
        (retract ?f4)
	
)

(defrule msg-dessert-useless   
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 dessert))
?f2<-	(dessertstatus (step ?i) (time ?t) (requested-by ?p) (answer ~pending))		
?f3<-	(agentstatus (step ?i) (time ?t))
?f4<-	(penalty ?penalty)
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f2 (time (+ ?t 1)) (step (+ ?i 1)))
        (modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
        (assert (penalty (+ ?penalty 50000)))
        (retract ?f4)
	
)


;// arriva un'inform per una richiesta non fatta dalla persona (meal)
(defrule msg-meal-wrong    
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 meal))
        (not (mealstatus (step ?i) (time ?t) (requested-by ?p))) 
?f3<-	(agentstatus (step ?i) (time ?t))
?f4<-	(penalty ?penalty)
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
	(assert (penalty (+ ?penalty 500000)))
	(retract ?f4)
)

;// arriva un'inform per una richiesta non fatta dalla persona (dessert)
(defrule msg-dessert-wrong    
	(declare (salience 20))
?f1<-	(status (step ?i) (time ?t))
	(exec (step ?i) (action Inform) (param1 ?p) (param2 dessert))
        (not (dessertstatus (step ?i) (time ?t) (requested-by ?p))) 
?f3<-	(agentstatus (step ?i) (time ?t))
?f4<-	(penalty ?penalty)
=> 
	(modify ?f1 (time (+ ?t 1)) (step (+ ?i 1)))
	(modify ?f3 (time (+ ?t 1)) (step (+ ?i 1)))
	(assert (penalty (+ ?penalty 500000)))
	(retract ?f4)
)




;// __________________________________________________________________________________________
;// REGOLE PER il Clean Table


;// Operazione OK
;// il pasto è stato consegnato parecchio tempo fa e il tavolo è sporco

(defrule cleantable_North_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered yes) (delivertime ?dt))
        (test (> (- ?t ?dt) 500))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 30)))
)

;// la persona seduta al tavolo ha chiesto un dessert e il tavolo è sporco

(defrule cleantable_North_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by ?id))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 30)))
)

;// il tavo.o è sporco e non c'è nessuno seduto al tavolo


(defrule cleantable_North_OK3
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by no))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
)

;// il pasto è stato consegnato parecchio tempo fa e il tavolo è sporco

(defrule cleantable_South_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered yes) (delivertime ?dt))
        (test (> (- ?t ?dt) 500))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 30)))
)

;// la persona seduta al tavolo ha chiesto un dessert e il tavolo è sporco

(defrule cleantable_South_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by ?id))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 30)))
)

;// il tavo.o è sporco e non c'è nessuno seduto al tavolo


(defrule cleantable_South_OK3
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by no))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
)

;// il pasto è stato consegnato parecchio tempo fa e il tavolo è sporco

(defrule cleantable_East_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1))
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered yes) (delivertime ?dt))
        (test (> (- ?t ?dt) 500))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 30)))
)

;// la persona seduta al tavolo ha chiesto un dessert e il tavolo è sporco

(defrule cleantable_East_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by ?id))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 30)))
)

;// il tavo.o è sporco e non c'è nessuno seduto al tavolo


(defrule cleantable_East_OK3
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by no))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
)

;// il pasto è stato consegnato parecchio tempo fa e il tavolo è sporco

(defrule cleantable_West_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1))
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered yes) (delivertime ?dt))
        (test (> (- ?t ?dt) 500))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 30)))
)

;// la persona seduta al tavolo ha chiesto un dessert e il tavolo è sporco

(defrule cleantable_West_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1))
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by ?id))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 30)))
)

;// il tavolo è sporco e non c'è nessuno seduto al tavolo


(defrule cleantable_West_OK3
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no) (occupied-by no))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
)


;// CleanTable  ha fisicamente successo ma fatta quando non si deve
 
(defrule cleantable_North_feasable-incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y)
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no))
?f4 <- (penalty ?p)

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (assert (penalty (+ ?p 400000)))
        (retract ?f4)
)

(defrule cleantable_South_feasable-incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no))
?f4 <- (penalty ?p)

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (assert (penalty (+ ?p 400000)))
        (retract ?f4)
)

(defrule cleantable_East_feasable-incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no))
?f4 <- (penalty ?p)

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (assert (penalty (+ ?p 400000)))
        (retract ?f4)
)

(defrule cleantable_West_feasable-incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean no))
?f4 <- (penalty ?p)

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (assert (penalty (+ ?p 400000)))
        (retract ?f4)
)




;// azione inutile di cleantable perchè il tavolo è già pulito

(defrule cleantable_North_feasable-useless
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y)
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes))
?f4 <- (penalty ?p)

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (assert (penalty (+ ?p 1000)))
        (retract ?f4)
)

(defrule cleantable_South_feasable-useless
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes))
?f4 <- (penalty ?p)

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (assert (penalty (+ ?p 1000)))
        (retract ?f4)
)

(defrule cleantable_East_feasable-useless
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes))
?f4 <- (penalty ?p)

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (assert (penalty (+ ?p 1000)))
        (retract ?f4)
)


(defrule cleantable_West_feasable-useless
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (free 2))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes))
?f4 <- (penalty ?p)

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 30)) (waste yes))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)) (clean yes))
        (assert (penalty (+ ?p 1000)))
        (retract ?f4)
)


;// Operazione di CleanTable fisicamente impossibile

(defrule Cleantable_unfeasable
	(declare (salience 18))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CleanTable) (param1 ?x) (param2 ?y))
?f3<-   (agentstatus (time ?t) (step ?i))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 30)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 30)))
        (retract ?f4)
        (assert (penalty (+ ?p 200000)))
)




;/// REGOLE PER WAIT

(defrule WAIT
	(declare (salience 20))
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action Wait))
?f1<-	(agentstatus (step ?i) (time ?t))   
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 5)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 5)))
)

;// *******************************************************************
;// REGOLE PER CheckId

;// Operazione OK

(defrule CheckId_North_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CheckId) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains PersonSeated|PersonStanding))
?f1<-	(agentstatus (step ?i) (time ?t) (direction north) (pos-r =(- ?x 1)) (pos-c ?y))
?f3<-   (personstatus (step ?i) (time ?t) (ident ?id) (pos-r ?x) (pos-c ?y))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 20)))
        (assert (perc-id (step (+ ?i 1)) (time (+ ?t 20)) (id ?id) (type patient)))
)

(defrule CheckId_North_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CheckId) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains PersonStanding))
?f1<-	(agentstatus (step ?i) (time ?t) (direction north) (pos-r =(- ?x 1)) (pos-c ?y))
?f3<-   (staffstatus (step ?i) (time ?t) (ident ?id) (pos-r ?x) (pos-c ?y))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 20)))
        (assert (perc-id (step (+ ?i 1)) (time (+ ?t 20)) (id ?id) (type staff)))
)


(defrule CheckId_South_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CheckId) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains PersonSeated|PersonStanding))
?f1<-	(agentstatus (step ?i) (time ?t) (direction south) (pos-r =(+ ?x 1)) (pos-c ?y))
?f3<-   (personstatus (step ?i) (time ?t) (ident ?id) (pos-r ?x) (pos-c ?y))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 20)))
        (assert (perc-id (step (+ ?i 1)) (time (+ ?t 20)) (id ?id) (type patient)))
)

(defrule CheckId_South_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CheckId) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains PersonStanding))
?f1<-	(agentstatus (step ?i) (time ?t) (direction south) (pos-r =(+ ?x 1)) (pos-c ?y))
?f3<-   (staffstatus (step ?i) (time ?t) (ident ?id) (pos-r ?x) (pos-c ?y))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 20)))
        (assert (perc-id (step (+ ?i 1)) (time (+ ?t 20)) (id ?id) (type staff)))
)



(defrule CheckId_East_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CheckId) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains PersonSeated|PersonStanding))
?f1<-	(agentstatus (step ?i) (time ?t) (direction east) (pos-r ?x) (pos-c =(- ?y 1)))
?f3<-   (personstatus (step ?i) (time ?t) (ident ?id) (pos-r ?x) (pos-c ?y))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 20)))
        (assert (perc-id (step (+ ?i 1)) (time (+ ?t 20)) (id ?id) (type patient)))
)

(defrule CheckId_East_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CheckId) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains PersonStanding))
?f1<-	(agentstatus (step ?i) (time ?t) (direction east) (pos-r ?x) (pos-c =(- ?y 1)))
?f3<-   (staffstatus (step ?i) (time ?t) (ident ?id) (pos-r ?x) (pos-c ?y))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 20)))
        (assert (perc-id (step (+ ?i 1)) (time (+ ?t 20)) (id ?id) (type staff)))
)


(defrule CheckId_West_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CheckId) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains PersonSeated|PersonStanding))
?f1<-	(agentstatus (step ?i) (time ?t) (direction west) (pos-r ?x) (pos-c =(+ ?y 1)))
?f3<-   (personstatus (step ?i) (time ?t) (ident ?id) (pos-r ?x) (pos-c ?y))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 20)))
        (assert (perc-id (step (+ ?i 1)) (time (+ ?t 20)) (id ?id) (type patient)))
)

(defrule CheckId_West_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CheckId) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains PersonStanding))
?f1<-	(agentstatus (step ?i) (time ?t) (direction west) (pos-r ?x) (pos-c =(+ ?y 1)))
?f3<-   (staffstatus (step ?i) (time ?t) (ident ?id) (pos-r ?x) (pos-c ?y))

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 20)))
        (assert (perc-id (step (+ ?i 1)) (time (+ ?t 20)) (id ?id) (type staff)))
)

;// Operazione di CheckId  fallisce per qualsiasi motivo

 (defrule CheckId_KO
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action CheckId) (param1 ?x) (param2 ?y))
?f3<-   (agentstatus (step ?i) (time ?t))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f3 (step (+ ?i 1)) (time (+ ?t 20)))
) 

;// __________________________________________________________________________________________
;// REGOLE PER il prelievo di Meal da meal Dispenser

;// Operazione OK
(defrule load-meal_North_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains MealDispenser))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 15)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 ?type)))
)

(defrule load-meal_South_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains MealDispenser))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 15)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 ?type)))
)


(defrule load-meal_East_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains MealDispenser))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 15)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 ?type)))
)

(defrule load-meal_West_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains MealDispenser))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 15)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 ?type)))
)


;// Operazione di LoadMeal  fallisce per qualsiasi motivo

 (defrule load-meal_KO
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadMeal) (param1 ?x) (param2 ?y) (param3 ?type))
?f3<-   (agentstatus (step ?i) (time ?t))
?f1<-   (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)))
	(modify ?f3 (step (+ ?i 1)) (time (+ ?t 15)))
        (retract ?f1)
        (assert (penalty (+ ?p 100000)))
) 




;// __________________________________________________________________________________________
;// REGOLE PER il prelievo di DESSERT   da DessertDispenser

;// Operazione OK
(defrule load-dessert_North_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains DessertDispenser))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 15)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 dessert)))
)

(defrule load-dessert_South_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains DessertDispenser))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 15)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 dessert)))
)


(defrule load-dessert_East_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains DessertDispenser))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 15)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 dessert)))
)

(defrule load-dessert_West_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains DessertDispenser))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 15)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 dessert)))
)


;// Operazione di LoadDessert  fallisce per qualsiasi motivo

 (defrule load-dessert_KO
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadDessert) (param1 ?x) (param2 ?y))
?f3<-   (agentstatus (step ?i) (time ?t))
?f1<-   (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)))
	(modify ?f3 (step (+ ?i 1)) (time (+ ?t 15)))
        (retract ?f1)
        (assert (penalty (+ ?p 100000)))
) 

 ;// __________________________________________________________________________________________
;// REGOLE PER il prelievo di PILLS   da PillDispenser


;// Operazione OK

(defrule load-pill_North_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadPill) (param1 ?x) (param2 ?y)(param3 ?id))
	(cell (pos-r ?x) (pos-c ?y) (contains PillDispenser))
?f3<-   (pillrepository (content $?cc))
        (test (member$ ?id $?cc))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 ?id)))
        (modify ?f3 (content (delete-member$ $?cc ?id)))
)


(defrule load-pill_South_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadPill) (param1 ?x) (param2 ?y)(param3 ?id))
	(cell (pos-r ?x) (pos-c ?y) (contains PillDispenser))
?f3<-   (pillrepository (content $?cc))
        (test (member$ ?id $?cc))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 ?id)))
        (modify ?f3 (content (delete-member$ $?cc ?id)))
)


(defrule load-pill_East_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadPill) (param1 ?x) (param2 ?y)(param3 ?id))
	(cell (pos-r ?x) (pos-c ?y) (contains PillDispenser))
?f3<-   (pillrepository (content $?cc))
        (test (member$ ?id $?cc))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 ?id)))
        (modify ?f3 (content (delete-member$ $?cc ?id)))
)


(defrule load-pill_West_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadPill) (param1 ?x) (param2 ?y)(param3 ?id))
	(cell (pos-r ?x) (pos-c ?y) (contains PillDispenser))
?f3<-   (pillrepository (content $?cc))
        (test (member$ ?id $?cc))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (> ?ff 0))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)) (free (- ?ff 1))
                    (content (insert$ $?cont 1 ?id)))
        (modify ?f3 (content (delete-member$ $?cc ?id)))
)


;// Operazione di LoadPill  fallisce per qualsiasi motivo

 (defrule load-pill_KO
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action LoadPill) (param1 ?x) (param2 ?y) (param3 ?id))
?f3<-   (agentstatus (step ?i) (time ?t))
?f1<-   (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 15)))
	(modify ?f3 (step (+ ?i 1)) (time (+ ?t 15)))
        (retract ?f1)
        (assert (penalty (+ ?p 100000)))
)   


;// __________________________________________________________________________________________
;// REGOLE PER LA CONSEGNA di MEAL ad una persona
;// 

;// Operazione OK


(defrule delivery-meal_North_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?id) (when no|after))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes) 
                    (delivertime (+ ?t 12)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)


(defrule delivery-meal_North_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?id) (when before) (delivered yes))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes) 
                    (delivertime (+ ?t 12)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)

(defrule delivery-meal_South_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?id) (when no|after))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes)
                    (delivertime (+ ?t 12)))
       (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)



(defrule delivery-meal_South_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?id) (when before) (delivered yes))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes)
                    (delivertime (+ ?t 12)))
       (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)



(defrule delivery-meal_East_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?id) (when no|after))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes)
                    (delivertime (+ ?t 12)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)

(defrule delivery-meal_East_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?id) (when before) (delivered yes))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes)
                    (delivertime (+ ?t 12)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)


(defrule delivery-meal_West_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?id) (when no|after))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes)
                    (delivertime (+ ?t 12)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)

(defrule delivery-meal_West_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (clean yes) (occupied-by ?id))
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (type ?type)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?id) (when before) (delivered yes))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes)
                    (delivertime (+ ?t 12)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)



;// Operazione fisicamente possibile, ma in situazione errata 

(defrule delivery-meal_North_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (retract ?f4)
        (assert (penalty (+ ?p 1000000)))
)

(defrule delivery-meal_South_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (retract ?f4)
        (assert (penalty (+ ?p 1000000)))
)

(defrule delivery-meal_East_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (retract ?f4)
        (assert (penalty (+ ?p 1000000)))
)

(defrule delivery-meal_West_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?type $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?type)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (retract ?f4)
        (assert (penalty (+ ?p 1000000)))
)
;// Operazione fisicamente impossibile

(defrule delivery-meal_unfeasable_incorrect
	(declare (salience 18))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryMeal) (param1 ?x) (param2 ?y) (param3 ?type))
?f3<-   (agentstatus (time ?t) (step ?i))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (retract ?f4)
        (assert (penalty (+ ?p 200000)))
)


;// __________________________________________________________________________________________
;// REGOLE PER LA CONSEGNA Di DESSERT ad una persona



(defrule delivery-dessert_North_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?id))
        (prescription (patient ?id) (dessert yes) (pills no|before))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (delivered yes)) 

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)

(defrule delivery-dessert_North_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?id))
        (prescription (patient ?id) (dessert yes) (pills after))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (delivered yes))
?f6 <-  (pillstatus (step ?i) (time ?t) (for ?id) (delivered yes))  

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f6 (step (+ ?i 1)) (time (+ ?t 12)))
)


(defrule delivery-dessert_South_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?id))
        (prescription (patient ?id) (dessert yes) (pills no|before))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (delivered yes)) 

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)

(defrule delivery-dessert_South_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?id))
        (prescription (patient ?id) (dessert yes) (pills after))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (delivered yes))
?f6 <-  (pillstatus (step ?i) (time ?t) (for ?id) (delivered yes))  

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f6 (step (+ ?i 1)) (time (+ ?t 12)))
)


(defrule delivery-dessert_East_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?id))
        (prescription (patient ?id) (dessert yes) (pills no|before))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (delivered yes)) 

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)

(defrule delivery-dessert_East_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1))
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?id))
        (prescription (patient ?id) (dessert yes) (pills after))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (delivered yes))
?f6 <-  (pillstatus (step ?i) (time ?t) (for ?id) (delivered yes))  

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f6 (step (+ ?i 1)) (time (+ ?t 12)))
)


(defrule delivery-dessert_West_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?id))
        (prescription (patient ?id) (dessert yes) (pills no|before))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (delivered yes)) 

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
)

(defrule delivery-dessert_West_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1))
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?id))
        (prescription (patient ?id) (dessert yes) (pills after))
?f4 <-  (dessertstatus (step ?i) (time ?t) (requested-by ?id)
                    (tpos-r ?x) (tpos-c ?y) (delivered no))
?f5 <-  (mealstatus (step ?i) (time ?t) (requested-by ?id) (delivered yes))
?f6 <-  (pillstatus (step ?i) (time ?t) (for ?id) (delivered yes))  

=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 12)) (delivered yes))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f6 (step (+ ?i 1)) (time (+ ?t 12)))
)



;// Operazione fisicamente possibile, ma in situazione errata 

(defrule delivery-dessert_North_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (retract ?f4)
        (assert (penalty (+ ?p 1000000)))
)

(defrule delivery-dessert_South_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (retract ?f4)
        (assert (penalty (+ ?p 1000000)))
)

(defrule delivery-dessert_East_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (retract ?f4)
        (assert (penalty (+ ?p 1000000)))
)

(defrule delivery-dessert_West_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ dessert $?cont))
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 12)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont dessert)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)) (clean no))
        (retract ?f4)
        (assert (penalty (+ ?p 1000000)))
)
;// Operazione fisicamente impossibile

(defrule delivery-dessert_unfeasable_incorrect
	(declare (salience 18))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryDessert) (param1 ?x) (param2 ?y))
?f3<-   (agentstatus (time ?t) (step ?i))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 12)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 12)))
        (retract ?f4)
        (assert (penalty (+ ?p 200000)))
)
;// Regole per la generazione di percload

(defrule perc-load-generation1
        (declare (salience 15))
	(status (time ?t) (step ?i)) 
	(exec (step ?ii&:(= ?ii (- ?i 1))) (action DeliveryMeal|DeliveryDessert|DeliveryPill|LoadMeal|LoadPill|LoadDessert|EmptyRobot))               
        (agentstatus (step ?i)  (free  2))	
=>      (assert (perc-load (time ?t) (step ?i) (load no)))
)

(defrule perc-load-generation2
        (declare (salience 15))
	(status (time ?t) (step ?i)) 
	(exec (step ?ii&:(= ?ii (- ?i 1))) (action DeliveryMeal|DeliveryDessert|DeliveryPill|LoadMeal|LoadPill|LoadDessert|EmptyRobot))
        (agentstatus (step ?i)  (free 0|1))	
=>      (assert (perc-load (time ?t) (step ?i) (load yes)))
)




; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;// __________________________________________________________________________________________
;// REGOLE PER LA CONSEGNA di pill ad una persona
;// 

;// Operazione OK


(defrule delivery-pill_North_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))        
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?rec))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?rec) (delivered no)(when before))  
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?rec)
                    (delivered no))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 8)) (delivered yes))
)

(defrule delivery-pill_North_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))        
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?rec))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?rec) (delivered no)(when after))  
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?rec)
                    (delivered yes))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 8)) (delivered yes))
)


(defrule delivery-pill_South_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))        
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?rec))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?rec) (delivered no)(when before))  
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?rec)
                    (delivered no))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 8)) (delivered yes))
)

(defrule delivery-pill_South_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))        
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?rec))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?rec) (delivered no)(when after))  
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?rec)
                    (delivered yes))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 8)) (delivered yes))
)



(defrule delivery-pill_East_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))        
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?rec))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?rec) (delivered no)(when before))  
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?rec)
                    (delivered no))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 8)) (delivered yes))
)

(defrule delivery-pill_East_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))        
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?rec))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?rec) (delivered no)(when after))  
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?rec)
                    (delivered yes))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 8)) (delivered yes))
)

(defrule delivery-pill_West_OK1
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))        
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?rec))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?rec) (delivered no)(when before))  
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?rec)
                    (delivered no))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 8)) (delivered yes))
)

(defrule delivery-pill_West_OK2
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))        
?f3 <-  (tablestatus (step ?i) (time ?t) (pos-r ?x) (pos-c ?y) 
                     (occupied-by ?rec))
?f5 <-  (pillstatus (step ?i) (time ?t) (for ?rec) (delivered no)(when after))  
?f4 <-  (mealstatus (step ?i) (time ?t) (requested-by ?rec)
                    (delivered yes))
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f4 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f5 (step (+ ?i 1)) (time (+ ?t 8)) (delivered yes))
)


;// Operazione fisicamente possibile, ma in situazione errata 

(defrule delivery-pill_North_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (retract ?f4)
        (assert (penalty (+ ?p 2000000)))
)

(defrule delivery-pill_South_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (retract ?f4)
        (assert (penalty (+ ?p 2000000)))
)



(defrule delivery-pill_East_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1))  
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (retract ?f4)
        (assert (penalty (+ ?p 2000000)))
)




(defrule delivery-pill_West_feasable_incorrect
	(declare (salience 19))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill) (param1 ?x) (param2 ?y) (param3 ?rec))
	(cell (pos-r ?x) (pos-c ?y) (contains Table))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1))  
                     (waste no) (free ?ff) (content $?cont))
        (test (member$ ?rec $?cont))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 8)) (free (+ ?ff 1))
                    (content (delete-member$ $?cont ?rec)))
        (retract ?f4)
        (assert (penalty (+ ?p 2000000)))
)





;// Operazione fisicamente impossibile

(defrule delivery-pill_unfeasable_incorrect
	(declare (salience 18))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action DeliveryPill))
?f3<-   (agentstatus (time ?t) (step ?i))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 8)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 8)))
        (retract ?f4)
        (assert (penalty (+ ?p 200000)))
)

;// __________________________________________________________________________________________
;// REGOLE PER  ReleaseTrash
;// 

;// Operazione OK


(defrule ReleaseTrash_North_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action ReleaseTrash) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste yes) (free 2))       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)) (waste no))
)


(defrule ReleaseTrash_South_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action ReleaseTrash) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste yes) (free 2))       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)) (waste no))
)


(defrule ReleaseTrash_East_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action ReleaseTrash) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1))
                     (waste yes) (free 2))       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)) (waste no))
)

(defrule ReleaseTrash_West_OK
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action ReleaseTrash) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1))
                     (waste yes) (free 2))       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)) (waste no))
)




;// Operazione fisicamente possibile, ma il robot non ha rifiuti 



(defrule ReleaseTrash_North_no_waste
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action ReleaseTrash) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (waste no))
?f3<-   (penalty ?p)       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000)))
)


(defrule ReleaseTrash_South_no_waste
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action ReleaseTrash) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (waste no))
?f3<-   (penalty ?p)       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000)))
)


(defrule ReleaseTrash_East_no_waste
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action ReleaseTrash) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (waste no))
?f3<-   (penalty ?p)       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000)))
)

(defrule ReleaseTrash_West_no_waste
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action ReleaseTrash) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (waste no))
?f3<-   (penalty ?p)       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 10)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000)))
)



;// Operazione fisicamente impossibile

(defrule ReleaseTrash_unfeasable_incorrect
	(declare (salience 18))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action ReleaseTrash) (param1 ?x) (param2 ?y))
?f3<-   (agentstatus (time ?t) (step ?i))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 10)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 10)))
        (retract ?f4)
        (assert (penalty (+ ?p 200000)))
)

;// __________________________________________________________________________________________
;// REGOLE PER  EmptyRobot
;// 


; operazione ficamente possibile con robot carico

(defrule EmptyRobot_North_loaded
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action EmptyRobot) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (free 0|1))
?f3<-   (penalty ?p)       
=> 
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)) (free 2))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000000)))
)


(defrule EmptyRobot_South_loaded
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action EmptyRobot) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (free 0|1))
?f3<-   (penalty ?p)       
=> 
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)) (free 2))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000000)))
)


(defrule EmptyRobot_East_loaded
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action EmptyRobot) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (free 0|1))
?f3<-   (penalty ?p)       
=> 
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)) (free 2))
	(modify ?f3 (step (+ ?i 1)) (time (+ ?t 20)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000000)))
)

(defrule EmptyRobot_West_loaded
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action EmptyRobot) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (free 0|1))
?f3<-   (penalty ?p)       
=> 
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)) (free 2))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000000)))
)


;// Operazione fisicamente possibile, ma il robot è scarico



(defrule EmptyRobot_North_already_empty
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action EmptyRobot) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(- ?x 1)) (pos-c ?y) 
                     (free 2))
?f3<-   (penalty ?p)       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000)))
)


(defrule EmptyRobot_South_already_empty
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action EmptyRobot) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r =(+ ?x 1)) (pos-c ?y) 
                     (free 2))
?f3<-   (penalty ?p)       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000)))
)


(defrule EmptyRobot_East_already_empty
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action EmptyRobot) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(- ?y 1)) 
                     (free 2))
?f3<-   (penalty ?p)       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000)))
)

(defrule EmptyRobot_West_already_empty
	(declare (salience 20))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action EmptyRobot) (param1 ?x) (param2 ?y))
	(cell (pos-r ?x) (pos-c ?y) (contains TrashBasket))
?f1<-	(agentstatus (step ?i) (time ?t) (pos-r ?x) (pos-c =(+ ?y 1)) 
                     (free 2))
?f3<-   (penalty ?p)       
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 20)))
        (retract ?f3)
        (assert (penalty (+ ?p 1000)))
)


;// Operazione fisicamente impossibile

(defrule EmptyRobot_unfeasable
	(declare (salience 18))    
?f2<-	(status (time ?t) (step ?i)) 
	(exec (step ?i) (action EmptyRobot) (param1 ?x) (param2 ?y))
?f3<-   (agentstatus (time ?t) (step ?i))
?f4 <-  (penalty ?p)
=> 
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 20)))
        (modify ?f3 (step (+ ?i 1)) (time (+ ?t 20)))
        (retract ?f4)
        (assert (penalty (+ ?p 200000)))
)

;*****************************************************
;      AZIONI DI MOVIMENTO
;*****************************************************

(defrule forward-north-ok 
	(declare (salience 20))    
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Forward))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north))
?f4<-   (cell (pos-r ?r) (pos-c ?c) (contains Robot) (previous ?pp))
?f3<-	(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains Empty|Parking) (previous ?prev))
=> 
	(modify ?f1 (pos-r (+ ?r 1)) (step (+ ?i 1)) (time (+ ?t 1)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)))
        (modify ?f4 (contains ?pp))
        (modify ?f3 (contains Robot) (previous ?prev))		
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - azione eseguita: Forward" crlf)	
;	(printout t " - in direzione: north" crlf)
;	(printout t " - nuova posizione dell'agente: (" (+ ?r 1) "," ?c ")" crlf)	
) 
 
(defrule forward-north-bump 
	(declare (salience 20))    
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Forward))
?f1<-   (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north))
	(cell (pos-r =(+ ?r 1)) (pos-c ?c) (contains ~Empty&~Parking))
?f3<-   (penalty ?p)
=> 
	(modify ?f1  (step (+ ?i 1)) (time (+ ?t 1)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)))
	(assert (perc-bump (step (+ ?i 1)) (time (+ ?t 1)) (pos-r ?r) (pos-c ?c) (direction north) (bump yes)))
	(retract ?f3)
	(assert (penalty (+ ?p 10000000)))
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - penalità +10000000 (Forward-north-bump): " (+ ?p 10000000) crlf)
)
 
(defrule forward-south-ok 
	(declare (salience 20))    
?f2<-	(status (step ?i) (time ?t))  
	(exec (step ?i) (action  Forward))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south))
?f4<-   (cell (pos-r ?r) (pos-c ?c) (contains Robot) (previous ?pp))
?f3<-	(cell (pos-r =(- ?r 1)) (pos-c ?c) (contains Empty|Parking) (previous ?prev))
=> 
	(modify ?f1 (pos-r (- ?r 1)) (step (+ ?i 1)) (time (+ ?t 1)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)))
        (modify ?f4 (contains ?pp))
        (modify ?f3 (contains Robot) (previous ?prev))		
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - azione eseguita: Forward" crlf)	
;	(printout t " - in direzione: south" crlf)
;	(printout t " - nuova posizione dell'agente: (" (- ?r 1) "," ?c ")" crlf)
)
  

(defrule forward-south-bump 
	(declare (salience 20))    
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Forward))
?f1<-   (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south))
	(cell (pos-r =(- ?r 1)) (pos-c ?c) (contains ~Empty&~Parking))
?f3<-   (penalty ?p)
=> 
	(modify ?f1 (step (+ ?i 1)) (time (+ ?t 1)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)))
	(assert (perc-bump (step (+ ?i 1)) (time (+ ?t 1)) (pos-r ?r) (pos-c ?c) (direction south) (bump yes)))
	(retract ?f3)
	(assert (penalty (+ ?p 10000000)))
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - penalità +10000000 (forward-south-bump): " (+ ?p 10000000) crlf)
) 

(defrule forward-west-ok 
	(declare (salience 20))    
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Forward))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west))
?f4<-   (cell (pos-r ?r) (pos-c ?c) (contains Robot) (previous ?pp))
?f3<-	(cell (pos-r ?r) (pos-c =(- ?c 1)) (contains Empty|Parking) (previous ?prev))
=> 
	(modify ?f1 (pos-c (- ?c 1)) (step (+ ?i 1)) (time (+ ?t 1)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)))
        (modify ?f4 (contains ?pp))
        (modify ?f3 (contains Robot) (previous ?prev))		
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - azione eseguita: Forward" crlf)	
;	(printout t " - in direzione: west" crlf)
;	(printout t " - nuova posizione dell'agente: (" ?r "," (- ?c 1) ")" crlf)	
)


(defrule forward-west-bump 
	(declare (salience 20))    
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Forward))
?f1<-   (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west))
	(cell (pos-r ?r) (pos-c =(- ?c 1)) (contains ~Empty&~Parking))
?f3<-   (penalty ?p)
=> 
	(modify  ?f1  (step (+ ?i 1)) (time (+ ?t 1)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)))
	(assert (perc-bump (step (+ ?i 1)) (time (+ ?t 1)) (pos-r ?r) (pos-c ?c) (direction west) (bump yes)))
	(retract ?f3)
	(assert (penalty (+ ?p 10000000)))
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - penalità +10000000 (forward-west-bump): " (+ ?p 10000000) crlf)
)

(defrule forward-east-ok 
	(declare (salience 20))    
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Forward))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction east))
?f4<-   (cell (pos-r ?r) (pos-c ?c) (contains Robot) (previous ?pp))
?f3<-	(cell (pos-r ?r) (pos-c =(+ ?c 1)) (contains Empty|Parking) (previous ?prev))
=> 
	(modify  ?f1 (pos-c (+ ?c 1)) (step (+ ?i 1)) (time (+ ?t 1)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)))
        (modify ?f4 (contains ?pp))
        (modify ?f3 (contains Robot) (previous ?prev))		
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - azione eseguita: Forward" crlf)	
;	(printout t " - in direzione: east" crlf)
;	(printout t " - nuova posizione dell'agente: (" ?r "," (+ ?c 1) ")" crlf)
) 


(defrule forward-east-bump 
	(declare (salience 20))    
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Forward))
?f1<-   (agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction east))
	(cell (pos-r ?r) (pos-c =(+ ?c 1)) (contains ~Empty&~Parking))
?f3<-   (penalty ?p)
=> 
	(modify  ?f1  (step (+ ?i 1)) (time (+ ?t 1)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 1)))
	(assert (perc-bump (step (+ ?i 1)) (time (+ ?t 2)) (pos-r ?r) (pos-c ?c) (direction east) (bump yes)))
	(retract ?f3)
	(assert (penalty (+ ?p 10000000)))
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - penalità +10000000 (forward-east-bump): " (+ ?p 10000000) crlf)
)

(defrule turnleft1
	(declare (salience 20))      
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Turnleft))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west))
	(cell (pos-r ?r) (pos-c ?c))
=>	
	(modify  ?f1 (direction south) (step (+ ?i 1)) (time (+ ?t 2)) )
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)) )		
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - azione eseguita: turnleft" crlf)	
;	(printout t " - nuova direzione dell'agente: south" crlf)
)

(defrule turnleft2
	(declare (salience 20))      
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Turnleft))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south))
	(cell (pos-r ?r) (pos-c ?c))
=> 
	(modify  ?f1 (direction east) (step (+ ?i 1)) (time (+ ?t 2)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)))		
;	(printout t " ENVIRONMENT:" crlf)
;     	(printout t " - azione eseguita: turnleft" crlf)	
;     	(printout t " - nuova direzione dell'agente: east" crlf)
)

(defrule turnleft3
	(declare (salience 20))      
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Turnleft))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction east))
	(cell (pos-r ?r) (pos-c ?c))
=> 
	(modify  ?f1 (direction north) (step (+ ?i 1)) (time (+ ?t 2)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)))		
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - azione eseguita: turnleft" crlf)	
;	(printout t " - nuova direzione dell'agente: north" crlf)
)

(defrule turnleft4
	(declare (salience 20))      
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Turnleft))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north))
	(cell (pos-r ?r) (pos-c ?c))
=> 
	(modify  ?f1 (direction west) (step (+ ?i 1)) (time (+ ?t 2)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)))		
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - azione eseguita: turnleft" crlf)	
;	(printout t " - nuova direzione dell'agente: west" crlf)
)

(defrule turnright1
	(declare (salience 20))      
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Turnright))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction west))
	(cell (pos-r ?r) (pos-c ?c))
=> 
	(modify  ?f1 (direction north) (step (+ ?i 1))  (time (+ ?t 2)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)))		
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - azione eseguita: turnright" crlf)	
;	(printout t " - nuova direzione dell'agente: north" crlf)
)

(defrule turnright2
	(declare (salience 20))      
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Turnright))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction south))
	(cell (pos-r ?r) (pos-c ?c))
=> 
	(modify  ?f1 (direction west) (step (+ ?i 1)) (time (+ ?t 2)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)))		
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - azione eseguita: turnright" crlf)	
;	(printout t " - nuova direzione dell'agente: west" crlf)
)

(defrule turnright3
	(declare (salience 20))      
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Turnright))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c) (direction east))
	(cell (pos-r ?r) (pos-c ?c))
=> 
	(modify ?f1 (direction south) (step (+ ?i 1)) (time (+ ?t 2)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)))		
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - azione eseguita: turnright" crlf)	
;	(printout t " - nuova direzione dell'agente: south" crlf)
)

(defrule turnright4
	(declare (salience 20))      
?f2<-	(status (step ?i) (time ?t)) 
	(exec (step ?i) (action  Turnright))
?f1<-	(agentstatus (step ?i) (pos-r ?r) (pos-c ?c)(direction north))
	(cell (pos-r ?r) (pos-c ?c))
=> 
	(modify ?f1 (direction east) (step (+ ?i 1)) (time (+ ?t 2)))
	(modify ?f2 (step (+ ?i 1)) (time (+ ?t 2)))		
;	(printout t " ENVIRONMENT:" crlf)
;	(printout t " - azione eseguita: turnright" crlf)	
;	(printout t " - nuova direzione dell'agente: east" crlf)
)


;// __________________________________________________________________________________________
;// REGOLE PER PERCEZIONI VISIVE (N,S,E,O)          
;// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ 
(defrule percept-north
	(declare (salience 5))
?f1<-	(agentstatus (step ?i) (time ?t&:(> ?t 0)) (pos-r ?r) (pos-c ?c) (direction north)) 
	(cell (pos-r =(+ ?r 1))	(pos-c =(- ?c 1)) (contains ?x1))
	(cell (pos-r =(+ ?r 1)) (pos-c ?c)  	(contains ?x2))
	(cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x3))
	(cell (pos-r ?r) 		(pos-c =(- ?c 1)) (contains ?x4))
	(cell (pos-r ?r) 		(pos-c ?c)  	(contains ?x5))
	(cell (pos-r ?r) 		(pos-c =(+ ?c 1)) (contains ?x6))
	(cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x7))
	(cell (pos-r =(- ?r 1)) (pos-c ?c)  	(contains ?x8))
	(cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x9))
=> 
	(assert 	
		(perc-vision (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (direction north) 
			(perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
			(perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
			(perc7 ?x7) (perc8 ?x8) (perc9 ?x9)
		)
	)

)

(defrule percept-south
	(declare (salience 5))
?f1<-	(agentstatus (step ?i) (time ?t&:(> ?t 0)) (pos-r ?r) (pos-c ?c) (direction south)) 
	(cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x1))
	(cell (pos-r =(- ?r 1)) (pos-c ?c)  	(contains ?x2))
	(cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x3))
	(cell (pos-r ?r)  	(pos-c =(+ ?c 1)) (contains ?x4))
	(cell (pos-r ?r)  	(pos-c ?c)  	(contains ?x5))
	(cell (pos-r ?r)  	(pos-c =(- ?c 1)) (contains ?x6))
	(cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x7))
	(cell (pos-r =(+ ?r 1)) (pos-c ?c)  	(contains ?x8))
	(cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (contains ?x9))
=> 
	(assert 	
		(perc-vision (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (direction south) 
			(perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
			(perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
			(perc7 ?x7) (perc8 ?x8) (perc9 ?x9)
		)
	)
	
)

(defrule percept-east
	(declare (salience 5))
?f1<-	(agentstatus (step ?i) (time ?t&:(> ?t 0)) (pos-r ?r) (pos-c ?c) (direction east)) 
	(cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x1))
	(cell (pos-r ?r)  	(pos-c =(+ ?c 1)) (contains ?x2))
	(cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x3))
	(cell (pos-r =(+ ?r 1)) (pos-c ?c)  	(contains ?x4))
	(cell (pos-r ?r)  	(pos-c ?c)  	(contains ?x5))	
	(cell (pos-r =(- ?r 1)) (pos-c ?c)  	(contains ?x6))
	(cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1))	(contains ?x7))
	(cell (pos-r ?r)		(pos-c =(- ?c 1)) (contains ?x8))
	(cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x9))
=> 	
	(assert 	
		(perc-vision (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (direction east) 
			(perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
			(perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
			(perc7 ?x7) (perc8 ?x8) (perc9 ?x9)
		)
	)
	
)

(defrule percept-west
	(declare (salience 5))
?f1<-	(agentstatus (step ?i) (time ?t&:(> ?t 0)) (pos-r ?r) (pos-c ?c) (direction west)) 
	(cell (pos-r =(- ?r 1)) (pos-c =(- ?c 1)) (contains ?x1))
	(cell (pos-r ?r)  	(pos-c =(- ?c 1)) (contains ?x2))
	(cell (pos-r =(+ ?r 1)) (pos-c =(- ?c 1)) (contains ?x3))
	(cell (pos-r =(- ?r 1)) (pos-c ?c)  	(contains ?x4))
	(cell (pos-r ?r)  	(pos-c ?c)  	(contains ?x5))
	(cell (pos-r =(+ ?r 1)) (pos-c ?c)  	(contains ?x6))
	(cell (pos-r =(- ?r 1)) (pos-c =(+ ?c 1)) (contains ?x7))	
	(cell (pos-r ?r)  	(pos-c =(+ ?c 1)) (contains ?x8))	
	(cell (pos-r =(+ ?r 1)) (pos-c =(+ ?c 1)) (contains ?x9))
=> 
	(assert 	
		(perc-vision (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (direction west) 
			(perc1 ?x1) (perc2 ?x2) (perc3 ?x3)
			(perc4 ?x4) (perc5 ?x5) (perc6 ?x6)
			(perc7 ?x7) (perc8 ?x8) (perc9 ?x9)
		)
	)
	
)

(defrule update1_AgentDisplayed
	(declare (salience 4))
?f1<-	(agentstatus (step ?i) (time ?t&:(> ?t 0)) (pos-r ?r) (pos-c ?c) (direction ?d) (free 2) (waste no)) 
?f2<-	(agentstatusdisplayed (step =(- ?i 1)))
=> 
	(modify ?f2 (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (direction ?d) (loaded no))
        (focus MAIN)
		
)

(defrule update2_AgentDisplayed
	(declare (salience 4))
?f1<-	(agentstatus (step ?i) (time ?t&:(> ?t 0)) (pos-r ?r) (pos-c ?c) (direction ?d) (free 0|1)) 
?f2<-	(agentstatusdisplayed (step =(- ?i 1)))
=> 
	(modify ?f2 (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (direction ?d) (loaded good))
        (focus MAIN)
		
)

(defrule update3_AgentDisplayed
	(declare (salience 4))
?f1<-	(agentstatus (step ?i) (time ?t&:(> ?t 0)) (pos-r ?r) (pos-c ?c) (direction ?d) (free 2) (waste yes)) 
?f2<-	(agentstatusdisplayed (step =(- ?i 1)))
=> 
	(modify ?f2 (step ?i) (time ?t) (pos-r ?r) (pos-c ?c) (direction ?d) (loaded waste))
	(focus MAIN)	
)



