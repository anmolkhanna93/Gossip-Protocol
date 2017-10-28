# Project2

READ ME file for Distributed Operating Systems - Project 2, Due Date: 7th October,2017

Group members:

Team 3
1. Anmol Khanna, UFID:65140549, anmolkhanna93@ufl.edu,
2. Akshay Singh Jetawat, UFID:22163183, akshayt80@ufl.edu,

# What is Working:

Gossip Protocol: Each process in the network listens for gossips. When a rumor is heard by a process, it spreads it to other neighbor process in the network selected at random. The alignment of neighbor varies according to the underlying topology. 
Each process in the topology maintains its own state which comprises of its neighbors, a count variable to store the number of rumors received so far i.e. every process has a count of how many times it has heard a rumor.Once a process receives a particular number of rumors, it sends the notification to its parents notifying about its completion and terminates.

We experimented with different number of nodes with different topologies keeping the count of rumors to be constant in all the cases for the termination of a process. The time taken to achieve convergence (in ms) for different configurations is shown below:

|Nodes |Full	|line	  |2d	  |Imperfect 2d|
|------|------|-------|-----|------------|
|50	   |2219	|10656	|3823 |3823        |
|100	 |2225	|15682	|4427	|3420        |
|500	 |2586	|67340	|7443	|4426        |
|1000	 |3266	|113572	|8852	|4830        |
|1500	 |4072	|289448	|10863|5233        |

![alt tag](https://github.com/akshayt80/gosip_simulator/blob/master/Gossip.png)

PushSum Algorithm:
The Actor initiates the algorithm by sending a message to one of its randomly selected neighboring processes. Each process maintains its own state to hold the process id's of its neighboring processes. This state depends upon the topology being used. We use s to represent the sum, w to store the weight and use the process id's of the parent process for notifying once the process is completed. In the input of the message, the s and w values of the received message are added to the initial s and w values of the process. Also, the total sum of all the process is constant. With every iteration of the process, the values of s and w keep on changing. The process is termintaed as follows, the receiver process calculates the difference between the s/w values and when the valus of the change goes below the threshold times, the process is terminated. Afte all the processes get terminated, the parent process gives the total time for the protocol and terminates.

We experimented with different number of nodes with different topologies keeping the count of rumors to be constant in all the cases for the termination of a process. The time taken to achieve convergence (in ms) for different configurations is shown below:

|Nodes |Full	|line	  |2d	  |Imperfect 2d|
|------|------|-------|-----|------------|
|10	   |112	  |41422	|1691 |1333        |
|20	   |268	  |    	  |3128 |1699        |
|30	   |329   |   	  |9156	|3952        |
|40	   |395	  |   	  |43228|13029       |
|50	   |507	  |   	  |57480|17300       |

- We have recorded only one value for line topology as it takes long to converge.

![alt tag](https://github.com/akshayt80/gosip_simulator/blob/master/Picture1.png)

In the above graph, we have just taken a single reading for the line topology as we tried testing for other larger values of nodes, due to limited resources of our systems, those larger values were taking far too much of time.

In conclusion, we have implemented all the topologies along with the pushsum and gossip algorithms. 

# Largest Network Managed for each algorithm and topology.

This may vary significantly from machine to machine.

On our systems, we got the following values:

For Gossip:
-----------

1. Line: 1500
2. Full: 5000
3. 2D: 1500
4. Imp-2D: 1500

For Push-Sum:
-------------
1. Line :10
2. Full: 50
3. 2D: 50
4. imp-2D: 50

NOTE: The highest values are not recorded every time we run the program.

