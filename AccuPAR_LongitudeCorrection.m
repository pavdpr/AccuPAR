function LC = AccuPAR_LongitudeCorrection( longitude, standardMeridian )
%ACCUPAR_LONGITUDECORRECTIONNAIVE Computes the Longitude Correction
%
% DETAILED DESCRIPTION:
%   This function computes the solar noon correction based on longitude.
%
% INPUTS:
%   longitude: The longitude in degrees. Longitudes in the western 
%       hemisphere are negative.
%
% OUTPUTS:
%   LC: The Longitude Correction in hours
%
% HISTORY:
%   2013-05-08: Written by Paul Romanczyk (par4249 at rit dot edu)
%   2013-07-23: Modified by Wei Yao (wxy3806 ...)
%   	Corrected the longitude correction (western longitude is negative)
%   2013-07-23: Modified by Paul Romanczyk
%       Fixed documentation
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%

longitude = longitude(:);

if nargin < 2
    % assume the standard meridians are evenly spaced every 15 deg.
    standardMeridian = 15 .* round( longitude ./ 15.0 );
else
    standardMeridian = standardMeridian(:);
    
    %error checking for two inputs
    nl = numel( longitude );
    ns = numel( standardMeridian );
    if nl == ns
        % nothing needs to be done
    elseif nl == 1
        longitude = longitude .* ones( size( standardMeridian ) );
    elseif ns == 1
        standardMeridian = standardMeridian .* ones( size( longitude ) );
    else
        error( 'AccuPAR_LongitudeCorrection:InvalidInputDimensions', ...
            'The inputs must be the same size or one input have size 1' );
    end
end

% the Longitude correction is +1/15 hr for every degree east of a standard
% meridian
LC = -( standardMeridian - longitude ) ./ 15.0;

end

