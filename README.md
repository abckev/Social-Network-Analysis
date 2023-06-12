# Social-Network-Analysis
Progetto SNA 

Il progetto realizzato consiste nell'eseguire diverse operazioni sul file Excel "cluster_summary.xlsx" per analizzare le relazioni tra cluster e domini della rete presa in considerazione.

L'obiettivo è quello di creare un grafo bipartito (cluster - dominio) e successivamente, di eseguire una proiezione del grafo per ottenere una rete connessa solo tra i cluster e domini e analizzarla tramite il software Gephi.

Il programma consiste inizialmente nella lettura ed estrazione dei campi dati 'cluster' e 'domini' dal file, e viene creato un nuovo dataframe per memorizzare le relazioni tra i cluster e i domini. Tali domini dovranno essere unici (non ripetuti in fase di memorizzazione).

Il dataframe sarà composto da soli valori binari (1 o 0) in base alla presenza o assenza di una relazione tra ciascun cluster e i domini.

Successivamete, avviene la crezione del grafo bipartito applicando una tecnica di semplificazione utilizzando funzioni del pacchetto 'igraph' al quale sarà fatta una proiezione per poi analizzarla.

Infine, viene richiesto all'utente, da riga di comando, di inserire una soglia di peso per gli archi del grafo. Gli archi con un peso inferiore a tale soglia vengono eliminati dal grafo per semplificarne la rappresentazione ed analizzare al meglio le connessioni tra cluster e dominio.

Il grafo filtrato viene quindi visualizzato e salvato in un nuovo file.
