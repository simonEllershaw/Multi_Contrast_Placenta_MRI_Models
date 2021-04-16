classdef ThreeCompModel
        methods(Static)
        function S = predict(params, b, TE)
            params = ThreeCompModel.to_param_space(params);
            % Extract the parameters
            S0 = params(1);
            T2_star = params(2);
            D_1 = params(3);
            f_1 = params(4);
            D_2 = params(5);
            f_2 = params(6);
            D_3 = params(7);
            f_3 = params(8);
            % Synthesize the signals according to the model
            S = S0*exp(-TE/T2_star).*(f_1*exp(-b*D_1)+f_2*exp(-b*D_2)+f_3*exp(-b*D_3));
        end
        
        function params_constr = to_constr_space(params)
            % Constrain >= 0
            S0_constr = sqrt(params(1));           
            % Constrain [0, 1]
            T2_star_constr = asin(sqrt(params(2)));
            % Contrain x>>y
            D_1_constr = asin(sqrt(params(3)/0.01));
            D_2_constr = asin(sqrt((params(5)-params(3))));
            D_3_constr = asin(sqrt((params(7)-params(5))));
            % Contrain f1+f2+f3 = 1 and 0<f_i<1
            f_1_constr = log(params(4));
            f_2_constr = log(params(6));
            f_3_constr = log(params(8));
            params_constr = [S0_constr T2_star_constr D_1_constr f_1_constr D_2_constr f_2_constr D_3_constr f_3_constr];
        end

        function params = to_param_space(params_constr)
            % Invert > 0 constr
            S0 = params_constr(1)^2;
            % Invert 0<param<1 constr
            T2_star = sin(params_constr(2))^2;
            % Invert 0<D1<0.01, D1<D2<1+D1, D2<D3<10+D2
            D_1 = 0.01*sin(params_constr(3))^2;
            D_2 = 1*sin(params_constr(5))^2 + D_1;
            D_3 = 10*sin(params_constr(5))^2 + D_2;
            % Invert 0<=f1+f2+f3<=1
            ef_1 = exp(params_constr(4));
            ef_2 = exp(params_constr(6));
            ef_3 = exp(params_constr(8));
            ef_sum = ef_1+ef_2+ef_3;
            f_1 = ef_1/ef_sum;
            f_2 = ef_2/ef_sum;
            f_3 = ef_3/ef_sum;
            
            params = [S0 T2_star D_1 f_1 D_2 f_2 D_3 f_3];
        end
    end
end

