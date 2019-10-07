# safeBodaChallenge
Greetings and thanks for the opportunity.

---

## Project configuration

This project can run directly, there is no need to previous installations.

1. Xcode 10.2.1
2. Swift version : 5
3. Deployment target : 9


---

## Considerations

The first view has some fixed values in the airports picker and date due to there are a lot of combinations with no results, so for the challenge purposes I chosed some combinations in order to get data and avoid losing time trying to find a match.

When the user selects the fixed airport from the picker, a request is performed in order to get the airport data.

An interesting combination is selecting Frankfurt to New York, here we can see that there are some direct flights and others with more stops.

In the last view we can see a resume of the flight and the map with the polyline connecting both airports.

