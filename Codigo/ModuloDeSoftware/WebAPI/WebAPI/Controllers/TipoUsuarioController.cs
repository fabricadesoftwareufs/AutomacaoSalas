﻿using Microsoft.AspNetCore.Mvc;
using Model;
using Service;
using Service.Interface;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TipoUsuarioController : ControllerBase
    {
        private readonly ITipoUsuarioService _service;
        public TipoUsuarioController(ITipoUsuarioService service)
        {
            _service = service;
        }
        // GET: api/TipoUsuario
        [HttpGet]
        public ActionResult Get()
        {
            try
            {
                var tipoUser = _service.GetAll();
                if (tipoUser.Count == 0)
                    return NoContent();

                return Ok(tipoUser);
            }
            catch (ServiceException e)
            {
                return StatusCode(500, e.Message);
            }
           
        }

        // GET: api/TipoUsuario/5
        [HttpGet("{id}")]
        public ActionResult Get(int id)
        {
            try
            {
                var tipo = _service.GetById(id);
                if (tipo == null)
                    return NotFound("Tipo de Usuário não encontrado na base de dados.");

                return Ok(tipo);
            }
            catch (ServiceException e)
            {
                return StatusCode(500, e.Message);
            }
           
        }
    }
}
