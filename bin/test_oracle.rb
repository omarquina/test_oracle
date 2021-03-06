#encoding: utf-8

require 'oci8'
require 'active_record'
require 'composite_primary_keys'
require 'pry'
require 'ostruct'

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

#puts conn.connection.execute("SELECT TABLE_NAME FROM USER_TABLES").to_s
#puts "------"
#maestroLista1= MaestroLista.first
#puts maestroLista1.inspect

#maestroComp1 = MaestroComp.first
#listas_accion_componente = nil

# Cargar el archivo de Baremos
nombre_archivo = "VZLA 20OT"
nombre_baremo = "20OT"
componente_descripcion = "20OT"
pais = "VENEZUELA"

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

lineas = [
         ["CONT","LONA","CON","ARGOLLAS DEL TENSOR","FO","ROTO","LAV","REEMPLAZAR","0","0","3","165,31","16","48","213,31","00SD","TODAS"],
         #["CONT","LONA","CON","ARGOLLAS DEL TENSOR","FO","ROTO","LAV","REEMPLAZAR","0","0","3","165,31","16","48","213,31","00SD","TODAS"],
         #["CONT","LONA","CON","ARGOLLAS DEL TENSOR","FO","ROTO","LAV","REEMPLAZAR","0","0","3","165,31","16","48","213,31","00SD","TODAS"],
         #["CONT","LONA","CON","ARGOLLAS DEL TENSOR","FO","ROTO","LAV","REEMPLAZAR","0","0","3","165,31","16","48","213,31","00SD","TODAS"],
         ]

linea = lineas[0]

ActiveRecord::Base.transaction do
# Obtener la primera hoja
# Extraer el nombre del baremo
#   Revisar cuales datos se deben insertar en otra tabla para obtener el id, u obtener el id del mismo si ya existe
#   Insertar el Baremo

### Idiomas

  maestro_idiomas = MaestroLista.find_by(descripcionlista:"LISTA DE IDIOMAS")
  lista_idiomas = maestro_idiomas.valores_lista
  idioma_obj = lista_idiomas.find_by(codigovalor: idioma)
  puts "IDIOMAS: #{lista_idiomas.inspect}"
  puts "IDIOMA: #{idioma.inspect}","----"
  
  # Unidad siempre es "CENTIMETRO"
  maestro_unidades_medida = MaestroLista.find_by(descripcionlista:"UNIDADES DE MEDIDA")
  unidad_medida_obj = maestro_unidades_medida.valores_lista.find_by(descripcionvalor: "CENTIMETROS")
  puts "Unidad Medida #{unidad_medida_obj.inspect}"

#Definir la ubicación 
# del Baremo
ubicacion = OpenStruct.new #(:pais,:estado,:ciudad,:municipio,:direc)
case pais
  when /VENEZUELA/i
    ubicacion.pais = Pais.find_by( descpais: pais )
    #ubicacion.estado = Estado.find_by( descestado: "DISTRITO CAPITAL" )
    #ubicacion.ciudad = Ciudad.find_by( descciudad: "CARACAS" )
    #ubicacion.municipio = Municipio.find_by( descmunicipio: "BARUTA" )
    ubicacion.direc = pais
    ubicacion.tipoid = "J"
    ubicacion.numid = "010123456"
    ubicacion.dvid = "2"
  when /COLOMBIA/i
    ubicacion.pais = Pais.find_by( descpais: pais )
    #ubicacion.estado = Estado.find_by( descestado: "" )
    #ubicacion.ciudad = Ciudad.find_by( descciudad: "" )
    #ubicacion.municipio = Municipio.find_by( descmunicipio: "" )
    ubicacion.direc = pais
    ubicacion.tipoid = "J"
    ubicacion.numid = "010123456"
    ubicacion.dvid = "2"
  when /COSTA RICA/i
    ubicacion.pais = Pais.find_by( descpais: pais )
    #ubicacion.estado = Estado.find_by( descestado: "" )
    #ubicacion.ciudad = Ciudad.find_by( descciudad: "" )
    #ubicacion.municipio = Municipio.find_by( descmunicipio: "" )
    ubicacion.direc = pais
    ubicacion.tipoid = "J"
    ubicacion.numid = "010123456"
    ubicacion.dvid = "2"
  when /HONDURAS/i
    ubicacion.pais = Pais.find_by( descpais: pais )
    #ubicacion.estado = Estado.find_by( descestado: "" )
    #ubicacion.ciudad = Ciudad.find_by( descciudad: "" )
    #ubicacion.municipio = Municipio.find_by( descmunicipio: "" )
    ubicacion.direc = pais
    ubicacion.tipoid = "J"
    ubicacion.numid = "010123456"
    ubicacion.dvid = "2"
