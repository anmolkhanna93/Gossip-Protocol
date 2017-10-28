defmodule PushSum2 do
    def start(parent) do
        pid_str = self() |> inspect
        # String.slice(s, 7..-4) slices 141 from #PID<0.141.0> 
        process_number = elem(Integer.parse(String.slice(pid_str, 7..-4)), 0)
        ratio_list = []
        #listen([], {process_number, 1}, ratio_list, 0, parent, 0)
        listen([], {process_number, 1}, ratio_list, parent, 0)
    end
    defp listen(neighbors, {s, w}, ratio_list, parent, neighbor_count, terminated \\ false) do
        #IO.puts "start listening: #{inspect(self())}"
        receive do
            {:neighbours, neighbor_list} -> 
                {neighbors, neighbor_count} = set_neighbors(neighbor_list)
                #IO.inspect neighbors, label: "Registered neighbors"
            {:rumor, from, message} -> 
                {s, w, ratio_list, terminated, neighbors, neighbor_count} = handle_rumors(message, {s, w}, ratio_list, neighbors, from, parent, neighbor_count, terminated)
            {:initiate, _} -> 
                s = s/2
                w = w/2
                ratio = s/w
                ratio_list ++ [ratio]
                {neighbors, neighbor_count} = send_rumor({s, w}, neighbors, neighbor_count)
        after
            100 -> {neighbors, neighbor_count} = check_active_neighbors(neighbors, parent, neighbor_count)
        end
        if ratio_list != nil and (length ratio_list) ==  3 do
            if !terminated do
                #IO.puts "self: #{inspect(self())} ratio_list: #{inspect(ratio_list)}"
                if abs((Enum.at(ratio_list, 1) - Enum.at(ratio_list, 0))) <= 0.0000000001 &&
                    abs((Enum.at(ratio_list, 2) - Enum.at(ratio_list, 1))) <= 0.0000000001 do
                    terminated = true
                    terminate(parent)
                # else
                #     {s, w, ratio_list} = handle_ratio(s, w, ratio_list)
                #     :timer.sleep(10)
                #     send_rumor({s, w}, neighbors, neighbor_count, true)
                end
            else
                :timer.sleep(50)
                {neighbors, neighbor_count} = send_rumor({s, w}, neighbors, neighbor_count)
            end 
        end
        listen(neighbors, {s, w}, ratio_list, parent, neighbor_count, terminated)
    end
    defp check_active_neighbors(neighbors, parent, neighbor_count) do
        # make sure that the initialization of the node is done
        # as  after initialization it will have non zero neighbors
        if neighbor_count != 0 do
            {_, neighbors, neighbor_count} = get_active_neighbors(neighbors, MapSet.new, 0, neighbor_count)
            #IO.puts "self: #{inspect(self())} check active neighbors here: #{inspect(neighbors)}"
            if neighbor_count == 0 do
                #IO.puts "No active neighbors left: #{inspect(self())}"
                terminate(parent)
            end
        end
        {neighbors, neighbor_count}
    end
    defp set_neighbors(neighbors) do
        neighbors = List.delete(neighbors, self())
        neighbor_count = length(neighbors)
        {neighbors, neighbor_count}
    end
    defp handle_rumors({new_s, new_w}, {s, w}, ratio_list, neighbors, from, parent, neighbor_count, terminated) do
        #IO.puts "Received rumor from: #{inspect(from)} to: #{inspect(self())} new_s: #{new_s} new_w: #{new_w} old_s: #{s} old_w: #{w}"
        s = new_s + s
        w = new_w + w
        {s, w, ratio_list} = handle_ratio(s, w, ratio_list)
        {neighbors, neighbor_count} = send_rumor({s, w}, neighbors, neighbor_count)
        {s, w, ratio_list, terminated, neighbors, neighbor_count}
    end
    defp handle_ratio(s, w, ratio_list) do
        s = s/2
        w = w/2
        ratio = s / w

        if ratio_list == [] or (length ratio_list) < 3 do
            ratio_list = ratio_list ++ [ratio]
        else
            ratio_list = ratio_list ++ [ratio]
            ratio_list = List.delete_at(ratio_list, 0)
        end
        {s, w, ratio_list}
    end
    defp send_rumor({s, w}, neighbors, neighbor_count, self \\ false) do
        #recipients = get_random_neighbors(neighbors)
        if self do
            recipients = [self()]
        else
            {recipients, neighbors, neighbor_count} = get_active_neighbors(neighbors, MapSet.new, 0, neighbor_count)
        end
        for recipient <- recipients do
            #IO.puts "self: #{inspect(self())} send to: #{inspect(recipient)} s: #{s} w: #{w}"
            send recipient, {:rumor, self(), {s, w}}
        end
        {neighbors, neighbor_count}
    end
    defp get_random_neighbors(neighbors, number \\ 1) do
        Enum.take_random(neighbors, number)
    end
    # Following can be used in fault tolerance code
    defp get_active_neighbors(neighbors, act_recipients, size, neighbor_count) when size == 1 do
        #IO.puts "Recipients selected: #{inspect(act_recipients)}"
        {act_recipients, neighbors, neighbor_count}
    end
    # No more neighbors to be found
    defp get_active_neighbors(neighbors, act_recipients, size, neighbor_count) when neighbors == [] do
        #IO.puts "neighbors exhausted"
        {neighbors, act_recipients, neighbor_count}
    end
    # stop_count is more than total number of current_neighbors
    # defp get_active_neighbors(neighbors, act_recipients, size, stop_count, neighbor_count) when size == neighbor_count do
    #     {act_recipients, neighbors}
    # end
    defp get_active_neighbors(neighbors, act_recipients, size, neighbor_count) do
        #IO.puts "self: #{inspect(self())} neighbor_count: #{neighbor_count} neighbors: #{inspect(neighbors)}"
        neighbor = Enum.random(neighbors)
        #IO.puts "self: #{inspect(self())} neighbors: #{inspect(neighbors)} act_recipients: #{inspect(act_recipients)}"
        if Process.alive?(neighbor) do
            #IO.puts "Adding to active neighbors: #{inspect(neighbor)}"
            act_recipients = MapSet.put(act_recipients, neighbor)
            size = size + 1
        else
            #IO.puts "Removing killed process: #{inspect(neighbor)} from: #{inspect(self)}"
            neighbors = List.delete(neighbors, neighbor)
            neighbor_count = neighbor_count - 1
            #IO.puts "self: #{inspect(self())} left neighbors: #{inspect(neighbors)}"
        end
        get_active_neighbors(neighbors, act_recipients, size, neighbor_count)
    end
    defp terminate(parent) do
        IO.puts "Terminating: #{inspect(self())}"
        send parent, {:terminating, self(), :normal}
        #Process.exit(self(), :normal)
    end    
end
