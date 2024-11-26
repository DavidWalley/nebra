# nebra
Stellarium Scripts and Other Code for Analyzing Nebra Sky Disc Calendars

The Nebra Sky Disc and the rhyme "High Diddle Diddle" relate to a procedure for keeping a lunar calendar in sync with the seasons. This repo contains code for simulating and analysing potential procedures, and results from some code runs.

Lunar calendars from cultures around the world are based on observations of the Moon's phases, as it cylces from invisible (new) to full and back again about every 29.5 days. No particular skill is required to make these observations - it only requires interest. Combined with counting, early societies had a natural calendar suitable for mid-term planning.

Counting yeilds 12 lunar months per year, with months alternating between 29 and 30 days long. A "year" corresponds to a cycle of the seasons. Observations of the Sun eventually led to our modern solar calendar and understanding of the seasons, but a lunar calendar can stand on its own, without reference to the Sun.

Such lunar calendars account for 354 days of the modern value of 365.24219 days per year, a difference of 11.24219 days. Thus, every 3 years, the lunar calendar drifts a little more than 33 days, or 1 lunar month, from its initial synchronicity. To correct for this, an extra lunar month can be added every 2 or 3 years.

Deciding whether to add a "leap lunar month", or not, is the hypothetical subject of the Sky Disc and the rhyme, and what we are simulating here.

The use of calendars and astronomical observations in determining when to plant and harvest is often overstated. There are dozens of signs of spring that any given farmer would use, perhaps including the melting of snow, bird migrations, budding of leaves, and so on. For harvest, the readiness of the crop would surely top the list. Observations of the sky would surely be one factor, but claiming or implying it is the only factor is unjustified.

Far more important for emerging societies is the ability to synchronize group activities - market days and fares, celebrations, and war, for example. For this, the procedure should be reproducible across a geographic area, and adaptable to working around bad weather. While considerable experties is required to create the procedure, it is most useful if its application is understood by everyone. 

More details can be found at https://dcwalley.com/sky-disc, but the basic proposed procedure is:

- Count the days of the previously declared year, till the last (lunar) month (around the modern calendar's December).
- Look for a waxing crescent Moon, and the last time it sets (before becoming gibbous).
- Count another 7 or 8 nights to the full Moon, noting nightly Moon positions should they be needed due to unfavorable weather.
- When Vega kisses the horizon, if the Moon is still in Taurus the new year needs an intercalary month. If in Gemini, no extra month is required.
- If a close call, use the line defined by the 2 brightest stars of nearby Canis Minor as the boundary.
- In any case, when the ball of the Harp star Vega drops and kisses the horizon, it is midnight and a new year, so kiss someone and sing.

There are several variations of this which also work. For example, the count from gibbous to full can be 7 nights, or 8 nights. One goal of this code is to test the effects of some of these choices, perhaps leading to insights on choices facing early astronomers.

Some details of potential calendars are beyond computer analysis. For example, names of things, and exactly when the leap month (and leap days) are added. Some historical evidence exists to help, but our code cannot address all these details. 

The hope is that running the code in this repo leads to new ideas and further investigations that use or extend the code.

# Stellarium

Stellarium software v:24.2+ , downloaded for free from stellarium.org, was the starting point for calculating and displaying the night sky for current and historic dates. Stellarium contributors (2024). Stellarium v24.3 Astronomy Software. URL https://stellarium.org/. DOI: 10.5281/zenodo.13825639

This research has made use of the Stellarium planetarium. Zotti, G., Hoffmann, S. M., Wolf, A., Chéreau, F., & Chéreau, G. (2021). The Simulated Sky: Stellarium for Cultural Astronomy Research. Journal of Skyscape Archaeology, 6(2), 221–258. DOI: 10.1558/jsa.17822

Stellarium was not originally designed for simulation of historic or prehistoric skies, but has become a goal. The developers now claim arcseconds accuracy going back at least 10,000 years (User Guide, Appendix F, https://stellarium.org/files/guide.pdf).

Stellarium features scripting capabilities, which seemingly makes it ideal for retroactive testing of potential lunar calendar systems. However, at the time of this writing, it suffers from a couple of problems. First, it can be very slow. Some calculations have to wait for graphical rendering to finish before results are accurate. Second, while output to the file system is possible with text logs and high quality screen, file input is awkward or impossible so that only generated source code is practical.

To test calendar systems, initial code was working but just too slow for multiple tests. Instead, the code is now in two parts. 

The first part is a Stellarium script which generates CSV (comma separated values) files with basic information about the sun and moon, as seen from a point on Earth. Each row represents data for one night, and each file covers one (Gregorian) year. It can take hours, days even, to generate files for significant time spans, so the code is intended to run unattended over-night and/or in the background.

The second part is a Haxe program for reading the generated files, and testing various potential astronomical procedures reasonably quickly. The Haxe language is designed to use and be compatible with, and exportable to, various other languages including JavaScript, Java, Python and C.

