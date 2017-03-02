#Representation of native Julia data structures into a graph per the YAML spec

yaml_tag(::Void) = "tag:yaml.org,2002:null"
yaml_tag(::Bool) = "tag:yaml.org,2002:bool"
yaml_tag(::Integer) = "tag:yaml.org,2002:int"
yaml_tag(::AbstractFloat) = "tag:yaml.org,2002:float"
yaml_tag(::AbstractString) = "tag:yaml.org,2002:str"
yaml_tag(::Vector) = "tag:yaml.org,2002:seq"
yaml_tag(::Dict) = "tag:yaml.org,2002:map"

#Represent into sequence node
function represent(data::Vector)
    children = [represent(item) for item in data]
    SequenceNode(yaml_tag(data), children, nothing, nothing)
end

#Represent into mapping node
function represent(data::Dict)
    children = [(represent(key), represent(value)) for (key,value) in data]
    MappingNode(yaml_tag(data), children, nothing, nothing)
end

#Scalar representations
function represent(data::Integer)
    ScalarNode(yaml_tag(data), present(data), nothing, nothing)
end

function represent(data::AbstractFloat)
    ScalarNode(yaml_tag(data), present(data), nothing, nothing)
end

function represent(data::AbstractString)
    ScalarNode(yaml_tag(data), present(data), nothing, nothing)
end
