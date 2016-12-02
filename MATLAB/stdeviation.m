function [sd1,sdf1,sdnf1,sdtot1] = stdeviation(j1,form,j_tot_average,j_irr_average,t)
% This is the function that helps calculate the standard deviations
% for each time step in a model.
% The 'form' variable defines what 'j1' looks like.
% When: 
% 'form' = 1: The first three columns are the x,y,z co-ordinate data with only faradaic data export.
% 'form' = 2: The first three columns are the x,y,z co-ordinate data with all three data export.
% 'form' = 3: The first three columns are the x,y,z co-ordinate data with two data export, total and faradaic.
%
% j_average is the average current density, or the current density that we
% would assume if the electrode distribution was uniform. This is constant
% for the total current density, because of the constant current source
% used for stimulation. However, for irreversible current density, the
% j_average changes over time as I_irr changes over time.


if form == 1;
	
	for j=1:1:length(t);

	sd1=std(j1,1,1)./j_tot_average;
	sdf1(j)=sd1(j+3);
	sdnf1=0;
	sdtot1=0;
	
	end 

elseif form == 2;

	for j=1:1:length(t);

	sd1=std(j1,1,1)./j_tot_average;
	sdf1(j)=sd1(3*j+1);
	sdnf1(j)=sd1(3*j+2);
	sdtot1(j)=sd1(3*j+3);
	
    end
    
elseif form == 3;
          
   	sd1=std(j1,1,1);
	sdf1=sd1(1,[5:2:size(sd1,2)])./j_irr_average';
	sdnf1=0;
	sdtot1=sd1(1,[4:2:size(sd1,2)])./j_tot_average; 
    
end
