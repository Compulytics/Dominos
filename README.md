#############-DOMINOS CONNECTION CHECKER INFORMATION-##############

The Dominos Connection Checker is a monitoring script which displays a list of stores which are unavailable for Online Orders.
This script uses color coding to represent how long the store has been unavailable for online orders as well as to give basic information on what kind of issue is causing the store to be unavailable.
See below for a legend of color codes used by this script and their meanings:

****BLACK BACKGROUND****
Any store listed on a black background has been unavailable for Online Orders for less than 10 minutes.

- Green Text on Black Background = Online Orders have been manually disabled for this store using OSIM.
- Yellow Text on Black Background = The store is reachable through the Dominos network but a problem on PulseBOS is causing a connection error. (This is usually caused by an error in the World Wide Web Publishing Service)
- Red Text on Black Background = The store is unreachable through the Dominos network. (This is usually caused by the store's internet being down or PulseBOS being turned off)

****RED BACKGROUND****
Any store listed on a red background has been unreachable through the Dominos network for more than 10 minutes.

****YELLOW BACKGROUND****
Any store listed on a yellow background has been unavailable for Online Orders for more than 10 minutes due to a problem on PulseBOS ***SEE "Yellow Text on Black Background" ABOVE***

****BLUE BACKGROUND****
Any store listed on a blue background has been unavailable for Online Orders for more than 10 minutes but the reason for the outage has changed. (This is usually seen when PulseBOS reboots)

- Yellow Text on Blue Background = On last check, the store WAS NOT reachable through the Dominos network. The store IS now reachable through the Dominos network but a problem on PulseBOS is causing a connection error. ***SEE "Yellow Text on Black Background" ABOVE***
- Red Text on Blue Background = On last check, the store WAS reachable through the Dominos network. The store is now NOT reachable through the Dominos network.
