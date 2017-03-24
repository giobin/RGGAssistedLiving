package org.clipsmonitor.monitor2015;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import net.sf.clipsrules.jni.CLIPSError;
import org.clipsmonitor.clips.ClipsConsole;
import org.clipsmonitor.core.MonitorModel;
import org.clipsmonitor.core.MonitorCore;
import org.clipsmonitor.core.MonitorMap;
import org.clipsmonitor.core.ProjectDirectory;

/**
 * L'implementazione della classe ClipsModel specifica per il progetto Rescue 2014/2015.
 * L'oggetto fondamentale è il map, una matrice che in ogni elemento
 * contiene la stringa corrispondente al contenuto.
 *
 * @author Violanti Luca, Varesano Marco, Busso Marco, Cotrino Roberto
 * @edit by Enrico Mensa, Matteo Madeddu, Davide Dell'Anna, Ruben Caliandro
 */

public class AssistedLivingModel extends MonitorModel {
    private String direction;
    private String mode;
    private String loaded; // presenza di un carico
    private boolean bumped;
    private String kdirection;
    private String kmode;
    private String kloaded; // presenza di un carico
    private int krow;
    private int kcolumn;
    private int kstep;
    private int ktime;
    
    private Map<String,int[]> offsetPosition;
    private ClipsConsole console;
    private static AssistedLivingModel instance;
    private String advise;
    private Map<String, MonitorMap> maps;
    private ArrayList<int[]> personPositions;
    
    //[MP] Staff
    private ArrayList<int[]> staffPositions;
    
    //[MP] TableStatus
    private ArrayList<int[]> tablePositions; 
    private ArrayList<int[]> tableCleanPositions; 
    private ArrayList<int[]> tableNotCleanPositions; 
    
    private ArrayList<int[]> kpersonPositions;
    private String pdirection;
    private String pmode;
    private String ploaded; // presenza di un carico
    private int prow;
    private int pcolumn;
    private ArrayList<int[]> openNodes;
    private ArrayList<int[]> closedNodes;
    private ArrayList<int[]> goalsToDo;
    private int [] goalSelected;
    private String typeGoalSelected;
    
    /*costanti enumerative intere per un uso più immediato delle posizioni all'interno
     degli array che definiscono i fatti di tipo (real-cell)*/




    /**
     * Singleton
     */
    public static AssistedLivingModel getInstance(){
        if(instance == null){
            instance = new AssistedLivingModel();
        }
        return instance;
    }

    public static void clearInstance() {
        if(instance != null){
            instance.advise = null;
            instance.direction = null;
            instance.mode = null;
            instance.maps = null;
            instance.durlastact = 0;
            instance.time = null;
            instance.step = null;
            instance.maxduration = null;
            instance.result = null;
            instance.score = 0;
            instance.loaded = null;
            instance.console = null;
            instance.row = 0;
            instance.column = 0;
            instance.krow = 0;
            instance.kcolumn = 0;
            instance.bumped=false;
            instance.kdirection = null;
            instance.kmode = null;
            instance.kloaded = null;
            instance.kstep = 0;
            instance.ktime = 0;
            instance.personPositions = null;
            //[MP] Staff
            instance.staffPositions = null;
            //[MP] TableStatus
            instance.tablePositions = null;
            instance.tableCleanPositions = null;
            instance.tableNotCleanPositions = null;
            
    
            instance.kpersonPositions = null;
            instance.offsetPosition = null;
            instance.pdirection = null;
            instance.pmode = null;
            instance.ploaded = null; // presenza di un carico
            instance.prow = 0;
            instance.pcolumn = 0;
            instance.openNodes = null;
            instance.closedNodes = null;
            instance.goalsToDo = null;
            instance.goalSelected = new int []{0,0};
            instance = null;
        }
    }

    /**
     * Costruttore del modello per il progetto Monitor
     *
     */
    private AssistedLivingModel() {
        super();
        console = ClipsConsole.getInstance();
        MonitorCore.getInstance().registerModel(this);
        maps = new HashMap<String, MonitorMap>();
        personPositions = new ArrayList<int[]>();
        //[MP] Staff
        staffPositions = new ArrayList<int[]>();
        //[MP] TableStatus
        tablePositions = new ArrayList<int[]>();
        tableCleanPositions = new ArrayList<int[]>();
        tableNotCleanPositions = new ArrayList<int[]>();
        
        
        kpersonPositions = new ArrayList<int[]>();
        offsetPosition = new HashMap<String,int[]>();
        goalSelected = new int []{0,0};
    }

