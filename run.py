
# coding: utf-8

# In[1]:

import json
import pandas as pd
import numpy as np
from datetime import datetime, date, time, timedelta
from geojson import Feature, Point, LineString, FeatureCollection
import googlemaps
import os

# In[2]:

gmaps = googlemaps.Client(key='AIzaSyC2dX9jXmdYtYYdNOxu6CLoKYUIXb2IN2Y')


# In[3]:

# This function decodes google maps polyline to lon/lat pairs.
# https://github.com/mgd722/decode-google-maps-polyline/blob/master/polyline_decoder.py
def decode_polyline_reverse_coords(polyline_str):
    '''Pass a Google Maps encoded polyline string; returns list of lat/lon pairs'''
    index, lat, lng = 0, 0, 0
    coordinates = []
    changes = {'latitude': 0, 'longitude': 0}

    # Coordinates have variable length when encoded, so just keep
    # track of whether we've hit the end of the string. In each
    # while loop iteration, a single coordinate is decoded.
    while index < len(polyline_str):
        # Gather lat/lon changes, store them in a dictionary to apply them later
        for unit in ['latitude', 'longitude']: 
            shift, result = 0, 0

            while True:
                byte = ord(polyline_str[index]) - 63
                index+=1
                result |= (byte & 0x1f) << shift
                shift += 5
                if not byte >= 0x20:
                    break

            if (result & 1):
                changes[unit] = ~(result >> 1)
            else:
                changes[unit] = (result >> 1)

        lat += changes['latitude']
        lng += changes['longitude']

        coordinates.append([lng / 100000.0, lat / 100000.0]) # I REVERSED THE ORDER HERE

    return coordinates


# # Trip 1: Times Square to Newark Airport at 6pm on a Friday by Car

# In[4]:

departure_time = datetime(2017, 5, 21, 18, 0, 0)
departure_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]


# In[5]:

# Request directions
mode = 'driving'
directions_result = gmaps.directions("Times Square, New York City",
                                     "Newark Airport",
                                     mode=mode,
                                     departure_time=departure_time)

arrival_time = departure_time + timedelta(0,directions_result[0]['legs'][0]['duration']['value'])


# In[6]:

print "Start Time:", departure_time
print "End Time:", arrival_time
print "Start Address:", directions_result[0]['legs'][0]['start_address']
print "End Address:", directions_result[0]['legs'][0]['end_address']
print "Distance:", directions_result[0]['legs'][0]['distance']['text']
print "Duration:", directions_result[0]['legs'][0]['duration']['text']


# In[7]:

polyline = directions_result[0]['overview_polyline']['points']


# In[8]:

feature1 = Feature(geometry=LineString(decode_polyline_reverse_coords(polyline)), properties={'mode': mode, 'start': departure_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], 'end': arrival_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]})


# # Trip 2: Times Square to JFK at 6pm on a Friday by Car

# In[9]:

# Request directions
mode = 'driving'
directions_result = gmaps.directions("Times Square, New York City",
                                     "JFK Airport",
                                     mode=mode,
                                     departure_time=departure_time)

arrival_time = departure_time + timedelta(0,directions_result[0]['legs'][0]['duration']['value'])


# In[10]:

print "Start Time:", departure_time
print "End Time:", arrival_time
print "Start Address:", directions_result[0]['legs'][0]['start_address']
print "End Address:", directions_result[0]['legs'][0]['end_address']
print "Distance:", directions_result[0]['legs'][0]['distance']['text']
print "Duration:", directions_result[0]['legs'][0]['duration']['text']


# In[11]:

polyline = directions_result[0]['overview_polyline']['points']


# In[12]:

feature2 = Feature(geometry=LineString(decode_polyline_reverse_coords(polyline)), properties={'mode': mode, 'start': departure_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], 'end': arrival_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]})


# # Trip 3: Times Square to LGA at 6pm on a Friday by Car

# In[13]:

# Request directions
mode = 'driving'
directions_result = gmaps.directions("Times Square, New York City",
                                     "LGA Airport",
                                     mode=mode,
                                     departure_time=departure_time)

