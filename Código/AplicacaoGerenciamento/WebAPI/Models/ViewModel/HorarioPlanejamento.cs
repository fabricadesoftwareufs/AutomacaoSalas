﻿using System;
using System.Collections.Generic;
using System.Text;

namespace Model.ViewModel
{
    public class HorarioPlanejamento
    {
        public TimeSpan HorarioInicio { get; set; }
        public TimeSpan HorarioFim { get; set; }
        public string DiaSemana { get; set; }
    }
}
