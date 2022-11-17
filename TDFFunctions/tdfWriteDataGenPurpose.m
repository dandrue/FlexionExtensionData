function res = tdfWriteDataGenPurpose (filename,startTime,frequency,gpMap,labels,gpData,varargin)
%TDFWRITEDATAGENPURPOSE   Write GeneralPurpose Data to TDF-file.
%   RES = TDFWRITEDATAGENPURPOSE (FILENAME,STARTTIME,FREQUENCY,GPMAP,LABELS,GPDATA) writes 
%   to FILENAME the GP data sampling start time ([s]) and sampling rate ([Hz]),
%   the correspondance map between GP logical channels and physical channels stored
%   in GPMAP, the GP channel labels stored in LABELS and the GP data stored in GPDATA.
%   GPMAP must be a [nSignals,1] array such that GPMAP(logical channel) == physical channel.
%   LABELS must be a matrix whose rows are the GP channel labels.
%   GPDATA must be an array of size nSignals x nSamples such that
%   GPDATA(s,:) stores the samples of the GP channel s. 
%
%   res = TDFWRITEDATAGENPURPOSE (...,FORMAT) specifies the format for the GP data block.
%   Valid entries for FORMAT are 'bytrack' (default), 'byframe'.
%   See Tdf File format documentation for further details.
%
%   If the file specified does not exist, a new one is created.
%   RES is 0 in case of success, -1 otherwise.
%
%   See also TDFREADDATAGENPURPOSE
%
%   Copyright (c) 2000 by BTS S.p.A.
%   $Revision: 3 $ $Date: 1/23/12 4:02p $

if (nargin == 6)
   strFormat   = 'bytrack';
else
   strFormat   = varargin{1};
end

switch strFormat
case 'bytrack'
   blockFormat = 1;
case 'byframe'
   blockFormat = 2;
otherwise
   disp ('Error: invalid block format')
   return
end

tdfDataGPBlockId = 14;
res = -1;

[fid,entryOffset,blockOffset] = tdfFileTest (filename,tdfDataGPBlockId);
if fid == -1
   return
end

if (-1 == fseek (fid,blockOffset,'bof'))
   disp ('Error: the file specified is corrupted.')
   tdfFileClose (fid);
   return
end

nSignals = length (gpMap);
nSamples = size (gpData,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% write header information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fwrite (fid,nSignals,'int32');
fwrite (fid,frequency,'int32');
fwrite (fid,startTime,'float32');
fwrite (fid,nSamples,'int32');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% write GP map information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fwrite (fid,gpMap,'int16');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% write GP data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

labelsToWrite = char (zeros (nSignals,256));
labelLen = size (labels,2);
for l = 1 : size (labels,1)
   labelsToWrite(l,1:labelLen) = labels(l,:);
end

if (1 == blockFormat)
   for e = 1 : nSignals
      fwrite (fid,labelsToWrite(e,:),'char');
      invalidFrames = cat(2,0,find (~isfinite (gpData(e,:))),nSamples+1);
      segLens = diff (invalidFrames)-1;
      segments = cat (1,invalidFrames (find (segLens>0)),segLens (find (segLens>0)));
      nSegments = size (segments,2);
      fwrite (fid,nSegments,'int32');
      fwrite (fid,0,'uint32');
      fwrite (fid,segments,'int32');
      for s = 1 : nSegments
         fwrite (fid,gpData(e,segments(1,s)+1 : (segments(1,s)+segments(2,s))),'float32');
      end
   end
elseif (2 == blockFormat)
   for e = 1 : nSignals
      fwrite (fid,labelsToWrite(e,:),'char');
   end
   fwrite (fid,gpData','float32');
end   

newBlockOffset = ftell (fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% write entry information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fseek (fid,entryOffset,'bof');
fwrite (fid,tdfDataGPBlockId,'uint32');
fwrite (fid,blockFormat,'uint32');
fwrite (fid,blockOffset,'int32');
fwrite (fid,newBlockOffset-blockOffset,'int32');
tdfTime = (now - datenum ('02-Jan-1970 00:00:00') ) * 24 * 60 * 60;
fwrite (fid,tdfTime,'int32');
fwrite (fid,tdfTime,'int32');
fwrite (fid,tdfTime,'int32');
fwrite (fid,0,'uint32');
fwrite (fid,char (zeros (1,256)),'char');

tdfFileFinalize (fid,newBlockOffset);             % close the file
res = 0;




