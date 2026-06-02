clc;
clear;

disp("GPS Positioning for Drone -> Fire Target");

%% USER INPUT: DRONE GPS LOCATION
droneLat = input("Enter drone latitude (deg): ");
droneLon = input("Enter drone longitude (deg): ");
droneAlt = input("Enter drone altitude (m): ");

%% USER INPUT: FIRE GPS LOCATION
fireLat = input("Enter fire latitude (deg): ");
fireLon = input("Enter fire longitude (deg): ");
fireAlt = input("Enter fire altitude (m): ");

%% FORM LLA VECTORS
lla0 = [droneLat, droneLon, droneAlt];   % reference = drone position
llaFire = [fireLat, fireLon, fireAlt];

%% CONVERT FIRE GPS TO LOCAL NED COORDINATES
xyzNED = lla2ned(llaFire, lla0, "flat");

north = xyzNED(1);
east  = xyzNED(2);
down  = xyzNED(3);

%% OPTIONAL: CONVERT TO UNITY-STYLE AXES
x = east;
y = -down;
z = north;

%% DISPLAY RESULTS
fprintf("\n--- LOCAL TARGET LOCATION ---\n");
fprintf("North : %.2f m\n", north);
fprintf("East  : %.2f m\n", east);
fprintf("Down  : %.2f m\n", down);

fprintf("\n--- UNITY STYLE LOCATION ---\n");
fprintf("X = %.2f\n", x);
fprintf("Y = %.2f\n", y);
fprintf("Z = %.2f\n", z);