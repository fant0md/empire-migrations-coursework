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
         'lit_rate_total': 'Literacy rate',
         'urbanization': 'Urbanization',
         'pop_rate': 'Natural population growth rate',
         'industry_pc': 'Industrial output per capita (rub.)',
         'agriculture_pc': 'Agricultural output per capita (rub.)',
         'mig_from': 'Out-migration',
         'mig_of_pop_from': 'Out-migration (share of population)',
         'mig_to': 'In-migration',
         'mig_of_pop_to': 'In-migration (share of population)',
         'russian': 'Russian-speaking (% of population)',
         'ukrainian': 'Ukrainian-speaking (% of population)',
         'belorus': 'Belorussian-speaking (% of population)',
         'polish': 'Polish-speaking (% of population)',
         'jewish': 'Jewish-speaking (% of population)',
         'agriculture': 'Involvement in agriculture (share of population)',
         'manufacturing': 'Involvement in manufacturing (share of population)',
         'mig_total': 'Migration'
        }

def plot_variable(regions, var, title=False):
    regions['id'] = regions.index
    missing = regions.loc[regions[var].isna(),:].fillna('No Data')
    
    missing_fig = px.choropleth(
        missing,
        geojson=missing.geometry,
        locations=missing.id,
        color=var,
        hover_name = 'name',
        labels={
            var:var_map[var],
        },
        hover_data={
            'id':False,
        },
        color_discrete_map={'No Data':'lightgrey'},
    )
    
    fig = px.choropleth(
        regions,
        geojson=regions.geometry,
        locations=regions.id,
        color=var,
        hover_name='name',
        color_continuous_scale='greens',
        labels={
            var:var_map[var],
        },
        hover_data={
            'id': False,
        },
    )
    
    fig.update_geos(
        visible=False,
        projection = dict(type="conic equal area", parallels=[50,70]),
        lonaxis_range=[28, 180],
        lataxis_range=[44, 84],
        #showlakes=False,
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
    #fig.update_traces(hovertemplate=f'Price: {regions.var[]}')
    
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
    reg = reg.fillna('Target')
    df_reg = df_reg.loc[df_reg['name'] != reg_name, :]
    
    reg['id'] = reg.index
    self_fig = px.choropleth(
        reg,
        geojson=reg.geometry,
        locations=reg.id,
        color='mig_total',
        hover_name='name',
        color_discrete_map={'Target':'orange'},
        labels = {
            'mig_total':var_map['mig_total'],
        },
        hover_data={
            'id': False,
        },
    )
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
server = app.server
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
    app.server.run(debug=True)