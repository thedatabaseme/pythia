# General Informations
In this section, you can find some more in detail examples using Pythia. For instance, how to do a duplicate with Pythia.

Pythia works in the following order. This is important to know, which steps will be done in which order.


                +---------------+
                |               |
                | Prerequisites |
                |               |
                +-------+-------+
                        |
                +-------v-------+
                |               |
                | Install RDBMS |
                |               |
                +-------+-------+
                        |
                +-------v-------+
                |               |
                | Patch RDBMS / |
                |  existing DB  |
                |               |
                +-------+-------+
                        |
                +-------v-------+
                |               |
                |  Install DB   |
                |               |
                +-------+-------+
                        |
                +-------v-------+
                |               |
                |  Upgrade DB   |
                |               |
                +-------+-------+
                        |
                +-------v-------+
                |               |
                |  Install add. |
                |   Software    |
                |               |
                +-------+-------+
                        |
                +-------v--------+
                |                |
                | Run SQL Script |
                |                |
                +-------+--------+
                        |
                +-------v--------+
                |                |
                | Install Client |
                |                |
                +-------+--------+
                        |
                +-------v--------+
                |                |
                |  Duplicate DB  |
                |                |
                +----------------+