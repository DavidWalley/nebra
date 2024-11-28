# nebra

## Stellarium Scripts and Other Code for Analyzing the Nebra Sky Disc

The Nebra Sky Disc and the rhyme "High Diddle Diddle" relate to a procedure for keeping a lunar calendar in sync with the seasons. This repo contains code for simulating and analysing potential procedure variations.

Lunar calendars from cultures around the world are based on observations of the Moon's phases, as it cycles from new (invisible) to full, and back again, about every 29.5 days. No particular skill is required to make these observations - it only requires interest in the sky, and the Moon in particular. Combined with counting, the sky gave early societies a natural calendar, suitable for mid-term planning and societal synchronization.

Counting yeilds 12 months (lunar phase cycles) per year, with months alternating between 29 and 30 days long, and "year" corresponding to a cycle of the seasons. Astronomers observing the Sun over long terms can become more precise, but a lunar calendar can stand on its own and find use by everyone, long before precision or understanding.

Such simple counting and observation account for 354 days of the modern value of 365.24219 days per year, a difference of 11.24219 days. Thus, every 3 years, the lunar calendar drifts a little more than 1 lunar month, from its initial synchronicity. To correct for this, an extra lunar month can be added every 2 or 3 years.

The annual decision to add a "leap lunar month" or not, is the hypothetical subject of the Sky Disc and the rhyme, and what we are simulating with this code.

The importance of calendars and astronomical observations for determining when to plant and harvest, is often overstated. There are dozens of signs of spring that a farmer would use, perhaps including the melting of snow and ice, bird migrations, budding of leaves, and so on. For harvest, the maturity of the crop would surely be the most important factor. Observation of the sky might be a factor, but if anything like today, every farmer would have their own way of deciding when to plant.

Far more important for emerging societies is the ability to synchronize group activities - market days and annual fairs, celebrations, war, and more mundane meetups. Importantly, synchronizing calendars to the sky synchronizes calendars to each other. Procedures to do this should work across a geographic area, and work-around bad weather. While considerable expertise is required to create such a procedure, its application should be simple and understandable by everyone.

We believe the Sky Disc and "High Diddle Diddle" point to such a common procedure. More details can be found at https://dcwalley.com/sky-disc, but the basic proposed procedure is:

- Count the days of the previously declared year, till the last (lunar) month (around our modern calendar's December).
- Look for a waxing crescent Moon, and the last time it sets (before becoming gibbous).
- Count another 7 or 8 nights to the full Moon, noting nightly Moon positions should they be needed due to unfavorable weather.
- When the star Vega kisses the horizon, if the Moon is still in Taurus, the new year needs an intercalary month. If in Gemini, no extra month is required.
- If a close call, use the line defined by the 2 brightest stars of nearby Canis Minor as the boundary.
- In any case, when the ball of the Harp star Vega drops and kisses the horizon, it is midnight and a new year, so kiss someone and sing.

The main goal of this code is show that proposed procedures work over centuries, and get a measure of how well they work. 

There are several variations of the proposed procedure which work. For example, the count from gibbous to full can be 7 nights, or 8 nights. Both work if applied consistently.

Another goal of this code is to test the effects of some of these choices, perhaps leading to insights on choices facing early astronomers. The hope is that this repo's code leads to hints that might support or refute whatever can be gleaned from historical research.

We are interested in theoretical calendars here. Whether or not any particular system was implemented, or implemented consistently over any particular geographic area or time span, is an entirely different question. In the modern day, calendars, timezones, and Daylight Saving Time are all subject to politics, and there is no reason to think prehistoric time-keeping was any different.

## Stellarium
Stellarium software v:24.3+, downloaded for free from stellarium.org, was the starting point for calculating and displaying the night sky for current and historic dates. [^Stellarium contributors (2024). Stellarium v24.3 Astronomy Software. URL https://stellarium.org/. DOI: 10.5281/zenodo.13825639]

This research has made use of the Stellarium planetarium. [^Zotti, G., Hoffmann, S. M., Wolf, A., Chéreau, F., & Chéreau, G. (2021). The Simulated Sky: Stellarium for Cultural Astronomy Research. Journal of Skyscape Archaeology, 6(2), 221–258. DOI: 10.1558/jsa.17822]

Stellarium was not originally designed for simulation of historic or prehistoric skies, but this has become a goal. The developers now claim a few arcseconds of accuracy going back at least 10,000 years. [^User Guide, Appendix F, https://stellarium.org/files/guide.pdf]

Stellarium features scripting capabilities, which makes it ideal for retroactive testing of potential lunar calendar systems, or so it seems. However, at the time of this writing, it suffers from a couple of problems. First, it can be very slow. Some calculations have to wait for graphical rendering to finish before results are accurate. The only way to do this appears to be generous use of 'wait' commands. Second, while output to the file system is possible with text logs and high quality screen snapshots, file input is awkward or impossible, so the only simple, practical data input is generated source code.

To test calendar systems, initial code worked, but was too slow for multiple tests. Instead, the code is now in two parts. 

The first part is a Stellarium script which generates CSV (comma separated values) files with basic information about the sun and moon, as seen from a point on Earth (Stonehenge). Each row represents data for one night, and each file covers one (Gregorian) year. It can take hours, days even, to generate files for significant time spans, so the code is intended to run unattended overnight and/or in the background. Output is stored in this repo in the folder "trials".

The second part is a Haxe program for reading the generated files, and testing various potential astronomical procedures quickly using local command line execution. The Haxe language was chosen because it is designed to use, be compatible with, and port code to, various other languages including JavaScript, Java, Python and C.

## Files and Directories
| File / Folder name      | Contents                                                                 |
|------------------------|----------------------------------------------------------------------|
| README.md               | This file.                                                               |
| lunascope.ssc           | Stellarium script for generating sun and moon data files.                |
| TestProcedures.hx       | Haxe code for reading data files and testing various lunar sync systems. |
| Tool_Chain_lunascope.hx | Haxe bodge code for pre-processing and Stellarium script lunascope.ssc   |
| trials/                 | Results of running lunascope.ssc, and input to TestProcedures.hx         |
| trials/YYYY_yyyy/       | CSV files of results for a range of years.                               |
| YYYY_yyyy/table012_*    | CSV files of results for a years, from a particular version of code.     |

## License
Shield: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg
