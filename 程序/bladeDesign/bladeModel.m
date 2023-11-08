function [theta_modify, rho_modify, z_modify] = bladeModel(theta_initial, rho_initial, z_initial, blade)
% 在柱坐标系下叠加叶片造型参数，涉及到面外的造型保持柱坐标系中的rho不变
% 只有内外流道线会对面内产生影响，theta叠加的过程中需要考虑扭转导致的偏转

% twist
beta = (blade.beta_tip-blade.beta_root)/blade.span*(rho_initial-blade.radius)+blade.beta_root;
z_twist=cos(beta);
theta_twist=asin(z_initial*sin(beta)/rho_initial);

% lean
theta_lean = asin((rho_initial-blade.radius)*sin(blade.miu)*cos(beta)/rho_initial);

% sweep
z_sweep=(rho_initial-blade.radius)*tan(blade.lamda);

% flow path angle
flowPathInner = (z_initial+blade.chord/2)*tan(blade.phi);
flowPathOuter = (blade.theta_trail-blade.theta_lead)/(2*blade.chord)*z_initial^2+...
    (blade.theta_lead+blade.theta_trail)/2*z_initial+...
    (3*blade.theta_lead+blade.theta_trail)/8*blade.chord;
% flowPathOuter = (z_initial+blade.chord/2)*tan(blade.theta);
rho_angle=blade.radius+flowPathInner+(rho_initial-blade.radius)/blade.span*(blade.span-flowPathInner-flowPathOuter);

% camber
zeta = (blade.zeta_tip-blade.zeta_root)/blade.span*(rho_initial-blade.radius)+blade.zeta_root;
theta_camber = asin(tan(zeta)*cos(beta)*(blade.chord/2-2/blade.chord*z_initial^2)/rho_initial);
z_camber = blade.camber/blade.chord;

% blade model
rho_modify = rho_angle;
z_modify = (z_initial-z_sweep)*z_twist*z_camber;
theta_modify = theta_initial+theta_twist+theta_lean+theta_camber;

end

