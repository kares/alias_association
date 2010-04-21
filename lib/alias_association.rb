
module AliasAssociation

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def alias_association(new_name, ref_name)
      reflection = self.reflections[ref_name.to_sym]
      raise NoMethodError, "undefined association #{ref_name} for #{self}" unless reflection
      case reflection.macro
      when :belongs_to
        # NOTE: we do not alias '#{ref_name}_id' - the FK attribute
        alias_method "build_#{new_name}", "build_#{ref_name}"
        alias_method "create_#{new_name}", "create_#{ref_name}"
        alias_method "loaded_#{new_name}?", "loaded_#{ref_name}?"
        alias_method "set_#{new_name}_target", "set_#{ref_name}_target"
      when :has_one
        alias_method "build_#{new_name}", "build_#{ref_name}"
        alias_method "create_#{new_name}", "create_#{ref_name}"
        alias_method "loaded_#{new_name}?", "loaded_#{ref_name}?"
        alias_method "set_#{new_name}_target", "set_#{ref_name}_target"
      when :has_many, :has_and_belongs_to_many
        ref_sname = ref_name.to_s.singularize
        new_sname = new_name.to_s.singularize
        alias_method "#{new_sname}_ids", "#{ref_sname}_ids"
        alias_method "#{new_sname}_ids=", "#{ref_sname}_ids="
      else
        raise "unsupported reflection.macro #{reflection.macro}"
      end
      # aliases common to all types of macro :
      alias_method new_name, ref_name
      alias_method "#{new_name}=", "#{ref_name}="
    end

    #alias_method :alias_reflection, :alias_association

  end

end
