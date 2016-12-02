for a = 1:MaxFileNumber;

    tic

    VariableIndex = num2str(a);
%    eval(['FaradaicStDev',VariableIndex,'= transpose(FaradaicStDev',VariableIndex,');']);
    eval(['TotalStDev',VariableIndex,'= transpose(TotalStDev',VariableIndex,');']);
    clear VariableIndex;

    toc

end
