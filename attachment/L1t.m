clear;clc;

%% init
pc = [30, 0, 0];
phi = 45/57.3;
V = 10;
dt = 0.001;
N = 12/dt;
P = zeros(N,3);
ETA = zeros(N,2);
L1 = 10;
R = 10;
center = [0,0,0];


as = 0;
e1 = [0,1,0];

for i = 1:N
%% direct
%     eV = [cos(phi), sin(phi), 0];
    
%     a1 = cross(pc,e1);
%     a2 = cross(eV, e1);
%     eta1 = asin(sat(a1(3)/L1,-0.707,0.707));
%     eta2 = asin(sat(a2(3),-1,1));
%     ETA(i,:) = [eta1, eta2];
%     eta = eta1 + eta2;
%     as = 2*V*V/L1*sin(eta);
%     
% % px4:    
% %     xtrack_vel = cross(eV,e1).*V;
% % 	ltrack_vel = eV*e1'*V;
% % 	eta2 = atan2(xtrack_vel(3), ltrack_vel);
% % 	xtrackErr = cross(pc,e1);
% % 	sine_eta1 = xtrackErr(3) / L1;
% % 	sine_eta1 = sat(sine_eta1, -0.7071, 0.7071);
% % 	eta1 = asin(sine_eta1);
% % 	eta = eta1 + eta2;
% %     eta = sat(eta, -pi/2, pi/2);
% % 	as = 2*V*V/L1*sin(eta);
% %     ETA(i,:) = [eta1, eta2];

    % circle-only
    eV = [cos(phi), sin(phi), 0];
    d = pc(1);
    R = inf;
    kd = 1;kv = 5;
    L1x = (L1^2 - R^2 + (d+R)^2)/2/(d+R);
    eta1 = sat(acos(L1x/L1),0,pi/2);
    eta = acos(eV*e1');
    sg = cross(eV,e1);
    sig = sign(sign(sg(3))+0.1);
    as = V*V/R*sig + kv * (kd*sat(d,-5,5) + sig*V*sin(eta));
%     as = V*V/R*sig + kv * (kd*sat(d,-10,10) + sig*V*sin(eta));

    as = sat(as, -9.8*sin(45/57.3), 9.8*sin(45/57.3));
%% circle

%     % 2circle
%     eV = [cos(phi), sin(phi), 0];
%     d = norm(pc - center) - R;
%     e1 = (center - pc)./norm(center-pc);
%     if (d >= L1) 
% %         eta1 = asin((0.8*L1+R)/(d+R));
%         eta1 = asin((0*L1+R)/(d+R));
%         eta = acos(eV*e1');
%         sg = cross(eV,e1);
%         as = 2*V*V/L1*sin((eta-eta1)*sign(sign(sg(3))+0.1));
%     else
%         L1x = (L1^2 - R^2 + (d+R)^2)/2/(d+R);
%         eta1 = sat(acos(L1x/L1),0,pi/2);
%         eta = acos(eV*e1');
%         sg = cross(eV,e1);
%         as = 2*V*V/L1*sin(((eta-eta1)*sign(sign(sg(3))+0.1)));
%     end

    % circle-only
%     eV = [cos(phi), sin(phi), 0];
%     d = norm(pc - center) - R;
%     e1 = (center - pc)./norm(center-pc);
%     
%     kd = 1;kv = 2;
%     L1x = (L1^2 - R^2 + (d+R)^2)/2/(d+R);
%     eta1 = sat(acos(L1x/L1),0,pi/2);
%     eta = acos(eV*e1');
%     sg = cross(eV,e1);
%     sig = sign(sign(sg(3))+0.1);
%     as = V*V/R*sig + sig*kv * (kd*d - V*cos(eta));
%     
%     
%     
%     %
% %     kd = 0.5;
% %     kv = 0.5;
% %     
% %     d = norm(pc - center) - R;
% %     dunit = (pc-center)./norm(pc-center);
% %     v = eV*dunit';
% %     
% %     a1 = V*V/R;
% %     a2 = kd*d+kv*v;
% %     as = a1 + kd * d + kv * v;
%     
% %     d = norm(pc - center) - R;
% %     eta1 = d/L1;
% % %     eta2 = pi/2 - acos((pc-center)*eV');
% %     a0 = (pc - center)./norm(pc - center);
% %     a1 = asin(sat(cross(a0,eV),-1,1));
% %     eta2 = (sign(a1(3))*pi/2 - a1(3)); 
% %     eta3 = L1/2/R;
% %     
% %     eta = eta1 + eta2 + eta3;
% %     as = 2*V*V/L1*sin(eta);
% %     ETA(i,:) = [eta1, eta2];
%     
% %     %px4
% %     dr = 1;
% %     omega = (2 * pi / 25);
% % 	K_crosstrack = omega * omega;
% % 	K_velocity = 2.0 * 0.7 * omega;
% %     ep = (pc - center)./norm(pc - center);
% %     
% %     aa = cross(ep, eV).*V;
% %     xtrack_vel_center = aa(3);
% %     ltrack_vel_center = - (eV * ep').*V;
% % 	xtrack_vel_circle = -ltrack_vel_center;
% % 	xtrack_err_circle = norm(ep) - R;
% % 
% % 	lateral_accel_sp_circle_pd = (xtrack_err_circle * K_crosstrack + xtrack_vel_circle * K_velocity);
% % 
% % 	tangent_vel = xtrack_vel_center * dr;
% % 
% % 	if (tangent_vel < 0)
% % 		lateral_accel_sp_circle_pd = max([lateral_accel_sp_circle_pd , 0]);
% %     end
% % 	lateral_accel_sp_circle_centripetal = tangent_vel * tangent_vel / max([(0.5 * R) , (R + xtrack_err_circle)]);
% % 
% % 	as = dr * (lateral_accel_sp_circle_pd + lateral_accel_sp_circle_centripetal);




%%
%     dphi = sat(as/V*dt, -0.02/57.3, 0.02/57.3);
    dphi = sat(as/V*dt, -0.2/57.3, 0.2/57.3);
%     dphi = as/V*dt;
    phi = phi + dphi;
    pc = pc + V*dt.*[cos(phi), sin(phi), 0];
    P(i,:) = [pc(1:2),phi];
    

end

plot(P(:,2),P(:,1),'linewidth',2)
grid on;
axis equal;

% load a.mat;
% hold on;
% plot(P(:,2),P(:,1),'linewidth',2)
% 
% legend('sat=5','sat=10')

% hold on;
% theta = [0:0.1:360]./57.3;
% R = 10;
% x1 = R*cos(theta);
% y1 = R*sin(theta);
% % plot(y1-10*0.707+1.8,x1+10*0.707+0.64,'-.b');
% % plot(y1,x1+10,'-.b');
% plot(y1-10*0.707+2.184,x1+10*0.707+1,'-.b');
% plot([-10*0.707+2.184 30],[10*0.707+1 30],'bo');
