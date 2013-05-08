function tau = AccuPAR_transmittedPAR_Goudriaan( fb, a )
%ACCUPAR_TRANSMITTEDPAR_GOUDRIAAN computes fraction of transmitted PAR
%according to Goudriaan (1988)
%
% DETAILED DESCRIPTION:
%   This function computes the fraction of transmitted PAR by using
%       Goudriann (1988).
%
% INPUTS:
%   fb: the fraction of incident PAR from the sun vs other sources. Can be
%       computed by using AccuPAR_BeamFraction.m
%   a: (optional) the leaf absorbtivity in the PAR band. Default is 0.9
%
% OUTPUTS:
%   tau: the fraction of transmitted light in the PAR band
%
% HISTORY:
%   2013-05-08: Written by Paul Romanczyk (par4249 at rit dot edu)
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%   Goudriann, J. (1988) The bare bones of leaf angle distribution in
%       radiation models for canopy photosynthesis and energy exchange.
%       Agriculture and Forest Meteorology, 43:155-169.

if nargin < 2
    a = 0.9;
end

fb = fb(:);
a = a(:);

nf = numel( fb );
na = numel( a );

if nf == na
    % nothing to do
elseif na == 1
    a = a .* ones( size( fb ) );
elseif nf == 1
    fb = fb .* ones( size( a ) );
else
    error( 'AccuPAR_transmittedPAR_Goudriaan:InvalidInputDimensions', ...
        'The inputs must be the same size or one input have size 1' );
end

% equation 11
tau = fb .* exp( -sqrt( a ) ) + ( 1 - fb ) .* exp( -0.87 .* sqrt( a ) );
end

