package org.clipsmonitor.monitor2016;

import java.util.ArrayList;
import java.util.Observer;
import net.sf.clipsrules.jni.CLIPSError;
import org.clipsmonitor.core.MonitorMap;

public class AssistLAgentMap extends MonitorMap implements Observer {    
    private final String UNKNOWN_COLOR = "#000000";
    private final String DISCOVERED_COLOR = "rgba(0,255,0,0.3)";
    private final String CHECKED_COLOR = "rgba(255,255,0,0.3)";
    private final String CLEAR_COLOR = "rgba(182,20,91,0.3)";
    private int parkingr = 0;
    private int parkingc = 0;
    private boolean[][] oldTableStatus;
    
    public AssistLAgentMap(){
        super();
    }
    
    @Override
    protected void onDispose() {
        console.debug("Dispose effettuato");
        String result = model.getResult();
        double score = model.getScore();
        @SuppressWarnings("UnusedAssignment")
        String advise = "";
        if (result.equals("disaster")) {
            advise = "Distaster \n";
        } else if (model.getTime() > model.getMaxDuration()) {
            advise = "Maxduration has been reached \n";
        } else {
            advise = "The agent says DONE.\n";
        }
        advise = advise + "Penalties: " + score;
        model.setAdvise(advise);
        this.setChanged();
        this.notifyObservers("advise");
    }
    
    @Override
    protected void initializeMap() throws CLIPSError {
        console.debug("Inizializzazione del modello (EnvMap).");
        String[][] mp = core.findAllFacts("ENV", AssistLFacts.PriorCell.factName(), "TRUE", AssistLFacts.PriorCell.slotsArray());
        int maxr = 0;
        int maxc = 0;
        for (int i = 0; i < mp.length; i++) {
            int r = new Integer(mp[i][AssistLFacts.PriorCell.POSR.index()]);
            int c = new Integer(mp[i][AssistLFacts.PriorCell.POSC.index()]);
            String contains = mp[i][AssistLFacts.PriorCell.CONTAINS.index()];
            
            if(contains.equals("Parking")) {
                parkingr=r-1; parkingc=c-1;
            }
            if (r > maxr) {maxr = r;}
            if (c > maxc) {maxc = c;}
        }
        map = new String[maxr][maxc];//Matrice di max_n_righe x max_n_colonne
        oldTableStatus = new boolean[maxr][maxc];
        for (int i = 0; i < map.length; i++) {
            for (int j = 0; j < map[i].length; j++) {
                map[i][j] = UNKNOWN_COLOR;
            }
        }
    }
    
    /**
     * Aggiorna la mappa visualizzata nell'interfaccia per farla allineare alla
     * versione nel modello.
     *
     */
    @Override
    protected void refreshMap() throws CLIPSError {
        if(model.getStep()>1) {
            updateTableStatus();
            updateCells();
            updateAgentStatus();
        }
        /*
        if(model.getShowGoalEnabled()){
            updateGoal();
            updateGoalsToDo();
        }*/
        // debugMap("cell");
    }

    private void updateCells() throws CLIPSError {
        console.debug("Aggiornamento mappa reale in corso...");

        String[][] cellFacts = core.findAllFacts("AGENT", AssistLFacts.KCell.factName(), "TRUE", AssistLFacts.KCell.slotsArray());
        
        if(cellFacts != null) {
            for (String[] fact : cellFacts) {
                // Nei fatti si conta partendo da 1, nella matrice no, quindi sottraiamo 1.
                int c = new Integer(fact[AssistLFacts.KCell.POSC.index()]) - 1;
                int r = new Integer(fact[AssistLFacts.KCell.POSR.index()]) - 1;
                String contains = fact[AssistLFacts.KCell.CONTAINS.index()];
                
                //caso di default preleviamo il valore dello slot contains e lo applichiamo alla mappa
                
                if(contains.equals("Robot")) {
                    map[r][c] = "Empty";
                    if(r == parkingr && c == parkingc)
                        map[r][c] += "+Parking";
                }
                else if(contains.equals("PersonStanding")) {
                    map[r][c] = "Empty+unknown_person";
                }
                else if(contains.equals("PersonSeated")) {
                    map[r][c] = "Empty+Seat+unknown_person_seated";
                }
                else if(!contains.equals("Table")){
                    map[r][c] = contains.equals("Empty") ? "Empty" : "Empty+"+contains;
                }
                
                if(!(Math.abs((model.getKRow()-r-1))<=1 && Math.abs((model.getKColumn()-c-1))<=1)) {
                    map[r][c] += "+unknown";
                }
            }
        }
    }

    public void updateAgentStatus() throws CLIPSError{
        console.debug("Acquisizione posizione dell'agente...");
        int r = model.getKRow() - 1;
        int c = model.getKColumn() - 1;
        map[r][c] += "+agent_" + model.getKDirection();
        ArrayList<String> tmp = model.getKContent();
        if(tmp.size()>0 && tmp.get(0)!=null) {
            if(tmp.get(0).contains("dietetic"))
                map[r][c]+= "+dietetic1";
            if(tmp.get(0).contains("normal"))
                map[r][c]+= "+normal1";
            if(tmp.get(0).contains("P"))
                map[r][c]+= "+pill1";
            if(tmp.get(0).contains("dessert"))
                map[r][c]+= "+dessert1"; 
        }
        if(tmp.size()>1 && tmp.get(1)!=null) {
            if(tmp.get(1).contains("dietetic"))
                map[r][c]+= "+dietetic2";
            if(tmp.get(1).contains("normal"))
                map[r][c]+= "+normal2";
            if(tmp.get(1).contains("P"))
                map[r][c]+= "+pill2";
            if(tmp.get(1).contains("dessert"))
                map[r][c]+= "+dessert2"; 
        }
        if(model.getKWaste()) {
            map[r][c] += "+bin";
        }
        if(model.getBumped()){
          int [] offset = model.getOffset().get(model.getKDirection());
          map[r + offset[0]][c + offset[1]] += "+bump";
        }
    }
    
    public void updateTableStatus() throws CLIPSError{
        String[][] tableFacts = core.findAllFacts("ENV", AssistLFacts.TableStatus.factName(), "TRUE", AssistLFacts.TableStatus.slotsArray());
        for (String[] fact : tableFacts) {
            // Nei fatti si conta partendo da 1, nella matrice no, quindi sottraiamo 1.
            int c = new Integer(fact[AssistLFacts.TableStatus.POSC.index()]) - 1;
            int r = new Integer(fact[AssistLFacts.TableStatus.POSR.index()]) - 1;
            boolean clean = fact[AssistLFacts.TableStatus.CLEAN.index()].equals("no");
            
            if(oldTableStatus[r][c] && clean) {
                map[r][c] = "Empty+Table+dirty_dish";
            } else if(!oldTableStatus[r][c] && clean){
                map[r][c] = "Empty+Table+meal";
            } else {
                map[r][c] = "Empty+Table";
            }
            
            oldTableStatus[r][c] = clean;
        }
    }
    
    public void updateGoal()throws CLIPSError {
    
    }
    
    public void updateGoalsToDo() throws CLIPSError{}
}