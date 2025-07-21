This repository contains the **data** and **R code** to reproduce an R shiny app mapping species richness dynamics across Europe.

![alt text](https://github.com/gmidolo/interpolated_S_change_app/blob/main/screenshot.app.png)

**Description**:

We interpolated spatiotemporal changes in vascular plant richness between 1960 and 2020 using Random Forests. Training and predictions are obtained over 660,748 European vegetation plots retreived from the <a href='https://euroveg.org/eva-database/' target='_blank'>European Vegetation Archive</a> (<a href='https://doi.org/10.1111/avsc.12519' target='_blank'>Chytrý et al. 2020</a>) and <a href='https://euroveg.org/resurvey/' target='_blank'>ReSurveyEurope</a> (<a href='https://doi.org/10.1111/jvs.13235' target='_blank'>Knollová et al. 2024</a>).

Predictions of species richness from individual plots were aggregated onto a 10 km × 10 km grid. On the map, point size represents the number of plots within each grid cell. Areas with denser sampling in space and time are more likely to show more accurate trends.

This application uses original data and code deposited at:<br>
                 - <img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" width="15" style="vertical-align: middle; margin-right: 3px;"/> <a href="https://github.com/gmidolo/interpolated_S_change" target="_blank">github.com/gmidolo/interpolated_S_change</a><br>
                 - <img src="https://about.zenodo.org/static/img/icons/zenodo-icon-white.svg" width="15" style="vertical-align: middle; margin-right: 3px;"/> <a href="https://doi.org/10.5281/zenodo.15836616" target="_blank">10.5281/zenodo.15836616</a>

#### Authors:
**Gabriele Midolo** <a href="https://orcid.org/0000-0003-1316-2546" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Adam Thomas Clark <a href="https://orcid.org/0000-0002-8843-3278" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Milan Chytrý <a href="https://orcid.org/0000-0002-8122-3075" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Franz Essl <a href="https://orcid.org/0000-0001-8253-2112" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Stefan Dullinger <a href="https://orcid.org/0000-0003-3919-0887" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Ute Jandt <a href="https://orcid.org/0000-0002-3177-3669" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Helge Bruelheide <a href="https://orcid.org/0000-0003-3135-0356" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Olivier Argagnon <a href="https://orcid.org/0000-0003-2069-7231" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Idoia Biurrun <a href="https://orcid.org/0000-0002-1454-0433" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Alessandro Chiarucci <a href="https://orcid.org/0000-0003-1160-235X" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Renata Ćušterevska <a href="https://orcid.org/0000-0002-3849-6983" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Pieter De Frenne <a href="https://orcid.org/0000-0002-8613-0943" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Michele De Sanctis <a href="https://orcid.org/0000-0002-7280-6199" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Jürgen Dengler <a href="https://orcid.org/0000-0003-3221-660X" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Jan Divíšek <a href="https://orcid.org/0000-0002-5127-5130" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Tetiana Dziuba <a href="https://orcid.org/0000-0001-8621-0890" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Rasmus Ejrnæs <a href="https://orcid.org/0000-0003-2538-8606" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Emmanuel Garbolino <a href="https://orcid.org/0000-0002-4954-6069" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Estela Illa <a href="https://orcid.org/0000-0001-7136-6518" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Anke Jentsch <a href="https://orcid.org/0000-0002-2345-8300" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Borja Jiménez-Alfaro <a href="https://orcid.org/0000-0001-6601-9597" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Jonathan Lenoir <a href="https://orcid.org/0000-0003-0638-9582" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Jesper Erenskjold Moeslund <a href="https://orcid.org/0000-0001-8591-7149" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Francesca Napoleone <a href="https://orcid.org/0000-0002-3807-7180" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Remigiusz Pielech <a href="https://orcid.org/0000-0001-8879-3305" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Sabine B. Rumpf <a href="https://orcid.org/0000-0001-5909-9568" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Irati Sanz-Zubizarreta <a href="https://orcid.org/0009-0000-9816-2574" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Vasco Silva <a href="https://orcid.org/0000-0003-2729-1824" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Jens-Christian Svenning <a href="https://orcid.org/0000-0002-3415-0862" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Grzegorz Swacha <a href="https://orcid.org/0000-0002-6380-2954" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Martin Večeřa <a href="https://orcid.org/0000-0001-8507-791X" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Denys Vynokurov <a href="https://orcid.org/0000-0001-7003-6680" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>,
Petr Keil <a href="https://orcid.org/0000-0003-3017-1858" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15"/></a>
## License

**Data** are available under the terms of the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International license (CC BY-NC-ND 4.0) (<https://creativecommons.org/licenses/by-nc-nd/4.0/>).

**Code** are available under the terms of the GNU General Public License v3.0 (GPL-3.0) (<https://www.gnu.org/licenses/gpl-3.0.html>).

## Citation

*This repository is not linked to any publication yet.*