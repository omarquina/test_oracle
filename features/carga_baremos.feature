# language: es
# encoding: utf-8

Característica: Carga masiva de baremos

Escenario: Carga de un baremo dada una linea del excel
Dado que se tiene el nombre "20OT VZLA ESP"
Y que se tiene los datos
| COMPONENTE	| NOMBRE EN PORTUGUES	|SUBCOMPONENTE|	NOMBRE EN PORTUGUES|	DAÑO|	NOMBRE EN PORTUGUES|	REPARACION|	NOMBRE EN PORTUGUES|	LARGO|	ANCHO|	HorasBase | MaterialBase| costohh | Total HH| Total | TipoEquipo| Naviera|
|CONT|CONTAINER 20´|CON|CONTAINER 20'|FO|ODOR|LAV|CLEAN|0|0|1|26,98|16|16|42,98|00SD|TODAS|

Cuando se carga el baremo
Entonces debo obtener al proveedor "20 OT VZLA"
Y debo obtener al baremo "20 OT VZLA"
Y el idioma del baremos es "Español"
Y el maestro de componentes "Container 20´"
Y la descripción del subcomponente "Container 20´"
Y el largo del subcomponente es "0"
Y el ancho del subcomponente es "0"
Y la unidad de medida del subcomponente "Centimetro"
Y la sección del subcomponente mismo nombre del maestro del Componente "Container 20´"
Y el subcomponente "Container 20´" debe estar asociado al baremo "20 OT VZLA"

Y se lista el valor de un daño "Fuerte Olor"
Y se lista el valor de una reparación/acción "Lavar"


Escenario: Carga de un baremo dada una linea del excel 2do caso.
Dado que se tiene el nombre "20OT VZLA ESP"
Y que se tiene los datos
| COMPONENTE | Componente | SUBCOMPONENTE| SUBCOMPONENTE | DAÑO | DAÑO |	REPARACION | REPARACION | LARGO| ANCHO|	HorasBase | MaterialBase| costohh | Total HH| Total | TipoEquipo| Naviera|
|CONT|LONA|CON|ARGOLLAS DEL TENSOR |FO|ROTO|LAV|REEMPLAZAR|0|0|3|165,31|16|48|213,31|00SD|TODAS|


Cuando se carga el baremo
Entonces debo obtener al proveedor "20 OT VZLA"
Y debo obtener al baremo "20OT VZLA"
Y el idioma del baremos es "Español"
Y el maestro de componentes "20OT"
Y la descripción del subcomponente "ARGOLLAS DEL TENSOR"
Y el largo del subcomponente es "0"
Y el ancho del subcomponente es "0"
Y la unidad de medida del subcomponente "Centimetros"
Y la sección del subcomponente "Lona"
Y el subcomponente "ARGOLLAS DEL TENSOR" debe estar asociado al baremo "20OT VZLA"
Y ese componente en el baremo se lista con el valor de un daño "ROTO"
Y ese componente en el baremo se lista con el valor de una reparación/acción "REEMPLAZAR"
Y ese componente en el baremo se lista con la cantidad de "1"
Y ese componente en el baremo se lista con la costo unitario de ""
Y ese componente en el baremo se lista con la cantidad de "1"

Escenario: Carga de mas de un valor
