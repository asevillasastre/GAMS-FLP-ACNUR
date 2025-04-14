*********************************************************************************************
* Integración de las cadenas de suministro para emergencias y operaciones en curso en ACNUR *
*********************************************************************************************

* Reproduccion del modelo en GAMS
* Antonio Sevilla Sastre
* Master en Gestion de Desastres Universidad Complutense de Madrid

Sets
s  proveedores              /Alemania, China, Suiza/
g  almacenes                /Amsterdam, Bruselas, Burdeos, Dubai, Ghana, Marruecos, Sudafrica/
j  puntos de demanda        /Burkina, Camerun, Chad, Colombia, Etiopia, Guinea, Haiti, Irak, Libia, Mali, Mozambique, Niger/
k  escenarios de emergencia /2023,2024/
;

Parameter
f(g)   coste fijo en USD de abrir el almacén g
/Amsterdam     150000
 Bruselas      140000
 Burdeos       130000
 Dubai         240000
 Ghana         430000
 Marruecos     270000
 Sudafrica     130000/;

Parameter
v(g)   coste variable en USD de operar el almacén g
/Amsterdam     1800
 Bruselas      1270
 Burdeos       1700
 Dubai         1225
 Ghana         1200
 Marruecos     6500
 Sudafrica     5000/;

Table C_ER(g,j) coste de transporte express por aire de g a j (USD)
                            Burkina    Camerun  Chad  Colombia  Etiopia   Guinea  Haiti  Irak  Libia  Mali  Mozambique  Niger    
Amsterdam                    180         220    210    250      240        230    220    210    200   190    180        170          
Bruselas                     170         210    200    240      230        220    210    200    190   180    170        160          
Burdeos                      160         200    190    230      220        210    200    190    180   170    160        150        
Dubai                        230         270    260    300      290        280    270    260    250   240    230        220         
Ghana                        130         170    160    190      180        170    160    150    140   230    120        210            
Marruecos                    140         180    170    200      190        180    170    160    150   140    130        120         
Sudafrica                    150         190    180    210      200        190    180    170    160   150    140        130;

Table CL_ER(g,j) coste de transporte express por tierra de g a j (USD)
                            Burkina  Camerun  Chad  Colombia  Etiopia  Guinea  Haiti  Irak  Libia  Mali  Mozambique  Niger
Ghana                          70      90      85     100      95       90      85     80     75     70       65       60
Marruecos                      75      95      90     110     105      100      95     90     85     80       75       70
Sudafrica                      80     100      95     120     115      110     105    100     95     90       85       80;

Table C_OOSJ(s,j) coste de transporte normal de s a j (USD)
                            Burkina  Camerun  Chad  Colombia  Etiopia  Guinea  Haiti  Irak  Libia  Mali  Mozambique  Niger
Alemania                       90      110    105     130      125      120     115    110    108    107      140      100
China                         110      130    125     110      145      135     140    150    148    128      150      120
Suiza                          87      102    100     128      123      117     112    108    107    105      137       98;

Table C_OOGJ(g,j) coste transporte normal de g a j (USD)
                            Burkina  Camerun  Chad  Colombia  Etiopia  Guinea  Haiti  Irak  Libia  Mali  Mozambique  Niger
Amsterdam                      75       85     82     95       94       90      92     88     87     86      100       78
Bruselas                       76       87     84     96       95       91      93     89     88     87      101       79
Burdeos                        77       88     85     97       96       92      94     90     89     88      102       80
Dubai                          95      100     97    120      130      110     125    115    113    112      140       98
Ghana                          60       70     68     80       78       75      73     72     71     70       82       63
Marruecos                      62       73     70     85       82       77      75     74     73     72       85       65
Sudafrica                      65       75     72     87       85       80      78     76     75     74       87       67;

Table C(s,g) coste de transporte de proveedor s a almacén g (USD)
               Amsterdam  Bruselas  Burdeos  Dubai  Ghana  Marruecos  Sudafrica
