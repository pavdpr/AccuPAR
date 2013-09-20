function data = AccuPAR_ReadXLSsummary( file, isDST )
%ACCUPAR_READCSVSUMMARY Reads in an AccuPAR Summary XLS file
%
% DETAILED DESCRIPTION:
%   This function reads in an AccuPAR Summary XLS file. 
%
% INPUTS:
%   file: A string containing the path to the data
%   isDST: a bool that is true if it Daylight Savings Time
%
% OUTPUTS:
%   data: An array of structures containing the data.
%   data( i ): the i th entry of the spreadsheet.
%   data.type: the type of measurement. Will always be 'SUM' for this
%       function
%   data.JulianDay: The Julian Day.
%   data.t: The time in hours, corrected for daylight savings.
%   data.year: the year
%   data.Annotation: any annotation to the AccuPAR file. If there is a
%       comma in the annotation, the reading in will break.data
%   data.avgAbovePAR: the average above PAR.
%   data.avgBelowPAR: the average below PAR.
%   data.LAI: the leaf area index.
%   data.tau: the ratio of the avg Above PAR to the avg Below PAR.
%   data.LeafDistribution: the leaf angle distribution (chi).
%   data.BeamFraction: The beam fraction (fb)
%   data.zenith: the zenith angle (degrees)
%   data.latitude: the latitude (degrees)
%   data.longitude: the longitude (degrees)
%
% HISTORY:
%   2013-05-09: Written by Paul Romanczyk (par4249 at rit dot edu)
%   2013-09-20: Added RIT Copyright
%
% COPYRIGHT:
%   (C) 2013 Rochester Institute of Technology
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%

if ~exist( file, 'file' )
    error( 'AccuPAR_ReadXLSsummary:fileDNE', ...
        [ 'The file "' file '" does not exist.' ] );
end

if nargin < 2
    isDST = false;
end

[tmp_num, tmp_txt, ~] = xlsread(file, 'Summary Data');

tmp_txt = tmp_txt(2:end,:);  % remove the row of title

tmp = cell(1,12);

tmp{1} = tmp_txt(:,1);
%tmp{2} = tmp_num(:,1);
tmp{3} = tmp_txt(:,3);
tmp{4} = tmp_num(:,3);
tmp{5} = tmp_num(:,4);
tmp{6} = tmp_num(:,5);
tmp{7} = tmp_num(:,6);
tmp{8} = tmp_num(:,7);
tmp{9} = tmp_num(:,8);
tmp{10} = tmp_num(:,9);
tmp{11} = tmp_num(:,10);
tmp{12} = tmp_num(:,11);

n = numel( tmp{ 1 } );

datetime_str = cell(n,1);
datetime_num = tmp_num(:,1) + datenum('30-Dec-1899');

for i = 1:n
    datetime_str{i} = datestr(datetime_num(i),'mm/dd/yyyy HH:MM:SS AM');
    idx1 = strfind( datetime_str{i}, ' ' );
    if numel( idx1 ) == 3 && idx1(2)==idx1(1)+1
        datetime_str{i}(idx1(2)) =[];
    end
end
tmp{2} = datetime_str;

data( n ).JulianDay = 0;

for i = 1:n
    % copy the data type
    data( i ).type = tmp{ 1 }( i );
    while iscell( data( i ).type )
        data( i ).type = data( i ).type{ 1 };
    end
    
    % compute Julian Day, time, and year
    [ data( i ).JulianDay, data( i ).t, data( i ).year ] = ...
        AccuPAR_DateTime( tmp{ 2 }( i ), isDST );
    
    % copy an any annotation
    data( i ).Annotation = tmp{ 3 }( i );
    % if needed, take out of cell
    while iscell( data( i ).Annotation )
        data( i ).Annotation = data( i ).Annotation{ 1 };
    end
    
    % copy the average above PAR
    data( i ).avgAbovePAR = tmp{ 4 }( i );
    
    % copy the average below PAR
    data( i ).avgBelowPAR = tmp{ 5 }( i );
    
    % copy the LAI
    data( i ).LAI = tmp{ 6 }( i );
    
    % copy the tau
    data( i ).tau = tmp{ 7 }( i );
    
    % copy the leaf Distribution
    data( i ).LeafDistribution = tmp{ 8 }( i );
    
    % copy the beam fraction
    data( i ).BeamFraction = tmp{ 9 }( i );
    
    % copy the zenith angle 
    data( i ).zenith = tmp{ 10 }( i );
    
    % copy the latitude 
    data( i ).latitude = tmp{ 11 }( i );
    
    % copy the longitude 
    data( i ).longitude = tmp{ 12 }( i );
end


end

