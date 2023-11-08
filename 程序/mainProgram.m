clc; clear;
origin_folder = cd;

for id = 102:121
    test_save_folder  = ['test_', num2str(id-1)];
    blade_save_folder = ['test_', num2str(id-1),'/blade'];
    casing_save_folder = ['test_', num2str(id-1),'/casing'];
    result_save_folder = ['test_', num2str(id-1),'/result'];
    
    mkdir(test_save_folder)
    mkdir(blade_save_folder)
    mkdir(casing_save_folder)
    mkdir(result_save_folder)
    
    mkdir([result_save_folder,'/different rpm'])
    mkdir([result_save_folder,'/different rpm/abradableProfile'])
    mkdir([result_save_folder,'/different rpm/abradepth'])
    mkdir([result_save_folder,'/different rpm/blade'])
    mkdir([result_save_folder,'/different rpm/bladeForStress'])
    mkdir([result_save_folder,'/different rpm/casing'])
    mkdir([result_save_folder,'/different rpm/depth'])
    mkdir([result_save_folder,'/different rpm/penetrationforce'])
    mkdir([result_save_folder,'/different rpm/strainEnergy'])
    mkdir([result_save_folder,'/different rpm/velocity'])
    
    mkdir([result_save_folder,'/parameter'])
    mkdir([result_save_folder,'/parameter/abradableProfile'])
    mkdir([result_save_folder,'/parameter/blade'])
    mkdir([result_save_folder,'/parameter/depth'])
    mkdir([result_save_folder,'/parameter/fft'])
    mkdir([result_save_folder,'/parameter/strainEnergy'])
    
    copyfile('bladeTipRub_0.6mm_20200724.exe',test_save_folder)
    
    cd('bladeDesign')
    bladeDesignMain(id)
    casingNode(id)
    cd(origin_folder)
    
    cd('callAnsys')
    callAnsysMain
    txtModify
    cd(origin_folder)
    
    cd('modalReduce')
    modalReduceMain
    txtMove(id)
    cd(origin_folder)
    
%     command = [test_save_folder,'/bladeTipRub_0.6mm_20200724.exe'];
%     open(command)

end

