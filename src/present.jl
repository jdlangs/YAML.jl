#Scalar presentations

function present(data)
    io = IOBuffer()
    present(io, data)
    String(take!(io))
end

#"tag:yaml.org,2002:null"
function present(io::IO, ::Void)
end

#"tag:yaml.org,2002:bool"
function present(io::IO, b::Bool)
    if b
        print(io, "true")
    else
        print(io, "false")
    end
end

#"tag:yaml.org,2002:int"
#"tag:yaml.org,2002:float"
function present(io::IO, n::Real)
    print(io, n)
end

#"tag:yaml.org,2002:str"
function present(io::IO, str::AbstractString)
    print(io, str)
end

#"tag:yaml.org,2002:binary"
#function present(io:IO, n::Vector{UInt8})
#end

#"tag:yaml.org,2002:timestamp"
#function present(io::IO, t::DateTime)
#end

#Collection presentations

#"tag:yaml.org,2002:seq"
#"tag:yaml.org,2002:map"
#"tag:yaml.org,2002:omap"
#"tag:yaml.org,2002:pairs"
#"tag:yaml.org,2002:set"

function present_node(io::IO, n::ScalarNode)
    print(io, n.value)
end

function present_node(io::IO, n::SequenceNode)
    for node in n.value
        print(io, "  - ")
        present_node(io, node)
        println(io)
    end
end

function present_node(io::IO, n::MappingNode)
    for (knode, vnode) in n.value
        present_node(io, knode)
        print(io, ": ")
        present_node(io, vnode)
        println(io)
    end
end

function present_node(n::Node)
    io = IOBuffer()
    present_node(io, n)
    String(take!(io))
end
