
mumps_version = meson.project_version()

# -- MUMPS COMMON

if mumps_version.version_compare('>=5.1') and mumps_version.version_compare('<5.2')

comm_src = files(
'lr_common.F', 'ana_omp_m.F', 'ana_orderings_wrappers_m.F', 'mumps_memory_mod.F',
'mumps_static_mapping.F', 'mumps_sol_es.F', 'fac_future_niv2_mod.F', 'mumps_comm_ibcast.F', 'mumps_ooc_common.F',
'double_linked_list.F', 'fac_asm_build_sort_index_m.F', 'fac_asm_build_sort_index_ELT_m.F', 'omp_tps_common_m.F',
'mumps_l0_omp_m.F', 'front_data_mgt_m.F', 'fac_maprow_data_m.F', 'fac_descband_data_m.F', 'fac_ibct_data_m.F',
)

comm_other_src = files(
'ana_orderings.F', 'ana_AMDMF.F', 'bcast_errors.F', 'estim_flops.F', 'mumps_type_size.F', 'mumps_type2_blocking.F',
'mumps_version.F', 'tools_common.F', 'mumps_print_defined.F', 'mumps_common.c', 'mumps_size.c',
'mumps_io.c', 'mumps_io_basic.c', 'mumps_io_thread.c', 'mumps_io_err.c',
'ana_set_ordering.F', 'mumps_numa.c', 'mumps_thread.c', 'mumps_save_restore_C.c'
)

elif mumps_version.version_compare('>=5.2') and mumps_version.version_compare('<5.3')

comm_src = files(
'ana_omp_m.F', 'ana_orderings_wrappers_m.F', 'double_linked_list.F',
'fac_asm_build_sort_index_ELT_m.F', 'fac_asm_build_sort_index_m.F', 'fac_descband_data_m.F',
'fac_future_niv2_mod.F', 'fac_ibct_data_m.F', 'fac_maprow_data_m.F', 'front_data_mgt_m.F', 'lr_common.F',
'mumps_comm_ibcast.F', 'mumps_l0_omp_m.F', 'mumps_memory_mod.F', 'mumps_mpitoomp_m.F', 'mumps_ooc_common.F', 'mumps_static_mapping.F', 'omp_tps_common_m.F',
)

comm_other_src = files(
'ana_orderings.F', 'ana_set_ordering.F', 'ana_AMDMF.F', 'bcast_errors.F', 'estim_flops.F',
'mumps_type_size.F', 'mumps_type2_blocking.F', 'mumps_version.F', 'mumps_print_defined.F',
'mumps_pord.c',
'mumps_common.c', 'mumps_size.c', 'mumps_io.c', 'mumps_io_basic.c', 'mumps_io_thread.c', 'mumps_io_err.c',
'mumps_numa.c', 'mumps_thread.c', 'mumps_save_restore_C.c', 'mumps_config_file_C.c', 'mumps_thread_affinity.c',
'tools_common.F', 'sol_common.F'
)

if get_option('metis')
  comm_other_src += files('mumps_metis.c', 'mumps_metis64.c', 'mumps_metis_int.c')
endif
if get_option('scotch')
  comm_other_src += files('mumps_scotch.c', 'mumps_scotch64.c', 'mumps_scotch_int.c')
endif

else
  error('Update meson.build for MUMPS ' + mumps_version)
endif

mumps_common = library('mumps_common',
  sources: [comm_src, comm_other_src],
  dependencies : [mpic, mpif, scalapack, ordering_libs],
  include_directories : mumps_inc,
  c_args: [cargs, ordering_flags],
  fortran_args: ordering_flags,
  link_with : [pord, mpiseq],
  install: true
)

# -- MUMPS LIB

mumps_lib = []
foreach a : arith

if mumps_version.version_compare('>=5.1') and mumps_version.version_compare('<5.2')

