import json
import sys

def parse():

    with open('capture.json') as json_file:
        data = json.load(json_file)

        pfxRcd = 0 
        pfxSnt = 0
        msgSent = 0
        inQ = 0
        outQ = 0
        peersEstablished = 0
        receivedPrefixes = []
        for value in data['ipv4Unicast']['peers'].values():
            pfxRcd += int(value["pfxRcd"])
            msgSent += int(value["msgSent"])
            inQ += int(value["inq"])
            outQ += int(value["outq"])
            if (value["state"] == "Established"):
                pfxSnt = int(value["pfxSnt"])
                receivedPrefixes.append(int(value["pfxRcd"]))
                peersEstablished += 1
                

    receivedPrefixes = sorted(receivedPrefixes)
    res = ((receivedPrefixes[-1] - receivedPrefixes[0])/receivedPrefixes[0])*100
    print(f"Results for {sys.argv[1]} peers and round {sys.argv[2]}:\n")
    print("Number of peers established: " + str(peersEstablished))
    print("Prefixes in InQ: " + str(inQ))
    print("Prefixes in OutQ: " + str(outQ))
    print("Total message sent: " + str(msgSent))
    print("Total prefixes received: " + str(pfxRcd))
    print("Total prefixes sent: " + str(pfxSnt))
    print("Difference between received and sent prefixes: " + str(int(pfxRcd-pfxSnt)))
    print("Difference between most and least received prefixes: " + str(res) + "%")

    filename = f"vtyshresults-{sys.argv[1]}peers.txt"
    filename2 = f"vtysh-pfxrcd-{sys.argv[1]}peers.txt"
    results = open(filename, "a")
    pfxRcdResults = open(filename2, "a")

    results.write(f"Results for {sys.argv[1]} peers and round {sys.argv[2]}:\n")
    results.write("Number of peers established: " + str(peersEstablished) + "\n")
    results.write("Prefixes in InQ: " + str(inQ) + "\n")
    results.write("Prefixes in OutQ: " + str(outQ) + "\n")
    results.write("Total message sent: " + str(msgSent) + "\n")
    results.write("Total prefixes received: " + str(pfxRcd) + "\n")
    results.write("Total prefixes sent: " + str(pfxSnt) + "\n")
    results.write("Difference between received and sent prefixes: " + str(int(pfxRcd-pfxSnt)) + "\n")
    results.write("Delta received prefixes: " + str(res) + "%\n")
    results.write("\n")

    pfxRcdResults.write(str(pfxRcd) + "\n")


if __name__ == "__main__":
    parse()
