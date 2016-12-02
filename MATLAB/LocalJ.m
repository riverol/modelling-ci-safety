clear;
clc;

%% Reading the data and organising the variables.

MaxFileNumber = input('What is the max file number? ');
EdgeNumbers = input('Write the edge numbers, like [...,...,...]');
NumberofEdges = length(EdgeNumbers);

for n = 1:NumberofEdges;
    for i = 1:MaxFileNumber;

        tic

        SolutionNumber = num2str(i);
        EdgeNumber = num2str(EdgeNumbers(n));

        Filename = strcat(EdgeNumber,'Edge',SolutionNumber,'.csv');
        VariableName = strcat('Edge',EdgeNumber,'Sol',SolutionNumber);
        NormalVariable = lineimport(Filename);
        eval([VariableName, ' = NormalVariable;']);
        clear NormalVariable;
        clear Filename;
        clear VariableName;

        clear SolutionNumber;
        clear EdgeNumber;

        toc

    end
end
%% Sorting all data with respect to the arc length, s1.

for m = 1:NumberofEdges;
    for j = 1:MaxFileNumber;
        tic    

        SolutionNumber = num2str(j);
        EdgeNumber = num2str(EdgeNumbers(m));

        VariableName = strcat('Edge',EdgeNumber,'Sol',SolutionNumber);
        eval([VariableName,' = sortrows(',VariableName,',4);']);

        clear VariableName;
        clear SolutionNumber;
        clear EdgeNumber;

        toc
    end
end

%% Extracting the correct current density values and discarding the redundant x,y,z. 

for o = 1:NumberofEdges;
    for k = 1:MaxFileNumber;

        SolutionNumber = num2str(k);
        EdgeNumber = num2str(EdgeNumbers(o));

        VariableName = strcat('Edge',EdgeNumber,'Sol',SolutionNumber);
        eval(['HBTotalJ',VariableName,' = ',VariableName,'(:,[5:3:size(',VariableName,',2)]);']);
        eval(['HBFaradaicJ',VariableName,' = ',VariableName,'(:,[6:3:size(',VariableName,',2)]);']);
        eval(['HBs1',VariableName,' =',VariableName,'(:,4);']);
        clear VariableName;

        clear SolutionNumber;
        clear EdgeNumber;

    end
end
%% Make headers for the csv data export.
% TimeVector is a little redundant here. Loop over edge number, solution number and then time. Using edge and solution numbers to create the variable names. Then initialise the DataHeader variables, which are strings that contain the names of the columns for the csv export.

TimeVector = (0:0.5:74.5)';

tic

for a = 1:NumberofEdges;

    for b = 1:MaxFileNumber;

        SolutionNumber = num2str(b);
        EdgeNumber = num2str(EdgeNumbers(a));

        TotalJFilename = strcat('HBTotalJEdge',EdgeNumber,'Sol',SolutionNumber);
        FaradaicJFilename = strcat('HBFaradaicJEdge',EdgeNumber,'Sol',SolutionNumber);
        S1Filename = strcat('HBs1Edge',EdgeNumber,'Sol',SolutionNumber);


        eval([TotalJFilename,'DataHeader = [];']);
        eval([FaradaicJFilename,'DataHeader = [];']);
        eval([S1Filename,'DataHeader = [];']);
        
        eval([S1Filename,'DataHeaderTemp = strcat(S1Filename);']);
        eval([S1Filename,'DataHeader = strcat(',S1Filename,'DataHeader, '','' ,',S1Filename,'DataHeaderTemp);']);

        for c = 0:0.5:74.5;
    
            TimeIndex = num2str(c);
            Time='Time';

            eval([TotalJFilename,'DataHeaderTemp = strcat(TotalJFilename,Time,TimeIndex);']);
            eval([TotalJFilename,'DataHeader = strcat(',TotalJFilename,'DataHeader, '','' ,',TotalJFilename,'DataHeaderTemp);']);
            
            eval([FaradaicJFilename,'DataHeaderTemp = strcat(FaradaicJFilename,Time,TimeIndex);']);
            eval([FaradaicJFilename,'DataHeader = strcat(',FaradaicJFilename,'DataHeader, '','' ,',FaradaicJFilename,'DataHeaderTemp);']);
       
        end

        eval([TotalJFilename,'DataHeader = ',TotalJFilename,'DataHeader(2:end);']);
        eval([FaradaicJFilename,'DataHeader = ',FaradaicJFilename,'DataHeader(2:end);']);
        eval([S1Filename,'DataHeader = ',S1Filename,'DataHeader(2:end);']);       

    end
end

toc

% Tic tocking because this may be a lengthy part of LocalJ.

%% Output the data in csv files. 
% Loop over edge numbers and then solution numbers. Use edge numbers and solution numbers to generate variable names and csv filenames. Open the csvs for writing and write the headers for each file, both TotalJ and FaradaicJ. Then write the actual variables to the csvs. Using eval when we need to use the variable names, because the functions do not expect string inputs for the variable names.

for d = 1:NumberofEdges;

    for e = 1:MaxFileNumber;
     
        SolutionNumber = num2str(e);
        EdgeNumber = num2str(EdgeNumbers(d));

        TotalJFilename = strcat('HBTotalJEdge',EdgeNumber,'Sol',SolutionNumber);
        FaradaicJFilename = strcat('HBFaradaicJEdge',EdgeNumber,'Sol',SolutionNumber);
        S1Filename = strcat('HBs1Edge',EdgeNumber,'Sol',SolutionNumber);

        TotalJFilenamecsv = strcat(TotalJFilename,'.csv');
        FaradaicJFilenamecsv = strcat(FaradaicJFilename,'.csv');
        S1Filenamecsv = strcat(S1Filename,'.csv');


        fid = fopen(TotalJFilenamecsv,'w');
        eval(['fprintf(fid,''%s  \r\n'',',TotalJFilename,'DataHeader);']);
        fclose(fid);

        fid = fopen(FaradaicJFilenamecsv,'w');
        eval(['fprintf(fid,''%s  \r\n'',',FaradaicJFilename,'DataHeader);']);
        fclose(fid);
        
        fid = fopen(S1Filenamecsv,'w');
        eval(['fprintf(fid,''%s  \r\n'',',S1Filename,'DataHeader);']);
        fclose(fid);

        eval(['dlmwrite(''',TotalJFilenamecsv,''',',TotalJFilename,',''delimiter'','','',''precision'',16,''-append'');']);
        eval(['dlmwrite(''',FaradaicJFilenamecsv,''',',FaradaicJFilename,',''delimiter'','','',''precision'',16,''-append'');']);
        eval(['dlmwrite(''',S1Filenamecsv,''',',S1Filename,',''delimiter'','','',''precision'',16,''-append'');']);

    end   
    
end