src = files(
a+'ana_aux_par.F', a+'ana_lr.F', a+'fac_asm_master_m.F', a+'fac_asm_master_ELT_m.F',
a+'omp_tps_m.F', a+'mumps_comm_buffer.F', a+'mumps_load.F', a+'mumps_lr_data_m.F',
a+'mumps_ooc_buffer.F', a+'mumps_ooc.F', a+'mumps_struc_def.F', a+'static_ptr_m.F',
a+'lr_core.F', a+'lr_type.F', a+'lr_stats.F', a+'fac_lr.F', a+'fac_omp_m.F',
a+'fac_par_m.F', a+'fac_front_LU_type1.F', a+'fac_front_LU_type2.F',
a+'fac_front_LDLT_type1.F', a+'fac_front_LDLT_type2.F',
a+'fac_front_aux.F', a+'fac_front_type2_aux.F',
a+'mumps_save_restore_files.F', a+'mumps_save_restore.F'
)

src_other = files(
a+'ini_driver.F', a+'ana_driver.F', a+'fac_driver.F', a+'sol_driver.F',
a+'end_driver.F', a+'ana_aux_ELT.F', a+'ana_aux.F', a+'ana_dist_m.F', a+'ana_LDLT_preprocess.F',
a+'ana_reordertree.F', a+'arrowheads.F', a+'bcast_int.F', a+'fac_asm_ELT.F', a+'fac_asm.F',
a+'fac_b.F', a+'fac_distrib_distentry.F', a+'fac_distrib_ELT.F', a+'fac_lastrtnelind.F',
a+'fac_mem_alloc_cb.F', a+'fac_mem_compress_cb.F', a+'fac_mem_free_block_cb.F', a+'fac_mem_stack_aux.F',
a+'fac_mem_stack.F', a+'fac_process_band.F', a+'fac_process_blfac_slave.F', a+'fac_process_blocfacto_LDLT.F',
a+'fac_process_blocfacto.F', a+'fac_process_bf.F', a+'fac_process_end_facto_slave.F',
a+'fac_process_contrib_type1.F', a+'fac_process_contrib_type2.F', a+'fac_process_contrib_type3.F',
a+'fac_process_maprow.F', a+'fac_process_master2.F', a+'fac_process_message.F',
a+'fac_process_root2slave.F', a+'fac_process_root2son.F', a+'fac_process_rtnelind.F',
a+'fac_root_parallel.F', a+'fac_scalings.F', a+'fac_determinant.F',
a+'fac_scalings_simScaleAbs.F', a+'fac_scalings_simScale_util.F', a+'fac_sol_pool.F',
a+'fac_type3_symmetrize.F', a+'ini_defaults.F',
a+'mumps_driver.F', a+'mumps_f77.F', a+'mumps_iXamax.F',
a+'ana_mtrans.F', a+'ooc_panel_piv.F', a+'rank_revealing.F',
a+'sol_aux.F', a+'sol_bwd_aux.F', a+'sol_bwd.F', a+'sol_c.F',
a+'sol_fwd_aux.F', a+'sol_fwd.F', a+'sol_matvec.F', a+'sol_root_parallel.F',
a+'tools.F', a+'type3_root.F',
'fac_future_niv2_mod.F', 'mumps_ooc_common.F', 'mumps_memory_mod.F',
'ana_orderings_wrappers_m.F', 'mumps_comm_ibcast.F', 'omp_tps_common_m.F', 'fac_ibct_data_m.F',
'fac_asm_build_sort_index_m.F', 'fac_asm_build_sort_index_ELT_m.F', 'mumps_l0_omp_m.F', 'lr_common.F'
)

elif mumps_version.version_compare('>=5.2') and mumps_version.version_compare('<5.3')

