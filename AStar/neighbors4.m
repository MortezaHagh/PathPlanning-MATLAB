function Neighbors = neighbors4(TopNode, Closed, Model)
    % expand a node and find feasible successors
    % nodeNumber pNode gCost fCost dir

    curentXY = Model.Nodes.cord(:, TopNode.nodeNumber);
    currentDir = TopNode.dir;
    currentX = curentXY(1);
    currentY = curentXY(2);

    % prioritize expanding based on direction or random
    dxy = [1 0; 0 1; 0 -1; -1 0];
    nodeHeading = deg2rad([0 90 270 180]);

    switch Model.expandMethod
        case 'heading'
            dTheta = angdiff(currentDir * ones(1, numel(nodeHeading)), nodeHeading);
            [~, sortInd] = sort(abs(dTheta));
            dxy = dxy(sortInd, :);
            nodeHeading = nodeHeading(sortInd);
        case 'random'
            randInd = randperm(numel(nodeHeading));
            dxy = dxy(randInd, :);
            nodeHeading = nodeHeading(randInd);
    end

    nNeighbors = 0;

    for iNeighbor = 1:4
        % new node
        ix = dxy(iNeighbor, 1);
        iy = dxy(iNeighbor, 2);
        newX = currentX + ix;
        newY = currentY + iy;
        newDir = nodeHeading(iNeighbor);

        % check if the new node is within limits
        if ((newX >= Model.Map.xMin && newX <= Model.Map.xMax) && ...
                (newY >= Model.Map.yMin && newY <= Model.Map.yMax))
            newNodeNumber = TopNode.nodeNumber + ix + (iy * (Model.Map.xMax - Model.Map.xMin + 1));

            % add newNode to list if it is not in Closed list
            if ~any(newNodeNumber == Closed.nodeNumber)
                nNeighbors = nNeighbors + 1;
                list(nNeighbors).visited = 0;
                list(nNeighbors).nodeNumber = newNodeNumber;
                list(nNeighbors).pNode = TopNode.nodeNumber;
                list(nNeighbors).gCost = TopNode.gCost + calDistance(currentX, currentY, newX, newY, Model.distType);
                hCost = calDistance(Model.Robot.xt, Model.Robot.yt, newX, newY, Model.distType);
                list(nNeighbors).fCost = list(nNeighbors).gCost + hCost;
                list(nNeighbors).dir = newDir;
            end

        end

    end

    % Neighbors
    Neighbors.count = nNeighbors;

    if nNeighbors ~= 0
        Neighbors.List = list;
    else
        Neighbors.List = [];
    end

end
