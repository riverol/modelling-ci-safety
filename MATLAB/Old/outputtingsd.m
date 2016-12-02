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
