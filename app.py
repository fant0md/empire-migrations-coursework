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

var_map = {
    'pop_total': 'Население',
    'lit_rate_total': 'Грамотность',
    'urbanization': 'Уровень урбанизации',
    'pop_rate': 'Естественный прирост населения',
    'density_total': 'Плотность населения',
    'industry_pc': 'Промышленный выпуск на душу, руб.',
    'agriculture_pc': 'Сельскохозяйственный выпуск на душу, руб.',
    'mig_from': 'Родившихся в регионе, но проживающих в других регионах',
    'mig_of_pop_from': 'Родившихся в регионе, но проживающих в других регионах, доля населения',
    'mig_to': 'Родившихся в других регионах, но проживающих в этом',
    'mig_of_pop_to': 'Родившихся в других регионах, но проживающих в этом, доля населения',
    'mig_net_rate': 'Коэффициент миграционного прироста',
    'russian': 'Говорящих на русском, % населения',
    'ukrainian': 'Говорящих на украинсокм, % населения',
    'belorus': 'Говорящих на белорусском, % населения',
    'polish': 'Говорящих на польском, % населения',
    'jewish': 'Говорящих на еврейских языках, % населения',
    'german': 'Говорящих на немецком, % населения',
    'agriculture': 'Занятость в сельском хозяйстве, доля населения',
    'industry': 'Занятость в промышленность, доля населения',
    'sh_serfs1858': 'Доля крепостных в 1858',
    'tmp': 'Среднегодовая температура в 1901-1910, градусы Цельсия',
    'wet': 'Среднее число дождливых дней в месяц в 1901-1910',
    'pre': 'Среднее количество осадков в 1901-1910, кг на кв.м',
    'frs': 'Среднее число морозных дней в 1901-1910',
    'vap': 'Среднее давление насыщенного пара в 1901-1910, мм рт.ст.',
    'mig_total': 'Миграция',
    'rural_m': 'Сельская мужская миграция', 
    'rural_f': 'Сельская женская миграция', 
    'urban_m': 'Городская мужская миграция', 
    'urban_f': 'Городская женская миграция', 
    'distance_capitals': 'Расстояние между административными центрами', 
    'distance_centroids': 'Расстояние между центроидами',
}

def plot_variable(regions, var, title=False):
    regions['id'] = regions.index
    missing = regions.loc[regions[var].isna(),:].fillna('Нет данных')
    
    missing_fig = px.choropleth(
        missing,
        geojson=missing.geometry,
        locations=missing.id,
        color=var,
        hover_name='name',
        labels={
            var:var_map[var],
        },
        hover_data={
            'id':False,
        },
        color_discrete_map={'Нет данных':'lightgrey'},
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
        projection=dict(type="conic equal area", parallels=[50,70]),
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
        labels={
            'mig_total':var_map['mig_total'],
        },
        hover_data={
            'id':False,
        },
    )
    fig = plot_variable(df_reg, 'mig_total')
    fig.add_trace(self_fig.data[0])
    fig.update_traces(showlegend=False)
    return fig

how_dropdown = dcc.Dropdown(
    id='how-dropdown', 
    clearable=False,
    value='to', 
    options=[{'label': l, 'value': v} for l, v in zip(['в', 'из'], ['to', 'from'])]
)
region_dropdown = dcc.Dropdown(
    id='region-dropdown',
    clearable=False,
    value='Томская губерния',
    options=[{'label': c, 'value': c} for c in sorted(regions.name.unique())]
)

tab1_children = dcc.Tab(
    label='Миграции',
    children=[
        html.Div(
            children=[
                html.Div(
                    children=[
                        html.Div(
                            children=[
                                html.Label("Направление"),
                                how_dropdown,
                            ],
                            style=dict(width='50%')
                        ),
                        html.Div(
                            children=[
                                html.Label("Регион"),
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
    options=[{'label': v, 'value': k} for k, v in var_map.items() if k in regions.columns]
)

tab2_children = dcc.Tab(
    label='Региональные переменные', 
    children=[
        html.Div(
            children=[
                html.Label("Переменная"),
                color_dropdown,
            ],
        ),
        dcc.Graph(id='graph2', config=dict(displayModeBar=False)),
    ]
)

tab3_children = dcc.Tab(
    label='Источники', 
    children=[
        html.Div(
            children=[
                dcc.Markdown('''
                * GitHub: https://github.com/fant0md/empire-migrations-coursework
                * Источники данных: 
                    * Миграции:
                    
                    Эта работа,
                    
                    Первая всеобщая перепись населения Российской империи 1897 года  / Изд. Центр. Стат. комитетом М-ва вн. дел ; Под ред. Н. А. Тройницкого. - СПб., 1897 - 1905.
                    
                    * Границы на карте, языки: 
                    
                    Sablin, Ivan; Kuchinskiy, Aleksandr; Korobeinikov, Aleksandr; Mikhaylov, Sergey; Kudinov, Oleg; Kitaeva, Yana; Aleksandrov, Pavel; Zimina, Maria; Zhidkov, Gleb, 2015, "Transcultural Empire: Geographic Information System of the 1897 and 1926 General Censuses in the Russian Empire and Soviet Union", https://doi.org/10.11588/data/10064, heiDATA, V3
                    
                    * Занятость по отраслям:
                    
                    http://gpih.ucdavis.edu/
                    
                    * Климатические факторы:
                    
                    Harris, I., Osborn, T.J., Jones, P. et al. Version 4 of the CRU TS monthly high-resolution gridded multivariate climate dataset. Sci Data 7, 109 (2020). https://doi.org/10.1038/s41597-020-0453-3
                    
                    * Доля крепостных:
                    
                    Markevich, A., & Zhuravskaya, E. (2018). The Economic Effects of the Abolition of Serfdom: Evidence from the Russian Empire. American Economic Review, 108(4–5), 1074–1117. 
                    
                    Тройницкий, А. Г. (1861). Крепостное население в России по 10-й народной переписи. Центральный статистический комитет. Статистический отдел.
                    
                    * Все остальнве переменные:
                    
                    Кесслер Хайс и Маркевич Андрей, Электронный архив Российской исторической статистики, XVIII – XXI вв., Режим доступа: https://ristat.org/, Версия I (2020).
            
                * Сделано в Dash, размещено на Heroku
                '''),
            ],
        ),
    ]
)

app = dash.Dash(__name__)
server = app.server
app.layout = html.Div(
    children=[
        html.H1("Миграции в Российской империи, 1897"),
        dcc.Tabs([tab1_children, tab2_children, tab3_children])
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