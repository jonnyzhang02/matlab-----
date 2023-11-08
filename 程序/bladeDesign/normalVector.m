function [gradient] = normalVector(blade)
syms rho theta z

beta = (blade.beta_tip-blade.beta_root)/blade.span*(rho-blade.radius)+blade.beta_root;
G.twist = asin(z*sin(beta)/rho);

G.lean = blade.miu-asin(blade.radius/rho*sin(blade.miu)); 

zeta = (blade.zeta_tip-blade.zeta_root)/blade.span*(rho-blade.radius)+blade.zeta_root;
G.camber = asin(tan(zeta)*(blade.chord/2-2/blade.chord*z^2)/rho);

G = G.twist+G.lean+G.camber;

gradient.rho = diff(G,rho);
gradient.theta = diff(G,theta)/rho;
gradient.z = diff(G,z);

