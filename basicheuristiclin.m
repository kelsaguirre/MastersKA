
%clear
function [sum_likelihood] = basicheuristiclin(pars, data)

n_blocks=4;
n_slots=3;
n_trials=length(data{1}(:,1));
%need for BIC_Cals_RL script
%internalCellArray = data.data; 

choice_selections=0;

hlikelihood = zeros(1,n_blocks);
llikelihood = zeros(1,n_blocks);

alpha1 = pars(1); 
%is this the part that's wrong?
if alpha1<0|| alpha1>=1 %is this correct?
    hlikelihood=ones(1,n_blocks)*1000;
    llikelihood=ones(1,n_blocks)*1000;
else

    for iB = 1:n_blocks
        slotprior{iB}=ones(n_trials,n_slots)/n_slots;
    end

    % for each block
    for iB = 1:n_blocks
        % initialize expectation (Et) etc.
        P = zeros(20,3);
        P(1,:) = 1/3;
        errors = zeros(n_trials,1);
        % for each trial
        for iT = 1:n_trials
            %choice
            clear C
            clear R
            C = data{iB}(:,1);
            thischoice = data{iB}(iT,1);
            %predicted choice probability (P)
            %simple heuristic confirm 100/conflit 10 or 0
            %reward
            %why not all trials?
            %R = data{iB}(:,2);
            R = data{iB}(iT,2);
            x = 0.5 ;
            if iT == 1 % Expected P of the first trial
                P(iT,:) = 1/3;
            elseif iT>1 % Expected P for each choice at the beginning of each trial
                %previous choice and reward
                pC = data{iB}(iT-1,1);
                pR = data{iB}(iT-1,2);
                if pR == 100 % confirming previous R = full win
                    if pC == 1 %prev choice left slot
                        %dont need the previous choice again!
                        P(iT,1) = P(iT-1,1)+alpha1 ;
                        P(iT,2) = P(iT-1,2)-alpha1/2;
                        P(iT,3) = P(iT-1,3)-alpha1/2;
                    elseif pC == 2 %prev choice mid slot
                        P(iT,2) = P(iT-1,2)+alpha1 ;
                        P(iT,1) = P(iT-1,1)-alpha1/2;
                        P(iT,3) = P(iT-1,3)-alpha1/2;
                    elseif pC == 3 %prev choice right slot
                        P(iT,3) = P(iT-1,3)+alpha1 ;
                        P(iT,1) = P(iT-1,1)-alpha1/2;
                        P(iT,2) = P(iT-1,2)-alpha1/2;
                    else
                    end
                        P(iT,:) = P(iT-1,:);

                 elseif pR == 10 || pR == 0
                    if pC == 1 %prev choice left slot
                        P(iT,1) = P(iT-1,1)-alpha1/2 ;
                        P(iT,2) = P(iT-1,2)+alpha1 ;
                        P(iT,3) = P(iT-1,3)+alpha1 ;
                    elseif pC == 2 %prev choice mid slot
                        P(iT,2) = P(iT-1,2)-alpha1/2 ;
                        P(iT,1) = P(iT-1,1)+alpha1;
                        P(iT,3) = P(iT-1,3)+alpha1 ;
                    elseif pC == 3 %prev choice right slot
                        P(iT,3) = P(iT-1,3)-alpha1/2 ;
                        P(iT,1) = P(iT-1,1)+alpha1;
                        P(iT,2) = P(iT-1,2)+alpha1;
                    else %no choice made
                        P(iT,:) = P(iT-1,:);
                    end
                end
            end
            % Predicted Choice Probability: simple normalization
            P(iT,:) = (P(iT,:))/sum(P(iT,:));
            distro = P(iT,:);
            % If the probability is <0.05, replace with 0.05 and
            % recalculate probabilities
            problog=max(0.05, P(iT,:));
            problog=problog/sum(problog);
            % Error Estimations - optimization
            %need to fix the error estimation
%             if C == 0
%                 errors(iT,:) = 0;
%                 disp('missing choice')
%                 disp([iB,iT])
%             elseif C == 1
%                 errors(iT,1) = log(problog(1));
%             elseif C == 2
%                 errors(iT,1) = log(problog(2));
%             elseif C == 3
%                 errors(iT,1) = log(problog(3));
%             end

%linear calcs
                if C == 0
                    errors(iT,:) = 0;
                    % disp('missing choice')
                    % disp([iS,iB,iT])
                elseif C == 1
                    errors(iT,1) = 1 - P(iT,1);
                elseif C == 2
                    errors(iT,1) = 1 - P(iT,2);
                elseif C == 3
                    errors(iT,1) = 1 - P(iT,3);
                end
            %disp([data{iB}(iT,1),r])
            %disp([eA,eB,eC])
            %disp([P(iT,:),E(iT,:)])
            %pause(1)
            %errors(iB,1) = sum(errors);
    
            %how I did it for RL:
            % Error Estimations
            if thischoice > 0
                errors(iB) = 1-distro(thischoice);
                hlikelihood(iB)=hlikelihood(iB)+errors(iB);
                llikelihood(iB)=llikelihood(iB)+ min(3, abs(log(problog(thischoice))));
                
                %to keep it moving?
                choice_selections=choice_selections+1;
            end
        
            if max(problog)==0.05
            error ('check')
            end
        end
%end of block
    end
% calculate the max error value for Et(:,2) min for Et(:,1)
% store this for each subj
%     [min_val,ind1] = min(Et(:,2));
%     [max_val,ind2] = max(Et(:,3));
%     optimalalpha(iS,:) = [Et(ind1,1),Et(ind2,1)];
%     optimalerrors(iS,:) = [min_val,max_val];

end

sum_likelihood = sum(hlikelihood) ; 
