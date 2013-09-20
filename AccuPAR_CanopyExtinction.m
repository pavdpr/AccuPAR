function K = AccuPAR_CanopyExtinction( solarZenith, leafAngleDistribution )
%ACCUPAR_CANOPYEXTINCTION Computes the canopy extinction
%
% DETAILED DESCRIPTION:
%   This function computes the fraction of canopy extinction by using
%       Campbell (1986). This function assumes a ellipsoidal leaf angle
%       distribution.
%
% INPUTS:
%   solarZenith: the solar zenith angle in radians. Can be computed by
%       using AccuPAR_SolarZenith.m.
%   leafAngleDistribution: (optional) The leaf angle distribution. 1 is
%       spherical. The default is 1.
%
% OUTPUTS:
%   K: the canopy extinction
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
%   Campbell, G.S. (1986) Extinction coefficeints for radiation in plant
%       canopies calculated using an ellipsoidal inclination angle
%       distribution. Agricultral and Forest Meteorology, 36:317-321.

solarZenith = solarZenith(:);

if ( nargin < 2 ) || ( sum( ( leafAngleDistribution == 1 ) ) == ...
        numel( leafAngleDistribution ) )
    % assume leafAngleDistribution is 1.0
    % equation 12 reduces to this form
    % equation 13
    K = 1 ./ ( 2 .* cos( solarZenith ) );
    return;
end

leafAngleDistribution = leafAngleDistribution(:);

% error checking
nl = numel( leafAngleDistribution );
ns = numel( solarZenith );

if nl == ns
    % nothing to do
elseif ns == 1
    solarZenith = solarZenith .* ones( size( leafAngleDistribution ) );
elseif nl == 1
    leafAngleDistribution = ...
        leafAngleDistribution .* ones( size( solarZenith ) );
else
    error( 'AccuPAR_CanopyExtinction:InvalidInputDimensions', ...
        'The inputs must be the same size or one input have size 1' );
end

% equation 12
K = sqrt( leafAngleDistribution .^ 2 + tan( solarZenith ) .^2 ) ./ ...
    ( leafAngleDistribution + 1.744 .* ( leafAngleDistribution + ...
    1.182 ) .^ -0.733 );


end

