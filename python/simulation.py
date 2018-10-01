
import firedrake
import icepack, icepack.models
from icepack.constants import gravity as g, rho_ice as ρ_I, rho_water as ρ_W, \
    glen_flow_law as n


def init():
    Lx, Ly = 20e3, 20e3
    u0 = 100.0
    h0, dh = 500.0, 100.0
    T = 254.15

    def exact_u(x):
        ρ = ρ_I * (1 - ρ_I / ρ_W)
        Z = icepack.rate_factor(T) * (ρ * g * h0 / 4)**n
        q = 1 - (1 - (dh/h0) * (x/Lx))**(n + 1)
        du = Z * q * Lx * (h0/dh) / (n + 1)
        return u0 + du

    mesh = firedrake.RectangleMesh(32, 32, Lx, Ly)
    x, y = firedrake.SpatialCoordinate(mesh)

    Q = firedrake.FunctionSpace(mesh, 'CG', 1)
    h = firedrake.interpolate(h0 - dh * x / Lx, Q)
    A = firedrake.interpolate(firedrake.Constant(icepack.rate_factor(T)), Q)

    V = firedrake.VectorFunctionSpace(mesh, 'CG', 1)
    u = firedrake.interpolate(firedrake.as_vector((exact_u(x), 0)), V)

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
