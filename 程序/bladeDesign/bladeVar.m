function [ blade ] = bladeVar(line)
inputParameter = load('designData.txt');

blade.radius = inputParameter(line,1);
blade.span = inputParameter(line,2);
blade.thick = inputParameter(line,3);
blade.thick_root = inputParameter(line,4);
aspect_ratio = inputParameter(line,5); % 展弦比
thick_ratio1 = inputParameter(line,6); %ttr = th_tip/th_root
thick_ratio2 = inputParameter(line,7); %tr = th_edge/th_root

blade.theta_lead = inputParameter(line,8);
blade.theta_trail = inputParameter(line,9);
blade.phi = inputParameter(line,10);
blade.beta_root = inputParameter(line,11);
blade.beta_tip = inputParameter(line,12); 
blade.miu = inputParameter(line,13); 
blade.lamda = inputParameter(line,14); 
blade.zeta_root = inputParameter(line,15); 
blade.zeta_tip = inputParameter(line,16); 

blade.theta_lead = deg2rad(blade.theta_lead);
blade.theta_trail = deg2rad(blade.theta_trail);
blade.phi = deg2rad(blade.phi);
blade.beta_root = deg2rad(blade.beta_root);
blade.beta_tip = deg2rad(blade.beta_tip);
blade.miu = deg2rad(blade.miu);
blade.lamda = deg2rad(blade.lamda);
blade.zeta_root = deg2rad(blade.zeta_root);
blade.zeta_tip = deg2rad(blade.zeta_tip);

blade.chord = blade.span/aspect_ratio;
blade.thick_tip = thick_ratio1*blade.thick;
blade.thick_edge = thick_ratio2*blade.thick;
