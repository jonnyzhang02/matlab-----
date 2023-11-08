function [ camber ] = bladeCamber( blade, rho_initial  )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    zeta = (blade.zeta_tip-blade.zeta_root)/blade.span*(rho_initial-blade.radius)+blade.zeta_root;
    fun1 = @(z)sqrt(1+(4/blade.chord*z*tan(zeta)).^2);
    fun2 = @(x)integral(fun1, -x/2, x/2)-blade.chord;
    camber = fsolve(fun2, blade.chord);

end

