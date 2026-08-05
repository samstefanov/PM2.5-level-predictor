options validvarname=v7;

**Note that an error may appear in the log that says
"import unsuccessful". However, the output data still appears
in the way that we want it, and we can still use it;
proc import datafile="/home/u63919907/SASPractice/final.csv"
	dbms=csv
	out=mydata 
	replace;
run;

*Sorting the data by year month and day so we can group it
later on;
proc sort data = mydata out = sortedonceagain;
	by year month day;
run;

*Creating individual columns for the PM2.5values of each
individual hour;
data keephours;
	set sortedonceagain;
	if hour = 0 then PMhour0 = PM2_5;
	if hour = 1 then PMhour1 = PM2_5;
	if hour = 2 then PMhour2 = PM2_5;
	if hour = 3 then PMhour3 = PM2_5;
	if hour = 4 then PMhour4 = PM2_5;
	if hour = 5 then PMhour5 = PM2_5;
	if hour = 6 then PMhour6 = PM2_5;
	if hour = 7 then PMhour7 = PM2_5;
	if hour = 8 then PMhour8 = PM2_5;
	if hour = 9 then PMhour9 = PM2_5;
	if hour = 10 then PMhour10 = PM2_5;
	if hour = 11 then PMhour11 = PM2_5;
	if hour = 12 then PMhour12 = PM2_5;
	if hour = 13 then PMhour13 = PM2_5;
	if hour = 14 then PMhour14 = PM2_5;
	if hour = 15 then PMhour15 = PM2_5;
	if hour = 16 then PMhour16 = PM2_5;
	if hour = 17 then PMhour17 = PM2_5;
	if hour = 18 then PMhour18 = PM2_5;
	if hour = 19 then PMhour19 = PM2_5;
	if hour = 20 then PMhour20 = PM2_5;
	if hour = 21 then PMhour21 = PM2_5;
	if hour = 22 then PMhour22 = PM2_5;
	if hour = 23 then PMhour23 = PM2_5;
	retain PMhour0 PMhour1 PMhour2
	PMhour3 PMhour4 PMhour5 PMhour6
	PMhour7 PMhour8 PMhour9 PMhour10
	PMhour11 PMhour12 PMhour13 PMhour14
	PMhour15 PMhour16 PMhour17 PMhour18
	PMhour19 PMhour20 PMhour21 PMhour22 PMhour23;
run;

*Aggregating the hourly data by day;
data tot;
	set keephours;
	by year month day;
	if first.day then do;
		PM2_5total = PM2_5;
		PM10total = PM10;
		SO2total = SO2;
		NO2total = NO2;
		COtotal = CO;
		O3total = O3;
		TEMPtotal = TEMP;
		PREStotal = PRES;
		DEWPtotal = DEWP;
		RAINtotal = RAIN;
		WSPMtotal = WSPM;
	end;
	if first.day = 0 then do;
		PM2_5total + PM2_5;
		PM10total + PM10;
		SO2total + SO2;
		NO2total + NO2;
		COtotal + CO;
		O3total + O3;
		TEMPtotal + TEMP;
		PREStotal + PRES;
		DEWPtotal + DEWP;
		RAINtotal + RAIN;
		WSPMtotal + WSPM;
	end;
	if last.day;
	drop PM2_5 PM10 SO2 NO2 CO O3 TEMP PRES DEWP RAIN WSPM;
run;

*Using the lag function to move the values of each
non PM2.5 variable to the next row after, so that we can
predict the PM2.5 value of today using the values of
yesterday. Divided certain variable by 24 to create a
daily average, rather than a daily total;
data lag;
	set tot;
	PM10yesterday = lag(PM10total)/24;
	SO2yesterday = lag(SO2total)/24;
	NO2yesterday = lag(NO2total)/24;
	COyesterday = lag(COtotal)/24;
	O3yesterday = lag(O3total)/24;
	TEMPyesterday = lag(TEMPtotal)/24;
	PRESyesterday = lag(PREStotal)/24;
	DEWPyesterday = lag(DEWPtotal)/24;
	RAINyesterday = lag(RAINtotal)/24;
	WSPMyesterday = lag(WSPMtotal)/24;
	PMhour0yesterday = lag(PMhour0);
	PMhour1yesterday = lag(PMhour1);
	PMhour2yesterday = lag(PMhour2);
	PMhour3yesterday = lag(PMhour3);
	PMhour4yesterday = lag(PMhour4);
	PMhour5yesterday = lag(PMhour5);
	PMhour6yesterday = lag(PMhour6);
	PMhour7yesterday = lag(PMhour7);
	PMhour8yesterday = lag(PMhour8);
	PMhour9yesterday = lag(PMhour9);
	PMhour10yesterday = lag(PMhour10);
	PMhour11yesterday = lag(PMhour11);
	PMhour12yesterday = lag(PMhour12);
	PMhour13yesterday = lag(PMhour13);
	PMhour14yesterday = lag(PMhour14);
	PMhour15yesterday = lag(PMhour15);
	PMhour16yesterday = lag(PMhour16);
	PMhour17yesterday = lag(PMhour17);
	PMhour18yesterday = lag(PMhour18);
	PMhour19yesterday = lag(PMhour19);
	PMhour20yesterday = lag(PMhour20);
	PMhour21yesterday = lag(PMhour21);
	PMhour22yesterday = lag(PMhour22);
	PMhour23yesterday = lag(PMhour23);
	drop VAR1 hour station PM10total SO2total NO2total COtotal O3total TEMPtotal PREStotal DEWPtotal RAINtotal WSPMtotal
	PMhour0 PMhour1 PMhour2 PMhour3 PMhour4 PMhour5 PMhour6 PMhour7 PMhour8 PMhour9 PMhour10
	PMhour11 PMhour12 PMhour13 PMhour14 PMhour15 PMhour16 PMhour17 PMhour18 PMhour19 PMhour20 PMhour21 PMhour22 PMhour23;
run;

*Exported data;
proc export data=lag
     outfile="/home/u63919907/SASPractice/lag.csv"
     dbms=csv
     replace;                                     
run;