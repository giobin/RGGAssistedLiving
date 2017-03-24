/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.clipsmonitor.gui;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.Observable;
import java.util.Observer;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import org.clipsmonitor.clips.ClipsConsole;
import org.clipsmonitor.core.MonitorCore;
import org.clipsmonitor.core.MonitorImages;
import org.clipsmonitor.core.MonitorMap;
import org.clipsmonitor.monitor2015.AssistedLivingModel;
import org.openide.windows.TopComponent;

public abstract class MapTopComponent extends TopComponent implements Observer {
    private MapPanel mapPanel;
    protected AssistedLivingModel model;
    protected MonitorImages images;
    protected MonitorMap map;
    protected String target;
    protected ClipsConsole console;
    private int lastUpdate;
    
    public MapTopComponent(){
        initComponents();
        init();
    }
    
    private void init(){
        this.model = AssistedLivingModel.getInstance();
        this.model.addObserver(this);
        console = ClipsConsole.getInstance();
    }
    
    private void clear(){
        this.model = null;
        AssistedLivingModel.clearInstance();
        this.console = null;
        this.mapPanel.map = null;
        this.mapPanel.model = null;
        this.map = null;
        this.mapPanel = null;
        this.containerPanel.removeAll();
        this.containerPanel.repaint();
        this.lastUpdate = -1;
    }
    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        containerPanel = new javax.swing.JPanel();

        containerPanel.setLayout(new java.awt.BorderLayout());

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(containerPanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(containerPanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel containerPanel;
    // End of variables declaration//GEN-END:variables
    @Override
    public void componentOpened() {
        // TODO add custom code on component opening
    }

    @Override
    public void componentClosed() {
        // TODO add custom code on component closing
    }

    void writeProperties(java.util.Properties p) {
        // better to version settings since initial version as advocated at
        // http://wiki.apidesign.org/wiki/PropertyFiles
        p.setProperty("version", "1.0");
        // TODO store your settings
    }

    void readProperties(java.util.Properties p) {
        String version = p.getProperty("version");
        // TODO read your settings according to their version
    }

    @Override
    public void update(Observable o, Object arg) {
        if(arg.equals(this.target)){
            console.debug("Target map " + arg);
            this.map = model.getMapToRegister(this.target);
            this.map.addObserver(this);
        }
        else if(arg.equals("repaint")){
            this.repaintIfNeeded();
        }
        else if(arg.equals("initializeMap")){
            this.initializeMap();
        }
        else if(arg.equals("advise")){
            MonitorCore.getInstance().finished();
            JOptionPane.showMessageDialog(this.containerPanel, model.getAdvise(), "Termine Esecuzione", JOptionPane.INFORMATION_MESSAGE);
        }
        else if(arg == "clearApp"){
            this.clear();
        }
        else if(arg == "startApp"){
            this.init();
        }
    }
    
    private void repaintIfNeeded(){
        if(map.getVersion() > lastUpdate){
            this.mapPanel.repaint();
        }
        lastUpdate = map.getVersion();
    }
    
    
    /**
     * Crea la prima versione della mappa, quella corrispondente all'avvio
     * dell'ambiente. Inserisce in ogni elemento del grid (mappa) la corretta
     * immagine.
     *
     */
    private void initializeMap() {
        int[] mapSize = map.getSize();

        int x = mapSize[0];
        int y = mapSize[1];
        int cellDimension = Math.round(map.MAP_DIMENSION / x);

        // bloccata la dimensione massima delle singole immagini
        if (cellDimension > MonitorImages.DEFAULT_IMG_SIZE) {
            cellDimension = MonitorImages.DEFAULT_IMG_SIZE;
        }

        mapPanel = new MapPanel(map);

        javax.swing.GroupLayout mapPanelLayout = new javax.swing.GroupLayout(mapPanel);
        mapPanel.setLayout(mapPanelLayout);
        mapPanelLayout.setHorizontalGroup(
            mapPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 400, Short.MAX_VALUE)
        );
        mapPanelLayout.setVerticalGroup(
            mapPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );

        containerPanel.add(mapPanel, java.awt.BorderLayout.CENTER);
        this.containerPanel.validate();
    }
    
    
    
    protected class MapPanel extends JPanel {
        AssistedLivingModel model;
        MonitorMap map;
        
        public MapPanel(MonitorMap map) {
            
            super();
            model = AssistedLivingModel.getInstance();
            this.map = map;
        }
       
        
        

        @Override
        public void paintComponent(Graphics g) {
            super.paintComponent(g);
            Graphics2D g2 = (Graphics2D) g;
            
            int[] mapSize = map.getSize();
            int mapWidth = mapSize[0];
            int mapHeight = mapSize[1];

            int cellWidth = Math.round((this.getWidth() - 20) / mapWidth);
            int cellHeight = Math.round((this.getHeight() - 20) / mapHeight);

            if (cellWidth > cellHeight) {
                cellWidth = cellHeight;
            } else {
                cellHeight = cellWidth;
            }

            int x0 = (this.getWidth() - cellWidth * mapWidth) / 2;
            int y0 = (this.getHeight() - 30 - cellHeight * mapHeight) / 2;
            
            // genero la mappa di icone da disegnare
            
            BufferedImage[][] iconMatrix = map.getIconMatrix();

            for (int i = mapWidth - 1; i >= 0; i--) {
                
                // calcolo la posizione dei marker per le righe (i)
                int xiMarker = x0 - cellWidth ;
                int yiMarker = y0 + cellHeight / 2 + cellHeight * (mapWidth - i);
                g2.drawString((i + 1) + "",xiMarker , yiMarker );
                
                for (int j = 0; j < mapHeight; j++) {
                    if (i == 0) {
                        
                        // calcolo la posizione dei marker per le colonne (j)
                        int xjMarker = x0 + cellWidth / 2 + cellWidth * j;
                        int yjMarker = y0 + cellHeight / 2 ;
                        g2.drawString((j + 1) + "", xjMarker , yjMarker);
                    }
                
                    int xIconPos = x0 + cellWidth * j;
                    int yIconPos = y0 + cellHeight * (mapWidth - i);
                    
                    g2.drawImage(iconMatrix[i][j],xIconPos , yIconPos, cellWidth, cellHeight, this);

                }
            }
        }
    }
}
