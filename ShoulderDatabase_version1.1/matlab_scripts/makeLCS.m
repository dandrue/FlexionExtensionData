function [R,T] = makeLCS(landmarks,LN,bone,istep)
%makeLCS Calculates local coordinate systems according to ISB convention
%from landmark data

% Reference for ISB convention:
% ------------------------------------------------------------------------
% Wu et al. (2005)'ISB recommendation on definitions of joint coordinate systems of
% various joints for the reporting of human joint motion—Part II: shoulder,
% elbow, wrist and hand', Journal of Biomechanics 38, p981-992.
% ------------------------------------------------------------------------


% Inputs:
% landmarks: 3 x n x nStep matrix containing x-y-z (1st dim) coordinates
% of n landmarks (2nd dim) in nStep (3rd dim) frames.
% LN: structure relating name of the landmark (fieldname) to the
% corresponding index (2nd dim) in the matrix 'landmarks'
% bone: bone of which the local coordinate system is created. Possible
% entries are: 'thor','clav','scap','hum','fore' and 'scaploc'
% istep: index of time frame in data to process (3rd dim in 'landmarks')

% nStep = size(landmarks,3);

% Coded by Bart Bolsterlee (b.bolsterlee@tudelft.nl)
% September 2014
switch bone
    case 'thor'
        IJ = landmarks(:,1,istep);
        PX = landmarks(:,2,istep);
        C7 = landmarks(:,3,istep);
        T8 = landmarks(:,4,istep);

        % First axis (y): midpoint IJ-C7 to midpoint T8-PX
        y = (IJ + C7)/2 - (T8 + PX)/2;  y = y/norm(y)
        % Second axis (z): perpendicular to y and T8-PX
        z = cross(y,T8-PX);  z = z/norm(z)
        % Third axis (x): perpendicular to y and z
        x = cross(y,z)
        % Origin in IJ
        O = IJ
        
    case 'clav'
        IJ = landmarks(:,LN.IJ,istep);
        PX = landmarks(:,LN.PX,istep);
        C7 = landmarks(:,LN.C7,istep);
        T8 = landmarks(:,LN.T8,istep);
        SC = landmarks(:,LN.SC,istep);
        AC = landmarks(:,LN.ACv,istep);
        
        % First axis (z): from SC to AC
        z = (AC-SC)/norm(AC-SC);
        % Second axis (x): perpendicular to z and y-axis of thorax
        yt = (IJ + C7)/2 - (T8 + PX)/2;
        x = cross(yt,z); x = x/norm(x);
        % Third axis (y): perpendicular to x and z
        y = cross(z,x);
        % Origin in SC
        O = SC;
        
    case 'scap'
        AA = landmarks(:,LN.AA,istep);
        TS = landmarks(:,LN.TS,istep);
        AI = landmarks(:,LN.AI,istep);
        % First axis (z): from TS to AA, point to AA
        z = (AA-TS) / norm(AA-TS);
        % Second axis (x): perpendicular to z and AA-AI
        x = cross((AA-AI),z); x = x/norm(x);
        % Third axis (y): perpendicular to x and z
        y = cross(z,x);
        % Origin in AA
        O = AA;
        
    case 'scaploc'
        AA = landmarks(:,LN.SCREWAA,istep);
        TS = landmarks(:,LN.SCREWTS,istep);
        AI = landmarks(:,LN.SCREWAI,istep);
        % First axis (z): from TS to AA, point to AA
        z = (AA-TS) / norm(AA-TS);
        % Second axis (x): perpendicular to z and AA-AI
        x = cross((AA-AI),z); x = x/norm(x);
        % Third axis (y): perpendicular to x and z
        y = cross(z,x);
        % Origin in AA
        O = AA;
        
    case 'hum'
        GH = landmarks(:,LN.GH,istep);
        EL = landmarks(:,LN.EL,istep);
        EM = landmarks(:,LN.EM,istep);
        % First axis (y): from GH to midpoint EM-EL
        y = GH-(EM+EL)/2;y = y/norm(y);
        % Second axis (x): perpendicular to y and EM-EL, pointing forward
        x = cross(y,EL-EM); x = x/norm(x);
        % Third axis (z): perpendicular to x and y
        z = cross(x,y);
        % Origin in GH
        O = GH;
        
    case 'fore'
        EL = landmarks(:,LN.EL,istep);
        EM = landmarks(:,LN.EM,istep);
        US = landmarks(:,LN.US,istep);
        RS = landmarks(:,LN.RS,istep);        
        % First axis (y): from midpoint US to EM-EL, pointing proximally
        y = (EM+EL)/2 - US;y = y/norm(y);
        % Second axis (x): perpendicular to plane through RS, US and
        % midpoint EM-EL
        x = cross(y,RS-US);x = x/norm(x);
        % Third axis (z): perpendicular to x and y
        z = cross(x,y);
        % Origin in US
        O = US;
        
    otherwise
        disp(['Unknown option ' bone ''''])
        x=[];y=[];z=[];O=[]; 
%         return
           

end
R = [x y z];
T = [R O;0 0 0 1];


end
