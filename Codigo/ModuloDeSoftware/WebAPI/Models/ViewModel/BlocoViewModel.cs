﻿using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Model.ViewModel
{
    public class BlocoViewModel
    {

        public BlocoViewModel()
        {
        }

        [Display(Name = "Código")]
        public int Id { get; set; }
        [Display(Name = "Título")]
        public string Titulo { get; set; }
        [Display(Name = "Organização")]
        public OrganizacaoModel OrganizacaoId { get; set; }
    }
}
