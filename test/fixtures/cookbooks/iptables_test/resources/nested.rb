provides :nested
resource_name :nested

property :name, kind_of: String, name_property: true
property :source, kind_of: String, default: nil
property :cookbook, kind_of: String, default: nil
property :lines, kind_of: String, default: nil

default_action :doit

action :doit do
  iptables_rule new_resource.name do
    source new_resource.source
    cookbook new_resource.cookbook
    line new_resource.lines
  end
end
