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
Y el subcomponente "Container 20´ 0x0"


Escenario: Carga de mas de un valor
