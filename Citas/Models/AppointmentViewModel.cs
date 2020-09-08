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
        public string StartTime { get; set; }
        public DateTime EndDateTime { get; set; }
        public string EndTime { get; set; }
        public string FirstName { get; set; } 
        public string LastName { get; set; }
        public string Phone { get; set; }
        public long LocationId { get; set; }
        public List<object> LocationList { get; set; }
        public long ConsultantId { get; set; }
        public List<object> ConsultantList { get; set; }
        public long ServiceId { get; set; }
        public List<object> ServiceList { get; set; }
        public string Note { get; set; }
    }
}