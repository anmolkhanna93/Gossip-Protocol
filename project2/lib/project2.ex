defmodule Project2 do
  @moduledoc """
  Documentation for Project2.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Project2.hello
      :world

  """
  def main(args) do
      {_, [nodes, topology, algo], _} = OptionParser.parse(args)
      #IO.puts "Building mesh topology"
      IO.puts "command line arguments: #{inspect(nodes)}"
      nodes = elem(Integer.parse(nodes), 0)
      IO.puts "algo selected: #{algo} topology: #{topology}"
      case topology do
          "full" -> Mesh.build(nodes, :"#{algo}")
          "line" -> Line.build(nodes, :"#{algo}")
          "imp2d" -> Imp2d.build(nodes, :"#{algo}")
          "2d" -> P2D.build(nodes, :"#{algo}")
      end
      #
      #Line.build(nodes)
  end
end
