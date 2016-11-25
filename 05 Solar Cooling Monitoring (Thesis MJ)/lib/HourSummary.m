% This script averages out the data

Month = 7; % July
Day = 9; % Start of day

dminute = datenum(1, 1, 1, 1, 1, 0) -...
    datenum(1, 1, 1, 1, 0, 0);

% Start at 8am
Period = 10;
Start = datenum(2008, Month, Day, 7, 0, 0);
End = datenum(2008, Month, Day, 8, Period, 0);

% This is the time interval
dt = End - Start;

DayCol = 1;

HrRow = 1; % Set

TickNum = 1;

% Run to the 25th of July
for Day = 15

    
    for i = 0:1:23
        Hr.Ticks(TickNum,1) = datenum(2008, 7, Day, i, 0, 0);
        TickNum = TickNum + 1;
    end

    %     Hr.Ticks(TickNum+1,1) = datenum(2008, 7, Day, 12, 0, 0);
    %     Hr.Ticks(TickNum+2,1) = datenum(2008, 7, Day, 17, 0, 0);
    %    TickNum = TickNum + 3;

    %HrRow = 1;  % Reset row

    % Run from 7 am until 6 pm. # Periods = 660 mins / #mins/period

    for Interv = 1:660/Period

        Start = datenum(2008, Month, Day, 7, Interv*Period - Period, 0);
        End = datenum(2008, Month, Day, 8, Interv*Period, 0);

        Hr.DT(HrRow,DayCol) = Start + (End - Start)/2;


        %        Start = datenum(2008, Month, Day, Hour, 0, 0);
        %        Start = find(Date==Start); % Use specified start
        %        End = datenum(2008, Month, Day, Hour+1, 0, 0);
        %        End = find(Date==End); % Use specified ending
        %        OneHr = Start:End;

        StartIndx = find(Date>=Start);
        EndIndx = find(Date>=End);

        % Process air
        Hr.C.Air.Temp.In(HrRow,DayCol)...
            = Average(Air.Amb.Temp, 0, StartIndx(1), EndIndx(1));
        Hr.C.Air.Temp.Out(HrRow,DayCol)...
            = Average(Air.Proc.Temp, 0, StartIndx(1), EndIndx(1));
        Hr.C.Air.W.In(HrRow,DayCol)...
            = Average(Air.Amb.W, 0, StartIndx(1), EndIndx(1));
        Hr.C.Air.W.Out(HrRow,DayCol)...
            = Average(Air.Proc.W, 0, StartIndx(1), EndIndx(1));
        Hr.C.Air.dW(HrRow,DayCol)...
            = Average(Air.Amb.W - Air.Proc.W, ...
            0, StartIndx(1), EndIndx(1)); % [kg/kg]
        Hr.C.Air.H.In(HrRow,DayCol)...
            = Average(Air.Amb.H, 0, StartIndx(1), EndIndx(1));
        Hr.C.Air.H.Out(HrRow,DayCol)...
            = Average(Air.Proc.H, 0, StartIndx(1), EndIndx(1));

        % Cooling
        Hr.C.TC(HrRow,DayCol)...
            = Average(Perf.C.TC, 0, StartIndx(1), EndIndx(1));
        Hr.C.SC(HrRow,DayCol)...
            = Average(Perf.C.SC, 0, StartIndx(1), EndIndx(1));
        Hr.C.LC(HrRow,DayCol)...
            = Average(Perf.C.LC, 0, StartIndx(1), EndIndx(1));
        Hr.C.SHR(HrRow,DayCol)...
            = Average(Perf.C.SHR, 0, StartIndx(1), EndIndx(1));

        % CW
        Hr.C.CW.Temp.In(HrRow,DayCol)...
            = Average(Cold.Temp.In, 0, StartIndx(1), EndIndx(1)); % [C]
        Hr.C.CW.Temp.Out(HrRow,DayCol)...
            = Average(Cold.Temp.Out, 0, StartIndx(1), EndIndx(1)); % [C]
        Hr.C.CW.dE(HrRow,DayCol)...
            = Average(Enthalpy.Cond.CW.Out - Enthalpy.Cond.CW.In,...
            0, StartIndx(1), EndIndx(1)); % [kJ/hr]

        % Strong
        Hr.C.Str.Temp.In(HrRow,DayCol)...
            = Average(Des.C.TempIn, 0, StartIndx(1), EndIndx(1)); % [C]
        Hr.C.Str.Conc.In(HrRow,DayCol)...
            = Average(Des.C.ConcIn, 0, StartIndx(1), EndIndx(1)); % [%]
        Hr.C.Str.Temp.Out(HrRow,DayCol)...
            = Average(Des.C.TempOut, 0, StartIndx(1), EndIndx(1)); % [C]
        Hr.C.Str.Conc.Out(HrRow,DayCol)...
            = Average(Des.C.ConcOut, 0, StartIndx(1), EndIndx(1)); % [%]
        Hr.C.Str.WA(HrRow,DayCol)...
            = Average(Perf.C.WA_Air, 0, StartIndx(1), EndIndx(1)); % [kg/kJ]

        % Scavenging Air
        Hr.R.Air.Temp.In(HrRow,DayCol)...
            = Average(Air.Amb.Temp, 0, StartIndx(1), EndIndx(1));
        Hr.R.Air.Temp.Out(HrRow,DayCol)...
            = Average(Air.Reg.Temp, 0, StartIndx(1), EndIndx(1));
        Hr.R.Air.W.In(HrRow,DayCol)...
            = Average(Air.Amb.W, 0, StartIndx(1), EndIndx(1));
        Hr.R.Air.W.Out(HrRow,DayCol)...
            = Average(Air.Reg.W, 0, StartIndx(1), EndIndx(1));
        Hr.R.Air.dE(HrRow,DayCol)... % Hold
            = Average(Air.Proc.W, 0, StartIndx(1), EndIndx(1));
        Hr.R.Air.H.In(HrRow,DayCol)...
            = Average(Air.Amb.H, 0, StartIndx(1), EndIndx(1));
        Hr.R.Air.H.Out(HrRow,DayCol)...
            = Average(Air.Reg.H, 0, StartIndx(1), EndIndx(1));

        % HW
        Hr.R.HW.Temp.In(HrRow,DayCol)...
            = Average(Hot.Temp.In, 0, StartIndx(1), EndIndx(1)); % [C]
        Hr.R.HW.Temp.Out(HrRow,DayCol)...
            = Average(Hot.Temp.Out, 0, StartIndx(1), EndIndx(1)); % [C]
        Hr.C.HW.dE(HrRow,DayCol)...
            = Average(Enthalpy.Regen.HW.Out - Enthalpy.Regen.HW.In,...
            0, StartIndx(1), EndIndx(1)); % [kJ/hr]

        % Weak
        Hr.R.Wk.Temp.In(HrRow,DayCol)...
            = Average(Des.R.TempIn, 0, StartIndx(1), EndIndx(1)); % [C]
        Hr.R.Wk.Conc.In(HrRow,DayCol)...
            = Average(Des.R.ConcIn, 0, StartIndx(1), EndIndx(1)); % [%]
        Hr.R.Wk.Temp.Out(HrRow,DayCol)...
            = Average(Des.R.TempOut, 0, StartIndx(1), EndIndx(1)); % [C]
        Hr.R.Wk.Conc.Out(HrRow,DayCol)...
            = Average(Des.R.ConcOut, 0, StartIndx(1), EndIndx(1)); % [%]
        Hr.R.Wk.WR(HrRow,DayCol)...
            = Average(Perf.R.WR_Air, 0, StartIndx(1), EndIndx(1)); % [kg/kJ]

        % COP
        Hr.R.COP_Air(HrRow,DayCol)...
            = Average(Perf.R.COPth_Air, 0, StartIndx(1), EndIndx(1)); % [-]

        Hr.R.COP_Des(HrRow,DayCol)...
            = Average(Perf.R.COPth_Des, 0, StartIndx(1), EndIndx(1)); % [-]
        
        % WR
        Hr.R.WR_Des(HrRow,DayCol)...
            = Average(Perf.R.WR_Des, 0, StartIndx(1), EndIndx(1)); % [-]

        Hr.R.WR_Air(HrRow,DayCol)...
            = Average(Perf.R.WR_Air, 0, StartIndx(1), EndIndx(1)); % [-]
        
        %
        %         % Average flows
        %         % Hot water
        %         [Hr.R.HW.Flow.Range1(HrRow,DayCol) Hr.R.HW.Flow.Range2(HrRow,DayCol) Hr.R.HW.Flow.Sum(HrRow,DayCol) ...
        %             Hr.R.HW.Flow.Average(HrRow,DayCol) Hr.R.HW.Flow.Min(HrRow,DayCol) Hr.R.HW.Flow.Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Hot.FlowKH, 1, StartIndx(1), EndIndx(1)); % [kg/hr]
        %
        %         % Cold water
        %         [Hr.C.CW.Flow.Range1(HrRow,DayCol) Hr.C.CW.Flow.Range2(HrRow,DayCol) Hr.C.CW.Flow.Sum(HrRow,DayCol) ...
        %             Hr.C.CW.Flow.Average(HrRow,DayCol) Hr.C.CW.Flow.Min(HrRow,DayCol) Hr.C.CW.Flow.Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Cold.FlowKH, 1, StartIndx(1), EndIndx(1)); % [kg/hr]
        %
        %         % Conditioner Desiccant
        %         [Hr.C.Des.Flow.Range1(HrRow,DayCol) Hr.C.Des.Flow.Range2(HrRow,DayCol) Hr.C.Des.Flow.Sum(HrRow,DayCol) ...
        %             Hr.C.Des.Flow.Average(HrRow,DayCol) Hr.C.Des.Flow.Min(HrRow,DayCol) Hr.C.Des.Flow.Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Des.C.FlowInKH, 1, StartIndx(1), EndIndx(1)); % [kg/hr]
        %
        %         % Regenerator Desiccant
        %         [Hr.R.Des.Flow.Range1(HrRow,DayCol) Hr.R.Des.Flow.Range2(HrRow,DayCol) Hr.R.Des.Flow.Sum(HrRow,DayCol) ...
        %             Hr.R.Des.Flow.Average(HrRow,DayCol) Hr.R.Des.Flow.Min(HrRow,DayCol) Hr.R.Des.Flow.Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Des.R.FlowInKH, 1, StartIndx(1), EndIndx(1)); % [kg/hr]
        %
        %         % Natural Gas
        %         [Hr.Gas.Range1(HrRow,DayCol) Hr.Gas.Range2(HrRow,DayCol) Hr.Gas.Sum(HrRow,DayCol) ...
        %             Hr.Gas.Average(HrRow,DayCol) Hr.Gas.Min(HrRow,DayCol) Hr.Gas.Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Energy.Gas, 1, StartIndx(1), EndIndx(1)); % [Liters]
        %
        %         % Electricity
        %         [Hr.Elec.Range1(HrRow,DayCol) Hr.Elec.Range2(HrRow,DayCol) Hr.Elec.Sum(HrRow,DayCol) ...
        %             Hr.Elec.Average(HrRow,DayCol) Hr.Elec.Min(HrRow,DayCol) Hr.Elec.Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Energy.Elec, 0.01, StartIndx(1), EndIndx(1)); % [kW . min]
        %
        %         % Conditioner air flow
        %         [Hr.C.Air.Flow.Range1(HrRow,DayCol) Hr.C.Air.Flow.Range2(HrRow,DayCol) Hr.C.Air.Flow.Sum(HrRow,DayCol) ...
        %             Hr.C.Air.Flow.Average(HrRow,DayCol) Hr.C.Air.Flow.Min(HrRow,DayCol) Hr.C.Air.Flow.Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Air.FlowLPS, 100, StartIndx(1), EndIndx(1)); % [LPS . min]

        %         % HW Inlet temp
        %         [Hr.R.HW.Tin.Range1(HrRow,DayCol) Hr.R.HW.Tin.Range2(HrRow,DayCol) Hr.R.HW.Tin.Sum(HrRow,DayCol) ...
        %             Hr.R.HW.Tin.Average(HrRow,DayCol) Hr.R.HW.Tin.Min(HrRow,DayCol) Hr.R.HW.Tin.Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Hot.Temp.In, 0, StartIndx(1), EndIndx(1)); % [C]
        %
        %         % HW Outlet temp
        %         [Hr.R.HW.Out.Range1(HrRow,DayCol) Hr.R.HW.Out.Range2(HrRow,DayCol) Hr.R.HW.Out.Sum(HrRow,DayCol) ...
        %             Hr.R.HW.Out.Average(HrRow,DayCol) Hr.R.HW.Out.Min(HrRow,DayCol) Hr.R.HW.Out.Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Hot.Temp.Out, 0, StartIndx(1), EndIndx(1)); % [C]
        %
        %         % CW Inlet temp
        %         [Hr.R.CW.Tin.Range1(HrRow,DayCol) Hr.R.CW.Tin.Range2(HrRow,DayCol) Hr.R.CW.Tin.Sum(HrRow,DayCol) ...
        %             Hr.R.CW.Tin.Average(HrRow,DayCol) Hr.R.CW.Tin.Min(HrRow,DayCol) Hr.R.CW.Tin.Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Cold.Temp.In, 0, StartIndx(1), EndIndx(1)); % [C]
        %
        %         % CW Outlet temp
        %         [Hr.R.CW.Out.Range1(HrRow,DayCol) Hr.R.CW.Out.Range2(HrRow,DayCol) Hr.R.CW.Out.Sum(HrRow,DayCol) ...
        %             Hr.R.CW.Out.Average(HrRow,DayCol) Hr.R.CW.Out.Min(HrRow,DayCol) Hr.R.CW.Out.Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Cold.Temp.Out, 0, StartIndx(1), EndIndx(1)); % [C]
        %
        %         % CW Outlet temp
        %         Hr.R.CW.Out.Average(HrRow,DayCol)...
        %             = Average(Cold.Temp.Out, 0, StartIndx(1), EndIndx(1)); % [C]
        %
        %         % CW Outlet temp
        %         Hr.R.CW.Out.Average(HrRow,DayCol)...
        %             = FlowIntegrate(Cold.Temp.Out, 0, StartIndx(1), EndIndx(1))(3); % [C]
        %
        %         % CW Outlet temp
        %         Hr.R.CW.Out.Average(HrRow,DayCol)...
        %             = FlowIntegrate(Cold.Temp.Out, 0, StartIndx(1), EndIndx(1))(3); % [C]

        %         %
        %         [Hr.R.HW.Range1(HrRow,DayCol) Hr..Range2(HrRow,DayCol) Hr..Sum(HrRow,DayCol) ...
        %             Hr..Average(HrRow,DayCol) Hr..Min(HrRow,DayCol) Hr..Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Hot.Temp.Out, 0, StartIndx(1), EndIndx(1)); % []
        %                 %
        %         [Hr..Range1(HrRow,DayCol) Hr..Range2(HrRow,DayCol) Hr..Sum(HrRow,DayCol) ...
        %             Hr..Average(HrRow,DayCol) Hr..Min(HrRow,DayCol) Hr..Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Air.???, 0, StartIndx(1), EndIndx(1)); % [LPS . min]
        %                 %
        %         [Hr..Range1(HrRow,DayCol) Hr..Range2(HrRow,DayCol) Hr..Sum(HrRow,DayCol) ...
        %             Hr..Average(HrRow,DayCol) Hr..Min(HrRow,DayCol) Hr..Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Air.???, 0, StartIndx(1), EndIndx(1)); % [LPS . min]
        %                 %
        %         [Hr..Range1(HrRow,DayCol) Hr..Range2(HrRow,DayCol) Hr..Sum(HrRow,DayCol) ...
        %             Hr..Average(HrRow,DayCol) Hr..Min(HrRow,DayCol) Hr..Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Air.???, 0, StartIndx(1), EndIndx(1)); % [LPS . min]
        %                 %
        %         [Hr..Range1(HrRow,DayCol) Hr..Range2(HrRow,DayCol) Hr..Sum(HrRow,DayCol) ...
        %             Hr..Average(HrRow,DayCol) Hr..Min(HrRow,DayCol) Hr..Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Air.???, 0, StartIndx(1), EndIndx(1)); % [LPS . min]
        %                 %
        %         [Hr..Range1(HrRow,DayCol) Hr..Range2(HrRow,DayCol) Hr..Sum(HrRow,DayCol) ...
        %             Hr..Average(HrRow,DayCol) Hr..Min(HrRow,DayCol) Hr..Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Air.???, 0, StartIndx(1), EndIndx(1)); % [LPS . min]
        %                 %
        %         [Hr..Range1(HrRow,DayCol) Hr..Range2(HrRow,DayCol) Hr..Sum(HrRow,DayCol) ...
        %             Hr..Average(HrRow,DayCol) Hr..Min(HrRow,DayCol) Hr..Max(HrRow,DayCol)] ...
        %             = FlowIntegrate(Air.???, 0, StartIndx(1), EndIndx(1)); % [LPS . min]

        HrRow = HrRow +1;

        Start = Start + dt;
        End = End + dt;

    end
    %DayCol = DayCol + 1;
end

%datevec(Hr.Ticks)

Hr.DTVec = datevec(Hr.DT);

clear Start End Month Day i OneDay DayCol EndIndx HrRow Interv ...
    Period StartIndx TickNum dminute dt