function possiablePaths = allPaths(Graph, partialPath, destination)
% The original version of this function was found in http://www.ilovematlab.cn/thread-212175-1-1.html
% we really appreciate its author.

pathLength = length(partialPath);
lastNode = partialPath(pathLength); %get the last node
nextNodes = find(0<Graph(lastNode,:) & Graph(lastNode,:)<inf); %get the next node of the last node of Graph
GLength = length(Graph);
possiablePaths = [];
if lastNode == destination
    possiablePaths = partialPath;
    return;
elseif length( find( partialPath == destination ) ) ~= 0
    return;
end

for i=1:length(nextNodes)
    if destination == nextNodes(i)
        %path output
        tmpPath = cat(2, partialPath, destination);   
        possiablePaths( length(possiablePaths) + 1 , : ) = tmpPath;
        nextNodes(i) = 0;
    elseif length( find( partialPath == nextNodes(i) ) ) ~= 0
        nextNodes(i) = 0;
    end
end
nextNodes = nextNodes(nextNodes ~= 0);
for i=1:length(nextNodes)
    tmpPath = cat(2, partialPath, nextNodes(i));
    tmpPsbPaths = allPaths(Graph, tmpPath, destination);
    possiablePaths = cat(1, possiablePaths, tmpPsbPaths);
end