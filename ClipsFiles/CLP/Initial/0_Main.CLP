; Questo programma contiene il simulatore dell'agente robotico per applicazione
;   ASSISTED LIVING

;

;  Si noti che la parte di funzionamento dell'agente ? separata
;  dal particolare problema da risolvere.
;
;  Infatti la definizione del problema in termini di
;         mappa iniziale (descritta con istanzazioni di prior_cell)
;  deve essere contenuta nel file InitMap.txt
; cosi come l'accoppiamento <Tavolo,sedia>.
;
;  la descrizione di quali eventi avvengono durante l'esecuzione ?
;  contenuta nel file history.txt inclusa la durata massima (maxduration)
;  Questo file contiene anche le informazioni per indicare  quali sono
;  gli anziani (dove sono localizzati all'inizio), quali attivit? svolgeranno
;  e quali sono gli operatori sanitari,
;
;

;_______________________________________________________________________________________________________________________

;// MAIN

;// ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????


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


(deftemplate status (slot step) (slot time) (slot work (allowed-values on stop)))	;//struttura interna



(deftemplate perc-vision	;// la percezione di visione avviene dopo ogni azione, fornisce informazioni sullo stato del sistema

	(slot step)
        (slot time)

	(slot pos-r)		;// informazioni sulla posizione del robot (riga)

	(slot pos-c)		;// (colonna)

	(slot direction)		;// orientamento del robot

	;// percezioni sulle celle adiacenti al robot: (il robot ? nella 5):


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




(deftemplate prior-cell  (slot pos-r) (slot pos-c)
                         (slot contains
                               (allowed-values Wall Empty Parking Table Seat
                                      TrashBasket MealDispenser PillDispenser
                                      DessertDispenser)))

(deffacts init

	(create)

)





;; regola per inizializzazione




(defrule createworld

    ?f<-   (create) =>
           (load-facts "RealMap.txt")
           (load-facts "Prescription.txt")

           (assert (create-map) (create-initial-setting)

                   (create-history))

           (retract ?f)

           (focus ENV))



;// SI PASSA AL MODULO AGENT SE NON  E' ESAURITO IL TEMPO (indicato da maxduration)

(defrule go-on-agent

	(declare (salience 20))

	(maxduration ?d)

	(status (time ?t&:(< ?t ?d)) (work on))	;// controllo sul tempo

 =>

;	(printout t crlf)

	(focus AGENT)		;// passa il focus all'agente, che dopo un'azione lo ripassa al main.

)



;// SI PASSA AL MODULO ENV DOPO CHE AGENTE HA DECISO AZIONE DA FARE

(defrule go-on-env

	(declare (salience 21))

?f1<-	(status (step ?k))

	(exec (step ?k)) 	;// azione da eseguire al al passo k, viene simulata dall'environment

=>

;	(printout t crlf)

	(focus ENV)

)



;// quando finisce il tempo l'esecuzione si interrompe e vengono stampate le penalit?


(defrule finish1

   (declare (salience 20))

        (maxduration ?d)

        (status (time ?t) (work stop))

        (penalty ?p)

          =>

        (printout t crlf crlf)

          (printout t "stop work   " ?t)

          (printout t crlf crlf)

          (printout t "penalty:"  ?p)

          (printout t crlf crlf)

          (halt))



(defrule finish2

   (declare (salience 20))

        (maxduration ?d)

        (status (time ?t) (work on))
        (or (test (= ?t ?d))
            (test (> ?t ?d)))

        (penalty ?p)

          =>

        (printout t crlf crlf)

          (printout t "time over   " ?t)

          (printout t crlf crlf)

          (printout t "penalty:"  (+ ?p 100000000))

          (printout t crlf crlf)

          (halt))







;// _______________________________________________________________________________________________________________________
