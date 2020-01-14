# Semantic-Clustering-and-Localization

Below, the steps are presented and analyzed that we followed to implement our method.

1) Extract and save the histogramms descriptors from the code ''Histogramms_Descriptors_for_images.m'' as well as store the file 'simVectorSeq.txt'
2) Run the ''c_Louvain.c'' archive that is the Louvain implementation, extracting the archive ''simVectorSeqout.txt'' used in ''SEMANTIC_MAPS.m''
3) Run it ''SEMANTIC_MAPS.m'' and the indexes of the images belonging to the corresponding semantic regions are stored in the matrices. With this code we create the semantic maps.
4) Extract the features of the above frames(per cluster) with the code ''Features_from_semanticRegions.m''
5) Finally, run the algorithm ''Voting_process.m'' which is the voting process for the semantic localization with features descriptors of the robot's revised route on the semantic areas of first route.

''KMEANS_TESTING.m'' is the code of the creating visual words, where these can be inputs in the '''Voting_process.m'', which is describted as the voting process for the semantic localization with visual words.

The vocabulary tree which is used, is the ''vocabulary_tree.mat'' (download this link: https://drive.google.com/open?id=1pO_pQhbvkP4VUMzd6nB-8pALeBJKrqlM)




