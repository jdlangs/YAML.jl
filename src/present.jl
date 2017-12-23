import Base: print, println

mutable struct Presenter
    stream::IO
    indent::Int
    prefix::String
    Presenter(str::IO) = new(str, 0, "")
end

indent!(p::Presenter) = (p.indent += 1; p)
unindent!(p::Presenter) = (p.indent -= 1; p)
setprefix!(p::Presenter, prefix::AbstractString) = (p.prefix = prefix; p)

function print(p::Presenter, args...; indent::Bool=true)
    if indent
        print(p.stream, repeat("  ", p.indent))
    end
    print(p.stream, p.prefix, args...)
end

function println(p::Presenter, args...; indent::Bool=true)
    if length(args) > 0
        print(p, args...; indent=indent)
    end
    println(p.stream)
end

function present_node(n::Node)
    io = IOBuffer()
    present_node(Presenter(io), n)
    String(take!(io))
end

function present_node(p::Presenter, n::ScalarNode; flow_style::Bool=true)
    print(p, n.value)
end

function present_node(p::Presenter, n::SequenceNode; flow_style::Bool=false)
    if flow_style
        print(p, "[")
    end
    for node in n.value
        if ! flow_style
            print(p, "- ")
            setprefix!(p, "  ")
        end
        present_node(p, node; flow_style=true)
        setprefix!(p, "")
        if flow_style
            print(p, ", "; indent=false)
        else
            println(p)
        end
    end
    if flow_style
        print(p, "]")
    end
end

function present_node(p::Presenter, n::MappingNode; flow_style::Bool=false)
    if flow_style
        print(p, "{")
        println(p)
    end
    for (idx, pair) in enumerate(n.value)
        knode, vnode = pair
        present_node_as_key(p, knode)
        print(p, ": "; indent=false)
        present_node(p, vnode, flow_style=true)
        if flow_style
            print(p, ",")
        end
        println(p)
    end
    if flow_style
        print(p, "}")
    end
end

present_node_as_key(p::Presenter, n::ScalarNode) = present_node(p, n)

function present_node_as_key(p::Presenter, n::Node)
    println(p, "?")
    indent!(p)
    present_node(p, n)
    unindent!(p)
end