Alemania           30        32       35      90     80       70         85
China              50        52       53      70     60       65         75
Suiza              28        30       32      85     78       70         80;

Parameter d_OO(j) demanda actual en j (USD)
/Burkina      430000, Camerun     600000, Chad       2000000, Colombia   1000000, Etiopia    8000000, Guinea     4000000,
 Haiti        900000, Irak        350000, Libia      80000, Mali          150000, Mozambique 1000000, Niger      8500000/;

Table d_ER(j,k) demanda en j bajo escenario k (USD)
                      2023      2024     
Burkina              350000     400000
Camerun              120000     50000
Chad                 250000     350000
Colombia             110000     130000
Etiopia              900000     1100000
Guinea               50000      60000
Haiti                200000     850000
Irak                 450000     600000
Libia                120000     180000
Mali                 180000     300000
Mozambique           25000      350000
Niger                180000     200000;

Table l_e(g,j) plazo entrega express por aire de g a j (horas)
                            Burkina  Camerun  Chad  Colombia  Etiopia  Guinea  Haiti  Irak  Libia  Mali  Mozambique  Niger     
Amsterdam                    18       24      22      30       28      26      30     22     20    20      32         22              
Bruselas                     18       22      20      28       26      24      28     20     20    20      30         20             
Burdeos                      20       24      22      30       28      26      30     22     22    22      32         22               
Dubai                        16       18      14      32       12      18      36     14     16    16      24         14             
Ghana                        12       14      16      22       20      14      30     18     14    14      24         14              
Marruecos                    14       16      18      24       22      16      32     20     16    16      26         16                 
Sudafrica                    18       20      22      28       24      20      30     24     20    20      30         20;

Table lL_e(g,j) plazo entrega express por tierra de g a j (horas)
                            Burkina  Camerun  Chad  Colombia  Etiopia  Guinea  Haiti  Irak  Libia  Mali  Mozambique  Niger     
Ghana                        12       18      20      36       28      18      42     30     20    20      38         20                
Marruecos                    14       20      22      38       30      20      44     32     22    22      40         22               
Sudafrica                    18       22      24      40       34      22      48     36     24    24      42         24;

Table l_nGJ(g,j) plazo entrega normal desde g a j (horas)
                            Burkina  Camerun  Chad  Colombia  Etiopia  Guinea  Haiti  Irak  Libia  Mali  Mozambique  Niger      
Amsterdam                    36       42      42      60       56      48      58     44     42    42      64         42             
Dubai                        30       32      28      66       34      32      64     30     32    32      40         30               
Ghana                        18       24      28      48       40      28      54     36     28    28      46         28             
Marruecos                    22       26      30      50       44      30      56     38     30    30      48         30                
Sudafrica                    28       30      34      54       48      34      58     42     34    34      52         34;

Table l_nSJ(s,j) plazo entrega normal desde proveedor s a j (horas)
                            Burkina  Camerun  Chad  Colombia  Etiopia  Guinea  Haiti  Irak  Libia  Mali  Mozambique  Niger     
Alemania                      60       66      66      90       84      72      88     68     66    66      92         66               
China                         72       78      78      96       88      78      96     76     74    74      98         74             
Suiza                         56       60      60      84       76      66      80     62     60    60      86         60;

Parameter lim USD coste de diez TEUs /430000/;

Parameter Q(g) capacidad en TEUs del almacén g /Amsterdam   120, Bruselas   130, Burdeos 1100, Dubai  20, Ghana  600, Marruecos 150, Sudafrica 325/;

Parameter alpha(k) ponderacion que tiene en cuenta probabilidad e importancia del supuesto k /2023 0.3, 2024 0.7/;

Parameter MC1 cota auxiliar definir valor C1 /10000000000000000/;
Parameter MC2 cota auxiliar definir valor C2 /10000000000000000/;

*****************************************************************************************************************************************************

