function zenith = AccuPAR_SolarZenith( latitude, declination, t, solarNoon, latDeg )
%ACCUPAR_SOLARZENITH Computes the solar zenith angle
%
% DETAILED DESCRIPTION:
%   This function computes the solar zenith angle in radians. Equation 30
%
% INPUTS:
%   latitude: the latitude in radians (this can be degrees if latDeg is set
%       to true)
%   declination: the declination angle in radians. This can be computed
%       from AccuPAR_SolarDeclination.m
%   t: the time in hours
%   solarNoon: the time of solarNoon in hours. This can be computed from
%       AccuPAR_SolarNoon.m.
%   latDeg: (optional) set to true if latitude is in degrees. Default is
%       false.
%
% OUTPUTS:
%   zenith: the solar zenith angle in radians
%
% HISTORY:
%   2013-05-08: Written by Paul Romanczyk (par4249 at rit dot edu)
%   2013-09-20: Added RIT Copyright
%
% COPYRIGHT:
%   (C) 2013 Rochester Institute of Technology
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%


if nargin < 5
    latDeg = false;
end

if latDeg
    latitude = latitude .* ( pi / 180.0 );
end

latitude = latitude(:);
declination = declination(:);
t = t(:);
solarNoon = solarNoon(:);

% error checking and data formating
nl = numel( latitude );
nd = numel( declination );
nt = numel( t );
ns = numel( solarNoon );

n = [ nl nd nt ns ];
u = unique( n );

if numel( u ) == 1
    % all values are the same, nothing to do
elseif numel( u ) == 2
    if sum( n == 1 ) ~= 0
        n = u( 2 );
        if nl == 1
            latitude = latitude .* ones( n, 1 );
        end
        if nd == 1
            declination = declination .* ones( n, 1 );
        end
        if nt == 1
            t = t .* ones( n, 1 );
        end
        if ns == 1
            solarNoon = solarNoon .* ones( n, 1 );
        end
    else
        error( 'AccuPAR_SolarZenith:InvalidInputDimensions', ...
        'The inputs must be the same size n or 1' );
    end
else
    error( 'AccuPAR_SolarZenith:InvalidInputDimensions', ...
        'The inputs must be the same size n or 1' );
end

% equation 30
zenith = acos( sin( latitude ) .* sin( declination ) + ...
    cos( latitude ) .* cos( declination ) .* ...
    cos( 0.2618 .* ( t - solarNoon ) ) );

end

