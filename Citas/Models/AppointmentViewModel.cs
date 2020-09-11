using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Citas.Models
{
    public class AppointmentViewModel
    {
        public long Id { get; set; }
        public DateTime StartDateTime { get; set; }
        public DateTime EndDateTime { get; set; }
        public string FirstName { get; set; } 
        public string LastName { get; set; }
        public string Phone { get; set; }
        public long LocationId { get; set; }
        public string LocationName { get; set; }
        public long ConsultantId { get; set; }
        public string ConsultantName { get; set; }
        public long ServiceId { get; set; }
        public List<object> ServiceList { get; set; }
        public string Note { get; set; }
    }
}