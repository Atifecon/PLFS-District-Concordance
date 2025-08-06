# PLFS-District-Concordance
This repository contains do file and map for the state and district concordance of Periodic Labour Force Survey 2017-18 to 2023-24.

Steps:
1. Merge PLFS Files with their respective DistrictName List file using StateCode and DistrictCode as ID.
   2017-18 and 2018-19 with `PLFS_17_dist_list.dta' ; 2019-20 and 2020-21 with `TUS_19_dist_list.dta' ; 2021-22 and 2022-23 with `HCES_22_dist_list.dta' and 2023-24 with `ASUSE_23_dist_list.dta'.
   
2. Run do files.
   asuse_23_to_hces_22.do' for 2023-24 data () `hces_22_to_tus_19.do' for 2022-23 and 2021-22 data , `tus_19_to_plfs_17' for 2020-21 and 2019-20 data.



If you use this concordance in your research, please cite as:
Atif Anwar (2025). PLFS District Concordance Codes. GitHub Repository. https://github.com/Atifecon/PLFS-District-Concordance
