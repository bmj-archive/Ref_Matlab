% datestr(DatedData(length(DatedData(:,1)),1) - DatedData(1,1) )
% N = datenum(Y, M, D, H, MN, S)
Start = datenum(2008, 6, 26, 8, 0, 0);
Start = find(DatedData(:,1)==Start);
End = datenum(2008, 6, 26, 17, 10, 0);
End = find(DatedData(:,1)==End); % Use specified ending
% End = length(DatedData(:,1)); % Or just use all the data
TimeMask = Start:End;


Start = datenum(2008, 6, 26, 15, 10, 0);
Start = find(DatedData(:,1)==Start);
End = datenum(2008, 6, 26, 15, 50, 0);
End = find(DatedData(:,1)==End); % Use specified ending
%End = length(DatedData(:,1)); % Or just use all the data
TimeMask2 = Start:End;

clear Start End