end
### CREAR U OBTENER OFICINA
  ##Oficina.find_or_create_by( direc: )

  #oficina = Oficina.first
  #oficina = Oficina.find_by(codofi: "010500")
#pry
  oficina = Oficina.find_or_create_by(direc: ubicacion.direc) do |objeto|
     objeto.codofi = (Oficina.maximum(:codofi).to_i+1).to_s.rjust(6,"0")
     objeto.codpais = ubicacion.pais.codpais
     #objeto.codestado = ubicacion.estado.cod
     #objeto.codciudad = ubicacion.ciudad.cod,
     #objeto.codmunicipio = ubicacion.municipio.cod,
     objeto.direc = pais
     objeto.stssucur = "ACT"
     objeto.fecsts = Date.today
  end
puts "OFICINA: #{oficina.inspect}"
  ### CREAR U OBTENER PROVEEDOR
#   Extraer el nombre del proveedor
  #Proveedor.find_or_create_by()
  #proveedor = Proveedor.first
#pry
  proveedor_descripcion = Tercero.find_or_create_by(nomter: ubicacion.direc ) do |objeto|
     objeto.razonsocial = ubicacion.direc
     objeto.tipoid = ubicacion.tipoid 
     objeto.numid = ubicacion.numid
     objeto.dvid = ubicacion.dvid
     objeto.codpais = ubicacion.pais.codpais
     objeto.direc = ubicacion.direc
     objeto.indnacional = "J"
     objeto.stster = "ACT"
     objeto.fecsts = Date.today #FECSTS
  end
  
  #proveedor = Proveedor.find_by(codproveedor: "308845698")
  proveedor = Proveedor.find_or_create_by(codproveedor: ubicacion.direc) do |objeto|
    objeto.codproveedor = (ubicacion.numid).rjust(9,"0")
    objeto.tipoid = proveedor_descripcion.tipoid
    objeto.numid  = proveedor_descripcion.numid
    objeto.dvid   = proveedor_descripcion.dvid
    objeto.fecinc = Date.today #FECINC
  end
 # if proveedor.new_record?
 #   Tercero.create(tipoid:,numid:,dvid:)
 # end

puts "PROVEEDOR: #{proveedor.inspect}"

## RAMOS
ramos = Ramo.find(["0094","0095"])
#=begin
######################################################################
   baremo = Baremo.find_or_create_by(descbaremo: nombre_baremo) do |objeto|
     objeto.codofi = oficina.codofi
     objeto.codproveedor = proveedor.codproveedor
     objeto.codmoneda = "USD"
     objeto.idioma = idioma_obj.idevalorlista
     objeto.idebaremo = Baremo.maximum(:idebaremo)+1
     objeto.stsbaremo = "ACT"
     baremo.ramos << ramos
   end
############ DAtos temporales
baremo.proveedor = proveedor
baremo.oficina = oficina
baremo.save

   #baremo.save
puts "Baremo: #{baremo.inspect}"
puts "Baremo: #{baremo.ramos.inspect}"

# COMPONENTE
# Extraer el grupo de los subcomponentes (MaestroComp)
maestrocomp_id = MaestroComp.maximum(:idemaescmp)+1
maestro_componente = MaestroComp.find_or_create_by(desgrpcmp: componente_descripcion ) do |maestro|
  maestro.idemaescmp = maestrocomp_id
  maestro.stsmaescmp= "ACT"
  maestro.fecsts = Date.today
end

puts "Componente: #{maestro_componente.inspect} "



# Extraer los subcomponentes
# Se procesa cada línea del archivo
  lineas.each do |linea_|
        linea = linea_.split(",")
	seccion = linea[1]
	tipo_equipo = linea[15]
	subcomponente = linea[3]
	largo = linea[8]
	ancho = linea[9]
	componente_dano = linea[5]
	componente_accion = linea[7] 
	componente_costo = linea[14]

# obtener el Id de la sección según el nombre del componente
  maestro_uso_componente = MaestroLista.find_by(descripcionlista:"LISTA DE TIPOS DE USO DE COMPONENTE")
  listas_uso_componente = maestro_uso_componente.valores_lista
puts "LISTA USO COMPONENTES: #{listas_uso_componente.inspect}"
  seccion_obj = listas_uso_componente.find_or_create_by(descripcionvalor: seccion) do |valor|
    codigo_valor = listas_uso_componente.maximum(:codigovalor)
    valor.codigovalor = (codigo_valor.to_i + 1).to_s.rjust(5,"0")
    valor.idevalorlista = ValorLista.maximum(:idevalorlista)+1
  end
