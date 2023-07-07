
$$
\begin{aligned}
V_i + \varnothing_{j \in \partial_i} \xrightarrow{\lambda_V} V_i + V_j \\
B_i + \varnothing_{j \in \partial_i} \xrightarrow{\lambda_B} B_i + B_j \\
F_i + V_{j \in \partial_i} \xrightarrow{\lambda_{FV}} F_i + F_j \\
F_i + B_{j \in \partial_i} \xrightarrow{\lambda_{FB}} F_i + F_j \\
B_i + V_{j \in \partial_i} \xrightarrow{\lambda_{BV}} B_i + B_j \\
V_i  \xrightarrow{b_{FV}} F_i \\
B_i  \xrightarrow{b_{FB}} F_i \\
B_i  \xrightarrow{b_{VB}} V_i \\
F_i  \xrightarrow{d_F} \varnothing_i
\end{aligned}
$$

$$
\begin{aligned}
\frac{dP_V}{dt} &= \lambda_V P_V P_{\varnothing} + b_{VB} P_B - b_{FV} P_V - \lambda_{FV} P_F P_V - \lambda_{BV} P_B P_V \\
\frac{dP_B}{dt} &= \lambda_B P_B P_{\varnothing} + \lambda_{BV} P_B P_V - b_{FB} P_B - \lambda_{FB} P_F P_B \\
\frac{dP_F}{dt} &= b_{FV} P_V + b_{FB} P_B + \lambda_{FV} P_F P_V + \lambda_{FB} P_F P_B - d_F P_F
\end{aligned}
$$
