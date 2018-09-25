#encoding: utf-8

require 'oci8'
require 'active_record'
require 'composite_primary_keys'
require 'pry'

# Cargar el archivo de Baremos
nombre_archivo = "VZLA 20OT"
nombre_baremo = "20OT"
componente_descripcion = "20OT"

idioma = "ESP"
idioma_acsel = case idioma
  when "ESP"
    "ESPAÑOL"
  when "ENG"
    "INGLES"
  when "POR"
    "PORTUGUES"
end
# Cargar la linea
linea = ["CONT","CONTÊINER DE 20´","CON","CONTÊINER DE 20´","FO",
"FORTE CHEIRO","LAV","LAVAR","0","0","1","26","98","16","16","42",
"98","00SD","TODAS"]

linea = ["CONT","LONA","CON","ARGOLLAS DEL TENSOR","FO","ROTO","LAV","REEMPLAZAR","0","0","3","165,31","16","48","213,31","00SD","TODAS"]

seccion = linea[1]
tipo_equipo = linea[15]
subcomponente = linea[3]
largo = linea[8]
ancho = linea[9]
componente_dano = linea[5]
componente_accion = linea[7] 
componente_costo = linea[14]

db_config = {
#host: '192.168.210.86',
#port: 1521,
#adapter: 'oracle',
adapter: 'oracle_enhanced',
username: "acsel",
password: "acsel",
#encoding: 'utf-8',
#database: 'srvdevbd',
#database: 'srvdevqa',
database: "(DESCRIPTION=
(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.210.86)(PORT=1521)))
(CONNECT_DATA=(SERVER=dedicated)(SID=srvdevbd)))",
#user: 'oracle',
#password: 'oracle01'
}

#db_config_admin = db_config.merge {}
conn = ActiveRecord::Base.establish_connection(db_config)
require_relative "../lib/models"

puts conn.connection.execute("SELECT TABLE_NAME FROM USER_TABLES").to_s
pry