Variables
F_OBJ_1 funcion objetivo 1
F_OBJ_2 funcion objetivo 2

I(g) numero de contenedores en TEU requeridos en el almacen g
z(s,g) numero de contenedores en TEU enviados desde s a g con el servicio normal

x_OOSJ(s,j,k) porcentaje de demanda enviada desde s a j en el escenario k
x_OOGJ(g,j,k) porcentaje de demanda enviada desde g a j en el escenario k
x_ER(g,j,k) porcentaje de demanda de emergencia enviada desde g a j en el escenario k
ex_ER(g,j,k) porcentaje de exceso de demanda de emergencia enviada desde g a j en el escenario k

y(g) si el almacen g es abierto
bz(s,g) si se envia algun contenedor de s a g
bx_OOSJ(s,j,k) si se envia algun contenedor de s a j con el servicio normal
bx_OOGJ(g,j,k) si se envia algun contenedor de g a j con el servicio normal
bx_ER(g,j,k) se se envia algun contenedor de s a j con el servicio express por aire
bex_ER(g,j,k) se se envia algun contenedor de s a j con el servicio express por tierra

gamma_(j,k) variable auxiliar enviar mas de diez TEUs por aire

C1(g,j,k) variable auxiliar linealizar fobj1
C2(g,j,k) variable auxiliar linealizar fobj1
;

Integer variables I, z;
Binary variables y, bz, bx_OO, bx_ER, bex_ER, gamma_;
Positive variables x_OOSJ, x_OOGJ, x_ER, ex_ER, C1, C2;

* variables continuas entre 0 y 1
x_OOSJ.up(s,j,k) = 1;
x_OOGJ.up(g,j,k) = 1;
x_ER.up(g,j,k) = 1;
ex_ER.up(g,j,k) = 1;

Equations
F1
F2

eq_sat_dem_OO(j,k)
eq_sat_dem_ER(j,k)
eq_diez_TEU_1(j,k)
eq_diez_TEU_2(j,k)
eq_req_apertura(g)
eq_inventario_almacen(g)
eq_inventario_total(g,k)

eq_algun_sg(g,j,k)
eq_algun_sj(s,j,k)
eq_algun_gj_aire(g,j,k)
eq_algun_gj_tierra(g,j,k)

eq_C1_1_d_lower_lim(g,j,k)
eq_C1_2_d_lower_lim(g,j,k)
eq_C1_3_d_lower_lim(g,j,k)
eq_C1_4_d_lower_lim(g,j,k)

eq_C1_1_d_greater_lim(g,j,k)
eq_C1_2_d_greater_lim(g,j,k)
eq_C1_3_d_greater_lim(g,j,k)
eq_C1_4_d_greater_lim(g,j,k)

eq_C2_1(g,j,k)
eq_C2_2(g,j,k)
eq_C2_3(g,j,k)
;

F1.. F_OBJ_1 =E= sum(g, f(g)*y(g)) + sum((g,s), C(s,g)*z(s,g)) + sum(g, v(g)*I(g)) +
                 sum((k,j), alpha(k)*(
                    (sum(g,C_OOGJ(g,j)*x_OOGJ(g,j,k)) + sum(s, C_OOSJ(s,j)*x_OOSJ(s,j,k)))*d_OO(j) +
                    sum(g, C_ER(g,j)*C1(g,j,k) +
                    (CL_ER(g,j)*(d_ER(j,k)-lim)*C2(g,j,k))
                    )));

F2.. F_OBJ_2 =E= sum((j,k), alpha(k)*(sum(g, l_nGJ(g,j)*bx_OOGJ(g,j,k)) + sum(s, l_nSJ(s,j)*bx_OOSJ(s,j,k)) + sum(g, l_e(g,j)*bx_ER(g,j,k)) + sum(g, lL_e(g,j)*bex_ER(g,j,k))));

