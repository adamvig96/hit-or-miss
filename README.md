# Replication Exercise: Hit or Miss? The Effect of Assassinations on Institutions and War

Authors: Niccoló Borri, Philipp Hilmbauer, Ramzi Chariag, Marton Vegh, Adam Vig

The repository contains code and data to replicate our project to the Empirical Political Economy class at CEU 2022 Winter.

### Abstract

The purpose of this report is to replicate the results from Jones and Olken
(2009) on democratization and conflict, to test their robustness and to augment
their analysis by adding new methods. In particular, we recreate the main
results of the original analysis, we add controls and fixed effects to examine
the robustness of their main results, and we employ an event study design to
investigate the dynamic aspects of the post-assassination period. Overall, the
results are largely reproducible and robust, however the effects cannot be found
when adding the dynamic component to the analysis


### Details on each Data Source

The data were collected by the author, and are available under a Creative Commons Non-commercial license. 

#### **Database of news portal texts**
The data `media_corpus_raw.csv` in the directory `data/raw` were collected using scraping code writen in Python by the author. Code is available at the `code/scraper` folder.

#### **Database of representatives speeches in parliament**
The data `parliament_speeches_2010-2020.csv` in the directory `data/raw` were collected by K-monitor. The author recieved acces to the database, the script `download_parliament_speeches.py` in folder `code/sraper` merge and clean the raw files and saves results in `data/raw` used in the analysis.

### Memory and Runtime Requirements

#### Summary
 
Approximately 30-40 minutes needed to reproduce the analyses on a standard 2022 desktop machine. The stemming of media corpus executed in `code/stem_media_corpus.py` takes 1.5 hours on a standard 2022 desktop machine. The author would not recommend running the scraper code on a destop machine.

#### Details

The analysis code were last run on a **8-core M1 Macbook Pro with 16 GB RAM and MacOS version 12.1**. 

The scraper code were last run on a **8-core AWS EC2 server with 32 GB of RAM**. Computation took 7-8 days using [aswan](https://github.com/endremborza/aswan). 

Description of `code`
----------------------------

- `code/1_pipeline_with_feature_selection.ipynb` replicates the main results of the project.
- `code/2_pipeline_trimmed_dtm.ipynb` replicates robustness check No.1, using a simple trimmed DTM without feature selection.
- `code/3_pipeline_trimmed_dtm_tfidf..ipynb` replicates robustness check No.2, using a simple trimmed DTM without feature selection, and TFIDF vectorizer.
- `code/4_pipeline_cosine_similarity.ipynb` replicates robustness check No.3, using cosine similarity to estimate media bias. I calculate similarity of each news paper article to the vector of Fidesz and Opposition.