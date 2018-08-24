require 'oci8'
require 'active_record'
require 'composite_primary_keys'
require 'pry'


# Cargar el archivo de Baremos
nombre_baremo = "20OT "
idioma = "ESP"
# Cargar la linea
linea = ["CONT","CONTÊINER DE 20´","CON","CONTÊINER DE 20´","FO",
"FORTE CHEIRO","LAV","LAVAR","0","0","1","26","98","16","16","42",
"98","00SD","TODAS"]

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
puts "------"
maestro1= MaestroLista.first
puts maestro1.inspect

pry


# Obtener la primera hoja
#   Extraer el nombre del baremo
#   Extraer el nombre del proveedor
#   Extraer el grupo de los equipos
#   Extraer los subcomponentes
#   Revisar cuales datos se deben insertar en otra tabla para obtener el id, u obtener el id del mismo si ya existe
#   Insertar el Baremo

