%% 
% Diameter of the array is 0.5mm.
% Length of electrode is either 0.1mm, 0.3mm, 0.4mm in accordance with
% the technical drawings of CI422 array.

d_arr = 0.5e-3;

[e_leng] = 1e-3*[0.1 0.3 0.4];

%% 

% Geometric area of electrode is determined considering a hemi-cylindrical
% surface.
% For 0.1mm, area is 0.0785mm2.
% For 0.3mm, area is 0.2356mm2.
% For 0.4mm, area is 0.3142mm2.
% 
% From this, we can determine the average current density, which is the 
% current pulse amplitude divided by the geometrical area. 

g_area = 0.5*pi*d_arr*e_leng;
[current_amplitude] = [1.5 1.5 1.5]*1e-3;
j_average = [current_amplitude]./[g_area];

%% 

% Multiply by 4 to determine total current from symmetrical model.

% f1a100=4*f1a100;
% f1a300=4*f1a300;
% f1a400=4*f1a400;
% f1c100=4*f1c100;
% f1c300=4*f1c300;
% f1c400=4*f1c400;
% f2a100=4*f2a100;
% f2a300=4*f2a300;
% f2a400=4*f2a400;
% f2c100=4*f2c100;
% f2c300=4*f2c300;
% f2c400=4*f2c400;

d1a100f=4*d1a100f;
d1a300f=4*d1a300f;
d1a400f=4*d1a400f;
d1c100f=4*d1c100f;
d1c300f=4*d1c300f;
d1c400f=4*d1c400f;
d2a100f=4*d2a100f;
d2a300f=4*d2a300f;
d2a400f=4*d2a400f;
d2c100f=4*d2c100f;
d2c300f=4*d2c300f;
d2c400f=4*d2c400f;

%% 

form = 1;

% [sd1,sdf1a100,sdnf1,sdtot1] = stdeviation(n1a100,form,j_average(1),t1a100);
% [sd1,sdf1a300,sdnf1,sdtot1] = stdeviation(n1a300,form,j_average(2),t1a300);
% [sd1,sdf1a400,sdnf1,sdtot1] = stdeviation(n1a400,form,j_average(3),t1a400);
% [sd1,sdf1c100,sdnf1,sdtot1] = stdeviation(n1c100,form,j_average(1),t1c100);
% [sd1,sdf1c300,sdnf1,sdtot1] = stdeviation(n1c300,form,j_average(2),t1c300);
% [sd1,sdf1c400,sdnf1,sdtot1] = stdeviation(n1c400,form,j_average(3),t1c400);
% [sd1,sdf2a100,sdnf1,sdtot1] = stdeviation(n2a100,form,j_average(1),t2a100);
% [sd1,sdf2a300,sdnf1,sdtot1] = stdeviation(n2a300,form,j_average(2),t2a300);
% [sd1,sdf2a400,sdnf1,sdtot1] = stdeviation(n2a400,form,j_average(3),t2a400);
% [sd1,sdf2c100,sdnf1,sdtot1] = stdeviation(n2c100,form,j_average(1),t2c100);
% [sd1,sdf2c300,sdnf1,sdtot1] = stdeviation(n2c300,form,j_average(2),t2c300);
% [sd1,sdf2c400,sdnf1,sdtot1] = stdeviation(n2c400,form,j_average(3),t2c400);

[sd1,disc_sdf1c300,sdnf1,sdtot1] = stdeviation(ndisc_1c300,form,j_average(2),td1c300);
[sd1,disc_sdf1a300,sdnf1,sdtot1] = stdeviation(ndisc_1a300,form,j_average(2),td1a300);
[sd1,disc_sdf2a300,sdnf1,sdtot1] = stdeviation(ndisc_2a300,form,j_average(2),td2a300);
[sd1,disc_sdf2c300,sdnf1,sdtot1] = stdeviation(ndisc_2c300,form,j_average(2),td2c300);


