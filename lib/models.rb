#require 'active_record'
####################################################################
class MaestroLista < ActiveRecord::Base
  self.table_name="T_MAESTRO_LISTAS"
  self.primary_key= :idelista
  has_many :campos_lista  , class_name: "CampoLista",foreign_key:[:idelista]
  has_many :valores_lista , class_name: "ValorLista",foreign_key:[:idelista]
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
  belongs_to :maestro,class_name:"MaestroComp",foreign_key:[:idemaescmp]
  has_many :mi_comp_descs,class_name:"MiCompDesc",foreign_key:[:idecomp]
end

class MiCompDesc < ActiveRecord::Base
  self.primary_keys=[:idecomp,:idioma]
  belongs_to :componente,foreign_key: :idecomp
end
#################################3
# BAREMOS

