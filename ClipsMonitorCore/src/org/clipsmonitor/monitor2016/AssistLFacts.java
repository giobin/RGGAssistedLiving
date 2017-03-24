package org.clipsmonitor.monitor2016;


public final class AssistLFacts{

    private interface Fact {
        public int index();
        public String slot();
    }
    
    //**************************************************************************
    // Fatti relativi all'egente 
    //**************************************************************************
    
    //stato della cella secondo l'agente
    public enum KCell implements Fact{
        POSR (0, "pos-r"),
        POSC (1, "pos-c"),
        CONTAINS(2, "contains"),
        OLD(3, "old");

        private static final String FACT_NAME = "K-cell";
        private final int index;
        private final String slot;

        KCell(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    //stato dell'agente secondo l'agente
    public enum KAgent implements Fact {
        STEP(0, "step"),
        TIME(1, "time"),
        POSR(2, "pos-r"),
        POSC(3, "pos-c"),
        DIRECTION(4, "direction"),
        CONTENT(5, "content"),
        FREE(6, "free"),
        WASTE(7, "waste");
        
        private static final String FACT_NAME = "K-agent";
        private final int index;
        private final String slot;

        KAgent(int index, String slot) {
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index() {
            return index;
        }

        @Override
        public String slot() {
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // modella il task da pianificare
    public enum ToAchieve implements Fact {
        TASK(0, "task"),
        PARAM1(1, "param1"),
        PARAM2(2, "param2"),
        PARAM3(3, "param3"),
        PARAM4(4, "param4"),
        PROGRESS(5, "progress");
        
        private static final String FACT_NAME = "to-achieve";
        private final int index;
        private final String slot;
        
        ToAchieve(int index, String slot){
            this.index = index;
            this.slot = slot;
        }
        
        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // modella i task di tipo serve 
    public enum TaskServe implements Fact {
        WHAT(0, "what"),
        VARIANTS(1, "variants"),
        ID(2, "id"),
        T_POSR(3, "t_pos-r"),
        T_POSC(4, "t_pos-c"),
        STEP(5, "step"),
        NEXT(6, "next");
        
        private static final String FACT_NAME = "task-serve";
        private final int index;
        private final String slot;
        
        TaskServe(int index, String slot){
            this.index = index;
            this.slot = slot;
        }
        
        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // modella i task di risposta ai messaggi
    public enum TaskRespond implements Fact {
        PARAM1(0, "param1"),
        PARAM2(1, "param2"),
        PARAM3(2, "param3"),
        PARAM4(3, "param4");
        
        private static final String FACT_NAME = "task-serve";
        private final int index;
        private final String slot;
        
        TaskRespond(int index, String slot){
            this.index = index;
            this.slot = slot;
        }
        
        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    public enum TaskClean implements Fact {
        T_POSR(1, "t_pos-r"),
        T_POSC(2, "t_pos-c");
        
        private static final String FACT_NAME = "task-clean-table";
        private final int index;
        private final String slot;
        
        TaskClean(int index, String slot){
            this.index = index;
            this.slot = slot;
        }
        
        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // cosa ha portato e a chi (anche dove)
    public enum Delivered implements Fact {
        WHAT(0, "what"),
        ID(1, "id"),
        T_POSR(2, "t_pos-r"),
        T_POSC(3, "t_pos-c");
        
        private static final String FACT_NAME = "delivered";
        private final int index;
        private final String slot;
        
        Delivered(int index, String slot){
            this.index = index;
            this.slot = slot;
        }
        
        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // modella l'azione pianificata da eseguire
    public enum ToExec implements Fact {
        STEP(0, "step"),
        ACTION(1, "action"),
        PARAM1(2, "param1"),
        PARAM2(3, "param2"),
        PARAM3(4, "param3"),
        PARAM4(5, "param4");
        
        private static final String FACT_NAME = "to-exec";
        private final int index;
        private final String slot;
        
        ToExec(int index, String slot){
            this.index = index;
            this.slot = slot;
        }
        
        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    //**************************************************************************
    // Fatti realtivi a ENV
    //**************************************************************************
    
    //stato della cella iniziale
    public enum PriorCell implements Fact {
        POSR (0, "pos-r"),
        POSC (1, "pos-c"),
        CONTAINS (2, "contains");
        
        private static final String FACT_NAME = "prior-cell";
        private final int index;
        private final String slot;

        PriorCell(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // Fatto che modella lo stato di esecuzione
    public enum Status implements Fact {
        STEP (0, "step"),
        TIME (1, "time"),
        WORK (2, "work");

        private static final String FACT_NAME = "status";
        private final int index;
        private final String slot;

        Status(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    //stato della cella a livello globale
    public enum Cell implements Fact {
        POSR (0, "pos-r"),
        POSC (1, "pos-c"),
        CONTAINS (2, "contains"),
        PREVIOUS (3, "previous");
        
        private static final String FACT_NAME = "cell";
        private final int index;
        private final String slot;

        Cell(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // Stato dell'agente a livello globale
    public enum AgentStatus implements Fact {
        STEP(0, "step"),
        TIME(1, "time"),
        POSR (2, "pos-r"),
        POSC (3, "pos-c"),
        DIRECTION(4, "direction"),
        CONTENT (5, "content"),
        FREE(6, "free"),
        WASTE(7, "waste");

        private static final String FACT_NAME = "agentstatus";
        private final int index;
        private final String slot;

        AgentStatus(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // Stato dei tavoli a livello globale
    public enum TableStatus implements Fact {
        STEP(0, "step"),
        TIME(1, "time"),
        POSR(2, "pos-r"),
        POSC(3, "pos-c"),
        CLEAN(4, "clean"),
        OCCUPIEDBY(5, "occupied-by");
        
        private static final String FACT_NAME = "tablestatus";
        private final int index;
        private final String slot;

        TableStatus(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // Stato delle richieste di cibo
    public enum MealStatus implements Fact {
        STEP(0, "step"),
        TIME(1, "time"),
        ARRIVALTIME(2, "arrivaltime"),
        REQUESTEDBY(3, "requested-by"),
        TYPE(4, "type"),
        T_POSR(5, "tpos-r"),
        T_POSC(6, "tpos-c"),
        DELIVERED(7, "delivered"),
        DELIVERTIME(8, "delivertime"),
        ANSWER(9, "answer");
        
        private static final String FACT_NAME = "mealstatus";
        private final int index;
        private final String slot;

        MealStatus(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // Stato delle richieste di dessert
    public enum DessertStatus implements Fact {
        STEP(0, "step"),
        TIME(1, "time"),
        ARRIVALTIME(2, "arrivaltime"),
        REQUESTEDBY(3, "requested-by"),
        T_POSR(4, "tpos-r"),
        T_POSC(5, "tpos-c"),
        DELIVERED(6, "delivered"),
        ANSWER(7, "answer");
        
        private static final String FACT_NAME = "dessertstatus";
        private final int index;
        private final String slot;

        DessertStatus(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // Stato delle richieste di pillole
    public enum PillStatus implements Fact {
        STEP(0, "step"),
        TIME(1, "time"),
        FOR(2, "for"),
        DELIVERED(3, "delivered"),
        WHEN(4, "when");
        
        private static final String FACT_NAME = "pillstatus";
        private final int index;
        private final String slot;

        PillStatus(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // percezione della collisione tra il robot e altri agenti
    public enum PercBump implements Fact {
        STEP(0, "step"),
        TIME(1, "time"),
        POSR(2, "pos-r"),
        POSC(3, "pos-c"),
        DIRECTION(4, "direction"),
        BUMP(5, "bump");
        
        private static final String FACT_NAME = "perc-bump";
        private final int index;
        private final String slot;

        PercBump(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // penalita accumulate dall'agente
    public enum Penalty implements Fact {
        VALUE(0, "value");
        
        private static final String FACT_NAME = "penalty";
        private final int index;
        private final String slot;

        Penalty(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    //**************************************************************************
    // Fatti relativi agli altri agenti (anziani e infermieri)
    //**************************************************************************
    
    // Stato dell'anziano a livello globale
    public enum PersonStatus implements Fact{
        POSR (0, "pos-r"),
        POSC (1, "pos-c"),
        IDENT(2, "ident"),
        TIME (3, "time"),
        STEP(4, "step"),
        ACTIVITY(5, "activity");

        private static final String FACT_NAME = "personstatus";
        private final int index;
        private final String slot;

        PersonStatus(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    // Stato dello staff a livello globale
    public enum StaffStatus implements Fact{
        POSR (0, "pos-r"),
        POSC (1, "pos-c"),
        IDENT(2, "ident"),
        TIME (3, "time"),
        STEP(4, "step"),
        ACTIVITY(5, "activity");

        private static final String FACT_NAME = "staffstatus";
        private final int index;
        private final String slot;

        StaffStatus(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }
    
    //**************************************************************************
    public enum InitAgent implements Fact {
        DONE(0, "done");

        private static final String FACT_NAME = "init-agent";
        private final int index;
        private final String slot;

        InitAgent(int index, String slot){
            this.index = index;
            this.slot = slot;
        }

        @Override
        public int index(){
            return index;
        }

        @Override
        public String slot(){
            return slot;
        }

        public static String[] slotsArray() {
            Fact[] fact = values();
            String[] slots = new String[fact.length];
            for (Fact slot : fact) {
                slots[slot.index()] = slot.slot();
            }
            return slots;
        }

        public static String factName() {
            return FACT_NAME;
        }
    }    
}