puts "POST LISTA USO COMPONENTES: #{listas_uso_componente.reload.inspect}"
puts "---"
puts " USO COMPONENTES: #{seccion_obj.inspect}"

# obtener el Id del equipo según el nombre del archivo
  maestro_equipo_componente = MaestroLista.find_by(descripcionlista: "LISTA DE GRUPOS DE COMPONENTES")
  listas_equipo_componente = maestro_equipo_componente.valores_lista
puts "LISTA EQUIPO COMPONENTES: #{listas_equipo_componente.inspect}"
  equipo_obj = listas_equipo_componente.find_or_create_by(descripcionvalor: componente_descripcion) do |valor|
    valor.codigovalor = tipo_equipo
    valor.idevalorlista = ValorLista.maximum(:idevalorlista)+1
 end
puts "POST LISTA USO COMPONENTES: #{listas_equipo_componente.reload.inspect}"
puts "---"
puts " USO COMPONENTES: #{equipo_obj.inspect}"

# Insertar subcomponente
# busar la descripción del componente, por si ya no está creado
subcomponente_desc_obj = MiCompDesc.find_by(idioma: idioma_obj.idevalorlista,desccomp: subcomponente)
subcomponente_obj = nil
unless subcomponente_desc_obj
  subcomponente_obj = maestro_componente.componentes.create do |obj|
    obj.idecomp = Componente.maximum(:idecomp)+1
    obj.ideusocomp = seccion_obj.idevalorlista
    obj.idegrpcomp =  equipo_obj.idevalorlista
    obj.ideunimed = unidad_medida_obj.idevalorlista 
    obj.largo = largo
    obj.ancho = ancho
  end
   
  subcomponente_obj.mi_comp_descs.create(idioma: idioma_obj.idevalorlista,desccomp: subcomponente)
puts "---","SUBCOMPONENTE: #{subcomponente_obj.inspect}, desc: #{subcomponente_obj.mi_comp_descs.inspect}"
else
  subcomponente_obj = subcomponente_desc_obj.componente  
end

#=end

## ASOCIAR EL SUBCOMPONENTE
#
## Obtener el ACCION
# obtener el Id del equipo según el nombre del archivo
  maestro_accion_componente = MaestroLista.find_by(descripcionlista: "TIPO DE ACCION EN EL BAREMO")
  listas_accion_componente = maestro_accion_componente.valores_lista
puts "LISTA ACCION COMPONENTES: #{listas_accion_componente.inspect}"
#=begin
  accion_obj = listas_accion_componente.find_or_create_by(descripcionvalor: componente_accion) do |valor|
    valor.codigovalor = (listas_accion_componente.maximum(:codigovalor).to_i+1).to_s.rjust(2,"0")
    valor.idevalorlista = ValorLista.maximum(:idevalorlista)+1 
 end
#=end
puts "POST LISTA USO COMPONENTES: #{listas_accion_componente.reload.inspect}"
puts "---"
#=begin
## Obtener el DAÑO
# obtener el Id del equipo según el nombre del archivo
  maestro_componente = MaestroLista.where("descripcionlista like ?","TIPO DE DA%O EN EL BAREMO").first
  listas_componente = maestro_componente.valores_lista
puts "LISTA DAÑO COMPONENTES: #{listas_componente.inspect}"
  dano_obj = listas_componente.find_or_create_by(descripcionvalor: componente_dano) do |valor|
    valor.codigovalor = (listas_accion_componente.maximum(:codigovalor).to_i+1).to_s.rjust(2,"0")
    valor.idevalorlista = ValorLista.maximum(:idevalorlista)+1
  end
puts "POST LISTA DAÑO COMPONENTES: #{listas_componente.reload.inspect}"
puts "---------------------------"
#=end

puts "TIPOACCION: #{accion_obj.inspect}"
puts "TIPODANO: #{dano_obj.inspect}"

# AGREGAR COMPONENTE AL BAREMO
puts "BAREMO COMPONENTES: #{baremo.componentes.inspect}"

baremo.componentes.find_or_create_by(idecomp: subcomponente_obj.idecomp) do |comp|
  comp.tipoaccion = accion_obj.idevalorlista
  comp.tipodano = dano_obj.idevalorlista
  comp.cantcomp = 1
  comp.costcomp = componente_costo
  comp.totgen = componente_costo
end

puts "Baremo componentes: #{baremo.componentes.reload.inspect}"
pry

##  raise ActiveRecord::Rollback
  end # end de each
end # end de transaction