    /**
     * Inizializza il modello in base al contenuto del file clips caricato.
     */
    @Override
    protected synchronized void initModel() {
        result = "no";
        time = 0;
        step = 0;
        offsetPosition.put("north",new int[]{1,0});
        offsetPosition.put("south",new int[]{-1,0});
        offsetPosition.put("east",new int[]{0,1});
        offsetPosition.put("west",new int[]{0,-1});

        try {
            console.debug("Esecuzione degli step necessari ad aspettare che l'agente sia pronto.");
            core.RecFromRouter();
            /* Eseguiamo un passo fino a quando il fatto init-agent viene dichiarato
             * con lo slot (done yes): il mondo è pronto.
             */


            core.run();


            maxduration = new Integer(core.findOrderedFact("MAIN", "maxduration"));
            
            
            //[MP] TableStatus
            console.debug("Acquisizione posizione dei tavoli...");
            String[][] tables = core.findAllFacts("ENV", AssistedLivingFacts.TableStatus.factName(), "TRUE", AssistedLivingFacts.TableStatus.slotsArray());
            tablePositions.clear();
            if (tables != null) {
                for (int i = 0; i < tables.length; i++) {
                    if(tables[i][0] != null){
                        int r = new Integer(tables[i][AssistedLivingFacts.TableStatus.POSR.index()]);
                        int c = new Integer(tables[i][AssistedLivingFacts.TableStatus.POSC.index()]);
                        tablePositions.add(new int[]{r, c});
                    }
                }
            }
            
            for (MonitorMap map : maps.values()) {
                map.initMap();
            }
            core.StopRecFromRouter();
            console.debug("Il modello è pronto.");

        } catch (CLIPSError ex) {
            core.StopRecFromRouter();
            console.error("L'inizializzazione è fallita:");
            ex.printStackTrace();
            console.error(core.GetStdoutFromRouter());
        }
    }

    /**
     * Register a map to a MapTopComponent
     * @param target
     * @param map
     */


    public void registerMap(String target, MonitorMap map){
        maps.put(target, map);
        this.setChanged();
        this.notifyObservers(target);
    }



    public MonitorMap getMapToRegister(String target){
        return maps.get(target);
    }

    @Override
    protected synchronized void partialUpdate(String partial) throws CLIPSError {
        console.debug("Aggiornamento parziale del modello: " + partial);
        
        boolean updateValid = false;
                
        if(partial.equals("update-agent")){
            updateAgent();
            MonitorMap envMap = maps.get("envMap");
            if(envMap != null){
                envMap.updateMap();
            }
            updateValid = true;
        }
        else if(partial.equals("update-k-agent")){
            updateKAgent();
            MonitorMap agentMap = maps.get("agentMap");
            if(agentMap != null){
                agentMap.updateMap();
            }
            updateValid = true;
        }
        else if(partial.equals("update-p-nodes")){
            updatePNodes();
            updateGoal();
            updateGoalsToDo();
            MonitorMap agentMap = maps.get("agentMap");
            if(agentMap != null){
                agentMap.updateMap();
            }
            updateValid = true;
        }
        else if(partial.equals("update-people")){
            updatePeople();
            MonitorMap envMap = maps.get("envMap");
            if(envMap != null){
                envMap.updateMap();
            }
            updateValid = true;
        }
        else if(partial.equals("update-k-people")){
            updateKPeople();
            MonitorMap agentMap = maps.get("agentMap");
            if(agentMap != null){
                agentMap.updateMap();
            }
            updateValid = true;
        }

        if(updateValid){
          this.setChanged();
          this.notifyObservers("repaint"); 
        }
    }

    /**
     * Aggiorna la mappa leggendola dal motore clips. Lanciato ogni volta che si
     * compie un'azione.
     *
     * @throws ClipsExceptionF
     */
    @Override
    protected synchronized void updateModel() throws CLIPSError {

        console.debug("Aggiornamento del modello...");

        // Update the agent
        updateAgent();

        // Update the agent's perception about itself
        updateKAgent();
        
        //[MP] TableStatus
        updateTableStatus();

        // Update the planning nodes
        //  updatePNodes();

        // Update the other agents
        updatePeople();
        updateKPeople();
        checkBumpCondition();
        

        // Update all the maps (they read the values created by updateAgent)
        for(MonitorMap map : maps.values()){
            map.updateMap();
        }

        updateGoal();
        updateGoalsToDo();
        this.setChanged();
        this.notifyObservers("repaint");
    }

    
    
