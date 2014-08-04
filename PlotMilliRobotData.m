% Sample analysis of milli robot and milli bug data
% Sarah Bergbreiter
% 3 December 2013

clf;
clear;

[num,txt,MilliRobotData] = xlsread('MilliRobotBugData.xlsx','MilliRobots');
[num,txt,MilliInsectData] = xlsread('MilliRobotBugData.xlsx','MilliBugs');

% Some useful numbers
headerOffset = 2;                           % row offset due to headers in excel file
numRobots = size(MilliRobotData,1)-headerOffset;       
numBugs = size(MilliInsectData,1)-headerOffset;
% Column numbers
nameC = 1;
movedC = 6;
powerAutonomyC = 7;
controlAutonomyC = 8;
sensingAutonomyC = 9;
commsAutonomyC = 10;
time1mC = 28;
energy1mC = 29;
cotC = 30;
numMotorsC = 33;
massC = 37;
charLengthC = 38;

for i=1:numRobots
    name{i} = MilliRobotData{i+headerOffset,nameC};        
end

for i=numRobots+1:numBugs+numRobots
    name{i} = MilliInsectData{i-numRobots+headerOffset,nameC};     
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Autonomy
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Figure1=figure(1);
clf(Figure1);
set(Figure1,'PaperUnits','inches','PaperSize',[6.5 4.5],'PaperPosition',[0,0,6.5,4.5]);

charLength = zeros(numRobots+numBugs,1);
mass = zeros(numRobots+numBugs,1);
autonomy = zeros(numRobots+numBugs,1);

subplot(1,2,1)
for i=1:numRobots
    j = i+headerOffset;
    autonomytotal = MilliRobotData{j,powerAutonomyC} + MilliRobotData{j,controlAutonomyC} + MilliRobotData{j,sensingAutonomyC} + MilliRobotData{j,commsAutonomyC};
    if (MilliRobotData{j,movedC} == 1)
        charLength(i) = MilliRobotData{j,charLengthC}*1e3;
        autonomy(i) = autonomytotal;
        semilogx(charLength(i),autonomy(i),'rx','MarkerSize',15,'LineWidth',2);
        hold on;
    end
end

textfit(charLength,autonomy,name,'FontSize',6);

oldaxis = axis;
axis([1 oldaxis(2) -1 4])
xlabel('Characteristic Length (mm)');
ylabel('Autonomy');
set(gca,'FontSize',9)

hold off;

subplot(1,2,2)
for i=1:numRobots
    j = i+headerOffset;
    autonomytotal = MilliRobotData{j,powerAutonomyC} + MilliRobotData{j,controlAutonomyC} + MilliRobotData{j,sensingAutonomyC} + MilliRobotData{j,commsAutonomyC};
    if (MilliRobotData{j,movedC} == 1)
        mass(i) = MilliRobotData{j,massC}*1e6;
        autonomy(i) = autonomytotal;
        semilogx(mass(i),autonomy(i),'rx','MarkerSize',15,'LineWidth',2);
        hold on;
    end
end
textfit(mass,autonomy,name,'FontSize',6);

oldaxis = axis;
axis([1e-3 oldaxis(2) -1 4])
xlabel('Mass (mg)');
ylabel('Autonomy');
set(gca,'FontSize',9)

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.99,'\bf Autonomy = On-board power + sensing + control + communications','HorizontalAlignment','center','VerticalAlignment', 'top');

hold off;

