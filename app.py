import os
import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import plotly.express as px
import pandas as pd
import geopandas as gpd

regions = gpd.read_file('data/regions.geojson')
data = pd.read_csv('data/interactions.csv')

var_map={'area':'Total area (sq.m.)',
         'pop_total': 'Population',
         'pop_urban': 'Population, urban',
         'pop_rural': 'Population, rural',
         'pop_f': 'Population, female',
         'pop_m': 'Population, male',
         'lit_rate_rural': 'Literacy rate, rural',
         'lit_rate_urban': 'Literacy rate, urban',
         'lit_rate_m': 'Literacy rate, male',
         'lit_rate_f': 'Literacy rate, female',
         'lit_rate_total': 'Literacy rate',
         'pop_rate': 'Natural population increase rate',
         'industry_pc': 'Industrial output p.c. (rub.)',
         'mig_from': 'Out-migration',
         'mig_of_pop_from': 'Out-migration (%)',
         'mig_to': 'In-migration',
         'mig_of_pop_to': 'In-migration (%)',
         'mig_total': 'Migration'
        }

def plot_variable(regions, var, title=False):
    #regions.index = regions.name
    missing = regions.loc[regions[var].isna(),:].fillna('No Data')
    
    missing_fig = px.choropleth(
        missing,
        geojson=missing.geometry,
        locations=missing.index,
        color=var,
        #hover_name = 'name',
        color_discrete_map={'No Data':'lightgrey'},
        labels = {var:var_map[var], 
                  'index':'Region'}
    )
    
    fig = px.choropleth(
        regions,
        geojson=regions.geometry,
        locations=regions.index,
        color=var,
        #hover_name = 'name',
        color_continuous_scale='greens',
        labels = {var:var_map[var],
                  'index':'Region'},
        #template='plotly_dark'
    )
    
    fig.update_geos(
        visible=False,
        projection = dict(type = "conic equal area", parallels=[50,70]),
        lonaxis_range=[28, 180],
        lataxis_range=[44, 84],
        showlakes=False,
    )
    
    fig.update_layout(
        margin={"r":10,"t":10,"l":10,"b":10},
        dragmode=False,
        coloraxis=dict(
            colorbar=dict(outlinecolor="Black", outlinewidth=1, x=0.875, title=None)
        ),
    )
    
    
    fig.add_trace(missing_fig.data[0])
    fig.update_traces(showlegend=False)
    
    if title:
        fig.update_layout(margin={"r":10,"t":60,"l":10,"b":10}, title=var_map[var])
    return fig

def plot_region(data, regions, reg_name, how):
    if how=='to':
        t='j'
        r='i'
    elif how=='from':
        t='i'
        r='j'
    else:
        raise ValueError
    
    df_reg = data.loc[data[f'name_{t}'] == reg_name]
    df_reg = regions[['geometry', 'name']].merge(df_reg, how='left', left_on=['name'], right_on=[f'name_{r}'])
    reg = df_reg[df_reg['name'] == reg_name]
    df_reg = df_reg.loc[df_reg['name'] != reg_name, :]
    
    self_fig = px.choropleth(
        reg,
        geojson=reg.geometry,
        locations=reg.index,
        color='name',
        #hover_name='name',
        color_discrete_map={reg_name:'grey'},
        #labels = {'index':'Region'}
    )
    
    #df_reg.index = df_reg.name
    
    fig = plot_variable(df_reg, 'mig_total')
    fig.add_trace(self_fig.data[0])
    fig.update_traces(showlegend=False)
    return fig

how_dropdown = dcc.Dropdown(id='how-dropdown', 
                              clearable=False,
                              value='to', 
                              options=[{'label': c, 'value': c} for c in ['to', 'from']]
                             )
region_dropdown = dcc.Dropdown(id='region-dropdown',
                              clearable=False,
                              value='Томская губерния',
                              options=[{'label': c, 'value': c} for c in sorted(regions.name.unique())]
                             )

tab1_children = dcc.Tab(
    label='Migrations',
    children=[
        html.Div(
            children=[
                html.Div(
                    children=[
                        html.Div(
                            children=[
                                html.Label("Direction"),
                                how_dropdown,
                            ],
                            style=dict(width='50%')
                        ),
                        html.Div(
                            children=[
                                html.Label("Region"),
                                region_dropdown
                            ],
                            style=dict(width='50%')
                        )
                    ],
                    #style={'display': 'inline-block', 'vertical-align': 'top'},
                    style=dict(display='flex')
                ),
                html.Div(
                    children=[
                        dcc.Graph(id='graph1', config=dict(displayModeBar=False)),
                    ],
                    #style={'display': 'inline-block', 'vertical-align': 'top'},
                ),
            ],
            #style=dict()
        )
    ]
)

color_dropdown = dcc.Dropdown(
    id='color-dropdown',
    clearable=False,
    value='pop_total',
    options=[{'label': v, 'value': k} for k, v in var_map.items() if k != 'mig_total']
)

tab2_children = dcc.Tab(
    label='Other variables', 
    children=[
        html.Div(
            children=[
                html.Label("Variable"),
                color_dropdown,
            ],
        ),
        dcc.Graph(id='graph2', config=dict(displayModeBar=False)),
    ]
)

app = dash.Dash(__name__)
app.layout = html.Div(
    children=[
        html.H1("Migrations in Russian Empire 1897"),
        dcc.Tabs([tab1_children, tab2_children])
    ]
)

@app.callback(
    Output('graph1', 'figure'),
    [Input("region-dropdown", "value"),
     Input("how-dropdown", "value")]
)
def update_figure1(region, how):
    return plot_region(data, regions, region, how)


@app.callback(
    Output('graph2', 'figure'),
    Input("color-dropdown", "value")
)
def update_figure2(color):
    return plot_variable(regions, color)

if __name__ == '__main__':
    app.run_server(debug=True)