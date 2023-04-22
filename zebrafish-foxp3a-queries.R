
library(SPARQL)
endpoint <-"http://dayhoff.inf.um.es:3035/blazegraph/namespace/zebrafish-foxp3a/sparql"

#####QUERY 1. Which protein domains are registered in the graph. Show its or their name and the protein that contains it/them.
query1 <-"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX obo: <http://purl.obolibrary.org/obo/> 
SELECT ?protein ?domain ?label
WHERE {?protein obo:NCIT_R50 ?domain.
       ?domain rdfs:label ?label
  }
"
qd <- SPARQL(endpoint,query1)
View(as.data.frame(qd$results))

##### QUERY 2. Which species do the genes registered in the graph belong to? Show gene' URI, animal's URI and animal's label if it has one.
query2 <-"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX Thesaurus: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#> 
PREFIX uniprot: <http://purl.uniprot.org/core/> 
SELECT ?gene ?animal ?label
WHERE {Thesaurus:C28708 rdf:type?gene. ?gene uniprot:organism ?animal 
optional {?animal rdfs:label ?label}}
"
qe <- SPARQL(endpoint,query2)
View(as.data.frame(qe$results))


#####QUERY 3. How many protein domains are involved in any biological process?
query3 <- "PREFIX up: <http://purl.uniprot.org/prop/> 
PREFIX Thesaurus: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#> 
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
SELECT (count(distinct ?domain) as ?num_BP)
        WHERE {	
        ?domain up:participates-in ?biological_process.
		?domain rdfs:subClassOf Thesaurus:C13379}
"
qf <- SPARQL(endpoint,query3)
View(as.data.frame(qf$results))


#####QUERY 4.Show, for the species which are subclasses of class Fish, their genes which encodes proteins, the protein encoded and its label if possible. Show the same information for the mammals.
query4 <- "PREFIX obo: <http://purl.obolibrary.org/obo/> 
PREFIX uniprot: <http://purl.uniprot.org/core/> 
PREFIX up: <http://purl.uniprot.org/prop/> 
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX Thesaurus: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#> 

SELECT ?name ?protein ?gene
WHERE{{?animal rdfs:subClassOf Thesaurus:C14207.
       ?animal rdfs:label ?name.
  		?prot uniprot:organism ?animal.
       ?prot uniprot:encodedBy ?gen.
       ?prot rdf:type obo:PR_000000001.
       ?gen rdf:type Thesaurus:C16612.
       ?gen rdfs:label ?gene          
       OPTIONAL{?prot rdfs:label ?protein} }    
       
 UNION {?mamif rdfs:subClassOf Thesaurus:C14234.
       ?mamif rdfs:label ?name .
     	?pro uniprot:organism ?mamif.?pro rdf:type obo:PR_000000001.
       ?pro uniprot:encodedBy ?g.
       ?g rdf:type Thesaurus:C16612.
       ?g rdfs:label ?gene       
       OPTIONAL{?pro rdfs:label ?protein}
       }
      }
"
qg <- SPARQL(endpoint,query4)
View(as.data.frame(qg$results))
#####QUERY 5. Which biological process and molecular functions belong to FOXP3 protein domain?
query5 <- "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX obo: <http://purl.obolibrary.org/obo/> 
PREFIX up: <http://purl.uniprot.org/prop/> 
SELECT  ?name ?bp ?mf
WHERE{ {?bp rdf:type obo:NCIT_C17828.?bp rdfs:label ?name. obo:NCIT_C97565 up:participates-in ?bp}
      UNION {?mf rdf:type obo:GO_0003674. ?mf rdfs:label ?name.obo:NCIT_C97565 up:participates-in ?mf}}
"
qh <- SPARQL(endpoint,query5)
View(as.data.frame(qh$results))
