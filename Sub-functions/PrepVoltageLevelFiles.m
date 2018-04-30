function VoltageLevel = PrepVoltageLevelFiles(VoltageLevelInput)
%PrepVoltageLevelFiles Prepare Input for Sincal Database (DB) to add new VoltageLevels
%
%   The Input for the Sincal Database to add new VoltageLevel are table
%   entries for the table VoltageLevel. These are prepared with the
%   function.
%
%   VoltageLevel = PrepVoltageLevelFiles(VoltageLevelInput)
%
%       VoltageLevelInput (Required) - Table with variables:
%                                      .Un - Nominal voltage of new VoltageLevels
%                                      .VoltLevel_ID (primary key)
%                                      ....  - options can be added in future
%       VoltageLevel      (Result)   - Table with required entries for the
%                                      Sincal DB table VoltageLevel to add VoltageLevels
%
% Robert Brandalik, 2018 (Special thanks go to the entire TUK ESEM team)

%% Standard Setup

num_VLevel = size(VoltageLevelInput,1);

%% VoltageLevel table with new required entries

VoltageLevel = table;
VoltageLevel.VoltLevel_ID      	= VoltageLevelInput.VoltLevel_ID;
VoltageLevel.Variant_ID        	= ones  (num_VLevel,1);
VoltageLevel.Name              	= strcat('Network Level ',{' '},strrep(cellstr(num2str(VoltageLevelInput.Un)),' ',''), ' kV');
VoltageLevel.ShortName         	= strcat(strrep(cellstr(num2str(VoltageLevelInput.Un)),' ',''), ' kV');
VoltageLevel.Un                	= VoltageLevelInput.Un;
VoltageLevel.cmin              	= ones  (num_VLevel,1);
VoltageLevel.cmax              	= ones  (num_VLevel,1) * 1.1;
VoltageLevel.Flag_Reliability  	= zeros (num_VLevel,1);
VoltageLevel.Flag_RelElement   	= zeros (num_VLevel,1);
VoltageLevel.SwitchBay1_ID     	= zeros (num_VLevel,1);
VoltageLevel.SwitchBay2_ID     	= zeros (num_VLevel,1);
VoltageLevel.BusbarType_ID     	= zeros (num_VLevel,1);
VoltageLevel.LineType_ID       	= zeros (num_VLevel,1);
VoltageLevel.TransformerType_ID	= zeros (num_VLevel,1);
VoltageLevel.SupplyType_ID     	= zeros (num_VLevel,1);
VoltageLevel.SwitchDur_ID      	= zeros (num_VLevel,1);
VoltageLevel.LoadDurCurve_ID   	= zeros (num_VLevel,1);
VoltageLevel.Flag_LP           	= ones  (num_VLevel,1) * 3;
VoltageLevel.Flag_Variant      	= ones  (num_VLevel,1);
VoltageLevel.Flag_Arc_I        	= zeros (num_VLevel,1);
VoltageLevel.I_Fkt_R           	= ones  (num_VLevel,1) * 1.5;
VoltageLevel.I_R               	= ones  (num_VLevel,1) * 4;
VoltageLevel.I_R_X             	= ones  (num_VLevel,1) * 0.25;
VoltageLevel.Flag_Arc_M        	= zeros (num_VLevel,1);
VoltageLevel.M_Fkt_R           	= ones  (num_VLevel,1) * 1.5;
VoltageLevel.M_R               	= ones  (num_VLevel,1) * 4;
VoltageLevel.M_R_X             	= ones  (num_VLevel,1) * 0.25;
VoltageLevel.Flag_Arc_K        	= zeros (num_VLevel,1);
VoltageLevel.K_Fkt_R           	= ones  (num_VLevel,1) * 1.5;
VoltageLevel.K_R               	= ones  (num_VLevel,1) * 4;
VoltageLevel.K_R_X             	= ones  (num_VLevel,1) * 0.25;
VoltageLevel.Flag_Arc_P        	= zeros (num_VLevel,1);
VoltageLevel.P_Fkt_R           	= ones  (num_VLevel,1) * 1.5;
VoltageLevel.P_R               	= ones  (num_VLevel,1) * 4;
VoltageLevel.P_R_X             	= ones  (num_VLevel,1) * 0.25;
VoltageLevel.Flag_CompPower    	= NaN   (num_VLevel,1);
VoltageLevel.CosPhi_ind        	= NaN   (num_VLevel,1);
VoltageLevel.CosPhi_kap        	= NaN   (num_VLevel,1);
VoltageLevel.Flag_Sc           	= NaN   (num_VLevel,1);
VoltageLevel.Uop               	= ones  (num_VLevel,1);
VoltageLevel.Flag_Usc          	= NaN   (num_VLevel,1);
VoltageLevel.c                 	= ones  (num_VLevel,1) * 1.1;
VoltageLevel.Uk                	= NaN   (num_VLevel,1);
VoltageLevel.ts                	= NaN   (num_VLevel,1);
VoltageLevel.Ipmax             	= NaN   (num_VLevel,1);
VoltageLevel.Ikmax             	= NaN   (num_VLevel,1);
VoltageLevel.Flag_CurStp       	= NaN   (num_VLevel,1);
VoltageLevel.u_ansi            	= NaN   (num_VLevel,1);
VoltageLevel.dQ_rouch          	= NaN   (num_VLevel,1);
VoltageLevel.dQ_fine           	= NaN   (num_VLevel,1);
VoltageLevel.Flag_OptBr        	= NaN   (num_VLevel,1);
VoltageLevel.Flag_Toleranz     	= NaN   (num_VLevel,1);
VoltageLevel.Flag_Arc_MHO      	= NaN   (num_VLevel,1);
VoltageLevel.MHO_Fkt_R         	= NaN   (num_VLevel,1);
VoltageLevel.MHO_R             	= NaN   (num_VLevel,1);
VoltageLevel.MHO_R_X           	= NaN   (num_VLevel,1);
VoltageLevel.LF_Safety_I       	= NaN   (num_VLevel,1);
VoltageLevel.LF_Safety_Phi     	= NaN   (num_VLevel,1);
VoltageLevel.LF_Safety_Z       	= NaN   (num_VLevel,1);
VoltageLevel.Flag_Balance      	= ones  (num_VLevel,1);
VoltageLevel.hmax_THD          	= zeros (num_VLevel,1);
VoltageLevel.HarDistLimit_ID   	= zeros (num_VLevel,1);
VoltageLevel.Temp_Line         	= ones  (num_VLevel,1) * 20;
VoltageLevel.Temp_Cable        	= ones  (num_VLevel,1) * 20;
VoltageLevel.CableType_ID      	= zeros (num_VLevel,1);
VoltageLevel.Flag_DCInfeeder   	= zeros (num_VLevel,1);
VoltageLevel.DCInfeederType_ID 	= zeros (num_VLevel,1);
VoltageLevel.f                 	= ones  (num_VLevel,1) * 50;
VoltageLevel.fRD               	= ones  (num_VLevel,1) * 50;
VoltageLevel.Udgr              	= NaN   (num_VLevel,1);
VoltageLevel.AddFaultData_ID   	= NaN   (num_VLevel,1);
VoltageLevel.AmbTemp_Cable     	= NaN   (num_VLevel,1);
VoltageLevel.AmbTemp_Line      	= NaN   (num_VLevel,1);
VoltageLevel.TempSun_Line      	= NaN   (num_VLevel,1);
VoltageLevel.Flag_Volt         	= NaN   (num_VLevel,1);
VoltageLevel.Flag_LimitRes     	= NaN   (num_VLevel,1);
VoltageLevel.Flag_Arc_Comb     	= NaN   (num_VLevel,1);
VoltageLevel.Comb_Fkt_R        	= NaN   (num_VLevel,1);
VoltageLevel.Comb_R            	= NaN   (num_VLevel,1);
VoltageLevel.Comb_R_X          	= NaN   (num_VLevel,1);