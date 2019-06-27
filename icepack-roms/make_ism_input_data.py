import json
import numpy as np
import rasterio
from icepack.constants import ice_density as ρ_I, water_density as ρ_W

# Compute a velocity field
Lx, Ly = 100e3, 30e3
Nx, Ny = 200, 60

h_in, dh = 470, 400
b_in, db = -20, 980
u_in, du = 0, 4e3

# Write everything out to grids
fields = ['u', 'v', 'h', 'b', 'a', 'm']

dx, dy = Lx / Nx, Ly / Ny
origin = (-dx, -dy)
data = {name: np.zeros((Ny + 3, Nx + 3), dtype=np.float32) for name in fields}

for i in range(Ny + 3):
    y = origin[1] + i * dx
    for j in range(Nx + 3):
        x = origin[0] + j * dx
        data['u'][i, j] = u_in + du * x / Lx
        data['v'][i, j] = 0
        data['h'][i, j] = h_in - dh * x / Lx
        data['b'][i, j] = b_in - db * x / Lx
        data['a'][i, j] = 1.0
        data['m'][i, j] = 0.0

transform = rasterio.transform.from_origin(west=-dx, north=(Ny + 1) * dy,
                                           xsize=dx, ysize=dy)

for name in fields:
    field = data[name]
    filename = name + '.tif'
    with rasterio.open(filename, 'w', driver='GTiff',
                       height=Ny + 3, width=Nx + 3, count=1,
                       dtype=field.dtype, transform=transform) as dataset:
        dataset.write(np.flipud(field), indexes=1)
