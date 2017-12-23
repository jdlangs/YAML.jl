
@compat abstract type Node end

type ScalarNode <: Node
    tag::AbstractString
    value::AbstractString
    start_mark::Union{Mark, Void}
    end_mark::Union{Mark, Void}
    #style::Union{Char, Void}

    function ScalarNode(
        tag::AbstractString,
        val::AbstractString,
        start_mark::Union{Mark,Void}=nothing,
        end_mark::Union{Mark,Void}=nothing
    )
        new(tag, val, start_mark, end_mark)
    end
end


type SequenceNode <: Node
    tag::AbstractString
    value::Vector{Node}
    start_mark::Union{Mark, Void}
    end_mark::Union{Mark, Void}
    #flow_style::Bool
    
    function SequenceNode(
        tag::AbstractString,
        val::Vector,
        start_mark::Union{Mark,Void}=nothing,
        end_mark::Union{Mark,Void}=nothing
    )
        new(tag, val, start_mark, end_mark)
    end
end


type MappingNode <: Node
    tag::AbstractString
    value::Vector{Tuple{Node,Node}}
    start_mark::Union{Mark, Void}
    end_mark::Union{Mark, Void}
    #flow_style::Bool

    function MappingNode(
        tag::AbstractString,
        val::Vector,
        start_mark::Union{Mark,Void}=nothing,
        end_mark::Union{Mark,Void}=nothing
    )
        new(tag, val, start_mark, end_mark)
    end
end
