Faradaic = padcat(t1a100, f1a100, t1a300, f1a300, t1a400, f1a400, t1c100, f1c100, t1c300, f1c300, t1c400, f1c400, t2a100, f2a100, t2a300, f2a300, t2a400, f2a400, t2c100, f2c100, t2c300, f2c300, t2c400, f2c400); 

dlmwrite('Faradaic.csv',Faradaic,'delimiter',',','precision',16);