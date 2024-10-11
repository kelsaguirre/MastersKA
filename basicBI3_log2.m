function [sum_likelihood,numchoices] = basicBI3_log2(pars, data, upperbound)
%replaced data w ~, not sure what that does - went back todata

n_blocks=4;
n_slots=3;
start_trial=2;
choice_selections=0;

hlikelihood = zeros(1,n_blocks);
llikelihood = zeros(1,n_blocks);

%need for BIC_Cal_BIDynamic script
internalCellArray = data.data; 
n_trials=length(internalCellArray(:,1));

% Initialize numchoices as an empty array
numchoices = [];
% Initialize a cell array to store slotprior for all blocks
all_slotprior = {};

alpha = pars(1); 
beta = pars(2);
if alpha<=0 || beta<=0 || alpha>=upperbound || beta>=upperbound
    hlikelihood=ones(1,n_blocks)*1000;
    llikelihood=ones(1,n_blocks)*1000;
elseif pars(3)<1/3 || pars(3)>1
    hlikelihood=ones(1,n_blocks)*1000;
    llikelihood=ones(1,n_blocks)*1000;
elseif pars(4)<1/3 || pars(4)>1
    hlikelihood=ones(1,n_blocks)*1000;
    llikelihood=ones(1,n_blocks)*1000;
else
    th1=abs(pars(4)-pars(3));
    th2=pars(3);
    if pars(4)<pars(3)
        eta=0;
    else
        eta=1;
    end

    for iB = 1:n_blocks
        slotprior{iB}=ones(n_trials,n_slots)/n_slots;
    end
    
    for iB = 1:n_blocks
        clear choices
        clear outcomes
        %need for BIC_Cal_BIDynamic script
        outcomes = internalCellArray{iB}(:, 2);
        choices = internalCellArray{iB}(:, 1);
        numchoices_iB = 1; %bc start trial is 2?
        %need below for RunBI script to work
        %outcomes = data{iB}(:,2);
        %choices = data{iB}(:,1);
    
        distro = slotprior{iB}(1,:);
    
        for iT=start_trial:length(choices)
            %stretching the distribution from 1/3->1 to 0->1
            x1 = (max(distro)-1/3)*3/2;
            %determines lambda based on each trial
    
            if eta==0 %decreasing
                m1=th2-betainc(x1,alpha,beta)*th1;
            elseif eta==1 %increasing
                m1=th2+betainc(x1,alpha,beta)*th1;         
            end
    
            lambda1=m1;
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
            % Increment the number of choices for the current block - since
            % there was a reward!!
            numchoices_iB = numchoices_iB + 1;
            else % if no choice was made
                slotprior{iB}(iT,:)=(post + ones(1,3)/3)/2;
            end
            
            % later replaced by problog
            distro=slotprior{iB}(iT,:);
    
            % Predicted Choice Probability
            % If the probability is <0.05, replace with 0.05 and recalculate
            slotprior{iB}(iT,:)=max(0.05, slotprior{iB}(iT,:));
            slotprior{iB}(iT,:)=slotprior{iB}(iT,:)/sum(slotprior{iB}(iT,:));
%             if choices(iT) == 0
%                 numchoices = 
%                 disp('missing choice')
%                 disp([iB,iT])
%             end
    
            %comparison
            if choices(iT)>0
                errors(iB)=1-distro(choices(iT));
                hlikelihood(iB)=hlikelihood(iB)+errors(iB);
                llikelihood(iB)=llikelihood(iB)+ min(3, abs(log(distro(choices(iT)))));
    
                %to keep it moving?
                choice_selections=choice_selections+1;
            end
    
            if max(slotprior{iB}(iT,:))==0.05
                error ('check')
            end
   
        %end of trials
        end

    % Store the number of choices for the current block in numchoices array
    numchoices = [numchoices, numchoices_iB];
    
    % Save the slotprior for the current block
    all_slotprior{iB} = slotprior{iB};
    
    % Display the value of numchoices for the current block
    %disp(numchoices_iB)
    % Change directory
    cd('/Users/kelseyaguirre/Smith Group Dropbox/Kelsey Aguirre/AguirreWork/code/bayesian_dynamic')
    % Check if numchoices_iB is less than 20 and save the data if true
    if numchoices_iB < 20
        save(sprintf('block_%d_data.mat', iB), 'slotprior', 'numchoices');
    end
    %end of block
    end
end
%optimallinerrors = optimallinerrors ;
sum_likelihood = sum(llikelihood) ; 