opts2 = struct('color','cmyk','LineWidthMin',2,'Resolution',600,'Renderer','painters','FontMode','fixed','FontSize',9);
exportfig(gcf,'Autonomy.eps',opts2,'width',6.5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Energy to move 1m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Figure2=figure(2);
clf(Figure2);
set(Figure2,'PaperUnits','inches','PaperSize',[6.5 4.5],'PaperPosition',[0,0,6.5,4.5]);

charLength = zeros(numRobots+numBugs,1);
mass = zeros(numRobots+numBugs,1);
energy = zeros(numRobots+numBugs,1);

subplot(1,2,1)
for i=1:numRobots
    j = i+headerOffset;
    if ((MilliRobotData{j,movedC} == 1) && ~isnan(MilliRobotData{j,energy1mC}))
        if (MilliRobotData{j,powerAutonomyC} == 1)
            c = 'b';
        else
            c = 'r';
        end
        charLength(i) = MilliRobotData{j,charLengthC}*1e3;
        energy(i) = MilliRobotData{j,energy1mC};
        loglog(charLength(i),energy(i),'x','MarkerSize',15,'LineWidth',2,'Color',c);

        text(charLength(i),energy(i),MilliRobotData{j,nameC},'FontSize',10);
        
        hold on;
    end
end

for i=numRobots+1:numRobots+numBugs
    j = i-numRobots+headerOffset;
    charLength(i) = MilliInsectData{j,charLengthC}*1e3;
    energy(i) = MilliInsectData{j,energy1mC};
    loglog(charLength(i),energy(i),'ko','MarkerSize',15,'LineWidth',2);
    
    text(charLength(i),energy(i),MilliInsectData{j,nameC},'FontSize',10);

end

% length_text = charLength(charLength~=0);
% energy_text = energy(energy~=0);
% textfit(length_text,energy_text,name(charLength~=0),'FontSize',6);

oldaxis = axis;
axis([2 oldaxis(2) oldaxis(3) oldaxis(4)])
xlabel('Characteristic Length (mm)');
ylabel('Energy to move 1 m (J)');

hold off;

subplot(1,2,2)
energy = zeros(numRobots+numBugs,1);
for i=1:numRobots
    j = i+headerOffset;
    if ((MilliRobotData{j,movedC} == 1) && ~isnan(MilliRobotData{j,energy1mC}))
        if (MilliRobotData{j,powerAutonomyC} == 1)
            c = 'b';
        else
            c = 'r';
        end
        mass(i) = MilliRobotData{j,massC}*1e6;
        energy(i) = MilliRobotData{j,energy1mC};
        loglog(mass(i),energy(i),'x','MarkerSize',15,'LineWidth',2,'Color',c);

        text(mass(i),energy(i),MilliRobotData{j,nameC},'FontSize',10);
        
        hold on;
    end
end

for i=numRobots+1:numRobots+numBugs
    j = i-numRobots+headerOffset;
    mass(i) = MilliInsectData{j,massC}*1e6;
    energy(i) = MilliInsectData{j,energy1mC};
    loglog(mass(i),energy(i),'ko','MarkerSize',15,'LineWidth',2);
    
    text(mass(i),energy(i),MilliInsectData{j,nameC},'FontSize',10);

end

% mass_text = mass(mass~=0);
% energy_text = energy(energy~=0);
% textfit(mass_text,energy_text,name(mass~=0),'FontSize',6);

% oldaxis = axis;
% axis([0.5 oldaxis(2) oldaxis(3) oldaxis(4)])
xlabel('Mass (mg)');
ylabel('Energy to move 1 m (J)');
set(gca,'FontSize',12)

hold off;

opts2 = struct('color','cmyk','LineWidthMin',2,'Resolution',600,'Renderer','painters','FontMode','scaled','FontSize',1);
exportfig(gcf,'Energy.eps',opts2,'width',6.5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time to move 1 m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Figure3=figure(3);
clf(Figure3);
set(Figure3,'PaperUnits','inches','PaperSize',[6.5 4.5],'PaperPosition',[0,0,6.5,4.5]);

charLength = zeros(numRobots+numBugs,1);
mass = zeros(numRobots+numBugs,1);
time = zeros(numRobots+numBugs,1);

subplot(1,2,1)
for i=1:numRobots
    j = i+headerOffset;
    if ((MilliRobotData{j,movedC} == 1) && ~isnan(MilliRobotData{j,time1mC}))
        if (MilliRobotData{j,powerAutonomyC} == 1)
            c = 'b';
        else
            c = 'r';
        end
        charLength(i) = MilliRobotData{j,charLengthC}*1e3;
        time(i) = MilliRobotData{j,time1mC};
        loglog(charLength(i),time(i),'x','MarkerSize',15,'LineWidth',2,'Color',c);

        text(charLength(i),time(i),MilliRobotData{j,nameC},'FontSize',6);
        
        hold on;
    end
end

for i=numRobots+1:numRobots+numBugs
    j = i-numRobots+headerOffset;
    charLength(i) = MilliInsectData{j,charLengthC}*1e3;
    time(i) = MilliInsectData{j,time1mC};
    loglog(charLength(i),time(i),'ko','MarkerSize',15,'LineWidth',2);
    
    text(charLength(i),time(i),MilliInsectData{j,nameC},'FontSize',6);

end

oldaxis = axis;
axis([2 oldaxis(2) oldaxis(3) oldaxis(4)])
xlabel('Characteristic Length (mm)');
ylabel('Time to move 1 m (s)');

hold off;

subplot(1,2,2)
time = zeros(numRobots+numBugs,1);
for i=1:numRobots
    j = i+headerOffset;
    if ((MilliRobotData{j,movedC} == 1) && ~isnan(MilliRobotData{j,time1mC}))
        if (MilliRobotData{j,powerAutonomyC} == 1)
            c = 'b';
        else
            c = 'r';
        end
        mass(i) = MilliRobotData{j,massC}*1e6;
        time(i) = MilliRobotData{j,time1mC};
        loglog(mass(i),time(i),'x','MarkerSize',15,'LineWidth',2,'Color',c);

        text(mass(i),time(i),MilliRobotData{j,nameC},'FontSize',6);
        
        hold on;
    end
end

for i=numRobots+1:numRobots+numBugs
    j = i-numRobots+headerOffset;
    mass(i) = MilliInsectData{j,massC}*1e6;
    time(i) = MilliInsectData{j,time1mC};
    loglog(mass(i),time(i),'ko','MarkerSize',15,'LineWidth',2);
    
    text(mass(i),time(i),MilliInsectData{j,nameC},'FontSize',6);

end

xlabel('Mass (mg)');
ylabel('Time to move 1 m (s)');
set(gca,'FontSize',9)

hold off;

opts2 = struct('color','cmyk','LineWidthMin',2,'Resolution',600,'Renderer','painters','FontMode','scaled','FontSize',1);
exportfig(gcf,'Time.eps',opts2,'width',6.5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cost of Transport
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Figure4=figure(4);
clf(Figure4);
set(Figure4,'PaperUnits','inches','PaperSize',[6.5 4.5],'PaperPosition',[0,0,6.5,4.5]);

charLength = zeros(numRobots+numBugs,1);
mass = zeros(numRobots+numBugs,1);
cot = zeros(numRobots+numBugs,1);

subplot(1,2,1)
for i=1:numRobots
    j = i+headerOffset;
    if ((MilliRobotData{j,movedC} == 1) && ~isnan(MilliRobotData{j,cotC}))
        if (MilliRobotData{j,powerAutonomyC} == 1)
            c = 'b';
        else
            c = 'r';
        end
        charLength(i) = MilliRobotData{j,charLengthC}*1e3;
        cot(i) = MilliRobotData{j,cotC};
        loglog(charLength(i),cot(i),'x','MarkerSize',15,'LineWidth',2,'Color',c);

        text(charLength(i),cot(i),MilliRobotData{j,nameC},'FontSize',6);
        
        hold on;
    end
end

for i=numRobots+1:numRobots+numBugs
    j = i-numRobots+headerOffset;
    charLength(i) = MilliInsectData{j,charLengthC}*1e3;
    cot(i) = MilliInsectData{j,cotC};
    loglog(charLength(i),cot(i),'ko','MarkerSize',15,'LineWidth',2);
    
    text(charLength(i),cot(i),MilliInsectData{j,nameC},'FontSize',6);

end

oldaxis = axis;
axis([2 oldaxis(2) oldaxis(3) oldaxis(4)])
xlabel('Characteristic Length (mm)');
ylabel('Cost of Transport');

hold off;

subplot(1,2,2)
cot = zeros(numRobots+numBugs,1);
for i=1:numRobots
    j = i+headerOffset;
    if ((MilliRobotData{j,movedC} == 1) && ~isnan(MilliRobotData{j,cotC}))
        if (MilliRobotData{j,powerAutonomyC} == 1)
            c = 'b';
        else
            c = 'r';
        end
        mass(i) = MilliRobotData{j,massC}*1e6;
        cot(i) = MilliRobotData{j,cotC};
        loglog(mass(i),cot(i),'x','MarkerSize',15,'LineWidth',2,'Color',c);

        text(mass(i),cot(i),MilliRobotData{j,nameC},'FontSize',6);
        
        hold on;
    end
end

for i=numRobots+1:numRobots+numBugs
    j = i-numRobots+headerOffset;
    mass(i) = MilliInsectData{j,massC}*1e6;
    cot(i) = MilliInsectData{j,cotC};
    loglog(mass(i),cot(i),'ko','MarkerSize',15,'LineWidth',2);
    
    text(mass(i),cot(i),MilliInsectData{j,nameC},'FontSize',6);

end

xlabel('Mass (mg)');
ylabel('Cost of Transport');
set(gca,'FontSize',9)

hold off;

opts2 = struct('color','cmyk','LineWidthMin',2,'Resolution',600,'Renderer','painters','FontMode','scaled','FontSize',1);
exportfig(gcf,'COT.eps',opts2,'width',6.5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of Actuators
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Figure5=figure(5);
clf(Figure5);
set(Figure5,'PaperUnits','inches','PaperSize',[6.5 4.5],'PaperPosition',[0,0,6.5,4.5]);

charLength = zeros(numRobots,1);
mass = zeros(numRobots,1);
motors = zeros(numRobots,1);

subplot(1,2,1)
for i=1:numRobots
    j = i+headerOffset;
    if ((MilliRobotData{j,movedC} == 1))
        if (MilliRobotData{j,powerAutonomyC} == 1)
            c = 'b';
        else
            c = 'r';
        end
        charLength(i) = MilliRobotData{j,charLengthC}*1e3;
        motors(i) = MilliRobotData{j,numMotorsC};
        semilogx(charLength(i),motors(i),'x','MarkerSize',15,'LineWidth',2,'Color',c);
        hold on;
    end
end
textfit(charLength,motors,name(1:numRobots)','FontSize',10);

oldaxis = axis;
axis([1 oldaxis(2) 0 10])
xlabel('Characteristic Length (mm)');
ylabel('# of Actuators');

hold off;

subplot(1,2,2)
for i=1:numRobots
    j = i+headerOffset;
    if ((MilliRobotData{j,movedC} == 1))
        if (MilliRobotData{j,powerAutonomyC} == 1)
            c = 'b';
        else
            c = 'r';
        end
        mass(i) = MilliRobotData{j,massC}*1e6;
        motors(i) = MilliRobotData{j,numMotorsC};
        semilogx(mass(i),motors(i),'x','MarkerSize',15,'LineWidth',2,'Color',c);
        hold on;
    end
end
textfit(mass,motors,name(1:numRobots)','FontSize',10);

oldaxis = axis;
axis([1e-3 oldaxis(2) 0 10])
xlabel('Mass (mg)');
ylabel('# of Actuators');
set(gca,'FontSize',12)

hold off;

opts2 = struct('color','cmyk','LineWidthMin',2,'Resolution',600,'Renderer','painters','FontMode','scaled','FontSize',1);
exportfig(gcf,'Actuators.eps',opts2,'width',6.5)
