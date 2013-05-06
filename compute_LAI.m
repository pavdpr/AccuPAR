% Process LAI data from AccuPAR 

field_filename = uipickfiles('filterspec','/Users/Kelbe/Desktop/*csv', 'prompt', 'Please choose field data sheet');
log_filename = uipickfiles('filterspec','/Users/Kelbe/Desktop/*.csv', 'prompt', 'Please choose log data sheet')';

field_filename = field_filename{1};
log_filename = log_filename{1};

field_fid = fopen(field_filename);
log_fid = fopen(log_filename);



field = textscan(field_fid,'%s%s%s%f%f%f%f%f%f%f%f%f', 'headerlines',1, 'delimiter', ',');
log = textscan(log_fid,'%s%s%s%f%f%f%f%f%f%f%f%f', 'headerlines',1, 'delimiter', ',');

field_time = char(field{2});
field_annotation = field{3};
field_belowPAR = field{5};
field_leafdistribution = field{8};
field_zenith = field{10};
field_latitude = field{11};
field_long
itude = field{12};

log_time = char(log{2});
log_belowPAR = log{5};

field_hours = str2num(field_time(:,1:2));
field_minutes = str2num(field_time(:,4:5));
field_seconds = str2num(field_time(:,7:8));

log_hours = str2num(log_time(:,1:2));
log_minutes = str2num(log_time(:,4:5));
log_seconds = str2num(log_time(:,7:8));

field_relativetime = (3600*field_hours)+(60*field_minutes)+field_seconds;
log_relativetime = (3600*log_hours)+(60*log_minutes)+log_seconds;



field_lastlogPAR = 



%log_data = textscan(log_fid);

 