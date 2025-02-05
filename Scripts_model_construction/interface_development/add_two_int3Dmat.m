%% ADD two int3D structure and make a new one
% asif, Nov 2023

clear, close all 
clc

%% LOADING

% load station and event to check in the plot
load('/Users/asifashraf/Documents/MATLAB/Cascadia Analysis/Stingray_structures/srStation_13-Jul-2023_l2to3_g1to8_obsPD16to17rlc_pnsn.mat');
load('/Users/asifashraf/Documents/MATLAB/Cascadia Analysis/Stingray_structures/srEvent_20-Feb-2023_PD16to18_PS01Bsub1sub2_D1617.mat');

% load the two int_3Dmat structure
% these two interface structure has to be in the same x-y space
int1 = load('/Users/asifashraf/Documents/MATLAB/Cascadia Analysis/Initial_Model/output_int_and_UpCr_struc/int_3D_05-Nov-2023int3D_05-Nov-2023inversionApproved_actual.mat');
int2 = load('/Users/asifashraf/Documents/MATLAB/Cascadia Analysis/Initial_Model/output_int_and_UpCr_struc/int_3D_05-Nov-2023int3D_05-Nov-2023inversionApproved_DOWN_0.5to5.mat');

% pick a point to cut
figure(1), clf;
[xg, yg] = meshgrid(int1.int_3Dmat.xPos, int2.int_3Dmat.yPos);
plot(xg, yg)
hold on
plot(srStation.x, srStation.y, 'vr')
plot(srEvent.x, srEvent.y, '.r')
inp = ginput(1);

p = inp(2);

ind = find(abs(int1.int_3Dmat.yPos - p) == min(abs(int1.int_3Dmat.yPos - p)));

figure(2), clf
[xg, yg] = meshgrid(int2.int_3Dmat.xPos, int2.int_3Dmat.yPos(1:(ind-1)));
fb = int2.int_3Dmat.basement_elv((1:(ind-1)),:); % fb = first basement
plot3(xg, yg, fb)
grid on
hold on
[xx, yy] = meshgrid(int1.int_3Dmat.xPos, int1.int_3Dmat.yPos(ind:length(int1.int_3Dmat.yPos)));
lb = int1.int_3Dmat.basement_elv((ind:length(int1.int_3Dmat.yPos)),:);
plot3(xx, yy, lb, '-y')

final_basement = vertcat(fb,lb);

figure(3), clf
[xg, yg] = meshgrid(int1.int_3Dmat.xPos, int2.int_3Dmat.yPos);
plot3(xg, yg, final_basement);
grid on

%% structure development

clear int_3Dmat

int_3Dmat.xPos = int1.int_3Dmat.xPos;
int_3Dmat.yPos = int1.int_3Dmat.yPos;

fb = int2.int_3Dmat.basement((1:(ind-1)),:); % fb = first basement
lb = int1.int_3Dmat.basement((ind:length(int1.int_3Dmat.yPos)),:);
int_3Dmat.basement = vertcat(fb,lb);

fb = int2.int_3Dmat.basement_elv((1:(ind-1)),:); % fb = first basement
lb = int1.int_3Dmat.basement_elv((ind:length(int1.int_3Dmat.yPos)),:);
int_3Dmat.basement_elv = vertcat(fb,lb);

fb = int2.int_3Dmat.moho((1:(ind-1)),:); % fb = first basement
lb = int1.int_3Dmat.moho((ind:length(int1.int_3Dmat.yPos)),:);
int_3Dmat.moho = vertcat(fb,lb);

fb = int2.int_3Dmat.moho_elv((1:(ind-1)),:); % fb = first basement
lb = int1.int_3Dmat.moho_elv((ind:length(int1.int_3Dmat.yPos)),:);
int_3Dmat.moho_elv = vertcat(fb,lb);

int_3Dmat.elevation = int1.int_3Dmat.elevation;

figure(4), clf
[xg, yg] = meshgrid(int1.int_3Dmat.xPos, int2.int_3Dmat.yPos);
plot3(xg, yg, int_3Dmat.moho_elv, '-y');
hold on
plot3(xg, yg, int_3Dmat.moho, '-g');
grid on

figure(5), clf
plot3(xg, yg, int_3Dmat.basement_elv, '-g')
hold on
plot3(xg, yg, int_3Dmat.basement, '-y')
grid on
save('/Users/asifashraf/Documents/MATLAB/Cascadia Analysis/Initial_Model/InitialModel_development/interface_developement_scripts/int3Dmat_Nov5_add_dip0_dip1.mat', "int_3Dmat")

