function fig= filled_plot(input_vecs1, color_mean1, transparency1, ...
                          input_vecs2, color_mean2, transparency2)

mean_vec1=mean(input_vecs1);
mean_vec2=mean(input_vecs2);

error_vec1=std(input_vecs1)/sqrt(length(input_vecs1(:,1)));
error_vec2=std(input_vecs2)/sqrt(length(input_vecs2(:,1)));
% error_vec3=std(input_vecs3)/sqrt(length(input_vecs3(:,1)));
% error_vec1=std(input_vecs1);
% error_vec2=std(input_vecs2);

color_error1=min(1, color_mean1+0.3);
color_error2=min(1, color_mean2+0.3);

x1=1:length(mean_vec1);
x2=1:length(mean_vec2);
X1=[x1,fliplr(x1)];
X2=[x2,fliplr(x2)];
y1=mean_vec1+error_vec1;
y3=mean_vec2+error_vec2;

y2=mean_vec1-error_vec1;
y4=mean_vec2-error_vec2;

Y1=[y1,fliplr(y2)];
Y2=[y3,fliplr(y4)];

hold on
fig{1}=fill(X1,Y1, color_error1, 'EdgeColor', color_error1);
fig{2}=plot(mean_vec1, 'Color',color_mean1);
fig{3}=fill(X2,Y2, color_error2, 'EdgeColor', color_error2);
fig{4}=plot(mean_vec2, 'Color',color_mean2);

set(fig{1},'facealpha',transparency1);
set(fig{3},'facealpha',transparency2);
hold off

end

%code inspired by: http://stackoverflow.com/questions/6245626/matlab-filling-in-the-area-between-two-sets-of-data-lines-in-one-figure
