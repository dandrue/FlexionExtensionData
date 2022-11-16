function PlotFun(option,varargin)
% function required for DataViewer to plot kinematics data and do all sorts
% of operations in the GUI.
% Coded by Bart Bolsterlee (b.bolsterlee@tudelft.nl)
% September 2014
switch option
    case 'Resize'
        
        margin = 10;
        skip   = 10;
        text1   = [25 20];
        text2   = [35 20];
        edit   = [300 20];
        edit2   = [50 20];
        push   = [20 20];
        button = [50 20];
        text3 = [160 20];
        popup = [150 20];
        space = 25;
        button2 = [150 50];
        
        %    offset = [65 45 20 140];
        fPos = get(gcf, 'Position');
        % Play/pause button
        x = margin;y=margin;
        set(findobj(gcf,'Tag','PlayButton'),'Position',[x y button]);
        
        % Frame number text box
        x = x + button(1)+skip;
        set(findobj(gcf,'Tag','FrameNr'),'Position',[x y text2])
        
        % Frame number edit box input
        x = x + text2(1)+skip;
        set(findobj(gcf,'Tag','FrameNrInput'),'Position',[x y edit2])
        
        % Slider
        x = x + skip+edit2(1);
        sliderheight=20;
        dimslider = [fPos(3)-x-margin sliderheight];
        set(findobj(gcf,'Tag','Slider'),'Position',[x y dimslider])
        
        % Axes object
        userdata = get(gcf,'Userdata');
        dimx1 = 2/3*(fPos(3)-2*margin);
        x = margin;
        y = y+sliderheight+skip;
        dimy1 = fPos(4)-2*margin-2*skip-2*sliderheight;
        set(findobj(gcf,'Tag','MainAxes'),'Position',[x y dimx1 dimy1])
        
        % Top bar, position wrt left border
        y = y+dimy1+skip;
        set(findobj(gcf,'Tag','TextBox'),'Position',[x y-2.5 text1])
        x = x+text1(1)+skip;
        set(findobj(gcf,'Tag','inputModel'),'Position',[x y edit])
        x = x+edit(1)+skip;
        set(findobj(gcf,'Tag','browseModel'),'Position',[x y push])
        
        % Top bar, position wrt right border
        x = fPos(3)-margin-skip-text3(1)-popup(1);
        set(findobj(gcf,'Tag','PopupText1'),'Position',[x y-2.5 text3]);
        x = x+text3(1)+skip;
        set(findobj(gcf,'Tag','Popup1'),'Position',[x y popup]);
        
        % Dimensions of axes for plotting segment rotations
        dimx2 = (fPos(3)-2*margin-space)/3;
        dimy2 = dimy1/2;
        x = fPos(3) - margin-dimx2;
        y = y-skip-dimy2;
        set(findobj(gcf,'Tag','SegmRotAxes'),'Position',[x  y dimx2 dimy2])
        
        % bottom right corner
        x = fPos(3) - margin-button2(1);
        y  = margin+sliderheight+skip ;
        set(findobj(gcf,'Tag','PlotDirVec'),'Position',[x y button2]);
        y = y+button2(2)+skip;
        set(findobj(gcf,'Tag','ShowLandmarkLabel'),'Position',[x y button2]);
        y = y+button2(2)+skip;
        set(findobj(gcf,'Tag','CalcAngles'),'Position',[x y button2]);
        
    case 'LoadModel'
        filename = varargin{1};
        set(findobj(gcf,'Tag', 'inputModel'), 'String', filename)
        userdata = get(gcf,'Userdata');
        % Erase existing landmark data
        userdata.Landmarks = [];
        
        % Check for extension of selected file (should be .MAT) and read in data
        [~, ~, ext] = fileparts(filename);
        if strcmp(ext,'.mat')
            load(filename)
            
            % Check whether MAT-file contains the required variables.
            if ~exist('Landmarks','var')
                fprintf('Variable ''Landmarks'' not found in the MAT-file. Select another file.\n')
                return
            end
            if ~exist('Landmarks_Names','var')
                fprintf('Variable ''Landmarks_Names'' not found in the MAT-file. Select another file.\n')
                return
            end
            if ~exist('SegmRot','var')
                fprintf('Variable ''SegmRot'' not found in the MAT-file. Select another file.\n')
                return
            end
            if ~exist('SegmRot_Names','var')
                fprintf('Variable ''SegmRot_Names'' not found in the MAT-file. Select another file.\n')
                return
            end
            
            % Make structure which links landmark names and landmark numbers
            for l = 1:length(Landmarks_Names)
                eval(['LN.' Landmarks_Names{l} ' = l;'])
            end
            Landmarks = Landmarks;
            set(findall(findobj(gcf,'Tag','SegmRotAxes')),'Visible','off')
            
            userdata.LN = LN;
            userdata.Landmarks = Landmarks;
            userdata.SegmRot = SegmRot;
            set(gcf, 'UserData', userdata)
            set(findobj(gcf,'Tag','MainAxes'),'Visible','on')
            if ~isempty(SegmRot)
                set(findobj(gcf,'Tag','SegmRotAxes'),'Visible','on')
                set(findobj(gcf,'Tag','Popup1'),'Enable','on')
                % Plot segment rotations
                PlotFun('SegmRot1')
            else
                set(findobj(gcf,'Tag','SegmRotAxes'),'Visible','off')
                set(findobj(gcf,'Tag','Popup1'),'Enable','off')
                
            end
            Landmarks = userdata.Landmarks;
            nSteps = size(Landmarks,3);
            axes(findobj(gcf,'Tag','MainAxes'))
            % Plot first frame
            istep = 1;
            cla
            hold on
            % Thorax
            i = [LN.IJ LN.C7 LN.T8 LN.PX];
            h.thor = patch(Landmarks(1,i,istep),Landmarks(2,i,istep),Landmarks(3,i,istep),'b',...
                'EdgeColor','k','FaceAlpha',0.5);
            % Clavicula
            i = [LN.SC LN.ACv];
            h.clav = plot3(Landmarks(1,i,istep),Landmarks(2,i,istep),Landmarks(3,i,istep),'m','linewidth',2);
            % Scapula
            i = [LN.TS LN.AI LN.AA];
            h.scap = patch(Landmarks(1,i,istep),Landmarks(2,i,istep),Landmarks(3,i,istep),'g',...
                'EdgeColor','k','FaceAlpha',0.5);
            % Scapula locator
            i = [LN.SCREWTS LN.SCREWAI LN.SCREWAA];
            clr = [178 115 231];
            h.scaploc = patch(Landmarks(1,i,istep),Landmarks(2,i,istep),Landmarks(3,i,istep),clr/norm(clr),...
                'EdgeColor','k','FaceAlpha',0.5);
            % Humerus
            i = [LN.GH LN.EM LN.EL];
            h.hum = patch(Landmarks(1,i,istep),Landmarks(2,i,istep),Landmarks(3,i,istep),'r',...
                'EdgeColor','k','FaceAlpha',0.5);
            % Forearm
            i = [LN.EM LN.EL LN.US LN.RS];
            h.fore = patch(Landmarks(1,i,istep),Landmarks(2,i,istep),Landmarks(3,i,istep),'c',...
                'EdgeColor','k','FaceAlpha',0.5);
            % Hand
            i = [LN.US LN.RS LN.MCP2 LN.MCP5];
            h.hand = patch(Landmarks(1,i,istep),Landmarks(2,i,istep),Landmarks(3,i,istep),'y',...
                'EdgeColor','k','FaceAlpha',0.5);
            hold off
            % Add handles to userdata
            userdata.h = h;
            set(gcf,'Userdata',userdata)
            
            % Determine bounding box of data to set axes scale
            axesObj = findobj(gcf,'Tag','MainAxes');
            BLlist = [LN.IJ LN.PX LN.C7 LN.T8 LN.TS LN.AA LN.AI LN.ACv LN.GH LN.EL...
                LN.EM LN.US LN.RS LN.MCP2 LN.MCP5];
            
            limx = [min(min(Landmarks(1,BLlist,:)))...
                max(max(Landmarks(1,BLlist,:)))];
            
            limy = [min(min(Landmarks(2,BLlist,:)))...
                max(max(Landmarks(2,BLlist,:)))];
            
            limz = [min(min(Landmarks(3,BLlist,:)))...
                max(max(Landmarks(3,BLlist,:)))];
            
            axis equal
            view(0, 90)
            set(gca,'XLim',limx,'YLim',limy,'ZLim',limz)
            xlabel('x');ylabel('y');zlabel('z');
            
            % Enable slider and play button
            set(findobj(gcf,'Tag','PlayButton'),'Enable','On')
            set(findobj(gcf,'Tag','PlotDirVec'),'Enable','On')
            set(findobj(gcf,'Tag','CalcAngles'),'Enable','On')
            set(findobj(gcf,'Tag','ShowLandmarkLabel'),'Enable','On')
            set(findobj(gcf,'Tag', 'Slider'),...
                'Enable','On',...
                'Value',1,...
                'Min',1,...
                'Max',nSteps,...
                'SliderStep',[1/nSteps 10/nSteps])
            set(findobj(gcf,'Tag','FrameNrInput'),'String',int2str(1))
            PlotFun('Resize')
            PlotFun('Plot',1)
        else
            fprintf('No MAT-file was selected. File cannot be loaded.')

        end
        
    case 'Plot'
        %    tic
        istep = varargin{1};
        userdata = get(gcf, 'UserData');
        Landmarks = userdata.Landmarks;
        LN = userdata.LN;
        h = userdata.h;
        delete(findobj(gcf,'Tag','DirVec'))
        delete(findobj(gcf,'Tag','BL'))
        %    t1=toc;
        %    tic
        axes(findobj(gcf,'Tag','MainAxes'))
        % Thorax
        i = [LN.IJ LN.C7 LN.T8 LN.PX];
        set(h.thor,'Xdata', Landmarks(1,i,istep),...
            'Ydata', Landmarks(2,i,istep),...
            'Zdata', Landmarks(3,i,istep));
        % Clavicula
        i = [LN.SC LN.ACv];
        set(h.clav,'Xdata', Landmarks(1,i,istep),...
            'Ydata', Landmarks(2,i,istep),...
            'Zdata', Landmarks(3,i,istep));
        % Scapula
        i = [LN.TS LN.AI LN.AA];
        set(h.scap,'Xdata', Landmarks(1,i,istep),...
            'Ydata', Landmarks(2,i,istep),...
            'Zdata', Landmarks(3,i,istep));
        
        % Scapula locator
        i = [LN.SCREWTS LN.SCREWAI LN.SCREWAA];
        set(h.scaploc,'Xdata', Landmarks(1,i,istep),...
            'Ydata', Landmarks(2,i,istep),...
            'Zdata', Landmarks(3,i,istep));
        
        % Humerus
        i = [LN.GH LN.EM LN.EL];
        set(h.hum, 'Xdata', Landmarks(1,i,istep),...
            'Ydata', Landmarks(2,i,istep),...
            'Zdata', Landmarks(3,i,istep));
        % Forearm
        i = [LN.EM LN.EL LN.US LN.RS];
        set(h.fore,'Xdata', Landmarks(1,i,istep),...
            'Ydata', Landmarks(2,i,istep),...
            'Zdata', Landmarks(3,i,istep));
        % Hand
        i = [LN.US LN.RS LN.MCP2 LN.MCP5];
        set(h.hand,'Xdata', Landmarks(1,i,istep),...
            'Ydata', Landmarks(2,i,istep),...
            'Zdata', Landmarks(3,i,istep));
        
        %    t2=toc;
        %    tic
        set(findobj(gcf,'Tag','FrameNrInput'),'String',int2str(istep))
        
        set(findobj(gcf,'Tag','CurrentPosLine'),'Xdata',[istep istep])
        %    t3=toc;
        % %    set(findobj(findobj(gcf,'Tag','SegmRotAxes'),
        %     fprintf('t1: %8.2f%8.2f%8.2f\n',t1/(t1+t2+t3)*100,t2/(t1+t2+t3)*100,t3/(t1+t2+t3)*100)
        %     fprintf('Total time: %8.5f\n', t1+t2+t3)
        
    case 'Slider'
        sliderObj = findobj(gcf,'Tag', 'Slider');
        istep = round(get(sliderObj,'Value'));
        PlotFun('Plot',istep)
        
    case 'Play'
        userdata = get(gcf, 'UserData');
        nSteps = size(userdata.Landmarks,3);
        sliderObj = findobj(gcf,'Tag', 'Slider');
        istep = round(get(sliderObj,'Value'));
        playObj = findobj(gcf,'Tag','PlayButton');
        if get(playObj,'Value') == get(playObj,'Max')
            set(playObj,'String','Pause',...
                'TooltipString','Click to pause animation')
        elseif get(playObj,'Value') == get(playObj,'Min')
            set(playObj,'String','Play',...
                'TooltipString','Click to play animation')
        end
        while get(playObj,'Value') == get(playObj,'Max')
            if istep == nSteps
                set(playObj,'Value',get(playObj,'Min'));
                set(playObj,'String','Play')
                set(sliderObj,'Value',1)
                break
            end
            istep = istep + 1;
            PlotFun('Plot',istep)
            set(sliderObj,'Value',istep)
            pause(0.005)
        end
        
    case 'BrowseModel'
        currentFile = get(findobj(gcf,'Tag','inputModel'), 'String');
        if (~isempty(currentFile))
            % If a file was already loaded, start in that directory
            startPath = fileparts(currentFile);
        else
            % Start in current directory
            startPath = pwd;
        end
        
        [filename, modelPath] = uigetfile({'*.mat' 'MAT-file ';...
            '*.mat' 'MAT file (*.mat)'},...
            'Select a file',startPath);
        if exist('filename')~=0
            %    if (filename ~= 0)
            fullfileName = [modelPath filename];
            PlotFun('LoadModel',fullfileName)
        end
        
    case 'SegmRot1'
        value = get(findobj(gcf,'Tag','Popup1'),'Value');
        axes(findobj(gcf,'Tag','SegmRotAxes'))
        cla
        userdata = get(gcf,'Userdata');
        switch value
            case 1
                plot(userdata.SegmRot(:,1:3))
                legend({'z: Flex/ext','x: Lat. flexion','y: Axial rotation'},...
                    'Orientation','Vertical','color','none','box','off','location','best')
            case 2
                plot(userdata.SegmRot(:,4:6))
                legend({'y: Pro/retraction','x: Elevation/depression','z: Axial rotation'},...
                    'Orientation','Vertical','color','none','box','off','location','best')
            case 3
                plot(userdata.SegmRot(:,7:9));hold on
                %                 if size(userdata.SegmRot,2)>15
                %                     plot(userdata.SegmRot(:,15:17),'--')
                %                 end
                legend({'y: Pro/retraction','x: Medial/lateral rotation','z: Ant/Post tilt'},...
                    'Orientation','Vertical','color','none','box','off','location','best')
                hold off
            case 4
                plot(userdata.SegmRot(:,15:17))
                legend({'y: Pro/retraction','x: Medial/lateral rotation','z: Ant/Post tilt'},...
                    'Orientation','Vertical','color','none','box','off','location','best')
            case 5
                plot(userdata.SegmRot(:,10:12))
                legend({'y: Plane of elevation (pole angle)','x: Elevation','y: Axial rotation'},...
                    'Orientation','Vertical','color','none','box','off','location','best')
                
            case 6
                plot(userdata.SegmRot(:,13:14))
                legend({'z: Flexion/extension','y: pro/supination'},...
                    'Orientation','Vertical','color','none','box','off','location','best')
        end
        limy = get(gca,'Ylim');
        x = round(get(findobj(gcf,'Tag','Slider'),'Value'));hold on
        h=plot([x x],limy,'linewidth',2,'color','k','Tag','CurrentPosLine');
        set(gca,'XLim',[1 size(userdata.SegmRot,1)])
        
    case 'ShiftCurrentPos'
        currentPos = get(gca,'Currentpoint');
        istep = round(currentPos(1));
        set(findobj(gcf,'Tag','CurrentPosLine'),'Xdata',[istep istep])
        PlotFun('Plot',istep)
        set(findobj(gcf,'Tag','Slider'),'Value',istep)
        
    case 'PlotCoordSys'
        axes(findobj(gcf,'Tag','MainAxes'))
        istep = round(get(findobj(gcf,'Tag','Slider'),'Value'));
        userdata = get(gcf,'Userdata');
        Landmarks = userdata.Landmarks;
        LN = userdata.LN;
        [~, T_thor2glob] = makeLCS(Landmarks,LN,'thor',istep);
        [~, T_clav2glob] = makeLCS(Landmarks,LN,'clav',istep);
        [~, T_scap2glob] = makeLCS(Landmarks,LN,'scap',istep);
        [~, T_scaploc2glob] = makeLCS(Landmarks,LN,'scaploc',istep);
        [~, T_hum2glob]  = makeLCS(Landmarks,LN,'hum', istep);
        [~, T_fore2glob] = makeLCS(Landmarks,LN,'fore',istep);
        
        hold on
        PlotDirVec(eye(4))
        PlotDirVec(T_thor2glob)
        %         PlotDirVec(T_clav2glob)
        PlotDirVec(T_scap2glob)
        PlotDirVec(T_scaploc2glob)
        PlotDirVec(T_hum2glob)
        PlotDirVec(T_fore2glob)
        hold off
        
    case 'ShowLandmarkLabel'
        axes(findobj(gcf,'Tag','MainAxes'))
        istep = round(get(findobj(gcf,'Tag','Slider'),'Value'));
        userdata = get(gcf,'Userdata');
        Landmarks = userdata.Landmarks;
        LN = userdata.LN;
        fields = fieldnames(LN);
        hold on
        for BLnr = 1:length(fields)
            %             plot3(Landmarks(1,BLnr,istep),...
            %                   Landmarks(2,BLnr,istep),...
            %                   Landmarks(3,BLnr,istep),...
            %                   'marker','o','color','k','Tag','BL')
            text( Landmarks(1,BLnr,istep),...
                Landmarks(2,BLnr,istep),...
                Landmarks(3,BLnr,istep),...
                ['\bullet\leftarrow' char(fields(BLnr)) '('...
                num2str(Landmarks(1,BLnr,istep),'%0.2f') ','...
                num2str(Landmarks(2,BLnr,istep),'%0.2f') ','...
                num2str(Landmarks(3,BLnr,istep),'%0.2f') ')'],...
                'Tag','BL');
        end
        hold off
        
        
    case 'SetFrame'
        txt = get(findobj(gcf,'Tag','FrameNrInput'),'String');
        try
            istep = eval(txt);
            PlotFun('Plot',istep)
            set(findobj(gcf,'Tag','Slider'),'Value',istep)
        catch
            disp('Invalid entry')
        end
        
end