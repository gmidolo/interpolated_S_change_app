################################################################################
# Author: Gabriele Midolo
# Email: midolo@fzp.czu.cz
# Last update: 30.07.2025
################################################################################

#### 1. Prepare data ####

# Load packages
suppressPackageStartupMessages({
  library(shiny)
  library(sf)
  library(dplyr)
  library(leaflet)
  library(viridis)
  library(tidyr)
  library(readr)
  library(ggplot2)
  library(scales)
  library(base64enc)
})


# Load data
dat <- read_rds('data.rds')


#### 2. Define UI ####

ui <- fluidPage(
  titlePanel(
    title = 'Geographic patterns of alpha diversity change in European plant communities', ## Added tab title, feel free to change the title to your liking
    tags$h3('Geographic patterns of alpha diversity change in European plant communities from 1960 to 2020',
            style = 'font-size: 24px; font-weight: bold; color: #333;')
  ),
  sidebarLayout(
    sidebarPanel(
      
      # General Description Section
      div(style = 'margin-bottom: 20px; font-size: 1.1em; line-height: 1.4;',
          p(HTML("We interpolated spatiotemporal changes in vascular plant species richness between 1960 and 2020 using Random Forests. Training and predictions are obtained over 660,748 European vegetation plots available on the <a href='https://euroveg.org/eva-database/' target='_blank'>European Vegetation Archive</a> (<a href='https://doi.org/10.1111/avsc.12519' target='_blank'>Chytrý et al. 2020</a>) and <a href='https://euroveg.org/resurvey/' target='_blank'>ReSurveyEurope</a> (<a href='https://doi.org/10.1111/jvs.13235' target='_blank'>Knollová et al. 2024</a>)")),
          p(HTML("Predictions of species richness estimates from individual plots were aggregated onto a 10 km &times; 10 km grid. On the map, point size represents the number of plots within each grid cell. Areas with denser sampling in space and time are more likely to show more accurate trends.")),
          p(HTML('This application uses data and code deposited at:<br>
                  - <img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" width="15" style="vertical-align: middle; margin-right: 3px;"/> <a href="https://github.com/gmidolo/interpolated_S_change" target="_blank">github.com/gmidolo/interpolated_S_change</a><br>
                  - <img src="https://about.zenodo.org/static/img/icons/zenodo-icon-blue.svg" width="15" style="vertical-align: middle; margin-right: 3px;"/> <a href="https://doi.org/10.5281/zenodo.15836616" target="_blank">10.5281/zenodo.15836616</a>'))
      ),
      
      selectInput('mode', 'Mapping mode:',
                  choices = c('Species richness change', 'Species richness per year')),
      selectInput('habitat', 'Habitat:',
                  choices = c('Forest', 'Grassland', 'Scrub', 'Wetland')),
      
      div(style = 'font-size: 1.0em; font-style: italic; margin-top: 2px; margin-bottom: 15px;',
          textOutput('plot_size_note')), # dynamic note below habitat selector
      
      conditionalPanel(
        condition = "input.mode == 'Species richness change'",
        sliderInput('years', 'Time period:',
                    min = 1960, max = 2020, value = c(1960, 2020), sep = ''),
        radioButtons('metric', 'Metric of change:',
                     choices = c('Percentage (%)' = 'perc',
                                 'Log Response Ratio' = 'lnrr',
                                 'No. Species' = 'diff'))
      ),
      conditionalPanel(
        condition = "input.mode == 'Species richness per year'",
        sliderInput('single_year', 'Select Year:',
                    min = 1960, max = 2020, value = 1960, sep = '')
      ),
      # Author information with ORCID and affiliation
      div(style = 'margin-top: 40px; text-align: left; font-size: 0.9em; color: #555;',
          p(HTML('Author: <strong>Gabriele Midolo</strong><a href="https://orcid.org/0000-0003-1316-2546" target="_blank" style="margin-left: 5px;"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" width="15" style="vertical-align: middle;"/></a> (<a href="mailto:midolo@fzp.czu.cz">midolo@fzp.czu.cz</a>) <br> Department of Spatial Sciences, Faculty of Environmental Sciences, Czech University of Life Sciences Prague, Kamýcká 129, 165 00, Praha - Suchdol, Czech Republic')),
          p("Date: 21.07.2025"),
          p(HTML('Project contributors:
                  Petr Keil <a href="https://orcid.org/0000-0003-3017-1858" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Adam Thomas Clark <a href="https://orcid.org/0000-0002-8843-3278" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Milan Chytrý <a href="https://orcid.org/0000-0002-8122-3075" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Franz Essl <a href="https://orcid.org/0000-0001-8253-2112" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Stefan Dullinger <a href="https://orcid.org/0000-0003-3919-0887" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Ute Jandt <a href="https://orcid.org/0000-0002-3177-3669" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Helge Bruelheide <a href="https://orcid.org/0000-0003-3135-0356" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Olivier Argagnon <a href="https://orcid.org/0000-0003-2069-7231" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Idoia Biurrun <a href="https://orcid.org/0000-0002-1454-0433" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Alessandro Chiarucci <a href="https://orcid.org/0000-0003-1160-235X" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Renata Ćušterevska <a href="https://orcid.org/0000-0002-3849-6983" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Pieter De Frenne <a href="https://orcid.org/0000-0002-8613-0943" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Michele De Sanctis <a href="https://orcid.org/0000-0002-7280-6199" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Jürgen Dengler <a href="https://orcid.org/0000-0003-3221-660X" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Jan Divíšek <a href="https://orcid.org/0000-0002-5127-5130" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Tetiana Dziuba <a href="https://orcid.org/0000-0001-8621-0890" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Rasmus Ejrnæs <a href="https://orcid.org/0000-0003-2538-8606" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Emmanuel Garbolino <a href="https://orcid.org/0000-0002-4954-6069" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Estela Illa <a href="https://orcid.org/0000-0001-7136-6518" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Anke Jentsch <a href="https://orcid.org/0000-0002-2345-8300" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Borja Jiménez-Alfaro <a href="https://orcid.org/0000-0001-6601-9597" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Jonathan Lenoir <a href="https://orcid.org/0000-0003-0638-9582" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Jesper Erenskjold Moeslund <a href="https://orcid.org/0000-0001-8591-7149" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Francesca Napoleone <a href="https://orcid.org/0000-0002-3807-7180" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Remigiusz Pielech <a href="https://orcid.org/0000-0001-8879-3305" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Sabine B. Rumpf <a href="https://orcid.org/0000-0001-5909-9568" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Irati Sanz-Zubizarreta <a href="https://orcid.org/0009-0000-9816-2574" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Vasco Silva <a href="https://orcid.org/0000-0003-2729-1824" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Jens-Christian Svenning <a href="https://orcid.org/0000-0002-3415-0862" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Grzegorz Swacha <a href="https://orcid.org/0000-0002-6380-2954" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Martin Večeřa <a href="https://orcid.org/0000-0001-8507-791X" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>,
                  Denys Vynokurov <a href="https://orcid.org/0000-0001-7003-6680" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/0/06/ORCID_iD.svg" class="is-rounded" width="15" style="vertical-align: middle;"/></a>
          '))
      )
    ), # End of sidebarPanel
    mainPanel(
      leafletOutput('map', height = '800px')
    )
  )
)



#### 3. Define server ####

server <- function(input, output, session) {
  output$plot_size_note <- renderText({
    req(input$habitat)
    
    sizes <- c(
      'Forest' = '300 m²',
      'Grassland' = '20 m²',
      'Scrub' = '64 m²',
      'Wetland' = '50 m²'
    )
    
    habitat_name <- c(
      'Forest' = 'forests',
      'Grassland' = 'grasslands',
      'Scrub' = 'scrub',
      'Wetland' = 'wetlands'
    )
    
    paste0('Predictions at ', sizes[input$habitat], ' for ', habitat_name[input$habitat], '.')
    
  })
  
  # reactive to add geometry_id for map markers
  dat_with_id <- reactive({
    req(dat) # ensure data are available
    dat %>%
      mutate(geometry_id = paste0(x, '_', y, '_', habitat))
  })
  
  dat_sf <- reactive({
    dat_with_id() %>% # use the reactive with geometry_id
      st_as_sf(coords = c('x', 'y'), crs = 25832) %>%
      filter(habitat == input$habitat) %>%
      st_transform(4326)
  })
  
  change_data <- reactive({
    req(input$years[1] < input$years[2])
    dat_hab <- dat_sf()
    y1 <- paste0('S_pred_', input$years[1])
    y2 <- paste0('S_pred_', input$years[2])
    
    dat_hab <- dat_hab %>%
      mutate(
        change_value = case_when(
          input$metric == 'perc'  ~ 100 * ((.data[[y2]] - .data[[y1]]) / .data[[y1]]),
          input$metric == 'lnrr'  ~ log(.data[[y2]] / .data[[y1]]),
          input$metric == 'diff'  ~ .data[[y2]] - .data[[y1]]
        )
      )
    
    dat_hab <- dat_hab %>%
      mutate(
        change_cat = case_when(
          input$metric == 'perc' ~ cut(
            change_value,
            breaks = c(-Inf, -50, -25, -10, -5, 5, 10, 25, 50, Inf),
            labels = c(
              '< -50%',
              '-50% – -25%',
              '-25% – -10%',
              '-10% – -5%',
              '-5% – 5%',
              '5% – 10%',
              '10% – 25%',
              '25% – 50%',
              '> 50%'
            ),
            include.lowest = TRUE
          ),
          input$metric == 'lnrr' ~ cut(
            change_value,
            breaks = c(-10, -0.5, -0.1, -0.05, 0.05, 0.1, 0.5, 10),
            labels = c(
              '< -0.5',
              '-0.5 – -0.1',
              '-0.1 – -0.05',
              '-0.05 – 0.05',
              '0.05 – 0.1',
              '0.1 – 0.5',
              '> 0.5'
            ),
            include.lowest = TRUE
          ),
          input$metric == 'diff' ~ cut(
            change_value,
            breaks = c(-Inf, -10, -5, -1, 1, 5, 10, Inf),
            labels = c('< -10', '-10 – -5', '-5 – -1', '-1 – 1', '1 – 5', '5 – 10', '> 10'),
            include.lowest = TRUE
          )
        )
      )
    
    dat_hab
  })
  
  snapshot_data <- reactive({
    dat_hab <- dat_sf()
    yr <- paste0('S_pred_', input$single_year)
    dat_hab %>%
      mutate(S_value = log10(.data[[yr]])) # keep log10 richness for coloring
  })
  
  # initialize the map once
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles('Esri.WorldGrayCanvas') %>%
      setView(lng = 15,
              lat = 57,
              zoom = 4)
  })
  
  # get rective value
  prev_mode <- reactiveVal(NULL)
  
  # observe changes in mode to clear markers + popups
  observeEvent(input$mode, {
    if (!is.null(prev_mode()) && prev_mode() != input$mode) {
      leafletProxy('map') %>% clearMarkers()
    }
    prev_mode(input$mode)
    leafletProxy('map') %>% clearPopups() # clear popups if mode changes
  }, ignoreNULL = FALSE, ignoreInit = TRUE)
  
  # clear popups if other relevant inputs change
  observeEvent(input$habitat,
               {
                 leafletProxy('map') %>% clearPopups()
               },
               ignoreNULL = FALSE,
               ignoreInit = TRUE)
  
  observeEvent(input$years,
               {
                 if (input$mode == 'Species richness change') {
                   leafletProxy('map') %>% clearPopups()
                 }
               },
               ignoreNULL = FALSE,
               ignoreInit = TRUE)
  
  observeEvent(input$metric,
               {
                 if (input$mode == 'Species richness change') {
                   leafletProxy('map') %>% clearPopups()
                 }
               },
               ignoreNULL = FALSE,
               ignoreInit = TRUE)
  
  observeEvent(input$single_year,
               {
                 if (input$mode == 'Species richness per year') {
                   leafletProxy('map') %>% clearPopups()
                 }
               },
               ignoreNULL = FALSE,
               ignoreInit = TRUE)
  
  
  # observe inputs for main map updates
  observe({
    # add input$habitat as a direct dependency here
    input$habitat # this line makes the observe block reactive to habitat changes
    
    leafletProxy('map') %>% clearControls() #clear controls to redraw legend
    leafletProxy('map') %>% clearMarkers() # clear markers when inputs change
    
    current_zoom <- input$map_zoom
    if (is.null(current_zoom))
      current_zoom <- 4 # default zoom
    
    # Adjust point size by zooming level
    fac = 0.2
    zoomy = input$map_zoom
    scale_factor = zoomy * fac # set current scaling factor
    
    if (input$mode == 'Species richness change') {
      dat_plot <- change_data()
      
      if (input$metric == 'perc') {
        levels_lab <- c(
          '< -50%',
          '-50% – -25%',
          '-25% – -10%',
          '-10% – -5%',
          '-5% – 5%',
          '5% – 10%',
          '10% – 25%',
          '25% – 50%',
          '> 50%'
        )
      } else if (input$metric == 'lnrr') {
        levels_lab <- c(
          '< -0.5',
          '-0.5 – -0.1',
          '-0.1 – -0.05',
          '-0.05 – 0.05',
          '0.05 – 0.1',
          '0.1 – 0.5',
          '> 0.5'
        )
      } else {
        levels_lab <- c('< -10', '-10 – -5', '-5 – -1', '-1 – 1', '1 – 5', '5 – 10', '> 10')
      }
      
      cols <- hcl.colors(length(levels_lab), 'Spectral')
      pal <- colorFactor(palette = cols, levels = levels_lab)
      
      leafletProxy('map') %>%
        addCircleMarkers(
          data = dat_plot,
          layerId = ~ paste0('point_', geometry_id),
          # Unique ID for each point
          radius = ~ (log(n) + 2) * scale_factor,
          color = ~ pal(change_cat),
          stroke = FALSE,
          fillOpacity = 0.7#,
          # popup = ~ paste0(
          #   'Mean species richness change: ',
          #   round(change_value, 2),
          #   '<br>No. plots: ',
          #   n
          # )
        ) %>%
        addLegend(
          'topright',
          pal = pal,
          values = dat_plot$change_cat,
          title = 'Species richness change',
          opacity = 0.9
        )
      
    } else {
      # input$mode == 'Species richness per year'
      dat_plot <- snapshot_data()
      
      dat_plot <- dat_plot %>%
        mutate(original_S_value = 10^S_value) # back-transform species richness
      
      breaks_s_value <- c(1, 5, 10, 15, 20, 25, 30, 40, Inf)
      levels_lab_snapshot <- c('1-5',
                               '6-10',
                               '11-15',
                               '16-20',
                               '21-25',
                               '26-30',
                               '31-40',
                               '>40')
      
      dat_plot <- dat_plot %>%
        mutate(
          S_value_cat = cut(
            original_S_value,
            breaks = breaks_s_value,
            labels = levels_lab_snapshot,
            include.lowest = TRUE,
            right = TRUE
          )
        )
      
      cols_snapshot <- viridis(length(levels_lab_snapshot), option = 'plasma')
      pal_snapshot <- colorFactor(palette = cols_snapshot, levels = levels_lab_snapshot)
      
      leafletProxy('map') %>%
        addCircleMarkers(
          data = dat_plot,
          layerId = ~ paste0('point_', geometry_id),
          radius = ~ (log(n) + 2) * scale_factor,
          color = ~ pal_snapshot(S_value_cat),
          stroke = FALSE,
          fillOpacity = 0.7#,
          # popup = ~ paste0(
          #   'Mean species richness: ',
          #   round(original_S_value, 2),
          #   '<br>No. plots: ',
          #   n
          # )
        ) %>%
        addLegend(
          'topright',
          pal = pal_snapshot,
          values = dat_plot$S_value_cat,
          title = 'Species richness',
          opacity = 0.9
        )
    }
  })
  
  
  # Observer for map marker clicks to show time series plot in popup
  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click
    req(click$id) # Ensure a marker was clicked and it has an ID
    
    # extract geometry_id from the clicked marker's layerId
    clicked_id_raw <- sub('point_', '', click$id)
    id_parts <- strsplit(clicked_id_raw, '_')[[1]]
    
    # ensure id_parts has at least 3 elements (x, y, habitat)
    req(length(id_parts) >= 3)
    
    clicked_x <- as.numeric(id_parts[1])
    clicked_y <- as.numeric(id_parts[2])
    clicked_habitat <- id_parts[3]
    
    # get data to plot
    point_data_for_plot <- dat %>%
      filter(x == clicked_x, y == clicked_y, habitat == clicked_habitat)
    
    # make sure we found the data for this point
    req(nrow(point_data_for_plot) == 1)
    
    # get the number of plots (n) for this specific aggregated point
    n_plots_at_point <- point_data_for_plot$n
    
    # initialize popup content string
    richness_display_text <- ''
    graph_html <- ''
    
    # Display richness text
    if (input$mode == 'Species richness change') {
      # gey the change value for display in popup
      y1_col <- paste0('S_pred_', input$years[1])
      y2_col <- paste0('S_pred_', input$years[2])
      
      # ensure columns exist before trying to access them
      if (y1_col %in% names(point_data_for_plot) &&
          y2_col %in% names(point_data_for_plot)) {
        s_pred_y1 <- point_data_for_plot[[y1_col]]
        s_pred_y2 <- point_data_for_plot[[y2_col]]
        
        # get change_value based on selected metric for consistent display
        change_value <- case_when(
          input$metric == 'perc' ~ 100 * ((s_pred_y2 - s_pred_y1) / s_pred_y1),
          input$metric == 'lnrr' ~ log(s_pred_y2 / s_pred_y1),
          input$metric == 'diff' ~ s_pred_y2 - s_pred_y1
        )
        lab_change <- ''
        if (input$metric == 'perc') {
          lab_change <- ' (%)'
        }
        if (input$metric == 'lnrr') {
          lab_change <- ' (lnRR)'
        }
        if (input$metric == 'diff') {
          lab_change <- ' (no. species)'
        }
        val_display <- ifelse(change_value > 0,
                              paste0('+', round(change_value, 2)),
                              round(change_value, 2))
        richness_display_text <- paste0(
          '<strong>Mean change </strong> ',
          '(from ',
          input$years[1],
          ' to ',
          input$years[2],
          ') = ',
          val_display,
          lab_change
        )
      }
      
      # Plot graph only for 'Species richness change' mode
      # prepare data for plotting
      plot_data_long <- point_data_for_plot %>%
        dplyr::select(starts_with('S_pred_')) %>%
        pivot_longer(
          cols = starts_with('S_pred_'),
          names_to = 'prediction_year_str',
          values_to = 'S_prediction',
          names_prefix = 'S_pred_'
        ) %>%
        mutate(prediction_year = as.numeric(prediction_year_str)) %>%
        filter(prediction_year >= input$years[1] &
                 prediction_year <= input$years[2]) %>%
        arrange(prediction_year)
      
      if (nrow(plot_data_long) > 0) {
        span_yrs <- input$years[2] - input$years[1]
        p <- ggplot(plot_data_long,
                    aes(x = prediction_year, y = S_prediction)) +
          geom_line(color = 'midnightblue') +
          geom_point(
            data = plot_data_long %>%
              filter(
                prediction_year == max(prediction_year) |
                  prediction_year == min(prediction_year)
              ),
            size = 3,
            color = 'midnightblue'
          ) +
          scale_x_continuous(breaks = pretty_breaks(n = ifelse(span_yrs >= 5, 5, span_yrs))) +
          labs(
            title = paste0('Local trend (', clicked_habitat, ')'),
            x = 'Year',
            y = 'Species richness'
          ) +
          theme_minimal() +
          theme(
            plot.title = element_text(size = 12, face = 'bold'),
            axis.title = element_text(size = 12),
            axis.text = element_text(size = 12),
            plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), 'cm'),
            axis.text.x = element_text(
              angle = 45,
              vjust = 1,
              hjust = 1
            )
          )
        
        temp_file <- tempfile(fileext = '.png')
        ggsave(
          temp_file,
          plot = p,
          width = 4,
          height = 3,
          units = 'in',
          dpi = 150
        )
        img_b64 <- base64encode(temp_file)
        unlink(temp_file)
        graph_html <- paste0("<img src='data:image/png;base64,",
                             img_b64,
                             "' width='250px'><br>")
      } else {
        graph_html <- '<strong>No trend data for the selected period to plot.</strong><br>'
      }
      
    } else if (input$mode == 'Species richness per year') {
      single_year_col <- paste0('S_pred_', input$single_year)
      if (single_year_col %in% names(point_data_for_plot)) {
        current_s_value <- point_data_for_plot[[single_year_col]]
        richness_display_text <- paste0(
          '<strong>Mean richness (',
          input$single_year,
          '):</strong> ',
          round(current_s_value, 2)
        )
      } else {
        richness_display_text <- paste0('<strong>Richness data not available for ',
                                        input$single_year,
                                        '.</strong>')
      }
    }
    
    # get the popup content
    popup_content <- paste0(
      richness_display_text,
      '<br>Number of plots: ',
      n_plots_at_point,
      '<br>',
      graph_html # empty if not in 'Species richness change' mode
    )
    
    # show the popup
    leafletProxy('map') %>%
      clearPopups() %>%
      addPopups(
        lat = click$lat,
        lng = click$lng,
        popup = popup_content,
        layerId = click$id
      )
  })
  
}


#### 4. Run the app ####

shinyApp(ui, server)
