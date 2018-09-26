
import firedrake
import icepack, icepack.models
from icepack.constants import gravity as g, rho_ice as ρ_I, rho_water as ρ_W, \
    glen_flow_law as n

def run_simulation():
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

    V = firedrake.VectorFunctionSpace(mesh, 'CG', 1)
    u = firedrake.interpolate(firedrake.as_vector((exact_u(x), 0)), V)

    print(u((Lx/2, Ly/2)))
