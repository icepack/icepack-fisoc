import os
import json
import numpy as np
import firedrake
import icepack, icepack.models
from icepack.grid import arcinfo
from icepack.constants import gravity as g, rho_ice as ρ_I, rho_water as ρ_W, \
    glen_flow_law as n


def init(config_filename):
    path = os.path.dirname(os.path.abspath(config_filename))
    with open(config_filename, 'r') as config_file:
        config = json.load(config_file)

    print("Config: {}".format(config), flush=True)

    mesh = firedrake.Mesh(os.path.join(path, config['mesh']))

    Q = firedrake.FunctionSpace(mesh, 'CG', 1)
    V = firedrake.VectorFunctionSpace(mesh, 'CG', 1)

    thickness = arcinfo.read(os.path.join(path, config['thickness']))
    h = icepack.interpolate(thickness, Q)

    T = 254.15
    A = firedrake.interpolate(firedrake.Constant(icepack.rate_factor(T)), Q)

    velocity_x = arcinfo.read(os.path.join(path, config['velocity_x']))
    velocity_y = arcinfo.read(os.path.join(path, config['velocity_y']))
    u = icepack.interpolate(lambda x: (velocity_x(x), velocity_y(x)), V)

    print("Done initializing!")

    return dict(velocity=u, thickness=h, fluidity=A)


def run(fields):
    h, u = fields['thickness'], fields['velocity']
    A = fields['fluidity']

    opts = dict(dirichlet_ids=[1], side_wall_ids=[3, 4], tol=1e-12)
    ice_shelf = icepack.models.IceShelf()
    u.assign(ice_shelf.diagnostic_solve(u0=u, h=h, A=A, **opts))

    print(firedrake.norm(u))
    print("Done running!")

    return fields


def get_velocity(fields):
    print("Accessing velocity data!")
    return fields['velocity'].dat.data_ro


def get_thickness(fields):
    print("Accessing thickness data!")
    return fields['thickness'].dat.data_ro