    //[MP] AgentStatusDisplayed: adattare codice facendo riferimento agli slot del fatto "AgentStatusDisplayed"  
    // updateAgent aggiorna lo stato del robot, leggendo AgentStatusDiplayed
    // il fatto AgentStatusDisplayed esegue l'override di AgentStatus, per questioni legate alla
    // gestione dei multislot.
    // lo slot chiave è LOADED, che assume tre possibili valori: no, waste, good
    private void updateAgent() throws CLIPSError{
        String[] robot = core.findFact("ENV", AssistedLivingFacts.AgentStatusDisplayed.factName(), "TRUE", AssistedLivingFacts.AgentStatusDisplayed.slotsArray());
        if (robot[0] != null) { //Se hai trovato il fatto
            step = new Integer(robot[AssistedLivingFacts.AgentStatusDisplayed.STEP.index()]);
            time = new Integer(robot[AssistedLivingFacts.AgentStatusDisplayed.TIME.index()]);
            row = new Integer(robot[AssistedLivingFacts.AgentStatusDisplayed.POSR.index()]);
            column = new Integer(robot[AssistedLivingFacts.AgentStatusDisplayed.POSC.index()]);
            direction = robot[AssistedLivingFacts.AgentStatusDisplayed.DIRECTION.index()];
            loaded = robot[AssistedLivingFacts.AgentStatusDisplayed.LOADED.index()];                 

            //[MP] AgentStatusDisplayed: il valore di mode concorre nella corretta visualizzazione 
            // dello stato del robot
            // assume tre valori: no, good e waste, in AssistedLivingModel verrà composta la stringa
            // per la rapppresentazione dello stato (es. stato iniziale: agent_north_no)
            // occorre che in /img vi sia l'immagine corrispondente, altrimenti cella color rosa.
            mode = loaded.toLowerCase();

        }
    }
    

//[MP] TableStatus
    private void updateTableStatus() throws CLIPSError{
        String[][] tables = core.findAllFacts("ENV", AssistedLivingFacts.TableStatus.factName(), "TRUE", AssistedLivingFacts.TableStatus.slotsArray());
        tableCleanPositions.clear();
        tableNotCleanPositions.clear();
        if (tables != null) {
            for (int i = 0; i < tables.length; i++) {
                if(tables[i][0] != null){
                    if (tables[i][AssistedLivingFacts.TableStatus.CLEAN.index()].equals("yes")){
                        int r = new Integer(tables[i][AssistedLivingFacts.TableStatus.POSR.index()]);
                        int c = new Integer(tables[i][AssistedLivingFacts.TableStatus.POSC.index()]);
                        tableCleanPositions.add(new int[]{r, c});
                    } else if (tables[i][AssistedLivingFacts.TableStatus.CLEAN.index()].equals("no")){
                        int r = new Integer(tables[i][AssistedLivingFacts.TableStatus.POSR.index()]);
                        int c = new Integer(tables[i][AssistedLivingFacts.TableStatus.POSC.index()]);
                        tableNotCleanPositions.add(new int[]{r, c});
                    }         
                }
            }
        }
    }


    private void updateKAgent() throws CLIPSError{
        String[] robot = core.findFact("AGENT", AssistedLivingFacts.KAgent.factName(), "TRUE", AssistedLivingFacts.KAgent.slotsArray());
        if (robot[0] != null) { //Se hai trovato il fatto
            kstep = new Integer(robot[AssistedLivingFacts.KAgent.STEP.index()]);
            ktime = new Integer(robot[AssistedLivingFacts.KAgent.TIME.index()]);
            krow = new Integer(robot[AssistedLivingFacts.KAgent.POSR.index()]);
            kcolumn = new Integer(robot[AssistedLivingFacts.KAgent.POSC.index()]);
            kdirection = robot[AssistedLivingFacts.KAgent.DIRECTION.index()];
            kloaded = robot[AssistedLivingFacts.KAgent.LOADED.index()];
            
            //[MP] KAgent: il valore di mode concorre nella corretta visualizzazione dello stato del robot
            // assume tre valori: no, good e waste, in AssistedLivingModel verrà composta la stringa
            // per la rapppresentazione dello stato (es. stato iniziale: agent_north_no)
            // occorre che in /img vi sia l'immagine corrispondente, altrimenti cella color rosa.
            kmode = kloaded.toLowerCase();
        }
    }
    
