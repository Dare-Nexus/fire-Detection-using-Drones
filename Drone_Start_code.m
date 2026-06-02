clc;
clear;

%% SERIAL SETTINGS
port = "COM3";
baud = 9600;

dev = serialport(port, baud);
configureTerminator(dev, "CR/LF");
flush(dev);
dev.Timeout = 1.0;

pause(2);
disp("MATLAB ready.");

%% TARGET / FIRE LOCATION
x = -289.2;
y = 0.00;
z = -764.9;

msg = sprintf("FIRE,%.2f,%.2f,%.2f", x, y, z);
writeline(dev, msg);
disp("Sent to Unity: " + msg);

%% FLAGS
fireConfirmed = false;
noFire = false;
returningHome = false;
missionComplete = false;
truckDeployed = false;
landingOnTruck = false;

t0 = tic;
maxWait = 120;

disp("Waiting for Unity status...");

%% MAIN LOOP
while ~missionComplete && toc(t0) < maxWait

    if dev.NumBytesAvailable > 0
        data = readline(dev);

        if isempty(data)
            pause(0.05);
            continue;
        end

        data = strtrim(string(data));
        disp("From Unity: " + data);

        parts = split(data, ",");

        if numel(parts) >= 2
            tag = upper(strtrim(parts(1)));
            value = upper(strtrim(parts(2)));

            if tag == "STATUS"
                switch value
                    case "FIRE_CONFIRMED"
                        fireConfirmed = true;
                        disp("Fire confirmed.");

                    case "NO_FIRE"
                        noFire = true;
                        disp("No fire confirmed.");

                    case "RETURNING_HOME"
                        returningHome = true;
                        disp("Drone returning home.");

                    case "TRUCK_DEPLOYED"
                        truckDeployed = true;
                        disp("Truck deployed.");

                    case "LANDING_ON_TRUCK"
                        landingOnTruck = true;
                        disp("Drone landing on truck.");

                    case "MISSION_COMPLETE"
                        missionComplete = true;
                        disp("Mission complete.");

                    otherwise
                        disp("Unknown STATUS: " + value);
                end
            else
                disp("Unrecognized packet: " + data);
            end
        else
            disp("Malformed packet: " + data);
        end
    end

    pause(0.05);
end

%% FINAL REPORT
disp(" ");
disp("===== FINAL MISSION REPORT =====");
disp("Fire confirmed    : " + string(fireConfirmed));
disp("No fire           : " + string(noFire));
disp("Returning home    : " + string(returningHome));
disp("Truck deployed    : " + string(truckDeployed));
disp("Landing on truck  : " + string(landingOnTruck));
disp("Mission complete  : " + string(missionComplete));

if ~missionComplete
    disp("Timeout waiting for Unity.");
end

clear dev;
disp("Serial closed.");
