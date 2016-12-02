%% This is the script that is used to calculate the DC from the irreversible current measurements from COMSOL. 
% You can use the first parts of the script to automate the reading of a
% whole bunch of csv files that are numbered sequentially. 
% Custom functions used: vimport.
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
VariablePrefix = 'Voltage';

%% Reading in the IrreversibleCurrent files.

for i = 1:MaxFileNumber;
    tic
    SolutionNumber = num2str(i);
    VariableName = strcat(VariablePrefix,SolutionNumber);
    Filename = strcat(VariablePrefix,SolutionNumber,'.csv');

    Voltage = vimport(Filename);
    eval([VariableName, '= Voltage;'])
    
    clear SolutionNumber;
    clear VariableName;
    clear Filename;    
    clear Voltage;
    toc 
end


tic 

SolutionNumber = 1;

%% Perform calculations for every Solution.

for m = 1:MaxFileNumber;
    
    SolutionNumber = num2str(m); 
    VariableName = strcat(VariablePrefix,SolutionNumber);
    PolarisationVariableName = strcat('Polarisation_',SolutionNumber);
    AccessVariableName = strcat('Access_',SolutionNumber);
    
    % Determining the access voltage and polarisation voltage by determining the maximum absolute voltage and subtracting from voltage at 1 microsecond (access voltage).

    eval([AccessVariableName,' = abs(',VariableName,'(2));']);    
    eval([PolarisationVariableName,' = max(abs(',VariableName,')) - ',AccessVariableName,';']);
    
    clear SolutionNumber;
    clear VariableName;
    clear PolarisationVariableName;
    clear AccessVariableName;
    
end

%% Setting up header for CSV file.

AccessDataHeader = 'PulseWidth';
PolarisationDataHeader = 'PulseWidth';

for b = 1:MaxFileNumber;

    VariableIndex = num2str(b);
    VariableName = strcat(VariablePrefix,VariableIndex);    

    AccessVariableName = strcat('Access_',VariableIndex);
    AccessDataHeader = strcat(AccessDataHeader,',',AccessVariableName);

    PolarisationVariableName = strcat('Polarisation_',VariableIndex);
    PolarisationDataHeader = strcat(PolarisationDataHeader,',',PolarisationVariableName);

end

% AccessDataHeader now contains all the variable names of the data.

eval(['AccessData = cat(2,',AccessDataHeader,');']);
eval(['PolarisationData = cat(2,',PolarisationDataHeader,');']);

AccessDataHeader = regexprep(AccessDataHeader,',','\n');
PolarisationDataHeader = regexprep(PolarisationDataHeader,',','\n');

fid = fopen('AccessData.csv','w');
fprintf(fid,'%s  \r\n',AccessDataHeader);
fclose(fid);

fid = fopen('PolarisationData.csv','w');
fprintf(fid,'%s  \r\n',PolarisationDataHeader);
fclose(fid);

dlmwrite('Access.csv',AccessData,'delimiter','\n','precision',16);
dlmwrite('Polarisation.csv',PolarisationData,'delimiter','\n','precision',16);