    public void updateGoal() throws CLIPSError{
      String[] goal = core.findFact("AGENT", AssistedLivingFacts.Goal.factName(), "eq ?f:status selected", AssistedLivingFacts.Goal.slotsArray());
      if (goal!=null && goal[0]!=null){
      
          try{
            int row = Integer.parseInt(goal[AssistedLivingFacts.Goal.PARAM1.index()]);
            int column = Integer.parseInt(goal[AssistedLivingFacts.Goal.PARAM2.index()]);
            goalSelected = new int [] {row,column};
            typeGoalSelected = goal[AssistedLivingFacts.Goal.ACTION.index()];
            
          }
          catch(NumberFormatException ex){
            goalSelected=new int []{0,0};
          }
        }
      
    }
    
    private void updatePNodes() throws CLIPSError{
        openNodes = new ArrayList<int[]>();
        closedNodes = new ArrayList<int[]>();
        instance.pdirection = null;
        instance.pmode = null;
        instance.ploaded = null; // presenza di un carico
        instance.prow = -1;
        instance.pcolumn = -1;

        String[][] pnodes = core.findAllFacts("REASONING", AssistedLivingFacts.PNode.factName(), "TRUE", AssistedLivingFacts.PNode.slotsArray());
        if(pnodes!=null){
          for(String[] pnode : pnodes){
            if (pnode[0] != null) { //Se hai trovato il fatto
                int ident = new Integer(pnode[AssistedLivingFacts.PNode.IDENT.index()]);
                String nodetype = pnode[AssistedLivingFacts.PNode.NODETYPE.index()];

                String[] robot = core.findFact("REASONING", AssistedLivingFacts.PAgent.factName(), "eq ?f:ident " + ident, AssistedLivingFacts.PAgent.slotsArray());
                if (robot[0] != null) { //Se hai trovato il fatto
                  int curRow = new Integer(robot[AssistedLivingFacts.PAgent.POSR.index()]);
                  int curColumn = new Integer(robot[AssistedLivingFacts.PAgent.POSC.index()]);
                  if(nodetype.equals("selected")){
                    prow = curRow;
                    pcolumn = curColumn;
                    pdirection = robot[AssistedLivingFacts.PAgent.DIRECTION.index()];
                    ploaded = robot[AssistedLivingFacts.PAgent.LOADED.index()];
                    pmode = ploaded.equals("yes") ? "loaded" : "unloaded";
                    
                    
                    openNodes.add(new int[]{curRow,curColumn});
                  }
                  else if(nodetype.equals("open")){
                    openNodes.add(new int[]{curRow,curColumn});
                  }
                  else if(nodetype.equals("closed")){
                    closedNodes.add(new int[]{curRow, curColumn});
                  }
                }
            }
        }
          
        }
    }

    
    private void updateGoalsToDo(){
    
        goalsToDo = new ArrayList<int []>();
        String[][] goals = core.findAllFacts("AGENT", AssistedLivingFacts.Goal.factName(), "eq ?f:status to-do", AssistedLivingFacts.Goal.slotsArray());
        if(goals!=null){
          for(String [] goal : goals){
            try{
                int r = new Integer(goal[AssistedLivingFacts.Goal.PARAM1.index()]);
                int c = new Integer(goal[AssistedLivingFacts.Goal.PARAM2.index()]);
                goalsToDo.add(new int[]{r, c});
            }
            catch(NumberFormatException e){}
        }
        
        }
    }
    
    
    private void updatePeople() throws CLIPSError{
        console.debug("Acquisizione posizione delle persone per EnvMap...");
        String[][] persons = core.findAllFacts("ENV", AssistedLivingFacts.PersonStatus.factName(), "TRUE", AssistedLivingFacts.PersonStatus.slotsArray());
        personPositions.clear();
        if (persons != null) {
            for (int i = 0; i < persons.length; i++) {
                if(persons[i][0] != null){
                    int r = new Integer(persons[i][AssistedLivingFacts.PersonStatus.POSR.index()]);
                    int c = new Integer(persons[i][AssistedLivingFacts.PersonStatus.POSC.index()]);
                    personPositions.add(new int[]{r, c});
                }
            }
        }
        //[MP] Staff
        String[][] staffs = core.findAllFacts("ENV", AssistedLivingFacts.StaffStatus.factName(), "TRUE", AssistedLivingFacts.StaffStatus.slotsArray());
        staffPositions.clear();
        if (staffs != null) {
            for (int i = 0; i < staffs.length; i++) {
                if(staffs[i][0] != null){
                    int r = new Integer(staffs[i][AssistedLivingFacts.StaffStatus.POSR.index()]);
                    int c = new Integer(staffs[i][AssistedLivingFacts.StaffStatus.POSC.index()]);
                    staffPositions.add(new int[]{r, c});
                }
            }
        }
    }



