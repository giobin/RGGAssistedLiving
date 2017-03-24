package org.clipsmonitor.monitor2016;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import net.sf.clipsrules.jni.CLIPSError;
import org.clipsmonitor.clips.ClipsConsole;
import org.clipsmonitor.core.MonitorModel;
import org.clipsmonitor.core.MonitorCore;
import org.clipsmonitor.core.MonitorMap;
import org.clipsmonitor.core.ProjectDirectory;

public class AssistLModel extends MonitorModel {
    
    private String direction;
    private ArrayList<String> content; // carico trasportato dall'agente
    private int free;
    private boolean waste;
    private boolean bumped;
    private String result;
    private String kdirection;
    private ArrayList<String> kcontent; // carico trasportato dall'agente
    private int kfree;
    private boolean kwaste;
    private int krow;
    private int kcolumn;
    private int kstep;
    private int ktime;
    private Map<String,int[]> offsetPosition;
    private ClipsConsole console;
    private static AssistLModel instance;
    private String advise;
    private Map<String, MonitorMap> maps;
    private ArrayList<int[]> personPositions;
    private ArrayList<int[]> staffPositions;
    //private ArrayList<int[]> kpersonPositions;
    //private ArrayList<int[]> kstaffPositions;
    //private String pdirection;
    //private String pmode;
    //private String ploaded; // presenza di un carico
    //private int prow;
    //private int pcolumn;
    //private ArrayList<int[]> openNodes;
    //private ArrayList<int[]> closedNodes;
    //private ArrayList<int[]> goalsToDo;
    //private int [] goalSelected;
    //private String typeGoalSelected;
    
    /*costanti enumerative intere per un uso più immediato delle posizioni all'interno
     degli array che definiscono i fatti di tipo (real-cell)*/


    /**
     * Singleton
     */
    public static AssistLModel getInstance(){
        if(instance == null){
            instance = new AssistLModel();
        }
        return instance;
    }

    public static void clearInstance() {
        if(instance != null){
            instance.advise = null;
            instance.direction = null;
            instance.maps = null;
            instance.durlastact = 0;
            instance.time = null;
            instance.step = null;
            instance.maxduration = null;
            instance.result = null;
            instance.score = 0;
            instance.content = null;
            instance.free = 0;
            instance.console = null;
            instance.row = 0;
            instance.column = 0;
            instance.krow = 0;
            instance.kcolumn = 0;
            instance.bumped=false;
            instance.kdirection = null;
            instance.kcontent = null;
            instance.kstep = 0;
            instance.ktime = 0;
            instance.personPositions = null;
            instance.staffPositions = null;
            //instance.kpersonPositions = null;
            //instance.kstaffPositions = null;
            instance.offsetPosition = null;
            //instance.pdirection = null;
            //instance.pmode = null;
            //instance.ploaded = null; // presenza di un carico
            //instance.prow = 0;
            //instance.pcolumn = 0;
            //instance.openNodes = null;
            //instance.closedNodes = null;
            //instance.goalsToDo = null;
            //instance.goalSelected = new int []{0,0};
            instance = null;
        }
    }

    /**
     * Costruttore del modello per il progetto Monitor
     *
     */
    private AssistLModel() {
        super();
        console = ClipsConsole.getInstance();
        MonitorCore.getInstance().registerModel(this);
        maps = new HashMap<String, MonitorMap>();
        content = new ArrayList<String>();
        kcontent = new ArrayList<String>();
        personPositions = new ArrayList<int[]>();
        staffPositions = new ArrayList<int[]>();
        //kpersonPositions = new ArrayList<int[]>();
        offsetPosition = new HashMap<String,int[]>();
        //goalSelected = new int []{0,0};
    }

