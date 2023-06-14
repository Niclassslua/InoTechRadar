# InoTechRadar
I decided to give this [resource](https://forum.cfx.re/t/beta-radar-and-sonar-for-aircraft-boats/17815) from 2017 a rework and fix the main error of the radar not working. Forks and commits are appreciated.


# Requirements & Dependencies:
ESX (will be removed, only used in one function)

# Features:
- Tracks other player-controlled aircraft and boats.
- Toggleable interface display, which is maximized while in first person. (See example screenshot [#1](https://i.imgur.com/ZzXTtdx.jpg))
- Different vehicles have different radar ranges and refresh rates. (Military vehicles are generally equipped with much stronger radar, for instance). 2D range checks are used for simplicity’s sake.
- Configurable LoS checks allows for using terrain or buildings to occlude yourself, effectively allowing you to “fly under the radar”.
- Radar targets will be displayed with their callsign, distance, altitude, and velocity. (See example screenshot #1).
- Sonar targets are only displayed as a dot (See example screenshot [#2](https://i.imgur.com/MJKL4mr.png)).
- Radar cannot see targets that are submerged, and Sonar can only see other boats and subs.
- Size of the radar scales automatically with your resolution.

# Todos:

*) Angle based radar 

**) Animate radar sweep? Performance may be an issue for spam-updating html canvas

**) Bonus points if sweep can be matched with physically visible radar on Predator.

*) Client-side options

*) Implement radar types for different identification & showing directional vectors

*) Active & Passive SONAR

**) Active range sonar would greatly boost range, but also reveal your own position to other sonar from far away

**) Allow boats/subs without active SONAR to be invisible from passive SONAR while their engines are turned off (or going very slowly?)

***) Will need server-side code to propagate sonar status

***) Will need to ensure passengers in vehicles cannot change active sonar status, and get their own active sonar status from server.

***) There are currently no multi-person submarines, though.

*) Possibly add propagation delay to SONAR to simulate speed of sound

**) Investigate performance issues if this was to be implemented (10hz radius increase rate should be enough)

**) Save vehicle identifier?

**) Risks looking weird as fuck while turning

*) Add static ground radar

**) Add ground radar operation

**) Add radar distribution system

*) Add radar to certain dinghy variations (all seat variations)

*) Take target signature into account?

*) Would love some way to detect NPCs

*) Add knots as an option for velocity display

*) Comment code... for everyone's sake...

**All credits go to [Ino](https://forum.cfx.re/u/Ino)!**