    private void updateKPeople() throws CLIPSError{
        console.debug("Acquisizione posizione degli altri agenti per agentMap...");
        String[][] persons = core.findAllFacts("AGENT", AssistedLivingFacts.KPerson.factName(), "= ?f:step " + this.step, AssistedLivingFacts.KPerson.slotsArray());
        kpersonPositions.clear();
        if (persons != null) {
            for (int i = 0; i < persons.length; i++) {
                if(persons[i][0] != null){
                    int r = new Integer(persons[i][AssistedLivingFacts.KPerson.POSR.index()]);
                    int c = new Integer(persons[i][AssistedLivingFacts.KPerson.POSC.index()]);
                    kpersonPositions.add(new int[]{r, c});
                }
            }
        }
    }

    private void checkBumpCondition() throws CLIPSError{

      console.debug("Controllo di evento bump...");
      boolean bumped = false;
      String[][] bump = core.findAllFacts("AGENT",AssistedLivingFacts.SpecialCondition.factName(),"TRUE", AssistedLivingFacts.SpecialCondition.slotsArray());
      this.bumped= bump.length!=0 ? true: false;

    }



    protected void updateStatus() throws CLIPSError{
        String[] status = core.findFact("MAIN", AssistedLivingFacts.Status.factName(), "TRUE", AssistedLivingFacts.Status.slotsArray());
        if (status!= null) {
            step = new Integer(status[AssistedLivingFacts.Status.STEP.index()]);
            time = new Integer(status[AssistedLivingFacts.Status.TIME.index()]);
            result = status[AssistedLivingFacts.Status.RESULT.index()];
            console.debug("Step: " + step + " Time: " + time + " Result: " + result);
        }
        score = new Double(core.findOrderedFact("MAIN", "penalty"));
    }

    
    public ArrayList<int[]> getPersonPositions(){
        return personPositions;
    }
    //[MP] Staff: implementazione metodo per la restituzione dell'array contenente posizioni
    public ArrayList<int[]> getStaffPositions(){
        return staffPositions;
    }
    //[MP] TableStatus: implementazione metodo per la restituzione dell'array contenente posizioni
    public ArrayList<int[]> getTablePositions(){
        return tablePositions;
    }
    //[MP] TableStatus: implementazione metodo per la restituzione dell'array contenente posizioni
    public ArrayList<int[]> getTableCleanPositions(){
        return tableCleanPositions;
    }
    //[MP] TableStatus: implementazione metodo per la restituzione dell'array contenente posizioni
    public ArrayList<int[]> getTableNotCleanPositions(){
        return tableNotCleanPositions;
    }

    
    public ArrayList<int[]> getKPersonPostions(){

      return kpersonPositions;
    }

    public String[][] findAllFacts(String template, String conditions, String[] slots) throws CLIPSError{
        String[][] empty = {};
        return core != null ? core.findAllFacts(template, conditions, slots) : empty;
    }

    public String getLoaded() {
        return loaded;
    }



    public String getMode() {
       return mode;
    }



    public void setAdvise(String advise) {
        this.advise = advise;
    }

    public String getAdvise() {
        return this.advise;
    }

    public String getDirection() {
        return direction;
    }

    public String getKDirection() {
        return kdirection;
    }

    public String getKLoaded() {
        return kloaded;
    }

    public String getKMode() {
        return kmode;
    }

    public int getKRow(){
        return krow;
    }

    public int getKColumn(){
        return kcolumn;
    }

