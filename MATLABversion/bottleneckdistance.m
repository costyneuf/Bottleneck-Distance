function simple_gui2
    % SIMPLE_GUI2 Select a data set from the pop-up menu, then
    % click one of the plot-type push buttons. Clicking the button
    % plots the selected data in the axes.

    %  Create and then hide the UI as it is being constructed.
    f = figure('Visible','off','Position',[360,500,700,485]);

    % Construct the components.
    hBottleneckDistance    = uicontrol('Style','pushbutton',...
                 'String','Bottleneck Distance','Position',[525,220,180,25],...
                 'Callback',@bdbutton_Callback);
    hPlotPD    = uicontrol('Style','pushbutton',...
                 'String','Plot Persistence Diagrams','Position',[525,180,180,25],...
                 'Callback',@plotbutton_Callback);

    htext  = uicontrol('Style','text','String','Select Data',...
               'Position',[415,90,60,15]);
    hpopup = uicontrol('Style','popupmenu',...
               'String',{'PD1 and PD2','PD1 and PD3','PD4 and PD5'},...
               'Position',[415,50,100,25],...
               'Callback',@popup_menu_Callback);
    ha = axes('Units','pixels','Position',[50,70,400,385]);
    align([hBottleneckDistance,hPlotPD,htext,hpopup],'Center','None');

    % Initialize the UI.
    % Change units to normalized so components resize automatically.
    f.Units = 'normalized';
    ha.Units = 'normalized';
    hBottleneckDistance.Units = 'normalized';
    hPlotPD.Units = 'normalized';
    htext.Units = 'normalized';
    hpopup.Units = 'normalized';

    % Generate the data to plot.
    PD1 = importdata('PD1.mat');
    PD2 = importdata('PD2.mat');
    PD3 = importdata('PD3.mat');
    PD4 = importdata('PD4.mat');
    PD5 = importdata('PD5.mat');
    planarShapes = importdata('planarShapes.mat');
    planeCurve = importdata('planeCurve.mat');
    signatures = importdata('signatures.mat');

    % Create a plot in the axes.
    current_PD1 = PD1;
    current_PD2 = PD2;

    % Assign the a name to appear in the window title.
    f.Name = 'Bottleneck Distance Demo';

    % Move the window to the center of the screen.
    movegui(f,'center')

    % Make the window visible.
    f.Visible = 'on';

    %  Pop-up menu callback. Read the pop-up menu Value property to
    %  determine which item is currently displayed and make it the
    %  current data. This callback automatically has access to 
    %  current_data because this function is nested at a lower level.
       function popup_menu_Callback(source,eventdata) 
          % Determine the selected data set.
          str = get(source, 'String');
          val = get(source,'Value');
          % Set current data to the selected data set.
          switch str{val};
              case 'PD1 and PD2' 
                 current_PD1 = PD1;
                 current_PD2 = PD2;
              case 'PD1 and PD3' 
                 current_PD1 = PD1;
                 current_PD2 = PD3;
              case 'PD4 and PD5' 
                 current_PD1 = PD4;
                 current_PD2 = PD5;
          end
       end

      function [a] = calculate_Mpoint(point)
          a = abs(0.5 * (point(1,1) - point(1,2)));
      end
  
      function [d] = calculate_dInf(point1, point2)
          A = [abs(point1(1,1) - point2(1,1)),abs(point1(1,2) - point2(1,2))];
          d = max(A);
      end
  
      % M = costMatrix(A, C)
      % Inputs: Two PDs A and C of the same cardinality N 
      %     expressed as N * 2 matrices,
	  % Output: The corresponding N * N cost matrix M
      function [M] = costMatrix(A, C)
          cardinality = length(A);
          M = zeros(cardinality, cardinality);
          for i = 1 : cardinality
              a = A(i,:);
              for j = 1 : cardinality
                  r = C(j,:);
                  temp = [calculate_dInf(a, r), max([calculate_Mpoint(a), calculate_Mpoint(r)])];
                  M(i,j) = min(temp);
              end
          end
        
      end

      % T = thresholdList(M)
      % Input: A cost matrix M,
	  % Output: An ordered list of threshold values T = (t1, ..., tk).
      function [T] = thresholdList(M)
          T_temp = zeros(1, length(M) * length(M));
          a = 1;
          for i = 1 : length(M)
              for j = 1 : length(M)
                  T_temp(1,a) = M(i,j);
                  a = a + 1;
              end
          end
          T = sort(T_temp);
          len = length(T);
          a = 2;
          for i = 2 : len
              if round(T(1,a),2) ~= round(T(1,a - 1),2)
                  a = a + 1;
              else
                  T(:,a) = [];
              end
          end
      end
  
        % M^t = thresholdMatrix(M, t)
	    % Inputs: Cost matrix M and threshold level t,
        % Output: Threshold matrix M^t
    function [M_t] = thresholdMatrix(M, t)
        M_t = zeros(length(M), length(M));
        for i = 1 : length(M)
            for j = 1 : length(M)
                if round(M(i,j),2) <= round(t,2)
                    M_t(i,j) = 1;
                end
            end
        end
    end

    % tutteTest(M)
	% Input: An N * N threshold matrix M
	% Output: Evaluate the Tutte determinant polynomial on a random point. 
	%	 Return 0 of it evaluates to 0 and 1 otherwise.
    function [d] = tutteTest(M)
        M_t = zeros(length(M), length(M));
        for i = 1 : length(M)
            for j = 1 : length(M)
                if M(i,j) ~= 0
                    M_t(i, j) = rand(1,1);
                end
            end
        end
        if (det(M_t) ~= 0) 
            d = 1;
        else
            d = 0;
        end
    end

    % d = bottleneckDistance(A, C)
	% Inputs: PDs A and C with N points,
	% Output: Bottleneck distance between A and C	
    function [d] = bottleneckDistance(A, C)
        M = costMatrix(A, C);
        T = thresholdList(M);
        for j = 1 : length(T)
            t = T(1,j);
            M_t = thresholdMatrix(M, t);
            if tutteTest(M_t) == 1
                d = t;
                break;
            end
        end
    end
   
      % Push button callbacks. Each callback plots current_data in the
      % specified plot type.

      function bdbutton_Callback(source,eventdata)
          clc;
        % test costMatrix  
        M = costMatrix(current_PD1, current_PD2);  
        fileID = fopen('testCostMatrix.txt','w');
        for i = 1 : length(M)
            for j = 1 : length(M(1,:))
                fprintf(fileID,'%f ',M(i,j));
            end
            fprintf(fileID, '\n');
        end
        fclose(fileID);
        
          % test thresholdList(M)
          fileID = fopen('testThresholdList.txt','w');
          T = thresholdList(M);
          for i = 1 : length(T)
              fprintf(fileID,'%f ',T(1,i));
          end
          fclose(fileID);
          
        % test thresholdMatrix
        M_t = thresholdMatrix(M, 0.05);
        M_t2 = thresholdMatrix(M, 0.45);
        fileID = fopen('testThresholdMatrix1.txt','w');
        fileID2 = fopen('testThresholdMatrix2.txt','w');
        for i = 1 : length(M)
            for j = 1 : length(M)
                fprintf(fileID,'%d ',M_t(i,j));
                fprintf(fileID2,'%d ',M_t2(i,j));
            end
            fprintf(fileID, '\n');
            fprintf(fileID2,'\n');
        end
        fclose(fileID);    
        fclose(fileID2);
        
        % test tutteTest
        A = [1 0 0
            0 1 0
            0 0 1];
        B = [1 0 0
            0 0 1
            0 0 1];
        C = [1 1 1
            1 1 1
            1 1 1];
        fprintf('%d, %d, %d\n', tutteTest(A), tutteTest(B), tutteTest(C));
        
        %test bottleneckDistance(A, C)
        fprintf('%.4f\n', bottleneckDistance(current_PD1, current_PD2));
      end
  


      function plotbutton_Callback(source,eventdata) 
        plot(current_PD1, 'r.');
        hold on;
        plot(current_PD2, 'b.');
        hold off;  
      end
  

  
end
