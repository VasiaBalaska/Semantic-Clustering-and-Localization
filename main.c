
/* 
 * File:   main.c
 * Author: spyros
 *
 * Created on 22 Ιανουαρίου 2017, 12:45 μμ
 */

#include <igraph.h>

/*
 * 
 */

void show_results(igraph_t *g, igraph_vector_t *membership, igraph_matrix_t  *memberships, igraph_vector_t *modularity, FILE* f) {
    long int i, j, no_of_nodes = igraph_vcount(g);

    j = igraph_vector_which_max(modularity);
    for (i = 0; i < igraph_vector_size(membership); i++) {
        if (VECTOR(*membership)[i] != MATRIX(*memberships, j, i)) {
            fprintf(f, "WARNING: best membership vector element %li does not match the best one in the membership matrix\n", i);
        }
    }

    fprintf(f, "Modularities:");
//    for (i = 0; i < igraph_matrix_nrow(memberships); i++) 
//        fprintf(f, " %f", modularity[i]);
    
    igraph_vector_fprint(modularity, f);
fprintf(f, "\n");
    for (i = 0; i < igraph_matrix_nrow(memberships); i++) 
    {
        for (j = 0; j < no_of_nodes; j++) {
            fprintf(f, "%ld\t%ld\n", (long int) j, (long int) MATRIX(*memberships, i, j));
        }
        fprintf(f, "\n");
    }

    fprintf(f, "\n");
}

int fileRows() {
    int n = 0;
    FILE *fp;
    char fromStr[255];
    char toStr[255];
    char weightStr[255];

    fp = fopen("simVectorSeq_ras.txt", "r");
    if (fp == NULL)
        exit(EXIT_FAILURE);

    while (!feof(fp)) {
        fscanf(fp, "%[^\t]\t%[^\t]\t%[^\n]\n", fromStr, toStr, weightStr);
        ++n;
    }

    fclose(fp);

    return n;
}

int main() {

    igraph_t graph;
    igraph_vector_t weights, modularity, membership, edges;
    igraph_matrix_t memberships;

    FILE *fp;
    char fromStr[255];
    char toStr[255];
    char weightStr[255];
    long from, to, weight;
    char *ptr;
    int n = 0, m = 0;
    int rows = fileRows(); //rows of the file depicting from-to-weight relations, 66 for if 66 edges exist
    
    igraph_vector_init(&edges, 2 * rows); //2*66 = 132 parts of 66 edges, if 66 edges exist
    igraph_vector_init(&modularity, 0);
    igraph_vector_init(&weights, rows); //66 weights, if 66 edges exist
    igraph_vector_init(&membership, 0);
    igraph_matrix_init(&memberships, 0, 0);

    printf("Prepare graph with weights\n");

    //Populate graph with data from file win9.txt
    fp = fopen("simVectorSeq_ras.txt", "r");
    if (fp == NULL)
        exit(EXIT_FAILURE);

    while (!feof(fp)) {
        fscanf(fp, "%[^\t]\t%[^\t]\t%[^\n]\n", fromStr, toStr, weightStr);
        from = strtol(fromStr, &ptr, 10);
        to = strtol(toStr, &ptr, 10);
        weight = strtol(weightStr, &ptr, 10);
        //printf("%d: %ld, %ld, %ld\n", m, from, to, weight);
        VECTOR(weights)[m] = weight;
        VECTOR(edges)[n] = from;
        VECTOR(edges)[n + 1] = to;
        ++m;
        n += 2;
    }

    fclose(fp);

    //printf("Edges in file = %d\n", m);

    igraph_create(&graph, &edges, 0, IGRAPH_UNDIRECTED);
    printf("Edges in graph = %d\n", igraph_ecount(&graph));
    printf("Vertices in graph = %d\n", igraph_vcount(&graph));
    //if (igraph_vcount(&graph) != 12) {
    //    return 1;
    //}

    //igraph_write_graph_edgelist(&graph, stdout);

    igraph_community_multilevel(&graph, &weights, &membership, &memberships, &modularity);

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //show_results(&graph, &membership, &memberships, &modularity, stdout);
    fp = fopen("simVectorSeq_out_ras.txt", "w");
    fprintf(fp, "OUTPUT FILE: simVectorSeq_out_ras.txt\n");
    fprintf(fp, "Edges in graph = %d\n",igraph_ecount(&graph));
    fprintf(fp, "Vertices in graph = %d\n", igraph_vcount(&graph));
    show_results(&graph, &membership, &memberships, &modularity, fp);
    fclose(fp);
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    igraph_destroy(&graph);
    igraph_vector_destroy(&modularity);
    igraph_vector_destroy(&weights);
    igraph_vector_destroy(&membership);
    igraph_vector_destroy(&edges);
    igraph_matrix_destroy(&memberships);

    return 0;
}
