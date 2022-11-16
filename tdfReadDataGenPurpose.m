function [startTime,frequency,gpMap,labels,gpData] = tdfReadDataGenPurpose (filename)
%TDFREADDATAGENPURPOSE   Read GeneralPurpose Data from TDF-file.
%   [STARTTIME,FREQUENCY,GPMAP,LABELS,GPDATA] = TDFREADDATAGENPURPOSE (FILENAME) retrieves
%   the GP sampling start time ([s]) and sampling rate ([Hz]), 
%   the correspondance map between GP logical channels and physical channels 
%   and the GP data stored in FILENAME.
%   GPMAP is a [nSignals,1] array such that GPMAP(logical channel) == physical channel. 
%   LABELS is a matrix with the text strings of the GP channels as rows.
%   GPDATA is a [nSignals,nSamples] array such that GPDATA(s,:) stores 
%   the samples of the signal s. 
%
%   See also TDFWRITEDATAGENPURPOSE
%
%   Copyright (c) 2000 by BTS S.p.A.
%   $Revision: 3 $ $Date: 1/23/12 3:19p $

gpMap=[]; gpData=[];
globalStartTime=0;
frequency=0;

[fid,tdfBlockEntries] = tdfFileOpen (filename);   % open the file
if fid == -1
   return
end

tdfDataGPBlockId = 14;
blockIdx = 0;
for e = 1 : length (tdfBlockEntries)
   if (tdfDataGPBlockId == tdfBlockEntries(e).Type) & (0 ~= tdfBlockEntries(e).Format)
      blockIdx = e;
      break
   end
end
if blockIdx == 0
   disp ('GP Data not found in the file specified.')
   tdfFileClose (fid);
   return
end

if (-1 == fseek (fid,tdfBlockEntries(blockIdx).Offset,'bof'))
   disp ('Error: the file specified is corrupted.')
   tdfFileClose (fid);
   return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read header information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nSignals  = fread (fid,1,'int32');
frequency = fread (fid,1,'int32');
startTime = fread (fid,1,'float32');
nSamples = fread (fid,1,'int32')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read gp map information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gpMap = fread (fid,nSignals,'int16');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read gp data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

labels   = char (zeros (nSignals,256));
gpData  = NaN * ones(nSignals,nSamples);

if (1 == tdfBlockEntries(blockIdx).Format)         % by track
   
  for e = 1 : nSignals
      label      = strtok (char ((fread (fid,256,'uchar'))'), char (0));
      labels (e,1:length (label)) = label;
      nSegments  = fread (fid,1,'int32');
      fseek (fid,4,'cof');
      segments   = fread (fid,[2,nSegments],'int32');
      for s = 1 : nSegments
         gpData(e,segments(1,s)+1 : (segments(1,s)+segments(2,s))) = (fread (fid,segments(2,s),'float32'))';
      end
   end
   
elseif (2 == tdfBlockEntries(blockIdx).Format)     % by frame
   
   for e = 1 : nSignals
      label = strtok (char ((fread (fid,256,'uchar'))'), char (0));
      labels (e,1:length (label)) = label;
   end
   for frm = 1 : nSamples
     for sign = 1 : nSignals 
       gpData(sign, frm) = (fread (fid,1,'float32'))';
     end
   end
   
end

tdfFileClose (fid);                               % close the file
