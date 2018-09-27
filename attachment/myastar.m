mapOriginal=im2bw(imread('map1.bmp')); % input map read from a bmp file. for new maps write the file name here


% mapOriginal = [1 1 1 1 1 1;
%                1 0 1 1 0 0;
%                1 1 1 0 0 0;
%                1 0 1 0 0 0;
%                1 0 1 1 1 1;];
% resolutionX=100;
% resolutionY=100;
source=[10 10]; % source position in Y, X format
% goal=[490 490]; % goal position in Y, X format
goal=[392 423]; % goal position in Y, X format

% source=[1 1]; % source position in Y, X format
% % goal=[490 490]; % goal position in Y, X format
% goal=[5 6]; % goal position in Y, X format

si = size(mapOriginal);
X = si(1);
Y = si(2);

openSet = [getI(source, si)];
closedSet = [];

cameFrom = zeros(X*Y,1);

gScore = inf(X*Y,1);
gScore(getI(source,si),1) = 0;

fScore = inf(X*Y,1);
fScore(getI(source,si),1) = heuristic_cost_estimate(source, goal);

% neighborStep = [-1,0;
%                 1,0;
%                 0,-1;
%                 0,1];

neighborStep = [-1,0;
                1,0;
                0,-1;
                0,1;
                -1,-1;
                1,1;
                -1,1;
                1,-1];
dist = [1,1,1,1,1.5,1.5,1.5,1.5];
        
while(size(openSet)>0)
    [f,i] = min(fScore(openSet));
    ni = openSet(i,1);
    
    if (openSet(i) == getI(goal,si))
        path = getp(cameFrom, ni, si);
        break;
    end   
    
    closedSet = [closedSet; ni];
    openSet = openSet([1:i-1,i+1:end],1);
    
    neighbor = neighborStep + setI(ni,si);
       
    for xx=1:size(neighborStep,1)
        if (neighbor(xx,1)<1 || neighbor(xx,2)<1 || neighbor(xx,1)>X || neighbor(xx,2)>Y)
            continue;
        end
        
        xi = getI(neighbor(xx,:), si);
        
        if (mapOriginal(neighbor(xx,1), neighbor(xx,2)) == 0)
            continue;
        end
        
        if (~isempty(find(closedSet == xi)))
            continue;
        end
        
        if (isempty(find(openSet == xi)))
            openSet = [openSet;xi];
        end
        
        if (mapOriginal(neighbor(xx,1), neighbor(xx,2)) == 0)
            cameFrom(xi,1) = -1;
            gScore(xi,1) = inf;
            fScore(xi,1) = inf;
            continue;
        end
        
        tentative_gScore = gScore(ni) + dist(xx);
        if tentative_gScore >= gScore(xi)
            continue;
        end
        
        cameFrom(xi,1) = ni;
        gScore(xi,1) = tentative_gScore;
        fScore(xi,1) = gScore(xi,1) + heuristic_cost_estimate(setI(ni,si), goal);
    end
end
imshow(mapOriginal);
hold on;
plot(path(:,2), path(:,1), 'o');

% b = [1:30]';
% [b,cameFrom]
% [path]

function y = heuristic_cost_estimate(start, goal)
    y = norm(goal-start, 1);
end

function y = getI(x,size)
    y = (x(1)-1)*size(2) + x(2);
end

function y = setI(i,size)
    y(1) = floor((i-1)/size(2)) + 1;
    y(2) = mod(i-1, size(2)) + 1;
end

function y = getp(cameFrom, cur, si)
    y = [];
    while(cur>0)
        y = [y;setI(cur,si)];
        cur = cameFrom(cur,1);
    end    
    
end