    /**
     * Inizializza il modello in base al contenuto del file clips caricato.
     */
    @Override
    protected synchronized void initModel() {
        result = "no";
        time = 0;
        step = 0;
        maxduration = 0;
        offsetPosition.put("north",new int[]{1,0});
        offsetPosition.put("south",new int[]{-1,0});
        offsetPosition.put("east",new int[]{0,1});
        offsetPosition.put("west",new int[]{0,-1});

        try {
            console.debug("Esecuzione degli step necessari ad aspettare che l'agente sia pronto.");
            core.RecFromRouter();

            // Esegue un passo fino a quando il fatto creation done viene dichiarato
            boolean done = false;
            while(!done) {
                core.run(1);
                String tmp = core.findOrderedFact("AGENT", "init-agent", "done");
                System.out.println(tmp);
                if(tmp != null && tmp.equals("yes")){
                    done = true;
                }
            }//core.run(128);
            maxduration = new Integer(core.findOrderedFact("MAIN", "maxduration"));
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
    protected synchronized void partialUpdate(String partial) throws CLIPSError {}
    
    
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
        // Update the planning nodes
        //  updatePNodes();
        // Update the other agents
        updatePeople();
        updateStaff();
        //updateKPeople();
        //updateKStaff();
        checkBumpCondition();

        // Update all the maps (they read the values created by updateAgent)
        for(MonitorMap map : maps.values()){
            map.updateMap();
        }
        //updateGoal();
        //updateGoalsToDo();
        this.setChanged();
        this.notifyObservers("repaint");
    }

    
    private void updateAgent() throws CLIPSError{
        String[] robot = core.findFact("ENV", AssistLFacts.AgentStatus.factName(), "TRUE", AssistLFacts.AgentStatus.slotsArray());
        if (robot[0] != null) { //Se hai trovato il fatto
            step = new Integer(robot[AssistLFacts.AgentStatus.STEP.index()]);
            time = new Integer(robot[AssistLFacts.AgentStatus.TIME.index()]);
            row = new Integer(robot[AssistLFacts.AgentStatus.POSR.index()]);
            column = new Integer(robot[AssistLFacts.AgentStatus.POSC.index()]);
            direction = robot[AssistLFacts.AgentStatus.DIRECTION.index()];
            free = Integer.parseInt(robot[AssistLFacts.AgentStatus.FREE.index()]);
            waste = robot[AssistLFacts.AgentStatus.WASTE.index()].equals("yes");
            String[] cont = robot[AssistLFacts.AgentStatus.CONTENT.index()].split(" ");
            content.clear();
            for(int i=0; i<cont.length; i++) {content.add(cont[i]);}
        }
    }

    private void updateKAgent() throws CLIPSError{
        String[] robot = core.findFact("AGENT", AssistLFacts.KAgent.factName(), "TRUE", AssistLFacts.KAgent.slotsArray());
        if (robot[0] != null) { //Se hai trovato il fatto
            kstep = new Integer(robot[AssistLFacts.KAgent.STEP.index()]);
            ktime = new Integer(robot[AssistLFacts.KAgent.TIME.index()]);
            krow = new Integer(robot[AssistLFacts.KAgent.POSR.index()]);
            kcolumn = new Integer(robot[AssistLFacts.KAgent.POSC.index()]);
            kdirection = robot[AssistLFacts.KAgent.DIRECTION.index()];
            kfree = Integer.parseInt(robot[AssistLFacts.KAgent.FREE.index()]);
            kwaste = robot[AssistLFacts.AgentStatus.WASTE.index()].equals("yes");
            String[] cont = robot[AssistLFacts.AgentStatus.CONTENT.index()].split(" ");
            kcontent.clear();
            for(int i=0; i<cont.length; i++) {kcontent.add(cont[i]);}
        }
    }
    
    private void updatePeople() throws CLIPSError{
        console.debug("Acquisizione posizione degli altri agenti per EnvMap...");
        String[][] persons = core.findAllFacts("ENV", AssistLFacts.PersonStatus.factName(), "TRUE", AssistLFacts.PersonStatus.slotsArray());
        personPositions.clear();
        if (persons != null) {
            for (int i = 0; i < persons.length; i++) {
                if(persons[i][0] != null){
                    int r = new Integer(persons[i][AssistLFacts.PersonStatus.POSR.index()]);
                    int c = new Integer(persons[i][AssistLFacts.PersonStatus.POSC.index()]);
                    personPositions.add(new int[]{r, c});
                }
            }
        }
    }
    
    private void updateStaff() throws CLIPSError{
        console.debug("Acquisizione posizione degli altri agenti per EnvMap...");
        String[][] persons = core.findAllFacts("ENV", AssistLFacts.StaffStatus.factName(), "TRUE", AssistLFacts.StaffStatus.slotsArray());
        staffPositions.clear();
        if (persons != null) {
            for (int i = 0; i < persons.length; i++) {
                if(persons[i][0] != null){
                    int r = new Integer(persons[i][AssistLFacts.StaffStatus.POSR.index()]);
                    int c = new Integer(persons[i][AssistLFacts.StaffStatus.POSC.index()]);
                    staffPositions.add(new int[]{r, c});
                }
            }
        }
    }
    
    /*
    private void updateKPeople() throws CLIPSError{
        console.debug("Acquisizione posizione degli altri agenti per agentMap...");
        String[][] persons = core.findAllFacts("AGENT", "perc-vision", "= ?f:step " + this.step, new String[]{"perc1","perc2","perc3",
                                                                                                              "perc4","perc5","perc6",
                                                                                                              "perc7","perc8","perc9"});
        kpersonPositions.clear();
        if (persons != null) {
            for (int i = 0; i < persons.length; i++) {
                if(persons[i][0] != null){
                    int r = new Integer(persons[i][AssistLFacts.KPerson.POSR.index()]);
                    int c = new Integer(persons[i][AssistLFacts.KPerson.POSC.index()]);
                    if(direction.equals("north"))
                        
                    kpersonPositions.add(new int[]{r, c});
                }
            }
        }
    }*/

    private void checkBumpCondition() throws CLIPSError{
      console.debug("Controllo di evento bump...");
      boolean bumped = false;
      String[][] bump = core.findAllFacts("AGENT",AssistLFacts.PercBump.factName(),"TRUE", AssistLFacts.PercBump.slotsArray());
      this.bumped= bump.length!=0 ? true: false;   
    }

    @Override
    protected void updateStatus() throws CLIPSError{
        String[] status = core.findFact("MAIN", AssistLFacts.Status.factName(), "TRUE", AssistLFacts.Status.slotsArray());
        if (status!= null) {
            if(status[AssistLFacts.Status.STEP.index()] == null) { step = 0;} 
            else { step = new Integer(status[AssistLFacts.Status.STEP.index()]);}
            if(status[AssistLFacts.Status.TIME.index()] == null) {time = 0;}
            else {time = new Integer(status[AssistLFacts.Status.TIME.index()]);}
            if(status[AssistLFacts.Status.WORK.index()] == null){ result = "on";}
            else {
                result = status[AssistLFacts.Status.WORK.index()];
                if(result.equals("stop")){running = false;}
            }
            console.debug("Step: " + step + " Time: " + time + " Work: " + result);
        }
        score = Double.parseDouble(core.findOrderedFact("MAIN", "penalty"));
    }

    public ArrayList<int[]> getPersonPositions(){
        return personPositions;
    }
    
    public ArrayList<int[]> getStaffPositions(){
        return staffPositions;
    }

    /*
    public ArrayList<int[]> getKPersonPostions(){
        return kpersonPositions;
    }
    
    public ArrayList<int[]> getKStaffPositions(){
        return kstaffPositions;
    }
    */

    public String[][] findAllFacts(String template, String conditions, String[] slots) throws CLIPSError{
        String[][] empty = {};
        return core != null ? core.findAllFacts(template, conditions, slots) : empty;
    }

    public ArrayList<String> getContent() {
        ArrayList<String> tmp = new ArrayList();
        tmp.addAll(content);
        return tmp;
    }
    
    public int getFree() {
        return free;
    }
    
    public boolean getWaste() {
        return waste;
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

    public ArrayList<String> getKContent() {
        ArrayList<String> tmp = new ArrayList();
        tmp.addAll(kcontent);
        return tmp;
    }
    
    public int getKFree() {
        return kfree;
    }
    
    public boolean getKWaste() {
        return kwaste;
    }

    public int getKRow(){
        return krow;
    }

    public int getKColumn(){
        return kcolumn;
    }

    public boolean getBumped(){
        return bumped;
    }

    public Map<String,int[]> getOffset(){
      return this.offsetPosition;
    }
    
    public String getReport(){

        ProjectDirectory Pdir = ProjectDirectory.getInstance();
        String env = Pdir.getEnv();
        String strategy = Pdir.getStrategy();
        String penalties = Double.toString(score);
        String maxdur = Integer.toString(maxduration);
      
        String report = fixedLengthString(strategy,16) + "|" 
                      + fixedLengthString(env,16) + "|" 
                      + fixedLengthString(maxdur,8) + "|" 
                      + fixedLengthString(penalties,16) + "\n";
        return report;
    }

    public String getLogHeader(){
    
      return  fixedLengthString("Strategy",16)   + "|"
              + fixedLengthString("World",16) + "|"
              + fixedLengthString("Time",8) + "|"
              + fixedLengthString("Score",16) + "\n";
    }     
    
}