arrival_time = departure_time + timedelta(0,directions_result[0]['legs'][0]['duration']['value'])


# In[14]:

print "Start Time:", departure_time
print "End Time:", arrival_time
print "Start Address:", directions_result[0]['legs'][0]['start_address']
print "End Address:", directions_result[0]['legs'][0]['end_address']
print "Distance:", directions_result[0]['legs'][0]['distance']['text']
print "Duration:", directions_result[0]['legs'][0]['duration']['text']


# In[15]:

polyline = directions_result[0]['overview_polyline']['points']


# In[16]:

feature3 = Feature(geometry=LineString(decode_polyline_reverse_coords(polyline)), properties={'mode': mode, 'start': departure_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], 'end': arrival_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]})


# # Trip 4: Times Square to Newark Airport at 6pm on a Friday by Transit

# In[17]:

# Request directions
mode = 'transit'
directions_result = gmaps.directions("Times Square, New York City",
                                     "Newark Airport",
                                     mode=mode,
                                     departure_time=departure_time)

arrival_time = departure_time + timedelta(0,directions_result[0]['legs'][0]['duration']['value'])

print "Start Time:", departure_time
print "End Time:", arrival_time
print "Start Address:", directions_result[0]['legs'][0]['start_address']
print "End Address:", directions_result[0]['legs'][0]['end_address']
print "Distance:", directions_result[0]['legs'][0]['distance']['text']
print "Duration:", directions_result[0]['legs'][0]['duration']['text']
polyline = directions_result[0]['overview_polyline']['points']


# In[18]:

feature4 = Feature(geometry=LineString(decode_polyline_reverse_coords(polyline)), properties={'mode': mode, 'start': departure_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], 'end': arrival_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]})


# # Trip 5: Times Square to JFK Airport at 6pm on a Friday by Transit

# In[19]:

# Request directions
mode = 'transit'
directions_result = gmaps.directions("Times Square, New York City",
                                     "JFK Airport",
                                     mode=mode,
                                     departure_time=departure_time)

arrival_time = departure_time + timedelta(0,directions_result[0]['legs'][0]['duration']['value'])

print "Start Time:", departure_time
print "End Time:", arrival_time
print "Start Address:", directions_result[0]['legs'][0]['start_address']
print "End Address:", directions_result[0]['legs'][0]['end_address']
print "Distance:", directions_result[0]['legs'][0]['distance']['text']
print "Duration:", directions_result[0]['legs'][0]['duration']['text']
polyline = directions_result[0]['overview_polyline']['points']


# In[20]:

feature5 = Feature(geometry=LineString(decode_polyline_reverse_coords(polyline)), properties={'mode': mode, 'start': departure_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], 'end': arrival_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]})


# # Trip 6: Times Square to LGA Airport at 6pm on a Friday by Transit

# In[21]:

# Request directions
mode = 'transit'
directions_result = gmaps.directions("Times Square, New York City",
                                     "LGA Airport",
                                     mode=mode,
                                     departure_time=departure_time)

arrival_time = departure_time + timedelta(0,directions_result[0]['legs'][0]['duration']['value'])

print "Start Time:", departure_time
print "End Time:", arrival_time
print "Start Address:", directions_result[0]['legs'][0]['start_address']
print "End Address:", directions_result[0]['legs'][0]['end_address']
print "Distance:", directions_result[0]['legs'][0]['distance']['text']
print "Duration:", directions_result[0]['legs'][0]['duration']['text']
polyline = directions_result[0]['overview_polyline']['points']


# In[22]:

feature6 = Feature(geometry=LineString(decode_polyline_reverse_coords(polyline)), properties={'mode': mode, 'start': departure_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3], 'end': arrival_time.strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]})


# # Combine all trips into one GeoJSON file

# In[30]:

featureCollection = FeatureCollection([feature4, feature5, feature6, feature1, feature2, feature3])


# In[31]:

with open('sketch/data/output.geojson', 'w') as outfile:
    json.dump(featureCollection, outfile)

#os.rename("output.geojson", "sketch/data/output.geojson")