    public String getPDirection() {
        return pdirection;
    }

    public String getPLoaded() {
        return ploaded;
    }
    
    public int [] getGoalSelected(){
    
      return goalSelected;
    }

    public String getPMode() {
        return pmode;
    }

    public int getPRow(){
        return prow;
    }

    public int getPColumn(){
        return pcolumn;
    }

    public String getTypeGoalSelected(){
        return typeGoalSelected;
    }
    
    public ArrayList<int[]> getOpenNodes(){
        return openNodes;
    }

    public ArrayList<int[]> getClosedNodes(){
        return closedNodes;
    }
    
    public ArrayList<int[]> getGoalsToDo(){
        return goalsToDo;
    }

    public boolean getBumped(){

        return bumped;
    }

    public Map<String,int[]> getOffset(){
      return this.offsetPosition;
    }

    //[MP] Exec: adattare la stringa overrideEcecTemplate secondo la sintassi
    // del template exec del progetto corrente
    @Override
    public void injectExecutionRules() throws CLIPSError{
        super.injectExecutionRules();

        String overrideExecTemplate = "" +
            "(deftemplate override-exec \n" +
            "  (slot step) \n" +
            "  (slot action  \n" +
            "    (allowed-values \n" +
            "      Forward Turnright Turnleft Wait\n" +
            "      LoadMeal LoadPill LoadDessert\n" +
            "      DeliveryMeal DeliveryPill DeliveryDessert\n" +
            "      CleanTable EmptyRobot ReleaseTrash CheckId\n" +
            "      Inform Done\n" +
            "    )\n" +
            "  )\n" +
            "  (slot param1)\n" +
            "  (slot param2)\n" +
            "  (slot param3)\n" +
            "  (slot param4)\n" +
            ")\n";

        String overrideExecRule = "" +
            "(defrule override-exec\n" +
            "  (declare (salience 1))\n" +
            "  (status (step ?s))\n" +
            "  ?exec <- (exec (step ?s))\n" +
            "  ?override <- (override-exec (step ?s)(action ?a)(param1 ?p1)(param2 ?p2)(param3 ?p3)(param4 ?p4))\n" +
            "  =>\n" +
            "  (retract ?exec)\n" +
            "  (retract ?override)\n" +
            "  (assert (exec (step ?s)(action ?a)(param1 ?p1)(param2 ?p2)(param3 ?p3)(param4 ?p4)))\n" +
            ")";

        boolean check = core.build("AGENT", overrideExecTemplate);
        boolean check2 = core.build("AGENT", overrideExecRule);
        if (check && check2) {
            console.debug("Injected override exec rule");
        } else {
            console.error("Injection of override exec rule failed");
        }
    }

    public void actionForward() {
        assertOverrideExec("forward", null, null, null);
    }

    public void actionTurnLeft() {
        assertOverrideExec("turnleft", null, null, null);
    }

    public void actionTurnRight() {
        assertOverrideExec("turnright", null, null, null);
    }

    public void actionWait() {
        assertOverrideExec("wait", null, null, null);
    }

    //[MP] codice Rescue, valutare se eliminare
    public void actionLoadNorth() {
        String action = kloaded.equals("yes") ? "unload_debris" : "load_debris";
        assertOverrideExec(action, krow + 1, kcolumn, null);
    }
    
    //[MP] LoadMealNorth  
    /*
    public void actionLoadMealNorth() {
        String action = kloaded.equals("yes") ? "not_admitted" : "load_meal";
        assertOverrideExec(action, krow + 1, kcolumn, null);
    }*/

    public void actionLoadEast() {
        String action = kloaded.equals("yes") ? "unload_debris" : "load_debris";
        assertOverrideExec(action, krow, kcolumn + 1, null);
    }

    public void actionLoadWest() {
        String action = kloaded.equals("yes") ? "unload_debris" : "load_debris";
        assertOverrideExec(action, krow, kcolumn - 1, null);
    }

    public void actionLoadSouth() {
        String action = kloaded.equals("yes") ? "unload_debris" : "load_debris";
        assertOverrideExec(action, krow -1 , kcolumn, null);
    }

    public void actionDrillNorth() {
        assertOverrideExec("drill", krow + 1, kcolumn, null);
    }

    public void actionDrillEast() {
        assertOverrideExec("drill", krow, kcolumn + 1, null);
    }