eq_sat_dem_OO(j,k).. sum(g, x_OOGJ(g,j,k)*d_OO(j)) + sum(s, x_OOSJ(s,j,k)*d_OO(j)) =E= d_OO(j);
eq_sat_dem_ER(j,k).. sum(g, x_ER(g,j,k)*d_ER(j,k) + ex_ER(g,j,k)*d_ER(j,k)) =E= d_ER(j,k);

eq_diez_TEU_1(j,k).. sum(g, x_ER(g,j,k)*d_ER(j,k)) =E= (1-gamma_(j,k))*lim + d_ER(j,k)*gamma_(j,k);
eq_diez_TEU_2(j,k).. sum(g, ex_ER(g,j,k)*d_ER(j,k)) =E= (1-gamma_(j,k))*(d_ER(j,k)-lim);

eq_req_apertura(g).. I(g) =L= Q(g)*y(g);
eq_inventario_almacen(g).. sum(s, z(s,g)) =E= I(g);
eq_inventario_total(g,k).. sum(j, x_OOGJ(g,j,k)*d_OO(j) + x_ER(g,j,k)*d_ER(j,k) + ex_ER(g,j,k)*d_ER(j,k)) =L= 43000*I(g);

eq_algun_sg(g,j,k).. bx_OOGJ(g,j,k) =G= x_OOGJ(g,j,k);
eq_algun_sj(s,j,k).. bx_OOSJ(s,j,k) =G= x_OOSJ(s,j,k);
eq_algun_gj_aire(g,j,k).. bx_ER(g,j,k) =G= x_ER(g,j,k);
eq_algun_gj_tierra(g,j,k).. bex_ER(g,j,k) =G= ex_ER(g,j,k);

eq_C1_1_d_lower_lim(g,j,k)$(d_ER(j,k)<=lim).. x_ER(g,j,k)*d_ER(j,k) =L= C1(g,j,k);
eq_C1_2_d_lower_lim(g,j,k)$(d_ER(j,k)<=lim).. C1(g,j,k) =L= x_ER(g,j,k)*d_ER(j,k) + 1000000000000*(1-gamma_(j,k));
eq_C1_3_d_lower_lim(g,j,k)$(d_ER(j,k)<=lim).. C1(g,j,k) =L= x_ER(g,j,k)*lim;
eq_C1_4_d_lower_lim(g,j,k)$(d_ER(j,k)<=lim).. x_ER(g,j,k)*lim =L= C1(g,j,k) + 1000000000000*gamma_(j,k);

eq_C1_1_d_greater_lim(g,j,k)$(d_ER(j,k)>lim).. x_ER(g,j,k)*lim =L= C1(g,j,k);
eq_C1_2_d_greater_lim(g,j,k)$(d_ER(j,k)>lim).. C1(g,j,k) =L= x_ER(g,j,k)*lim + 1000000000000*gamma_(j,k);
eq_C1_3_d_greater_lim(g,j,k)$(d_ER(j,k)>lim).. C1(g,j,k) =L= x_ER(g,j,k)*d_ER(j,k);
eq_C1_4_d_greater_lim(g,j,k)$(d_ER(j,k)>lim).. x_ER(g,j,k)*d_ER(j,k) =L= C1(g,j,k) + 1000000000000*(1-gamma_(j,k));

eq_C2_1(g,j,k).. C2(g,j,k) =L= 1000000000000*(1-gamma_(j,k));
eq_C2_2(g,j,k).. C2(g,j,k) =L= ex_ER(g,j,k);
eq_C2_3(g,j,k).. ex_ER(g,j,k) =L= C2(g,j,k) + 1000000000000*gamma_(j,k);

