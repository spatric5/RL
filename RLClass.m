clear all; close all; clc;
format compact; format long g;

%Probability Matrix for Markov Reward Process
MRP_P = [0  .5 0  0  0  .5 0;
     0  0  .8 0  0  0  .2;
     0  0  0  .6 .4 0  0;
     0  0  0  0  0  0  1;
     .2 .4 .4 0  0  0  0;
     .1  0  0  0  0  .9 0;
     0  0  0  0  0  0  1];

%Labels for the columns and rows
names = ["Class1","Class2","Class3","Pass","Pub","FaceBook","Sleep"];

%Creates the Markov model
mc = dtmc(MRP_P,'StateNames',names);
figure; graphplot(mc,'ColorEdges',true);

%Reward Matrix for Markov Reward Process
MRP_R = [-2; -2; -2; 10; 1; -1; 0];

v0_0 = MRP_SilverEx(MRP_P,MRP_R,0);
v0_9 = MRP_SilverEx(MRP_P,MRP_R,.9);
v1_0 = MRP_SilverEx(MRP_P,MRP_R,.9999999);

MDP_P = [0  1  0  1 0;
         0  0  1  0 1;
         .2 .4 .4 0 1;
         1  0  0  1 0;
         0  0  0  0 1];
MDP_R = [0  -2 0  -1 0;
         0  0  -2 0  0;
         1 1 1  0  10;
         0  0  0  -1 0;
         0  0  0  0  0];
policy_pi = zeros(5,5)+.5;
[vMRP qMRP] = MDP_SilverEx(MDP_P,MDP_R,policy_pi,.99999);


P = zeros(5,5,9);
P(1,2,1) = 1; P(1,4,2) = 1; P(2,3,3) = 1; P(2,5,4) = 1;
P(3,1,5) = .2; P(3,2,5) = 0.4; P(3,3,5) = .4; P(3,5,6) = 1;
P(4,4,7) = 1; P(4,1,8) = 1; P(5,5,9) = 1;

P_pi = zeros(size(P,1),size(P,2));
R_sa = zeros(5,9);
R(1,1) = -2; R(1,2) = -1; R(2,3) = -2; R(2,4) = 0;
R(3,5) = 1; R(3,6) = 10; R(4,7) = -1; R(4,8) = 0; 
R(5,9) = 0;
for i = 1:size(P,3)
    P_pi = P_pi+.5*P(:,:,i);
end
R_pi = sum(R,2)*.5;
v_pi = (eye(size(R_pi,1))-.9999*P_pi)\R_pi;