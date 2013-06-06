function data = AccuPAR_ReadCSVall( file, isDST )
%ACCUPAR_READCSVSUMMARY Reads in an AccuPAR All CSV file
%
% DETAILED DESCRIPTION:
%   This function reads in an AccuPAR All Data CSV file. This must be
%       created by performing a "SAVE AS" csv in excel and choosing the
%       "All Data" table.
%
% INPUTS:
%   file: A string containing the path to the data
%   isDST: a bool that is true if it Daylight Savings Time
%
% OUTPUTS:
%   data: An array of structures containing the data.
%   data( i ): the i th entry of the spreadsheet.
%   data.type: the type of measurement. Will always be 'summary' for this
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
%   2013-05-10: Written by Paul Romanczyk (par4249 at rit dot edu)
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%

if ~exist( file, 'file' )
    error( 'AccuPAR_ReadCSVsummary:fileDNE', ...
        [ 'The file "' file '" does not exist.' ] );
end

if nargin < 2
    isDST = false;
end

fid = fopen( file, 'r' );
tmp = textscan( fid, '%s%s%s%f%f%f%f%f%f%s%s%s%f%f%f%f%f%f%f%f%f%d%d', ...
    'Delimiter', ',', ...
    'HeaderLines', 1 );

n = numel( tmp{ 1 } );
data( n ).JulianDay = 0;

zenith = tmp{ 10 };
latitude = tmp{ 11 };
longitude = tmp{ 12 };

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
    
    % copy the zenith angle (also remove the ¡ that excel puts in when
    %   converting to a csv).
    data( i ).zenith = str2double( zenith{ i }( 1:end-1 ) );
    
    % copy the latitude (also remove the ¡ that excel puts in when
    %   converting to a csv).
    data( i ).latitude = str2double( latitude{ i }( 1:end-1 ) );
    
    % copy the longitude (also remove the ¡ that excel puts in when
    %   converting to a csv).
    data( i ).longitude = str2double( longitude{ i }( 1:end-1 ) );
    
    % copy the segment PAR values
    data( i ).seg1par = tmp{ 13 }( i );
    data( i ).seg2par = tmp{ 14 }( i );
    data( i ).seg3par = tmp{ 15 }( i );
    data( i ).seg4par = tmp{ 16 }( i );
    data( i ).seg5par = tmp{ 17 }( i );
    data( i ).seg6par = tmp{ 18 }( i );
    data( i ).seg7par = tmp{ 19 }( i );
    data( i ).seg8par = tmp{ 20 }( i );
    
    % copy the external sensor PAR
    data( i ).extpar = tmp{ 21 }( i );
    
    % copy the record ID
    data( i ).recordID = tmp{ 22 }( i );
    
    % copy the raw record ID
    data( i ).rawRecordID = tmp{ 23 }( i );
end

end