* parametros para los archivos de salida
Parameters
var_F_OBJ_1 funcion objetivo 1
var_F_OBJ_2 funcion objetivo 2
var_I(g) numero de contenedores en TEU requeridos en el almacen g
var_z(s,g) numero de contenedores en TEU enviados desde s a g con el servicio normal
var_x_OOSJ(s,j,k) porcentaje de demanda enviada desde s a j en el escenario k
var_x_OOGJ(g,j,k) porcentaje de demanda enviada desde g a j en el escenario k
var_x_ER(g,j,k) porcentaje de demanda de emergencia enviada desde g a j en el escenario k
var_ex_ER(g,j,k) porcentaje de exceso de demanda de emergencia enviada desde g a j en el escenario k
var_y(g) si el almacen g es abierto
var_bz(s,g) si se envia algun contenedor de s a g
var_bx_OOSJ(s,j,k) si se envia algun contenedor de s a j con el servicio normal
var_bx_OOGJ(g,j,k) si se envia algun contenedor de g a j con el servicio normal
var_bx_ER(g,j,k) se se envia algun contenedor de s a j con el servicio express por aire
var_bex_ER(g,j,k) se se envia algun contenedor de s a j con el servicio express por tierra
var_gamma_(j,k) variable auxiliar enviar mas de diez TEUs por aire
var_C1(g,j,k) variable auxiliar linealizar fobj1
var_C2(g,j,k) variable auxiliar linealizar fobj1
;

*****************************************************************************************************************************************************

* fijamiento de los almacenes que ya estan abiertas
y.fx("Amsterdam") = 1;
y.fx("Bruselas") = 1;
y.fx("Burdeos") = 1;
y.fx("Dubai") = 1;

* fijamiento para imposibilitar la apertura de nuevos almacenes
*y.fx("Ghana") = 0;
*y.fx("Marruecos") = 0;
*y.fx("Sudafrica") = 0;

*****************************************************************************************************************************************************

Model modelo_1 /all/;

* resolucion de la primera fase
Solve modelo_1 using MIP minimizing F_OBJ_1;

* actualizacion de resultados para el archivo de salida
var_F_OBJ_1 = F_OBJ_1.l; var_I(g) = I.l(g); var_z(s,g) = z.l(s,g); var_x_OOSJ(s,j,k) = x_OOSJ.l(s,j,k);
var_x_OOGJ(g,j,k) = x_OOGJ.l(g,j,k); var_x_ER(g,j,k) = x_ER.l(g,j,k); var_ex_ER(g,j,k) = ex_ER.l(g,j,k);
var_y(g) = y.l(g); var_gamma_(j,k) = gamma_.l(j,k); var_C1(g,j,k) = C1.l(g,j,k); var_C2(g,j,k) = C2.l(g,j,k);

* generacion del archivo de salida
Execute_unload "solucion_modelo_1" var_F_OBJ_1 var_I var_z var_x_OOSJ var_x_OOGJ var_x_ER var_ex_ER
var_y var_gamma_ var_C1 var_C2 var_F_OBJ_2;

*****************************************************************************************************************************************************
**** PARETO *****************************************************************************************************************************************
*****************************************************************************************************************************************************

Model modelo_2 /all/;

Scalar 
pareto_beta parametro para generar la frontera de Pareto
num_iter indice numero de la iteracion
optimo valor optimo de f_obj_1;

num_iter = 1;
optimo = F_OBJ_1.l;

Set
n set numero de la iteracion /1*40/;

Parameter
obj_1(n) valor de f_obj_1 en la iteracion n
obj_2(n) valor de f_obj_2 en la iteracion n;

* se recorre un bucle con distintos valores de beta
for (pareto_beta = 0 to 0.4 by 0.001,
* se actualiza la cota pertinente para Pareto
    F_OBJ_1.up = optimo * (1 + pareto_beta);

* se resuelve la optimizacion con la cota
    Solve modelo_2 using MIP minimizing F_OBJ_2;

* se actualizan los valores para almacenar la informacion de cada iteracion
    obj_1(n)$(ord(n) = num_iter) = F_OBJ_1.l;
    obj_2(n)$(ord(n) = num_iter) = F_OBJ_2.l;
    num_iter = num_iter + 1;
);

Execute_unload "soluciones_pareto", obj_1, obj_2;
