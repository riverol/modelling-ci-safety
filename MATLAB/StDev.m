%% This is the script that calculates the standard deviation csvs, which are then plotted in Igor.
% You can use the first parts of the script to automate the reading of a
% whole bunch of csv files that are numbered sequentially. 
% Custom functions used: jimport, stdeviation.
% Ensure these are in your path or folder.

clear;
clc;
%% Inputting the data and organising the variables.

ChargeDensities = [8,16,32,64];
Polarities = [1];
Areas = [0.0785,0.1571,0.2356,0.3142];
form = 3; % This is a requirement for stdeviation (Normal current densities includes Total and Faradaic
TimeVector = (0:0.5:74.5);

MaxFileNumber = input('What is the max file number? ');
VariablePrefix = 'Normal';

%% Reading in the Normal files, IrreversibleCurrent files.

for i = 1:MaxFileNumber;
    tic
    SolutionNumber = num2str(i);
    VariableName = strcat(VariablePrefix,SolutionNumber);
    Filename = strcat(VariablePrefix,SolutionNumber,'.csv');
    NormalVariable = jimport(Filename);
    eval([VariableName, '= NormalVariable;'])

    IrrFilename = strcat('FaradaicIntegration',SolutionNumber,'.csv');
    IrrVariableName = strcat('Iirr_',SolutionNumber);
    IrreversibleCurrent=fimport(IrrFilename);
    eval([IrrVariableName, '= IrreversibleCurrent;'])
    
    clear NormalVariable;
    clear SolutionNumber;
    clear IrreversibleCurrent;
    clear Filename;
    clear IrrFilename;
    clear IrreversibleCurrent;
    clear VariableName;

    toc 
end

%% Determining the Average Current Densities for each SolutionNumber

tic 

SolutionNumber = 1;

for j = 1:length(Areas);
    ElectrodeArea = Areas(j);
        for l = 1:length(ChargeDensities);
            ChargeDensity = ChargeDensities(l);
            AverageCurrentDensity(SolutionNumber) = 10000*ChargeDensity/75;
            ElectrodeAreas(SolutionNumber) = ElectrodeArea;
            SolutionNumber = SolutionNumber + 1;
        end
end

clear SolutionNumber;
clear ElectrodeArea;
clear Polarity;
clear CurrentAmplitude;

%% Sending the variables to the standard deviation calculation function, stdeviation

for m = 1:MaxFileNumber;
    
    SolutionNumber = num2str(m); 
    VariableName = strcat(VariablePrefix,SolutionNumber);
    IrrVariableName = strcat('Iirr_',SolutionNumber);
    JirrVariableName = strcat('Jirr_',SolutionNumber);
    
    eval([JirrVariableName,' = ',IrrVariableName,'./(1e-6*ElectrodeAreas(m));']);
    eval(['[StDev',SolutionNumber,',FaradaicStDev',SolutionNumber,',NotUsed',',TotalStDev',SolutionNumber,'] = stdeviation(',VariableName,',form,AverageCurrentDensity(',SolutionNumber,'),',JirrVariableName,',TimeVector);']);
    
    clear SolutionNumber;
    clear VariableName;
    clear IrrVariableName;
    clear JirrVariableName;
    
end

%% Transposing the standard deviation results.

TimeVector = TimeVector';

for a = 1:MaxFileNumber;

    tic

    VariableIndex = num2str(a);
    eval(['FaradaicStDev',VariableIndex,'= transpose(abs(FaradaicStDev',VariableIndex,'));']);
    eval(['TotalStDev',VariableIndex,'= transpose(abs(TotalStDev',VariableIndex,'));']);
    clear VariableIndex;

    toc

end

%% Preparing the TotalStDev data for export. Contents of following code is in outputtingsd.m

TotalStDevDataHeader = 'TimeVector';
JirrDataHeader = 'TimeVector';

for b = 1:MaxFileNumber;

    VariableIndex = num2str(b);
    VariableName = strcat(VariablePrefix,VariableIndex);    

    JirrVariableName = strcat('Jirr_',VariableIndex);
    JirrDataHeader = strcat(JirrDataHeader,',',JirrVariableName);

    TotalStDevDataHeaderTemp = strcat('TotalStDev',VariableIndex);
    TotalStDevDataHeader = strcat(TotalStDevDataHeader,',',TotalStDevDataHeaderTemp);

end

% TotalStDevDataHeader now contains all the variable names of the data that are
% required to be put into TotalStDevData
eval(['TotalStDevData = cat(2,',TotalStDevDataHeader,');']);
eval(['JirrData = cat(2,',JirrDataHeader,');']);

fid = fopen('TotalStDevData.csv','w');
fprintf(fid,'%s  \r\n',TotalStDevDataHeader);
fclose(fid);

fid = fopen('JirrData.csv','w');
fprintf(fid,'%s  \r\n',JirrDataHeader);
fclose(fid);


dlmwrite('TotalStDevData.csv',TotalStDevData,'delimiter',',','precision',16,'-append');
dlmwrite('JirrData.csv',JirrData,'delimiter',',','precision',16,'-append');

%% Preparing the FaradaicStDev data for export. Contents of following code is in outputtingsd.m

FaradaicStDevDataHeader = 'TimeVector';

for b = 1:MaxFileNumber;

    VariableIndex = num2str(b);
    FaradaicStDevDataHeaderTemp = strcat('FaradaicStDev',VariableIndex);
    FaradaicStDevDataHeader = strcat(FaradaicStDevDataHeader,',',FaradaicStDevDataHeaderTemp);

end

eval(['FaradaicStDevData = cat(2,',FaradaicStDevDataHeader,');']);

fid = fopen('FaradaicStDevData.csv','w');
fprintf(fid,'%s  \r\n',FaradaicStDevDataHeader);
fclose(fid);

dlmwrite('FaradaicStDevData.csv',FaradaicStDevData,'delimiter',',','precision',16,'-append');
