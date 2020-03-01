﻿using Service;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Persistence;

namespace WebAPI
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddDbContext<STR_DBContext>(options => options.UseMySQL(Configuration.GetConnectionString("MySqlConnection")));

            // Injections
            services.AddScoped<BlocoService>();
       
            services.AddScoped<HardwareDeSalaService>();
            services.AddScoped<HorarioSalaService>();
            services.AddScoped<OrganizacaoService>();
            services.AddScoped<SalaService>();
            services.AddScoped<TipoHardwareService>();
            services.AddScoped<TipoUsuarioService>();
            services.AddScoped<UsuarioOrganizacaoService>();
            services.AddScoped<UsuarioService>();

            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseMvc();
        }
    }
}
