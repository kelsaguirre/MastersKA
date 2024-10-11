function [sum_likelihood] = BI_log_simple(pars, data)

n_blocks=4;
n_slots=3;
n_trials=length(data{1}(:,1));
%n_trials=length(fc{1}(:,1));
%need for BIC_Cals script
%internalCellArray = data.data;
%n_trials=length(internalCellArray(:,1));

%will it work without these?
start_trial=2;
choice_selections=0;

hlikelihood = zeros(1,n_blocks);
llikelihood = zeros(1,n_blocks);

%lambda1 = 0.8;

%pars = lambda1;
lambda1 = pars(1); 
if lambda1<=1/3 || lambda1>=1 %is this correct?
    hlikelihood=ones(1,n_blocks)*1000;
    llikelihood=ones(1,n_blocks)*1000;
else

    for iB = 1:n_blocks
        slotprior{iB}=ones(n_trials,n_slots)/n_slots;
    end
    
    for iB = 1:n_blocks
        clear choices
        clear outcomes
        %need for BIC_Cals script to work
        %outcomes = internalCellArray{iB}(:, 2);
        %choices = internalCellArray{iB}(:, 1);
        %need below for RunBI_simple script to work
        outcomes = data{iB}(:,2);
        choices = data{iB}(:,1);
    
        distro = slotprior{iB}(1,:);
    
        for iT=start_trial:length(choices)
            %stretching the distribution from 1/3->1 to 0->1
            %x1 = (max(distro)-1/3)*3/2;
            %starting prob (most prob outcome is 80%)
            %this needs to be different for each subject!
            m1=lambda1;
            s1=(1-lambda1)/2;
            m2=s1/(m1*2+s1);%s1;
            s2=m1/(m1*2+s1);%(1-s1)/2;
            matwin=[0 1 1
                1 0 1
                1 1 0]*s1 + eye(3)*m1;
            matlose=[0 1 1
                1 0 1
                1 1 0]*s2 + eye(3)*m2;
        
            post=slotprior{iB}(iT-1,:);
    
            if choices(iT-1)>0
                if outcomes(iT-1)==100 %winning outcome
                    denom=sum(post.*matwin(choices(iT-1),:));
                    slotprior{iB}(iT,:)=matwin(choices(iT-1),:).*slotprior{iB}(iT-1,:)/denom;
                elseif outcomes(iT-1) == 0 || outcomes(iT-1) == 10 %losing outcome - switch
                    denom=sum(post.*matlose(choices(iT-1),:));
                    slotprior{iB}(iT,:)=matlose(choices(iT-1),:).*slotprior{iB}(iT-1,:)/denom;
                end
            else % if no choice was made
                slotprior{iB}(iT,:)=(post + ones(1,3)/3)/2;
    
            end
            
            % later replaced by problog
            distro=slotprior{iB}(iT,:);
    
            % Predicted Choice Probability - is this still happening?
            % If the probability is <0.05, replace with 0.05 and recalculate
            slotprior{iB}(iT,:)=max(0.05, slotprior{iB}(iT,:));
            slotprior{iB}(iT,:)=slotprior{iB}(iT,:)/sum(slotprior{iB}(iT,:));
    
            %comparison
            if choices(iT)>0
                errors(iB)=1-distro(choices(iT));
                hlikelihood(iB)=hlikelihood(iB)+errors(iB);
                llikelihood(iB)=llikelihood(iB)+ min(3, abs(log(distro(choices(iT)))));
    
                choice_selections=choice_selections+1;
            end
    
            if max(slotprior{iB}(iT,:))==0.05
                error ('check')
            end
    
        %end of trials
        end
        %E(iB,:)=sum(errors); 
    
    %end of block
    end
end

sum_likelihood = sum(llikelihood) ; 
