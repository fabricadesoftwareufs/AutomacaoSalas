﻿using Model;
using Persistence;
using Service.Interface;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Service
{
    public class MonitoramentoService : IMonitoramentoService
    {
        private readonly str_dbContext _context;
        public MonitoramentoService(str_dbContext context)
        {
            _context = context;
        }

        public List<MonitoramentoModel> GetAll() => _context.Monitoramento.Select(m => new MonitoramentoModel { Id = m.Id, SalaId = m.Sala, ArCondicionado = Convert.ToBoolean(m.ArCondicionado), Luzes = Convert.ToBoolean(m.Luzes) }).ToList();

        public MonitoramentoModel GetById(int id) => _context.Monitoramento.Where(m => m.Id == id).Select(m => new MonitoramentoModel { Id = m.Id, SalaId = m.Sala, ArCondicionado = Convert.ToBoolean(m.ArCondicionado), Luzes = Convert.ToBoolean(m.Luzes) }).FirstOrDefault();

        public MonitoramentoModel GetByIdSala(int idSala) => _context.Monitoramento.Where(m => m.Sala == idSala).Select(m => new MonitoramentoModel { Id = m.Id, SalaId = m.Sala, ArCondicionado = Convert.ToBoolean(m.ArCondicionado), Luzes = Convert.ToBoolean(m.Luzes) }).FirstOrDefault();

        public bool Insert(MonitoramentoModel model)
        {
            try
            {
                if (GetByIdSala(model.SalaId) != null)
                    return true;

                _context.Add(SetEntity(model));
                return _context.SaveChanges() == 1;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public bool MonitorarSala(int idUsuario, MonitoramentoModel model)
        {
            if (model.SalaParticular)
            {
                var _salaParticular = new SalaParticularService(_context);
                if (_salaParticular.GetByIdUsuarioAndIdSala(idUsuario, model.SalaId) == null)
                    throw new ServiceException("Houve um problema e o monitoramento não pode ser finalizado, por favor tente novamente mais tarde!");
            }
            else
            {
                var _horarioSalaService = new HorarioSalaService(_context);
                if (!_horarioSalaService.VerificaSeEstaEmHorarioAula(idUsuario, model.SalaId))
                    throw new ServiceException("Você não está no horário reservado para monitorar essa sala!");
            }

            if (!EnviarComandosMonitoramento(model))
                throw new ServiceException("Não foi possível concluir seu monitoramento pois não foi possível estabelecer conexão com a sala!");

            return Update(model);
        }

        public bool Update(MonitoramentoModel model)
        {
            try
            {
                _context.Update(SetEntity(model));
                return _context.SaveChanges() == 1;
            }
            catch (Exception)
            {
                throw new ServiceException("Houve um problema ao tentar fazer monitoramento da sala, por favor tente novamente em alguns minutos!");
            }
        }

        private bool EnviarComandosMonitoramento(MonitoramentoModel solicitacao)
        {
            var _hardwareDeSalaService = new HardwareDeSalaService(_context);
            var modelDesatualizado = GetById(solicitacao.Id);
            bool comandoEnviadoComSucesso = true;

            /* 
             * Verifica qual o equipamento foi 'monitorado' para ligar/desligar   
             */
            if (solicitacao.ArCondicionado != modelDesatualizado.ArCondicionado)
            {
                var _codigosInfravermelhoService = new CodigoInfravermelhoService(_context);
                var _equipamentoServiceService = new EquipamentoService(_context);
                var idOperacao = solicitacao.ArCondicionado ? OperacaoModel.OPERACAO_LIGAR : OperacaoModel.OPERACAO_DESLIGAR;
                var equipamento = _equipamentoServiceService.GetByIdSalaAndTipoEquipamento(solicitacao.SalaId, EquipamentoModel.TIPO_CONDICIONADOR);
                var codigosInfravermelho = _codigosInfravermelhoService.GetByIdOperacaoAndIdEquipamento(equipamento.Id, idOperacao);
                var hardwareDeSala = _hardwareDeSalaService.GetByIdSalaAndTipoHardware(solicitacao.SalaId, TipoHardwareModel.CONTROLADOR_DE_SALA).FirstOrDefault();

                if (codigosInfravermelho == null)
                    throw new ServiceException("Houve um problema e o monitoramento não pode ser finalizado, por favor tente novamente mais tarde!");

                var mensagem = "CONDICIONADOR;" + codigosInfravermelho.Codigo + ";";

                try
                {
                    var clienteSocket = new ClienteSocketService(hardwareDeSala.Ip);

                    clienteSocket.AbrirConexao();
                    var status = clienteSocket.EnviarComando(mensagem);
                    clienteSocket.FecharConexao();

                    solicitacao.ArCondicionado = status.Contains("AC-ON");
                    comandoEnviadoComSucesso = status != null;
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                    return false;
                }
            }
            else if (solicitacao.Luzes != modelDesatualizado.Luzes)
            {
                var hardwareDeSala = _hardwareDeSalaService.GetByIdSalaAndTipoHardware(solicitacao.SalaId, TipoHardwareModel.CONTROLADOR_DE_SALA).FirstOrDefault();

                var mensagem = "LUZES;" + solicitacao.Luzes + ";";

                try
                {
                    var clienteSocket = new ClienteSocketService(hardwareDeSala.Ip);

                    clienteSocket.AbrirConexao();
                    var status = clienteSocket.EnviarComando(mensagem);
                    clienteSocket.FecharConexao();

                    solicitacao.Luzes = status.Contains("L-ON");
                    comandoEnviadoComSucesso = status != null;

                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                    return false;
                }
            }

            return comandoEnviadoComSucesso;
        }

        private Monitoramento SetEntity(MonitoramentoModel model)
        {
            return new Monitoramento
            {
                Id = model.Id,
                Luzes = Convert.ToByte(model.Luzes),
                ArCondicionado = Convert.ToByte(model.ArCondicionado),
                Sala = model.SalaId
            };
        }
    }
}
