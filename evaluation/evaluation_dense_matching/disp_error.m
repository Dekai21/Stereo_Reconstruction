function d_err = disp_error (D_gt,D_est,tau)

E = abs(D_gt-D_est); %����Ȳ�
% n_err   = length(find(D_gt>0  & E./abs(D_gt)>tau(2)));
n_err   = length(find(D_gt>0 & E>tau(1) & E./abs(D_gt)>tau(2)));%%�ҳ��Ӿ�������3�Ҵ���%5�ĵ�
n_total = length(find(D_gt>0));%���пɲ��
d_err = n_err/n_total;
