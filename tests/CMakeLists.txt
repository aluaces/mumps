# testing what we just built

if("d" IN_LIST arith)
  if(parallel)
    add_executable(mumpscfg test_mumps.f90)
    add_test(NAME MumpsCfg
      COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:mumpscfg>)
  else()
  add_executable(mumpscfg test_mumps_seq.f90)
    add_test(NAME MumpsCfg COMMAND mumpscfg)
  endif()

  target_link_libraries(mumpscfg PRIVATE dmumps mumps::mumps ${NUMERIC_LIBS})
  target_include_directories(mumpscfg PRIVATE ${NUMERIC_INCDIRS})

  set_tests_properties(MumpsCfg PROPERTIES RUN_SERIAL true)
endif()

if("s" IN_LIST arith)
  if(parallel)
    add_executable(s_simple s_simple.f90)
    add_test(NAME SimpleReal32
      COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:s_simple>)
  else()
    add_executable(s_simple s_simple_seq.f90)
    add_test(NAME SimpleReal32 COMMAND s_simple)
  endif()
  target_link_libraries(s_simple PRIVATE smumps mumps::mumps ${NUMERIC_LIBS})
  target_include_directories(s_simple PRIVATE ${NUMERIC_INCDIRS})

  set_tests_properties(SimpleReal32 PROPERTIES RUN_SERIAL true)
endif()

if("d" IN_LIST arith)
  if(parallel)
    add_executable(d_simple d_simple.f90)
    add_test(NAME SimpleReal64
      COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:d_simple>)
  else()
  add_executable(d_simple d_simple_seq.f90)
    add_test(NAME SimpleReal64 COMMAND d_simple)
  endif()
  target_link_libraries(d_simple PRIVATE dmumps mumps::mumps ${NUMERIC_LIBS})
  target_include_directories(d_simple PRIVATE ${NUMERIC_INCDIRS})

  set_tests_properties(SimpleReal64 PROPERTIES RUN_SERIAL true)

  if(NOT ClangTest)
    return()
  endif()

  if(parallel)
    add_executable(Csimple simple.c)
    add_test(NAME CSimpleReal64
      COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:Csimple>)
  else()
    add_executable(Csimple simple_seq.c)
    add_test(NAME CSimpleReal64 COMMAND Csimple)
  endif()
  target_link_libraries(Csimple PRIVATE dmumps mumps::mumps ${NUMERIC_LIBS})
  target_include_directories(Csimple PRIVATE ${NUMERIC_INCDIRS})
  target_compile_options(Csimple PRIVATE ${CFLAGS})

  set_tests_properties(CSimpleReal64 PROPERTIES RUN_SERIAL true)
endif()
