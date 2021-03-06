﻿using Model;
using Model.AuxModel;
using System.Collections.Generic;

namespace Service.Interface
{
    public interface ISalaService
    {
        List<SalaModel> GetAll();
        SalaModel GetById(int id);
        SalaModel GetByTitulo(string titulo);
        List<SalaModel> GetByIdBloco(int id);

        List<SalaModel> GetAllByIdUsuarioOrganizacao(int idUsuario);
        bool InsertSalaWithHardwares(SalaAuxModel sala, int idUsuario);
        SalaModel Insert(SalaModel salaModel);
        bool Remove(int id);
        bool Update(SalaModel entity);
    }
}
