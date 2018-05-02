function simple_gui2
    % SIMPLE_GUI2 Select a data set from the pop-up menu, then
    % click one of the plot-type push buttons. Clicking the button
    % plots the selected data in the axes.

    %  Create and then hide the UI as it is being constructed.
    clc
    f = figure('Visible','off','Position',[360,500,700,485]);

    % Construct the components.
    hBottleneckDistance    = uicontrol('Style','pushbutton',...
                 'String','Bottleneck Distance','Position',[485,220,180,25],...
                 'Callback',@bdbutton_Callback);
    hPlotPD    = uicontrol('Style','pushbutton',...
                 'String','Analyze Planar Shapes','Position',[525,180,180,25],...
                 'Callback',@plotbutton_Callback);
     hTestSignature    = uicontrol('Style','pushbutton',...
         'String','Signature Test','Position',[525,140,180,25],...
         'Callback',@sigbutton_Callback);

    htext  = uicontrol('Style','text','String','Select Data',...
               'Position',[525,90,60,15]);
    hpopup = uicontrol('Style','popupmenu',...
               'String',{'PD1 and PD2','PD1 and PD3','PD4 and PD5', 'Customized Data'},...
               'Position',[525,50,100,25],...
               'Callback',@popup_menu_Callback);
    ha = axes('Units','pixels','Position',[50,70,400,385]);
    align([hBottleneckDistance,hPlotPD,hTestSignature,htext,hpopup],'Left','None');

    % Initialize the UI.
    % Change units to normalized so components resize automatically.
    f.Units = 'normalized';
    ha.Units = 'normalized';
    hBottleneckDistance.Units = 'normalized';
    hPlotPD.Units = 'normalized';
    hTestSignature.Units = 'normalized';
    htext.Units = 'normalized';
    hpopup.Units = 'normalized';

    % Generate the data to plot.
    PD1 = importdata('PD1.mat');
    PD2 = importdata('PD2.mat');
    PD3 = importdata('PD3.mat');
    PD4 = importdata('PD4.mat');
    PD5 = importdata('PD5.mat');
    planarShapes = importdata('planarShapes.mat');
    planarShapesBarcodesOneDim = importdata('planarShapesBarcodesOneDim.mat');
    planarShapesBarcodesZeroDim = importdata('planarShapesBarcodesZeroDim.mat');
    planeCurve = importdata('planeCurve.mat');
    signaturesBarcodesOneDim = importdata('signaturesBarcodesOneDim.mat');
    signaturesBarcodesZeroDim = importdata('signaturesBarcodesZeroDim.mat');
    signatures = importdata('signatures.mat');

    % Create a plot in the axes.
    current_PD1 = PD1;
    current_PD2 = PD2;
    
    % Plot graphs
    scatter(current_PD1(:,1),current_PD1(:,2), 15, 'filled', 'MarkerFaceColor','r');
    hold on;
    scatter(current_PD2(:,1),current_PD2(:,2), 15, 'filled', 'MarkerFaceColor','g');
    hold off; 

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
              case 'Customized Data'
                [file,path] = uigetfile('*.mat');
                current_PD1 = importdata(fullfile(path,file));
                [file,path] = uigetfile('*.mat');
                current_PD2 = importdata(fullfile(path,file));
          end
        scatter(current_PD1(:,1),current_PD1(:,2), 15, 'filled', 'MarkerFaceColor','r');
        hold on;
        scatter(current_PD2(:,1),current_PD2(:,2), 15, 'filled', 'MarkerFaceColor','g');
        hold off;  
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
              if round(T(1,a),3) ~= round(T(1,a - 1),3)
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
                if round(M(i,j),3) <= round(t,3)
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

    % A^epsilon = simplifyPD(A, epsilon)
	% Inputs: An N * 2 matrix representing a persistence diagram A and 
    %   epsilon > 0,
	% Output: Simplified persistence diagram A^epsilon, represented as an 
    %   N' * 2 matrix 
	% 	with N' <= N.
    function [A_epsilon] = simplifyPD(A, epsilon)
        A_epsilon = zeros(length(A(:,1)), 2);
        b = 1;
        for j = 1 : length(A)
            a = A(j,:);
            if calculate_Mpoint(a) > epsilon
                A_epsilon(b, 1) = a(1,1);
                A_epsilon(b, 2) = a(1,2);
                b = b + 1;
            else
                A_epsilon(b,:) = [];
            end
        end
    end

    % (A', C') = equalCard(A, C)
	% Inputs: PDs A and C with potentially an unequal number of points,
	% Outputs: PDs A' and C' of equal cardinality max{|A|, |C|}.
    function [A_, C_] = equalCard(A, C)
        if length(A(:,1)) > length(C(:,1))
            A_ = zeros(length(A(:,1)),2);
            C_ = zeros(length(A(:,1)),2);
        else
            A_ = zeros(length(C(:,1)),2);
            C_ = zeros(length(C(:,1)),2);
        end
        for i = 1 : length(A)
            A_(i,1) = A(i,1);
            A_(i,2) = A(i,2);
        end
        for i = 1 : length(C)
            C_(i,1) = C(i,1);
            C_(i,2) = C(i,2);
        end
    end

    % d = fullBottleneckDist(A, C, epsilon)
	% Inputs: PDs A and C of potentially different cardinality and a 
    %   simplification parameter epsilon,
	% Output: bottleneck distance d between (A_epsilon)' and (C_epsilon)'.
    function [d] = fullBottleneckDist(A, C, epsilon)
        % simplify the PDs according to parameter epsilon
        A_epsilon = simplifyPD(A, epsilon);
        C_epsilon = simplifyPD(C, epsilon);
        % add necessary copies of {(0, 0)} to get PDs of the same cardinality
        [A_epsilon_, C_epsilon_] = equalCard(A_epsilon, C_epsilon);
        d = bottleneckDistance(A_epsilon_, C_epsilon_);
    end
   
      % Push button callbacks. Each callback plots current_data in the
      % specified plot type.

      function bdbutton_Callback(source,eventdata)
          clc;
        % test costMatrix  
        M = costMatrix(PD1, PD2);  
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
        
        % test bottleneckDistance(A, C)
        prompt = {'Enter the value of epsilon:'};
        dims = [1 35];
        definput = {'0.2'};
        title = 'Input';
        answer = inputdlg(prompt,title,dims,definput);
        epsilon = str2num(answer{1});
        d = fullBottleneckDist(current_PD1, current_PD2, epsilon);
        s = num2str(d);
        fprintf('%.4f\n', d);
        msgbox(s);

        % test simplifyPD
        PD4_test = simplifyPD(PD4, 0.2)
        len = length(PD4_test(:,1))
      end
  


      function plotbutton_Callback(source,eventdata) 
        figure;
        prompt = {'Enter first shape number:'};
        dims = [1 35];
        definput = {'20'};
        title = 'Input';
        answer = inputdlg(prompt,title,dims,definput);
        first = str2num(answer{1});
        PD = planarShapes(:,:,first);
        current_PD1 = PD.';
        prompt = {'Enter second shape number:'};
        dims = [1 35];
        definput = {'872'};
        answer = inputdlg(prompt,title,dims,definput);
        second = str2num(answer{1});
        PD = planarShapes(:,:,second);
        current_PD2 = PD.';
        subplot(3,1,1);
        scatter(current_PD1(:,1),current_PD1(:,2), 15, 'filled', 'MarkerFaceColor','r');
        subplot(3,1,2);
        scatter(current_PD2(:,1),current_PD2(:,2), 15, 'filled', 'MarkerFaceColor','g');
        subplot(3,1,3); 
        plotBarcodes(planarShapesBarcodesZeroDim(:,first), 'r', 2); 
        plotBarcodes(planarShapesBarcodesZeroDim(:,second), 'g', 1);
        d = fullBottleneckDist(current_PD1, current_PD2, 0.2);
        s = num2str(d);
        msgbox(s);
      end
  
    function sigbutton_Callback(source, eventdata)
        figure;
        prompt = {'Enter data set number:'};
        dims = [1 35];
        definput = {'10'};
        title = 'Input';
        answer = inputdlg(prompt,title,dims,definput);
        group = str2num(answer{1});
        
        current_PD1 = signatures(:,:,group,1);
        current_PD1 = current_PD1.';
        for i = 1 : 40
            a = signatures(:,:,group,i);
            a = a.';
            subplot(8,5,i);
            scatter(a(:,1),a(:,2), 10, 'filled', 'MarkerFaceColor','r');
        end
        
         % test 
          fileID = fopen('testSignatures.txt','w');  
        
        figure
        for i = 1 : 40
            subplot(8,5,i);
            current_data = signaturesBarcodesZeroDim{group,i};
            scatter(current_data(:,2), zeros(length(current_data(:,2)),1),10, 'filled', 'MarkerFaceColor','b');
        end
        
        d = 10000000000000000000;
        index = 1;
        for i = 1 : 39
            current_PD1 = signatures(:,:,group,i);
            current_PD1 = current_PD1.';
            for j = i+1 : 40        
                current_PD2 = signatures(:,:,group,j);
                current_PD2 = current_PD2.';
                d_ = fullBottleneckDist(current_PD1, current_PD2, 0.95);
                if d_ < d
                    d = d_;
                    index = j;
                end
            end
            fprintf(fileID,'The bottle distance between #%d and #%d = %f\n',i, index, d);            
        end
        fclose(fileID);
        
    end
  

  
end