    public void actionDrillWest() {
        assertOverrideExec("drill", krow, kcolumn - 1, null);
    }

    public void actionDrillSouth() {
        assertOverrideExec("drill", krow -1 , kcolumn, null);
    }

    private void assertOverrideExec(String action, Object param1, Object param2, Object param3){
        String cmd = "(assert (override-exec (action " + action + ")(step " + step + ")";
        if(param1 != null){
            cmd += "(param1 " + param1 + ")";
        }
        if(param2 != null){
            cmd += "(param2 " + param2 + ")";
        }
        if(param3 != null){
            cmd += "(param3 " + param3 + ")";
        }
        cmd += "))";
        console.info("Sending action: " + action);
        evalComandLine(cmd);
    }
    
    
    public int getUndiscoveredCount(){
      int count = 0; 
      String conditions = "eq ?f:contains debris";
      String [][] undiscovered = core.findAllFacts("ENV", AssistedLivingFacts.Cell.factName(),conditions, AssistedLivingFacts.Cell.slotsArray());
      for(int i=0;i<undiscovered.length;i++)
      {
        String contains = undiscovered[i][AssistedLivingFacts.Cell.CONTAINS.index()];
   //     String injured = undiscovered[i][AssistedLivingFacts.Cell.INJURED.index()];
   //     String discovered = undiscovered[i][AssistedLivingFacts.Cell.DISCOVERED.index()];
  //      if(contains.equals("debris") && injured.contains("yes") && !discovered.equals("yes")){
  //        count++;
  //      }
      }
      return count;
      
    }
    
    public int getUncheckedCount(){
      
      int count = 0; 
      String conditions = "eq ?f:contains debris";
      String [][] unchecked = core.findAllFacts("ENV", AssistedLivingFacts.Cell.factName(),conditions, AssistedLivingFacts.Cell.slotsArray());
      for(int i=0;i<unchecked.length;i++)
      {
        String contains = unchecked[i][AssistedLivingFacts.Cell.CONTAINS.index()];
  //      String injured = unchecked[i][AssistedLivingFacts.Cell.INJURED.index()];
  //      String uncheck = unchecked[i][AssistedLivingFacts.Cell.CHECKED.index()];
 //       if(contains.equals("debris") && injured.contains("no") && !uncheck.equals("yes")){
 //         count++;
 //       }
      }
      return count;

      
    }
    
    public int getNumPerson(){
      String [][] persons = core.findAllFacts("ENV", AssistedLivingFacts.PersonStatus.factName(),"TRUE", AssistedLivingFacts.PersonStatus.slotsArray());
      return persons.length;
    }
    
    public String getReport(){
      
      //  world + strategy + time + score  +  injured  + debris unchecked + numPerson 
      int countUndiscovered = getUndiscoveredCount();
      int countUnchecked = getUncheckedCount();
      
      console.debug("Undiscovered" + countUndiscovered);
      console.debug("Unchecked" + countUnchecked);
      
      int persons = getNumPerson();
      ProjectDirectory Pdir = ProjectDirectory.getInstance();
      String env = Pdir.getEnv();
      String strategy = Pdir.getStrategy();
      String penalties = Double.toString(score);
      String maxdur = Integer.toString(maxduration);
      String countUnd = Integer.toString(countUndiscovered);
      String countUnc = Integer.toString(countUnchecked);
      String pers = Integer.toString(persons);
      
      
      String report = fixedLengthString(strategy,16) + "|" 
                      + fixedLengthString(env,16) + "|" 
                      + fixedLengthString(maxdur,8) + "|" 
                      + fixedLengthString(penalties,16) + "|" 
                      + fixedLengthString(countUnd,8) + "|" 
                      + fixedLengthString(countUnc,8) + "|" 
                      + fixedLengthString(pers,8) + "\n";
      
      
      
      return report;
    }
    
    /**
     *  header per il progetto di rescue2015
     * @return 
     */
    
    public String getLogHeader(){
    
      return  fixedLengthString("Strategy",16)   + "|"
              + fixedLengthString("World",16) + "|"
              + fixedLengthString("Time",8) + "|"
              + fixedLengthString("Score",16) + "|"
              + fixedLengthString("Undiscovered",8) + "|"
              + fixedLengthString("Unchecked",8) + "|"
              + fixedLengthString("NumPerson",8) + "\n";
    }
    
    
    
}
