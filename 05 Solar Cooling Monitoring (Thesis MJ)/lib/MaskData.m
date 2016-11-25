function MaskData = MaskData(ArrayIn)

%ArrayIn = Hot.Temp.In

load StartEnd

Temp = [];

for i = 1:length(StartEnd(1,:))

    % Read in the start and end times for the day
    Start = StartEnd(1,i);
    End = StartEnd(2,i);

    % Return the corresponding index number
    StartIndx = find(Date>=Start);
    StartIndx = StartIndx(1);
    EndIndx = find(Date>=End);
    EndIndx = EndIndx(1);
    
    Temp = [Temp; ArrayIn(StartIndx:EndIndx)];
    
end

MaskData = Temp;