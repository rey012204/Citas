using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Citas.Startup))]
namespace Citas
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
