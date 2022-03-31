# Performance-analysis-of-the-FRRouting-Route-Server

The delivery of IP traffic on the Internet depends on the complex interactions between a set of autonomous systems that exchange routing information about IP prefix destinations utilizing the Border Gateway Protocol (BGP). Autonomous systems are often connected to a route server located at an Internet eXchange Point, which facilitates the administration of BGP peering arrangements for all parties connected to it. One of the most popular open-source implementations of BGP is the FRRouting software suite, making it an important part of the Internet infrastructure.

This thesis investigates the performance of FRRouting, configured as a route server, in terms of its capabilities of announcing routing information on the network to a set of peers emulating autonomous systems. The routing information consists of a set of distinct IP prefixes that FR- Routing receives from its peers. With various benchmarks of different configurations, we relate the number of received prefixes to the number of prefixes that FRRouting has announced on the network to its peers in a given time span. The output of the thesis is a wide overview of how the performance of FRRouting is impacted by different configurations such as filtering of specific prefixes that are not announced to the peering networks.

The obtained results show that there exists a divergence between the number of prefixes that have been received and announced by FRRouting. Specifically, the discrepancy shows that FRRouting, in our benchmarks, is incapable of announcing prefixes at the same rate as it receives these prefixes from its peers. In general, the number of announced prefixes is dependent on how the prefix filter is configured. However, one can question what real-world limitations this may result in. Suggestions for future work include developing a more realistic benchmarking environment that does not rely on emulated peers as well as improving how the routing information is recorded. There also exists a wide variety of other metrics and configurations of FRRouting that may reveal further limitations.

#### Keywords: FRRouting, Border Gateway Protocol, Route Server, Internet eXchange Points

[PDF](http://kth.diva-portal.org/smash/get/diva2:1606472/FULLTEXT01.pdf)

[DiVA](http://kth.diva-portal.org/smash/record.jsf?dswid=-232&pid=diva2%3A1606472&c=1&searchType=SIMPLE&language=en&query=Emil+Ståhl+performance&af=%5B%5D&aq=%5B%5B%5D%5D&aq2=%5B%5B%5D%5D&aqe=%5B%5D&noOfRows=50&sortOrder=author_sort_asc&sortOrder2=title_sort_asc&onlyFullText=false&sf=all)
