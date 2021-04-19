classdef IVIMModel
    methods(Static)
        function S = predict(params, b, TE)
            params = IVIMModel.to_param_space(params);
            % Extract the parameters
            S0 = params(1);
            T2_star = params(2);
            D_1 = params(3);
            f = params(4);
            D_2 = params(5);
            % Synthesize the signals according to the model
            S = S0*exp(-TE/T2_star).*(f*exp(-b*D_1)+(1-f)*exp(-b*D_2));
        end
        
        function params_constr = to_constr_space(params)
            % Constrain >= 0
            S0_constr = sqrt(params(1));           
            % Constrain [0, 1]
            T2_star_constr = asin(sqrt(params(2)));
            D_1_constr = asin(sqrt(params(3)));
            f_contr = asin(sqrt(params(4)));
            D_2_constr = asin(sqrt((params(5))/params(3))); 
            params_constr = [S0_constr T2_star_constr D_1_constr f_contr D_2_constr];
        end

        function params = to_param_space(params_constr)
            % Invert > 0 constr
            S0 = params_constr(1)^2;
            % Invert 0<param<1 constr
            T2_star = sin(params_constr(2))^2;
            D_1 = sin(params_constr(3))^2;
            f = sin(params_constr(4))^2;
            D_2 = D_1*sin(params_constr(5))^2;
            params = [S0 T2_star D_1 f D_2];
        end
    end
end