src = files(
a+'ana_aux.F', a+'ana_aux_par.F', a+'ana_lr.F', a+'fac_asm_master_ELT_m.F', a+'fac_asm_master_m.F',
a+'fac_front_aux.F', a+'fac_front_LU_type1.F', a+'fac_front_LU_type2.F',
a+'fac_front_LDLT_type1.F', a+'fac_front_LDLT_type2.F', a+'fac_front_type2_aux.F',
a+'fac_lr.F', a+'fac_mem_dynamic.F', a+'fac_omp_m.F', a+'fac_par_m.F',
a+'lr_core.F', a+'lr_stats.F', a+'lr_type.F',
a+'mumps_comm_buffer.F', a+'mumps_config_file.F', a+'mumps_load.F', a+'mumps_lr_data_m.F',
a+'mumps_ooc_buffer.F', a+'mumps_ooc.F', a+'mumps_sol_es.F',
a+'mumps_save_restore.F', a+'mumps_save_restore_files.F',
a+'mumps_struc_def.F', a+'omp_tps_m.F', a+'sol_lr.F', a+'static_ptr_m.F',
)

src_other = files(
a+'ini_driver.F', a+'ana_driver.F', a+'fac_driver.F', a+'sol_driver.F', a+'sol_distrhs.F',
a+'end_driver.F', a+'ana_aux_ELT.F', a+'ana_dist_m.F', a+'ana_LDLT_preprocess.F',
a+'ana_reordertree.F', a+'arrowheads.F', a+'bcast_int.F', a+'fac_asm_ELT.F',
a+'fac_asm.F', a+'fac_b.F', a+'fac_distrib_distentry.F', a+'fac_distrib_ELT.F', a+'fac_lastrtnelind.F',
a+'fac_mem_alloc_cb.F', a+'fac_mem_compress_cb.F', a+'fac_mem_free_block_cb.F',
a+'fac_mem_stack_aux.F', a+'fac_mem_stack.F',
a+'fac_process_band.F', a+'fac_process_blfac_slave.F', a+'fac_process_blocfacto_LDLT.F', a+'fac_process_blocfacto.F',
a+'fac_process_bf.F', a+'fac_process_end_facto_slave.F',
a+'fac_process_contrib_type1.F', a+'fac_process_contrib_type2.F', a+'fac_process_contrib_type3.F',
a+'fac_process_maprow.F', a+'fac_process_master2.F', a+'fac_process_message.F',
a+'fac_process_root2slave.F', a+'fac_process_root2son.F', a+'fac_process_rtnelind.F', a+'fac_root_parallel.F',
a+'fac_scalings.F', a+'fac_determinant.F', a+'fac_scalings_simScaleAbs.F', a+'fac_scalings_simScale_util.F',
a+'fac_sol_pool.F', a+'fac_type3_symmetrize.F', a+'ini_defaults.F',
a+'mumps_driver.F', a+'mumps_f77.F', a+'mumps_gpu.c', a+'mumps_iXamax.F',
a+'ana_mtrans.F', a+'ooc_panel_piv.F', a+'rank_revealing.F',
a+'sol_aux.F', a+'sol_bwd_aux.F', a+'sol_bwd.F', a+'sol_c.F', a+'sol_fwd_aux.F', a+'sol_fwd.F', a+'sol_matvec.F',
a+'sol_root_parallel.F', a+'tools.F', a+'type3_root.F'
)

endif

cint_src = files('mumps_c.c')

defs = [cargs, '-DMUMPS_ARITH=MUMPS_ARITH_'+a, ordering_flags]

mumps_lib += library(a + 'mumps',
  sources: [cint_src, src, src_other],
  dependencies : [mpif, mpic, scalapack],
  fortran_args : defs,
  c_args : defs,
  link_with: [mumps_common, mpiseq],
  include_directories : mumps_inc,
  install: true
)


install_headers(
'../include' / a+'mumps_c.h',
'../include' / a+'mumps_root.h',
'../include' / a+'mumps_struc.h'
)

endforeach

install_headers('../include/mumps_c_types.h','../include/mumps_compat.h')