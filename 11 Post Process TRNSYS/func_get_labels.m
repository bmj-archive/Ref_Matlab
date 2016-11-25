function labels = func_get_labels(dataFrame,dataMask,legendDefinition)

headerRows = [];
for idxHead = 1:size(legendDefinition,2)
    desiredHead = legendDefinition{idxHead};
    % Get the row number of the desiredHead 
    for idxHeaderDef = 1:size(dataFrame.headerDef,1)
        thisHeaderDef = dataFrame.headerDef{idxHeaderDef,1};
        if ~isempty(regexp(desiredHead, thisHeaderDef, 'match'))
            %headerMask = thisHeaderDef;
            headerRows = [headerRows dataFrame.headerDef{idxHeaderDef,2}];
        end
    end
    % Found headerMask
    assert(logical(exist('headerRows','var')));
end

thisLegendMatrix = dataFrame.headers(headerRows,dataMask);

thisLegend = {};
for idxVar = 1:size(thisLegendMatrix,2)
    thisLegendEntry = thisLegendMatrix(:,idxVar);
    thisLegendString = '';
    for idxElement = 1:size(thisLegendEntry,1)
        thisLegendString = [thisLegendString ' ' thisLegendEntry{idxElement}];
    end
    thisLegend = [thisLegend thisLegendString];
end 

labels = thisLegend;