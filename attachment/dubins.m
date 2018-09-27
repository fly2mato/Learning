clc
clear
% rsl/lsr 可以优化一下计算过程


Pi = [0,0]; %initial pos.
Pf = [20,30]; %final pos.
psii = -50/57.3; %initial psi
psif = 0/57.3; %final psi.
rho = 5;
dt = 5/57.3; 

cri = Pi + rho * [-sin(psii), cos(psii)]; % right turn center of initial pos.
cli = Pi + rho * [sin(psii), -cos(psii)];

crf = Pf + rho * [-sin(psif), cos(psif)];
clf = Pf + rho * [sin(psif), -cos(psif)]; % left turn center of final pos.


pcir = cri + rho .* [cos([0:0.01:2*pi])', sin([0:0.01:2*pi])']; % four circle
pcfr = crf + rho .* [cos([0:0.01:2*pi])', sin([0:0.01:2*pi])'];
pcil = cli + rho .* [cos([0:0.01:2*pi])', sin([0:0.01:2*pi])'];
pcfl = clf + rho .* [cos([0:0.01:2*pi])', sin([0:0.01:2*pi])'];


%% rsr
ps_rr = -cri + crf; % vector of stright path
psi_s = atan2(ps_rr(2), ps_rr(1));
angle = -pi/2 + psi_s;

pis_r = cri + rho * [cos(angle), sin(angle)];
psf_r = crf + rho * [cos(angle), sin(angle)];

theta_i = 0:dt:mod(psi_s-psii,2*pi);
theta_f = 0:dt:mod(psif-psi_s,2*pi);

pic_r = cri + rho .* [cos(-pi/2+theta_i + psii)', sin(-pi/2+theta_i + psii)'];
pfc_r = crf + rho .* [cos(-pi/2+theta_f + psi_s)', sin(-pi/2+theta_f + psi_s)'];




%% lsl
ps_ll = -cli + clf; % vector of stright path
psi_s = atan2(ps_ll(2), ps_ll(1));
angle = -pi/2 + psi_s;

pis_l = cli + rho * [-cos(angle), -sin(angle)];
psf_l = clf + rho * [-cos(angle), -sin(angle)];

theta_i = 0:-dt:-mod(psii - psi_s,2*pi);
theta_f = 0:-dt:-mod(psi_s - psif,2*pi);

pic_l = cli + rho .* [-cos(-pi/2+theta_i + psii)', -sin(-pi/2+theta_i + psii)'];
pfc_l = clf + rho .* [-cos(-pi/2+theta_f + psi_s)', -sin(-pi/2+theta_f + psi_s)'];


%% rsl
ps_rl =  -cri + clf; % vector of stright path
dangle = asin(rho/norm(ps_rl)*2);
psi_s = atan2(ps_rl(2), ps_rl(1)) + dangle;
angle = -pi/2 + psi_s;

pis_r = cri + rho * [cos(angle), sin(angle)];
psf_l = clf + rho * [-cos(angle), -sin(angle)];

theta_i = 0:dt:mod(psi_s-psii,2*pi);
theta_f = 0:-dt:-mod(psi_s - psif,2*pi);

pic_r = cri + rho .* [cos(-pi/2+theta_i + psii)', sin(-pi/2+theta_i + psii)'];
pfc_l = clf + rho .* [-cos(-pi/2+theta_f + psi_s)', -sin(-pi/2+theta_f + psi_s)'];


%% lsr
ps_lr =  -cli + crf; % vector of stright path
dangle = asin(rho/norm(ps_lr)*2);
psi_s = atan2(ps_lr(2), ps_lr(1)) - dangle;
angle = -pi/2 + psi_s;

pis_l = cli + rho * [-cos(angle), -sin(angle)];
psf_r = crf + rho * [cos(angle), sin(angle)];

theta_i = 0:-dt:-mod(psii - psi_s,2*pi);
theta_f = 0:dt:mod(psif-psi_s,2*pi);

pic_l = cli + rho .* [-cos(-pi/2+theta_i + psii)', -sin(-pi/2+theta_i + psii)'];
pfc_r = crf + rho .* [cos(-pi/2+theta_f + psi_s)', sin(-pi/2+theta_f + psi_s)'];


%% plot
figure;hold on;grid on;
% rsr
% plot(cri(2), cri(1), 'bo');
% plot(crf(2), crf(1), 'bo');
% plot(pis_rr(2), pis_rr(1), 'k*');
% plot(psf_rr(2), psf_rr(1), 'k*');
% plot([pis_rr(2), psf_rr(2)], [pis_rr(1), psf_rr(1)], '-b','linewidth',2);
% plot(pic_rr(:,2), pic_rr(:,1), '-b','linewidth',2);
% plot(pfc_rr(:,2), pfc_rr(:,1), '-b','linewidth',2);

% lsl
% plot(cli(2), cli(1), 'bo');
% plot(clf(2), clf(1), 'bo');
% plot(pis_ll(2), pis_ll(1), 'k*');
% plot(psf_ll(2), psf_ll(1), 'k*');
% plot([pis_ll(2), psf_ll(2)], [pis_ll(1), psf_ll(1)], '-b','linewidth',2);
% plot(pic_ll(:,2), pic_ll(:,1), '-b','linewidth',2);
% plot(pfc_ll(:,2), pfc_ll(:,1), '-b','linewidth',2);

% rsl
% plot(cri(2), cri(1), 'bo');
% plot(clf(2), clf(1), 'bo');
% plot(pis_rr(2), pis_rr(1), 'k*');
% plot(psf_ll(2), psf_ll(1), 'k*');
% plot([pis_rr(2), psf_ll(2)], [pis_rr(1), psf_ll(1)], '-b','linewidth',2);
% plot(pic_rr(:,2), pic_rr(:,1), '-b','linewidth',2);
% plot(pfc_ll(:,2), pfc_ll(:,1), '-b','linewidth',2);

% lsr
plot(cli(2), cli(1), 'bo');
plot(crf(2), crf(1), 'bo');
plot(pis_l(2), pis_l(1), 'k*');
plot(psf_r(2), psf_r(1), 'k*');
plot([pis_l(2), psf_r(2)], [pis_l(1), psf_r(1)], '-b','linewidth',2);
plot(pic_l(:,2), pic_l(:,1), '-bo','linewidth',2);
plot(pfc_r(:,2), pfc_r(:,1), '-bo','linewidth',2);


plot(Pi(2), Pi(1), 'ro');
plot(Pf(2), Pf(1), 'ro');
quiver(Pi(2),Pi(1),rho*sin(psii),rho*cos(psii),'r','linewidth',2);
quiver(Pf(2),Pf(1),rho*sin(psif),rho*cos(psif),'r','linewidth',2);
plot(pcir(:,2), pcir(:,1), ':b','linewidth',2);
plot(pcfr(:,2), pcfr(:,1), ':b','linewidth',2);
plot(pcil(:,2), pcil(:,1), ':b','linewidth',2);
plot(pcfl(:,2), pcfl(:,1), ':b','linewidth',2);
axis equal;


