; Questo programma contiene il simulatore dell'agente robotico per applicazione 
;   ASSISTED LIVING
;
;  Si noti che la parte di funzionamento dell'agente è separata
;  dal particolare problema da risolvere.
;
;  Infatti la definizione del problema in termini di 
;         mappa iniziale (descritta con istanzazioni di prior_cell)
;  deve essere contenuta nel file InitMap.txt       
; cosi come l'accoppiamento <Tavolo,sedia>.
;
;  la descrizione di quali eventi avvengono durante l'esecuzione è
;  contenuta nel file history.txt inclusa la durata massima (maxduration)
;  Questo file contiene anche le informazioni per indicare  quali sono 
;  gli anziani (dove sono localizzati all'inizio), quali attività svolgeranno 
;  e quali sono gli operatori sanitari,
;  
;
 
;_______________________________________________________________________________________________________________________
;// MAIN                                                
;// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ 


(defmodule MAIN (export ?ALL))

;// DEFTEMPLATE


(deftemplate exec 
	(slot step) 	
	(slot action  (allowed-values Forward Turnright Turnleft Wait 
                                      LoadMeal LoadPill LoadDessert 
                                      DeliveryMeal DeliveryPill DeliveryDessert 
                                      CleanTable EmptyRobot ReleaseTrash CheckId 
                                      Inform Done))
        (slot param1)
        (slot param2)
        (slot param3)
        (slot param4))

(deftemplate msg-to-agent 
           (slot request-time)
           (slot step)
           (slot sender)             ; // persona che fa la richiesta
           (slot request (allowed-values meal dessert))
           (slot t_pos-r)            ;// posizione del tavolo a cui servire
           (slot t_pos-c))

; [fixme] eliminare valori permessi per result: no, done, disaster
(deftemplate status (slot step) (slot time) (slot result (allowed-values on stop no done disaster)) )


(deftemplate perc-vision	;// la percezione di visione avviene dopo ogni azione, fornisce informazioni sullo stato del sistema
	(slot step)
        (slot time)	
	(slot pos-r)		;// informazioni sulla posizione del robot (riga)
	(slot pos-c)		;// (colonna)
	(slot direction)		;// orientamento del robot
	;// percezioni sulle celle adiacenti al robot: (il robot é nella 5):		        
	         
        (slot perc1  (allowed-values  Wall PersonSeated  PersonStanding Empty Parking Table Seat 
                                      TrashBasket MealDispenser PillDispenser DessertDispenser))
        (slot perc2  (allowed-values  Wall PersonSeated  PersonStanding Empty Parking Table Seat 
                                      TrashBasket MealDispenser PillDispenser DessertDispenser))
        (slot perc3  (allowed-values  Wall PersonSeated  PersonStanding Empty Parking Table Seat 
                                      TrashBasket MealDispenser PillDispenser DessertDispenser))
        (slot perc4  (allowed-values  Wall PersonSeated  PersonStanding Empty Parking Table Seat 
                                      TrashBasket MealDispenser PillDispenser DessertDispenser))
        (slot perc5  (allowed-values  Robot))
        (slot perc6  (allowed-values  Wall PersonSeated  PersonStanding Empty Parking Table Seat 
                                      TrashBasket MealDispenser PillDispenser DessertDispenser))
        (slot perc7  (allowed-values  Wall PersonSeated  PersonStanding Empty Parking Table Seat 
                                      TrashBasket MealDispenser PillDispenser DessertDispenser))
        (slot perc8  (allowed-values  Wall PersonSeated  PersonStanding Empty Parking Table Seat 
                                      TrashBasket MealDispenser PillDispenser DessertDispenser))
        (slot perc9  (allowed-values  Wall PersonSeated  PersonStanding Empty Parking Table Seat 
                                      TrashBasket MealDispenser PillDispenser DessertDispenser))
        )


(deftemplate perc-bump  	;// percezione di urto contro persone o ostacoli
	(slot step)
        (slot time)		
	(slot pos-r)		;// la posizione in cui si trova (la stessa in cui era prima dell'urto)
	(slot pos-c)
	(slot direction)
	(slot bump (allowed-values no yes)) ;//restituisce yes se sbatte
)



(deftemplate perc-load
                      (slot step)
                      (slot time)
                      (slot load  (allowed-values yes no)) ) 


(deftemplate perc-id  
         (slot step)
         (slot time)
         (slot id)
         (slot type (allowed-values patient staff)))


(deftemplate prescription
              (slot patient)
              (slot meal (allowed-values normal dietetic))
              (slot pills (allowed-values no before after))
              (slot dessert (allowed-values yes no)))

(deftemplate table-seat (slot t_pos-r) (slot t_pos-c)(slot s_pos-r) (slot s_pos-c))


(deftemplate real_cell  (slot pos-r) (slot pos-c) 
                         (slot contains 
                               (allowed-values Wall Empty Parking Table Seat 
                                      TrashBasket MealDispenser PillDispenser 
                                      DessertDispenser)))


(deffacts init
	(create)
)


(deftemplate perc-loaded
  (slot step)
  (slot time)
  (slot robotpos-r)
  (slot robotpos-c)
  (slot loaded  (allowed-values yes no))
)










;; regola per inizializzazione
;; legge anche initial map , initial agent status e durata simulazione (in numero di passi)



(defrule createworld

    ?f<- (create) =>
    (assert (create-map))
    (retract ?f)
    (focus ENV)
)



;// SI PASSA AL MODULO AGENT SE NON  E' ESAURITO IL TEMPO (indicato da maxduration)
(defrule go-on-agent		
	(declare (salience 20))
	(maxduration ?d)
	(status (time ?t&:(< ?t ?d)) (result on))	;// controllo sul tempo
 => 
;	(printout t crlf)
	(focus AGENT)		;// passa il focus all'agente, che dopo un'azione lo ripassa al main.
)


;// SI PASSA AL MODULO ENV DOPO CHE AGENTE HA DECISO AZIONE DA FARE

(defrule go-on-env

	(declare (salience 21))
  ?f1<-	(status (step ?s))
  (exec (step ?s)) 	;// azione da eseguire al passo s, viene simulata dall'environment

=>

  ; (printout t crlf crlf)
  ; (printout t "vado ad ENV  step" ?s)
  (focus ENV)

)



;; tempo esaurito

(defrule increase-penalties
  (declare (salience 20))
  (maxduration ?d)
  (status (time ?t) (result on))
  (or
    (test (= ?t ?d))
    (test (> ?t ?d))
  )
  ?penalty<-(penalty ?p)
  (not (penalty-update))
  =>
  (retract ?penalty)
  (assert ( penalty (+ ?p 10000000)))
  (assert (penalty-update))
)

(defrule finish1

   (declare (salience 19))
   (maxduration ?d)
   (penalty-update)
   (status (time ?t) (result on))
   (or
     (test (= ?t ?d))
     (test (> ?t ?d))
   )
   (penalty ?p)
      =>

  (printout t crlf crlf)
  (printout t "time over   " ?t)
  (printout t crlf crlf)
  (printout t "penalty:" ?p )
  (printout t crlf crlf)
  (halt)
)


;; l'agent ha dichiarato che ha terminato il suo compito (messaggio done)


(defrule finish2

   (declare (salience 19))
   (status (time ?t) (result stop))
   (penalty ?p)

          =>

  (printout t crlf crlf)
  (printout t "done at time   " ?t)
  (printout t crlf crlf)
  (printout t "penalty:" ?p)
  (printout t crlf crlf)
  (halt)
)

