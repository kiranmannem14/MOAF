function eNodeBs_to_compute = LTE_init_determine_eNodeBs_to_compute(LTE_config, eNodeBs)
% Determine the eNodeBs in which users are computed in the simulations
% In a stochastic network, the eNodeB positions are unknown in the
% beginning.
% (c) Martin Taranetz, ITC, 2012

% 1-Ring Hexgrid Scenario
if LTE_config.nr_eNodeB_rings == 1
    
    center_macro_index = [13 14 15];
    if isfield(LTE_config, 'femtocells_config')
        first_center_femto_index = 22 + LTE_config.femtocells_config.femtos_per_cell * 12;
        last_center_femto_index  = first_center_femto_index + 3 * LTE_config.femtocells_config.femtos_per_cell - 1;
        if last_center_femto_index > first_center_femto_index
            eNodeBs_to_compute = [center_macro_index first_center_femto_index:last_center_femto_index];
        else
            eNodeBs_to_compute = center_macro_index;
        end
    else
        if strcmp(LTE_config.antenna.antenna_gain_pattern, 'omnidirectional')
            eNodeBs_to_compute = 5;
        else
            eNodeBs_to_compute = center_macro_index;
        end
    end
    
% 2-Rings Hexgrid Scenario    
elseif LTE_config.nr_eNodeB_rings == 2
    center_macro_index = [31 32 33];
    if isfield(LTE_config, 'femtocells_config')
        first_center_femto_index = 58 + LTE_config.femtocells_config.femtos_per_cell * 30;
        last_center_femto_index  = first_center_femto_index + 3 * LTE_config.femtocells_config.femtos_per_cell - 1;
        if last_center_femto_index > first_center_femto_index
            eNodeBs_to_compute = [center_macro_index first_center_femto_index:last_center_femto_index];
        else
            eNodeBs_to_compute = center_macro_index;
        end
    else
        eNodeBs_to_compute = center_macro_index;
    end
    
% Distance-based fallback solution
else 
    inclusion_radius                   = 1/2*LTE_config.inter_eNodeB_distance*LTE_config.compute_only_center_users;
    eNodeB_sites_positions             = reshape([eNodeBs.pos]',2,[])'; 
    eNodeB_sites_distances_from_origin = sqrt(eNodeB_sites_positions(:,1).^2 + eNodeB_sites_positions(:,2).^2);
    eNodeB_sites_to_compute_idxs       = eNodeB_sites_distances_from_origin < inclusion_radius;
    % Check whether there are eNodeBs within the inclusion region.
    if sum(eNodeB_sites_to_compute_idxs > 0)
        eNodeB_sectors_to_compute = [eNodeBs(eNodeB_sites_to_compute_idxs).sectors];
    else
        % if no eNodeBs inside the conclusion region -> take all eNodeBs
        eNodeB_sectors_to_compute = [eNodeBs.sectors];
    end
    eNodeBs_to_compute = [eNodeB_sectors_to_compute.eNodeB_id];
end

