%% This is the script that is used to calculate the DC from the irreversible current measurements from COMSOL. 
% You can use the first parts of the script to automate the reading of a
% whole bunch of csv files that are numbered sequentially. 
% Custom functions used: fimport.
% Ensure these are in your path or folder.

clear;
clc;
%% Inputting the data and organising the variables.

% The following variables are not needed because they don't vary in this set of analyses.

% ChargeDensity = [16];
% Polarities = [1];
% Areas = [0.2356];

Offsets = [0,1e-4,2e-4,3e-4,4e-4,5e-4,6e-4,7e-4];
STConds = [0.2,0.4,0.6,1.4];
TimeVector = (0:0.5:74.5)';
PulseWidth = max(TimeVector);

MaxFileNumber = input('What is the max file number? ');
VariablePrefix = 'FaradaicIntegration';

%% Reading in the IrreversibleCurrent files.

for i = 1:MaxFileNumber;
    tic
    SolutionNumber = num2str(i);
    VariableName = strcat(VariablePrefix,SolutionNumber);
    Filename = strcat(VariablePrefix,SolutionNumber,'.csv');

    IrrVariableName = strcat('Iirr_',SolutionNumber);
    IrreversibleCurrent=fimport(Filename);
    eval([IrrVariableName, '= IrreversibleCurrent;'])
    
    clear SolutionNumber;
    clear VariableName;
    clear Filename;    
    clear IrrVariableName;    
    clear IrreversibleCurrent;
    toc 
end

%% Build solution length vectors 

tic 

SolutionNumber = 1;

for j = 1:length(Offsets);
    Offset = Offsets(j);

    for k = 1:length(STConds);
        STCond = STConds(k);

        ElectrodeAreas(SolutionNumber) = 16;
        OffsetVector(SolutionNumber) = Offset;
        STCondVector(SolutionNumber) = STCond;

        SolutionNumber = SolutionNumber + 1;
    end
end

clear SolutionNumber;
clear ElectrodeArea;
clear Polarity;
clear CurrentAmplitude;

%% Calculating the DC values by integration 

for n = 1:MaxFileNumber;
    
    SolutionNumber = num2str(n); 
    VariableName = strcat(VariablePrefix,SolutionNumber);
    IrrVariableName = strcat('Iirr_',SolutionNumber);
    DCVariableName = strcat('DC_',SolutionNumber);
    DCDensityVariableName = strcat('DCDensity_',SolutionNumber);
    
    % Integrating under the irreversible current curve (trapz) and dividing by the pulse width.

    eval([DCVariableName,' = abs(trapz(',IrrVariableName,',(TimeVector*1e-6)));']);
    eval([DCDensityVariableName,' = ',DCVariableName,'/ElectrodeAreas(n);']);
    
    clear SolutionNumber;
    clear VariableName;
    clear IrrVariableName;
    clear JirrVariableName;
    
end

%% Setting up header for CSV file.

DCDataHeader = 'PulseWidth';
DCDensityDataHeader = 'PulseWidth';

for b = 1:MaxFileNumber;

    VariableIndex = num2str(b);
    VariableName = strcat(VariablePrefix,VariableIndex);    

    DCVariableName = strcat('DC_',VariableIndex);
    DCDataHeader = strcat(DCDataHeader,',',DCVariableName);

    DCDensityVariableName = strcat('DCDensity_',VariableIndex);
    DCDensityDataHeader = strcat(DCDensityDataHeader,',',DCDensityVariableName);

end

% DCDataHeader now contains all the variable names of the data that are
% required to be put into TotalStDevData

eval(['DCData = cat(2,',DCDataHeader,');']);
eval(['DCDensityData = cat(2,',DCDensityDataHeader,');']);

DCDataHeader = regexprep(DCDataHeader,',','\n');
DCDensityDataHeader = regexprep(DCDensityDataHeader,',','\n');

fid = fopen('DCData.csv','w');
fprintf(fid,'%s  \r\n',DCDataHeader);
fclose(fid);

fid = fopen('DCDensityData.csv','w');
fprintf(fid,'%s  \r\n',DCDensityDataHeader);
fclose(fid);

dlmwrite('DC.csv',DCData,'delimiter','\n','precision',16);
dlmwrite('DCDensity.csv',DCDensityData,'delimiter','\n','precision',16);
