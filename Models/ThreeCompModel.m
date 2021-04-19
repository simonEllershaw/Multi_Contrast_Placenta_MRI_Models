classdef ThreeCompModel
        methods(Static)
        function S = predict(params, b, TE)
            params = ThreeCompModel.to_param_space(params);
            % Extract the parameters
            S0 = params(1);
            T2_star = params(2);
            D_1 = params(3);
            f = params(4);
            D_2 = params(5);
            v = params(6);
            D_3 = params(7);
            % Synthesize the signals according to the model
            S = S0*exp(-TE/T2_star).*(f*exp(-b*D_1)+(1-f)*(v*exp(-b*D_2)+(1-v)*exp(-b*D_3)));
        end
        
        function params_constr = to_constr_space(params)
            % Constrain >= 0
            S0_constr = sqrt(params(1));           
            % Constrain [0, 1]
            T2_star_constr = asin(sqrt(params(2)));
            f_star_constr = asin(sqrt(params(4)));
            v_star_constr = asin(sqrt(params(6)));
            % Contrain x>>y
            D_1_constr = asin(sqrt(params(3)/0.01));
            D_2_constr = asin(sqrt((params(5)-params(3))));
            D_3_constr = asin(sqrt((params(7)-params(5))/10));
            params_constr = [S0_constr T2_star_constr D_1_constr f_star_constr D_2_constr v_star_constr D_3_constr];
        end

        function params = to_param_space(params_constr)
            % Invert > 0 constr
            S0 = params_constr(1)^2;
            % Invert 0<param<1 constr
            T2_star = sin(params_constr(2))^2;
            f = sin(params_constr(4))^2;
            v = sin(params_constr(6))^2;
            % Invert 0<D1<0.01, D1<D2<1+D1, D2<D3<10+D2
            D_1 = 0.01*sin(params_constr(3))^2;
            D_2 = 1*sin(params_constr(5))^2 + D_1;
            D_3 = 10*sin(params_constr(7))^2 + D_2;
            params = [S0 T2_star D_1 f D_2 v D_3];
        end
    end
end

