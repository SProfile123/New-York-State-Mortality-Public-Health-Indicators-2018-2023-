/* Mortality Analysis in SAS
   Data: CDC WONDER - NY Mortality 2018–2023
*/

/* Step 1: Import dataset */
proc import datafile="ny_mortality_by_year.csv"
    out=mortality
    dbms=csv
    replace;
    getnames=yes;
run;

/* Step 2: Explore dataset */
proc contents data=mortality; run;
proc print data=mortality (obs=10); run;

/* Step 3: Summary statistics */
proc means data=mortality mean sum min max;
    var Deaths Population Crude_Rate;
run;

/* Step 4: Deaths by Year */
proc sql;
    create table yearly as
    select Year,
           sum(Deaths) as total_deaths,
           mean(Crude_Rate) as avg_crude_rate
    from mortality
    group by Year
    order by Year;
quit;

proc print data=yearly; run;

/* Step 5: Save charts as images */
ods graphics on;
ods listing gpath="." image_dpi=300;

/* Line chart: Crude Mortality Rate */
proc sgplot data=mortality;
    series x=Year y=Crude_Rate / markers lineattrs=(color=blue thickness=2);
    scatter x=Year y=Crude_Rate / markerattrs=(symbol=circlefilled color=red size=10);
    xaxis label="Year";
    yaxis label="Crude Mortality Rate per 100,000";
    title "Crude Mortality Rate in New York (2018–2023)";
run;

/* Bar chart: Death Counts */
proc sgplot data=mortality;
    vbar Year / response=Deaths datalabel fillattrs=(color=steelblue);
    xaxis label="Year";
    yaxis label="Total Deaths";
    title "Annual Death Counts in New York (2018–2023)";
run;

/* Pie chart (if cause of death is included) */
proc sgplot data=mortality;
    pie Year / response=Deaths datalabel;
    title "Share of Deaths by Year (2018–2023)";
run;

ods graphics off;
