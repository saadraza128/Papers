[![License](https://img.shields.io/badge/License-BSD%202--Clause-orange.svg)](https://opensource.org/licenses/BSD-2-Clause)


# Files Description

###     gendirectories.sh

The is the second script to generate the directories for simulation.



You can run the code using 
```bash
bash gendirectories.sh
```

---



## Requirements
* **Bash**



---

###     runeq.sh

The is the third script to equilibration simulation on NAMD.



You can run the code using 
```bash
bash runeq.sh
```

---



## Requirements
* **Bash**
* **NAMD3+**
* **CHARMM36 Forcefield**


---

###     runprod.sh

The is the forth script to run production simulation on NAMD on HPCC.



You can run the code using 
```bash
bash runprod.sh
```

---



## Requirements
* **Bash**
* **NAMD3+**
* **CHARMM36 Forcefield**
* **SLURM**


---

###     eq.namd

NAMD3 parameter file for running equilibration simulation.
---
###     run.namd

NAMD3 parameter file for running production simulation.
---
###     run.sh

SLURM submission script for running simulation on HPCC.
---