#require 'active_record'
####################################################################
# LISTAS DE VALORES Y REGLAS PARA LOS VALORES POR CADA TABLA
class MaestroLista < ActiveRecord::Base
  self.table_name="T_MAESTRO_LISTAS"
  self.primary_key= :idelista
  has_many :campos_lista  , class_name: "CampoLista",foreign_key:[:idelista]
  has_many :valores_lista , class_name: "ValorLista",foreign_key:[:idelista]

  def self.descripcion
    MaestroLista.all.order(:idelista).each do |m|
      m.descripcion
    end
    nil
  end

  def descripcion
     puts "#{self.idelista} :: #{self.descripcionlista}"
          puts "CAMPOS"
	  self.campos_lista.each do |cl| 
            puts "  TABLA: #{cl.nomtabla}:: CAMPO: #{cl.nomcampo}"
          end
          puts "LISTAS"
	  self.valores_lista.each do |vl|
            puts "  IdeValorLista: #{vl.idevalorlista} :: CodigoValor #{vl.codigovalor} :: DescripcionValor: #{vl.descripcionvalor}"
          end
  end
end

class CampoLista < ActiveRecord::Base
  self.primary_keys = [:idelista, :nomtabla,:nomcampo]
  self.table_name="T_CAMPO_LISTA"
  belongs_to :maestro_lista,class_name: "MaestroLista",foreign_key: [:idelista]
end

class ValorLista < ActiveRecord::Base
  self.table_name="T_VALORES_LISTA"
  belongs_to :maestro_lista,class_name: "MaestroLista",foreign_key: [:idelista]
end
####################################################################
#Componentes
class MaestroComp < ActiveRecord::Base
  self.table_name="MI_MAESTRO_COMP"
  self.primary_key=:idemaescmp
  has_many :componentes,class_name: "Componente",foreign_key:[:idemaescmp]
end

class Componente < ActiveRecord::Base
  self.table_name="MI_COMPONENTE"
  #self.primary_keys=[:idecomp,:usocomp,:idegrpcmp,:unimed,:idemaescmp]
  self.primary_key=:idecomp
  belongs_to :maestro,class_name:"MaestroComp",foreign_key: [:idemaescmp]
  has_many :mi_comp_descs,class_name:"MiCompDesc",foreign_key: [:idecomp]
end

class MiCompDesc < ActiveRecord::Base
  self.table_name="MI_COMP_DESC"
  self.primary_keys=[:idecomp,:idioma]
  belongs_to :componente,class_name: "Componente" ,foreign_key: [:idecomp]
end
#################################3
# BAREMOS

class Baremo < ActiveRecord::Base
  self.table_name = "MI_BAREMO"
  self.primary_key = :idebaremo
  has_many :componentes, class_name: "BaremoComponente",foreign_key:[:idebaremo]
  belongs_to :oficina,class_name: "Oficina",foreign_key: :codofi
  belongs_to :proveedor,class_name: "Proveedor",foreign_key: :codproveedor

  has_many :baremos_ramos,class_name: "BaremoRamo",foreign_key: :idebaremo
  has_many :ramos, through: :baremos_ramos,class_name: "Ramo", foreign_key: :codramo
end

class BaremoComponente < ActiveRecord::Base
  self.table_name = "MI_BAREMO_COMP"
  self.primary_keys = [:idebaremo,:idecomp]
  belongs_to :baremo,class_name: "Baremo",foreign_key:[:idebaremo]
  belongs_to :componente,class_name: "Componente",foreign_key: :idecomp
end

class Oficina < ActiveRecord::Base
  self.table_name = "OFICINA"
  self.primary_key = :codofi

  def self.find_by_ubicacion ubicacion
      oficina = Oficina.find_or_create_by(direc: ubicacion.direc) do |objeto|
       objeto.codofi = (Oficina.maximum(:codofi).to_i+1).to_s.rjust(6,"0")
       objeto.codpais = ubicacion.pais.codpais
       objeto.direc = pais
       objeto.stssucur = "ACT"
       objeto.fecsts = Date.today
     end
     oficina
   end
=begin
CAMPOS CON CONSTRAINTS
fecsts
STSSUCUR
DIREC
=end
end

# TPROVEEDOR
# T$_PROVEEDOR
# RENG_DESC_PROV
class Proveedor < ActiveRecord::Base
  self.table_name = "PROVEEDOR"
  self.primary_key = :codproveedor
  belongs_to :tercero,class_name: "Tercero",foreign_key: [:tipoid,:numid,:dvid]
# nombre del proveedor se encuentra en Tercero
# "nomter"
  def nombre
    Tercero.find_by(tipoid: self.tipoid,numid: self.numid,dvid: self.dvid).nomter
  end

  def self.get_by_ubicacion ubicacion
    proveedor_descripcion = Proveedor.get_description ubicacion
    proveedor = Proveedor.find_or_create_by(codproveedor: ubicacion.direc) do |objeto|
    objeto.codproveedor = (ubicacion.numid).rjust(9,"0")
    objeto.tipoid = proveedor_descripcion.tipoid
    objeto.numid  = proveedor_descripcion.numid
    objeto.dvid   = proveedor_descripcion.dvid
    objeto.fecinc = Date.today #FECINC
  end


  end
  
  def self.get_description ubicacion
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
    proveedor_description
 
  end
=begin
CAMPOS CON CONSTRAINTS

CODPROVEEDOR
FECINC
TIPOID
NUMID
DVID

=end

=begin
  ["tipoid",
   "numid",
   "dvid",
   "codproveedor",
   "fecinc",
   "tipoproveedor",
   "numctaaux",
   "stsproveedor",
   "fecsts",
   "indislr",
   "porc_desc",
   "entfinan",
   "numcta",
   "tipocta",
   "indiva",
   "porcretiva"]
=end
end

class Ramo < ActiveRecord::Base
  self.table_name = "RAMO"
  self.primary_key = :codramo
  has_many :baremos_ramos,class_name: "BaremoRamo",foreign_key: :codramo #:idebaremo
  has_many :baremos, through: :baremos_ramos,class_name: "Baremo", foreign_key: :idebaremo
end

class BaremoRamo < ActiveRecord::Base
  self.table_name = "MI_BAREMO_RAMO"
  belongs_to :ramo,class_name: "Ramo",foreign_key: :codramo
  belongs_to :baremo,class_name: "Baremo",foreign_key: :idebaremo
end

class Tercero < ActiveRecord::Base
  self.table_name = "TERCERO"
  self.primary_keys = [:tipoid,:numid,:dvid]
  has_many :proveedores,class_name: "Proveedor",foreign_key: [:tipoid,:numid,:dvid]
end

class Pais < ActiveRecord::Base
  self.table_name= "PAIS"
  self.primary_key ="CODPAIS"

end

class Municipio < ActiveRecord::Base
  self.table_name = "MUNICIPIO"
  self.primary_key = "CODMUNICIPIO"
end

class Ciudad < ActiveRecord::Base
  self.table_name = "CIUDAD"
  self.primary_key = "CODCIUDAD"
end

class Estado < ActiveRecord::Base
  self.table_name = "ESTADO"
  self.primary_key = "CODESTADO"
end

#CF_REGION
class Region < ActiveRecord::Base
  self.table_name = "REGION"
  self.primary_key = "COD"
end

###############################################################################
########
###############################################################################
class Subcomponente
  def initialize
    
  end

  def procesar datos,baremo
     
  end

  def self.procesar datos,baremo
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

  end
end
