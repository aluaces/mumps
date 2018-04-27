/* Copyright 2018 IPB, Universite de Bordeaux, INRIA & CNRS
**
** This file is part of the Scotch software package for static mapping,
** graph partitioning and sparse matrix ordering.
**
** This software is governed by the CeCILL-C license under French law
** and abiding by the rules of distribution of free software. You can
** use, modify and/or redistribute the software under the terms of the
** CeCILL-C license as circulated by CEA, CNRS and INRIA at the following
** URL: "http://www.cecill.info".
** 
** As a counterpart to the access to the source code and rights to copy,
** modify and redistribute granted by the license, users are provided
** only with a limited warranty and the software's author, the holder of
** the economic rights, and the successive licensors have only limited
** liability.
** 
** In this respect, the user's attention is drawn to the risks associated
** with loading, using, modifying and/or developing or reproducing the
** software by the user in light of its specific status of free software,
** that may mean that it is complicated to manipulate, and that also
** therefore means that it is reserved for developers and experienced
** professionals having in-depth computer knowledge. Users are therefore
** encouraged to load and test the software's suitability as regards
** their requirements in conditions enabling the security of their
** systems and/or data to be ensured and, more generally, to use and
** operate it in the same conditions as regards security.
** 
** The fact that you are presently reading this means that you have had
** knowledge of the CeCILL-C license and that you accept its terms.
*/
/************************************************************/
/**                                                        **/
/**   NAME       : test_scotch_mesh_graph.c                **/
/**                                                        **/
/**   AUTHOR     : Francois PELLEGRINI                     **/
/**                                                        **/
/**   FUNCTION   : This module tests the operation of      **/
/**                the SCOTCH_graphColor() routine.        **/
/**                                                        **/
/**   DATES      : # Version 6.0  : from : 11 feb 2018     **/
/**                                 to     11 feb 2018     **/
/**                                                        **/
/************************************************************/

/*
**  The defines and includes.
*/

#include <stdio.h>
#if (((defined __STDC_VERSION__) && (__STDC_VERSION__ >= 199901L)) || (defined HAVE_STDINT_H))
#include <stdint.h>
#endif /* (((defined __STDC_VERSION__) && (__STDC_VERSION__ >= 199901L)) || (defined HAVE_STDINT_H)) */
#include <stdlib.h>
#include <string.h>

#include "scotch.h"

/*********************/
/*                   */
/* The main routine. */
/*                   */
/*********************/

int
main (
int                 argc,
char *              argv[])
{
  FILE *              fileptr;
  SCOTCH_Mesh         meshdat;
  SCOTCH_Graph        grafdat;
  SCOTCH_Num          diamval;

  SCOTCH_errorProg (argv[0]);

  if (SCOTCH_meshInit (&meshdat) != 0) {          /* Initialize source graph */
    SCOTCH_errorPrint ("main: cannot initialize mesh");
    return            (1);
  }

  if (SCOTCH_graphInit (&grafdat) != 0) {         /* Initialize source graph */
    SCOTCH_errorPrint ("main: cannot initialize graph");
    return            (1);
  }

  if ((fileptr = fopen (argv[1], "r")) == NULL) {
    SCOTCH_errorPrint ("main: cannot open file");
    return            (1);
  }

  if (SCOTCH_meshLoad (&meshdat, fileptr, -1) != 0) { /* Read source mesh */
    SCOTCH_errorPrint ("main: cannot load mesh");
    return            (1);
  }

  fclose (fileptr);

  if (SCOTCH_meshGraph (&meshdat, &grafdat) != 0) {
    SCOTCH_errorPrint ("main: cannot create graph from mesh");
    return            (1);
  }

  SCOTCH_graphExit (&grafdat);
  SCOTCH_meshExit (&meshdat);

  return (0);
}