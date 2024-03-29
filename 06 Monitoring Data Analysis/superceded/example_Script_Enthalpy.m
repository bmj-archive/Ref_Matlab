%% Load data
clear all

load waterProps;

SolarJanuaryData=ADPRead('D:\L Scripts\02L Matlab\06 Monitoring Data Analysis\Sample Data\Solarsystem_January_Original.xls');

%sourceData=ADPRead('D:\L Scripts\02L Matlab\06 Monitoring Data Analysis\Sample Data\ALL_hourly.xlsx');

%LA01Data

%% First analysis

ADPDisp(SolarJanuaryData,'Solar-27 prim�rTemp.RL','Solar-24 prim�rTemp.VL') 

%% State point: enthalpy going into solar collector;
% Temperature 
% Sensor name: Solar-27 prim�rTemp.RL
sol.n27.col = ADPGetFromHeader(SolarJanuaryData.header,'Solar-27 prim�rTemp.RL');
sol.n27.T = SolarJanuaryData.data(:,sol.n27.col); % [�C]
% Mass flow
% Assumption!!!!
sol.n27.mf = 1000; % [kg/s]
% Specific enthalpy 
sol.n27.se = enthalpyWater(waterProps, sol.n27.T); % [kJ/kg]
% Absolute enthalpy
sol.n27.ef = sol.n27.se.*sol.n27.mf; % [kJ/s] or [kW]

%% State point: enthalpy leaving solar collector
% Sensor name: Solar-24 prim�rTemp.VL
% Temperature
sol.n24.col = ADPGetFromHeader(SolarJanuaryData.header,'Solar-24 prim�rTemp.VL');
sol.n24.T = SolarJanuaryData.data(:,sol.n24.col); % [�C]
% Mass flow
sol.n24.mf = 1000; % [kg/s]
% Specific enthalpy 
sol.n24.se = enthalpyWater(waterProps, sol.n24.T); % [kJ/kg]
% Absolute enthalpy
sol.n24.ef = sol.n24.se.*sol.n24.mf; % [kJ/s]

%% Solar irradiance onto solar collector
% Example only, find the right sensor!!!
% Assumption;
Gi_solar_spec = SolarJanuaryData.data(:,10); % [kW/m2]
% Assumption;
areaSolar = 100; % [m2]
% Assumption;
Gi_solar_inc = Gi_solar_spec .* areaSolar; % [kW]

%% Final analysis
%Temperature change across collector;
plot(sol.n24.T-sol.n27.T)
title('Temperature change across solar collector');
% Useful energy gain of solar collector
ef_solarGain = sol.n24.ef - sol.n27.ef;
plot(ef_solarGain)
title('Energy gain across solar collector');

% Efficiency of solar collector
% Assumption;
eta_solar = ef_solarGain ./ Gi_solar_inc; % [-]
plot(eta_solar)
title('Efficiency of solar collector');


% Example for enthalpy of moist air
rh_example1 = sourceData.data(:,15); % [- (%)]
T_example1 = sourceData.data(:,13); % [�C]
mf_example1 = 1000; % [kg/s]
x_example1 = humidityRatio(T_example1,101.3,rh_example1); % [kg/kg]
se_example1 = enthalpyMoistAir(T_example1,x_example1); % [kJ/kg]
ef_example1 = se_example1.*mf_example1; % [kW]

% Exhaust inlet for sorption rotor
% Column 133=RH & 132=T

% Exhaust outlet for sorption rotor
% Column 134=RH & 134=T

% Supply inlet for sorption rotor
% Column 122=RH & 121=T

% Supply outlet for sorption rotor
% Column 124=RH & 123=T

% Supply flow rate
% Col  = 114

% Exhaust flow rate
% Col  = 115

% columnNumbers = ADPGetFromHeader(sourceData.header,'�C');
% 
% temperatureData = sourceData.data(:,columnNumbers);
% 
% massFlowData = ones(size(temperatureData)).*1000; % [kg/hr]
% 
% enthData = enthalpyDataWater(temperatureData,massFlowData);
% 
% %absEnthData = specEnthData.data.*
% 
% ADPDisp(data2)

% temperature = data(:,10); % [�C]
% 
% massflow1 = ones(size(time)).*1000; % [kg/hr]
% 
% % This is the Absolute enthalpy! 
% absEnthalpy = enthalpyWater(temperature); % [kJ/kg]
% 
% enthalpyFlow = massflow1.*absEnthalpy; % []
% 
% plotyy(time,temperature,time,enthalpyFlow); %
% datetick2