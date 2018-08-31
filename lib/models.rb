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
