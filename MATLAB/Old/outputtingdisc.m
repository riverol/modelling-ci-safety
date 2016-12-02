Faradaic = padcat(tdv1a100, dv1a100, tdv1a300, dv1a300, tdv1a400, dv1a400, tdv1c100, dv1c100, tdv1c300, dv1c300, tdv1c400, dv1c400, tdv2a100, dv2a100, tdv2a300, dv2a300, tdv2a400, dv2a400, tdv2c100, dv2c100, tdv2c300, dv2c300, tdv2c400, dv2c400); 

dlmwrite('Faradaic.csv',Faradaic,'delimiter',',','precision',16);