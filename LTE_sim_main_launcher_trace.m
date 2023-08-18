close all force;
clc;

cd ..
simulation_type = 'trace';

% Possible simulation types now:
%   - 'tri_sector'
%   - 'tri_sector_tilted', 'tri_sector_tilted_4x2', 'tri_sector_tilted_4x4'
%   - 'tri_sector_plus_femtocells'
%   - 'six_sector_tilted'
%   - 'capesso_pathlossmaps'
%   - 'omnidirectional_eNodeBs'
%   - 'tri_sector_tilted_traffic'

simSet = [1 1 1];

%% Base configuration
LTE_config = LTE_load_params(simulation_type);
LTE_config.trace_filename        = './data_files/UE_pathloss_trace/UE_traces';
LTE_config.TTI_per_trace_step    = 10;
LTE_config.reduced_feedback_logs = true;
% LTE_config.eNodeB_tx_power              = 46; % 46 dBm
LTE_config.bandwidth                    = 10e6;
% LTE_config.simulation_time_tti          = 100;
% LTE_config.network_source               = 'capesso';
% LTE_config.pathlosses                   = [0 10 10];
% LTE_config.scheduler                    = 'prop fair Sun'; % prop fair Sun % round robin
% LTE_config.channel_model.type           = 'TU';
% LTE_config.UE_speed                     = 5/3.6;
% LTE_config.UE_distribution              = 'constant UEs per ROI';
LTE_config.simulation_time_tti = 800;
% 
% % Misc options
LTE_config.compact_results_file         = 1;
LTE_config.delete_ff_trace_at_end       = true;

UE_trace_cache = fullfile('./data_files/UE_pathloss_trace',[utils.hashing.DataHash(LTE_config.trace_filename) '.mat']);
if ~exist(UE_trace_cache,'file')
    [UE_traces,mapping] = utils.read_simulation_trace(LTE_config);
    save(UE_trace_cache,'UE_traces','mapping');
else
    loaded_data = load(UE_trace_cache);
    UE_traces   = loaded_data.UE_traces;
    mapping     = loaded_data.mapping;
end
LTE_config.default_shown_GUI_cells = UE_traces(1).connected_cells;

LTE_config.nTX     = simSet(2);
LTE_config.nRX     = simSet(3);
LTE_config.tx_mode = simSet(1);
ticIdx = tic;
output_results_file = LTE_sim_main(LTE_config,[],[],UE_traces);
time = toc(ticIdx);

simulation_data                   = load(output_results_file);
GUI_handles.aggregate_results_GUI = LTE_GUI_show_aggregate_results(simulation_data);
%GUI_handles.positions_GUI         = LTE_GUI_show_UEs_and_cells(simulation_data,GUI_handles.aggregate_results_GUI);

cell_throughputs_Mbps = zeros(1,length(simulation_data.the_eNodeB_traces));
for b_=1:length(simulation_data.the_eNodeB_traces)
    cell_throughputs_Mbps(b_) = sum(simulation_data.the_eNodeB_traces(b_).acknowledged_data(:))/1e6/(simulation_data.LTE_config.simulation_time_tti*simulation_data.LTE_config.TTI_length);
end
fprintf('Cell throughput\n');
cell_throughputs_Mbps_by_ids = zeros(2,size(mapping.trace2sim,1));
for id=1:size(mapping.trace2sim,1)
    idx = mapping.trace2sim(id,2);
    if idx>length(cell_throughputs_Mbps) || idx<1
        the_throughput = 0;
    else
        the_throughput = cell_throughputs_Mbps(idx);
    end
    fprintf('  -Cell %d: %.1fMb/s\n',id,the_throughput);
    cell_throughputs_Mbps_by_ids(1,id) = id;
    cell_throughputs_Mbps_by_ids(2,id) = the_throughput;
end

% Save cell throughput for post-processing
cell_throughputs_Mbps = cell_throughputs_Mbps_by_ids;
save(sprintf('cell_throughputs_Mbps_%d_steps_fullbuffer',LTE_config.simulation_time_tti/LTE_config.TTI_per_trace_step),...
    'cell_throughputs_Mbps');
UE_throughput_Mbps = [simulation_data.the_UE_traces.average_throughput_Mbps];
save(sprintf('UE_throughputs_Mbps_%d_steps_fullbuffer',LTE_config.simulation_time_tti/LTE_config.TTI_per_trace_step),...
    'UE_throughput_Mbps');


% save UE throughput TTI

% UE_searched = 133;
% UE_id_sim   = mapping.trace2sim(UE_searched,2);
% for u_=1:length(UE_traces)
%     if ~isempty(find(UE_traces(u_).attached_cell(2)==mapping.trace2sim(133,2), 1))
%         fprintf('UE %d, trace UE %d\n',u_,UE_traces(u_).trace_id);
%     end
% end