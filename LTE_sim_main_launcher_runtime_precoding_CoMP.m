close all force;
clc;
cd ..

simulation_type = 'tri_sector_tilted';

%% Base configuration
LTE_config = LTE_load_params(simulation_type);
simSet = [6 4 2];
LTE_config.nTX     = simSet(2);
LTE_config.nRX     = simSet(3);
LTE_config.tx_mode = simSet(1);
LTE_config.scheduler = 'CoMP'; % Wrapper that lets the CoMP-set do the scheduling
LTE_config.CoMP_scheduler = 'round robin DB'; % possible : 'round robin CB', 'round robin DB'
LTE_config.CoMP_configuration = 'intra_site'; % possible: 'intra_site', 'global', 'trivial'

%LTE_config.scheduler = 'round robin';

LTE_config.bandwidth                      = 10e6;
LTE_config.eNodeB_tx_power                = 10^(41/10)*10^(-3); % in [W]
LTE_config.network_geometry               = 'regular_hexagonal_grid';
LTE_config.inter_eNodeB_distance          = 200; % In meters. When the network is generated, this determines the distance between the eNodeBs.
LTE_config.nr_eNodeB_rings                = 1; % Number of eNodeB rings

LTE_config.channel_model.type             = 'PedA';
LTE_config.UE_speed                       = 3/3.6;
%LTE_config.shadow_fading_type             = 'claussen';

LTE_config.UE_per_eNodeB                  = 10;
LTE_config.simulation_time_tti            = 100;
LTE_config.feedback_channel_delay         = 3;
LTE_config.seedRandStream                 = 1;
%
% % Misc options
% LTE_config.non_parallel_channel_trace   = true;
LTE_config.show_network                 = 0;
% LTE_config.channel_model.trace_length   = 1;
LTE_config.keep_UEs_still               = true;
LTE_config.compact_results_file         = true;
% LTE_config.compact_results_file         = 3;
LTE_config.delete_ff_trace_at_end       = true;
LTE_config.rep                          = 0;
% LTE_config.UE_cache                     = false;
% LTE_config.pregenerated_ff_file         = 'auto';
% LTE_config.cache_network = false;
LTE_config.trace_version = 'v2';

output_results_file = LTE_sim_main(LTE_config);
        
simulation_data                   = load(output_results_file);
GUI_handles.aggregate_results_GUI = LTE_GUI_show_aggregate_results(simulation_data);
GUI_handles.positions_GUI         = LTE_GUI_show_UEs_and_cells(simulation_data,GUI_handles.aggregate_results_GUI);
