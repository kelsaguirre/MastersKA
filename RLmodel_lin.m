%clear
function [sum_likelihood] = RLmodel_lin(pars, data)


n_blocks=4;
n_slots=3;
n_trials=length(data{1}(:,1));

start_trial=2;
choice_selections=0;

hlikelihood = zeros(1,n_blocks);
llikelihood = zeros(1,n_blocks);

alpha1 = pars(1); 
if alpha1<0 || alpha1>=1 %is this correct?
    hlikelihood=ones(1,n_blocks)*1000;
    llikelihood=ones(1,n_blocks)*1000;
else

    for iB = 1:n_blocks
        slotprior{iB}=ones(n_trials,n_slots)/n_slots;
    end

    % for each block
    for iB = 1:n_blocks
        tau = 1; %modify later
        % initialize expectation (Et) etc.
        Q = zeros(20,3);
        Q(1,:) = 110/3;
        P = zeros(20,3);
        P(1,:) = 1/3;
        errors = zeros(n_trials,1);
        clear choices
        choices = data{iB}(:,1);

        distro = slotprior{iB}(1,:);

        % for each trial
        for iT = 1:length(choices)
            thischoice = data{iB}(iT,1);
            thisreward = data{iB}(iT,2);
            if iT>1 % Expected Q value for each choice at the beginning of each trial
                eA = Q(iT-1,1);
                eB = Q(iT-1,2);
                eC = Q(iT-1,3);
            else % Expected Q value of the first trial
                eA = Q(iT,1);
                eB = Q(iT,2);
                eC = Q(iT,3);
            end

            % Q Update
            if thischoice == 1 % if slot "A" was chosen
                update = alpha1*(thisreward - eA);
                Q(iT,1) = eA + update;
                Q(iT,2) = eB - update/2;
                Q(iT,3) = eC - update/2;
            elseif thischoice == 2 % if slot "B" was chosen
                update = alpha1*(thisreward - eB);
                Q(iT,2) = eB + update;
                Q(iT,1) = eA - update/2;
                Q(iT,3) = eC - update/2;
            elseif thischoice == 3 % if slot "C" was chosen
                update = alpha1*(thisreward - eC);
                Q(iT,3) = eC + update;
                Q(iT,1) = eA - update/2;
                Q(iT,2) = eB - update/2;
            else % if no choice was made
                Q(iT,3) = eC;
                Q(iT,1) = eA;
                Q(iT,2) = eB;
            end

            % Predicted Choice Probability:
            P(iT,:) = exp(Q(iT,:)/tau)/sum(exp(Q(iT,:)/tau));
            distro = P(iT,:);
            % If the probability is <0.05, replace with 0.05 and
            % recalculate probabilities.
            problog=max(0.05, P(iT,:));
            problog=problog/sum(problog);
            % P(iT,:) = Q(iT,:)/sum(Q(iT,:));
            % Error Estimations
            if data{iB}(iT,1) == 0
                errors = 0;
                %disp('missing choice')
                %disp([iS,iB,iT])
            end
            % Error Estimations
            if choices(iT) > 0
                errors(iB) = 1-distro(thischoice);
                hlikelihood(iB)=hlikelihood(iB)+errors(iB);
                llikelihood(iB)=llikelihood(iB)+ min(3, abs(log(distro(thischoice))));
                
                %to keep it moving?
                choice_selections=choice_selections+1;

            end
            if max(problog)==0.05
            error ('check')
            end
        end
    end
end

sum_likelihood = sum(hlikelihood) ; 