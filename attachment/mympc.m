clc
clear

N = 20;
Ps = [0,0];
psi = -45/57.3;
V = 1;
X0 = [psi, Ps];
dt = 0.1;
u0 = zeros(N,1);

umax = ones(N,1)*2*pi/9;
umin = -ones(N,1)*2*pi/9;
dumax = ones(N,1)*5/57.3;

dA1 = diag(-ones(N,1)) + diag(ones(N-1,1),1); dA1(N,N) = 0;
dA2 = diag(ones(N,1)) - diag(ones(N-1,1),1); dA2(N,N) = 0;
A = [eye(N); -eye(N); 
    dA1;
    dA2
    ];
B = [umax; -umin;
    dumax;
    dumax
    ];

T = 100;
Y = zeros(T,3);
Y(1,:) = [psi, Ps];
center = [3,3]; 
obr = 1;
dobV = [0, 0.01].*0;
Yob = zeros(T,2);
for j=1:T
   j
   Yob(j,:) = center;
   uc = fmincon(@(x) myfun(x, Y(j,:), V, dt, N, pi/4, center, obr), u0, A, B);
   Y(j+1,:) = Y(j,:) + dt*[9.8*tan(uc(1))/V, V*cos(Y(j,1)), V*sin(Y(j,1))];
   u0 = [uc(2:end);uc(end)];
   center = center + dobV;
end

% x0 = X0;


% X = duav(V, X0, u0, dt, N)
theta = linspace(0,2*pi,100)';

plot(Y(:,3), Y(:,2), '-o')
hold on;
plot([0, Y(end,3)], [0, Y(end,3)], '-r*');
plot(Yob(1:5:end,2), Yob(1:5:end,1), '-ks');
for jj = 1:5:T
    ob = Yob(jj,:) + obr * [cos(theta), sin(theta)];
    plot(ob(:,2), ob(:,1), '-k');
end 
grid on;
axis equal;

% plot([0, Y(end,3)], [0, Y(end,3)], '-r*');
% hold on;
% for jj = 1:T
%     plot(Yob(jj,2), Yob(jj,1), 'ks');
%     ob = Yob(jj,:) + obr * [cos(theta), sin(theta)];
%     plot(ob(:,2), ob(:,1), '-k');
%     plot(Y(1:jj,3), Y(1:jj,2), '-o');
%     grid on;
%     axis equal;
%     pause();
% end



function X = duav(V, X0, u, dt, N)
X = zeros(N+1,3);
X(1,:) = X0;
for i = 2:N+1
    X(i,:) = X(i-1,:) + dt*[9.8*tan(u(i-1))/V, V*cos(X(i-1,1)), V*sin(X(i-1,1))];
end
end

function f = myfun(uc, X0, V, dt, N, theta0, center, obr)
XX = duav(V, X0, uc, dt, N);
X = XX(2:end,:);
w = [1;-1];
w = w./norm(w);

p_ob = X(:,2:3) - center;
dis_ob = sqrt(p_ob(:,1).^2 + p_ob(:,2).^2);
dis_ob = 1./sat(dis_ob,0,obr);
ff = sum(dis_ob) - N*obr;

pd = X(:,2:3) - [10,10];
dis_pd = sqrt(pd(:,1).^2 + pd(:,2).^2);
fd = sum(dis_pd);
f = sum(abs(X(:,2:3)*w)) + 0.5*sum(abs(X(:,1)-theta0)) + 30*ff + 0.5*fd;

end
