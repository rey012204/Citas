using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Citas.Controllers.Api
{
    public class AppointmentController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/<controller>/5
        public string Get(int id)
        {
            try
            {
                using (CallTraxEntities callTraxDb = new CallTraxEntities())
                {
                    Appointment app = callTraxDb.Appointments.Where(a => a.AppointmentId == id).FirstOrDefault();
                    if(app != null)
                    {
                        var data = new
                        {
                            StartTime = app.StartDateTime.ToString("hh:mm tt"),
                            EndTime = app.EndDateTime.ToString("hh:mm tt"),
                            FirstName = app.Customer.FirstName,
                            LastName = app.Customer.LastName,
                            Phone = app.Customer.PhoneNumber,
                            Consultant = app.Consultant.ConsultantName,
                            Service = app.ServiceCategory.Name,
                            Note = app.Note 
                        };
                        return JsonConvert.SerializeObject(data);
                    }
                    else
                    {
                        return null;
                    }
                    
                }
            }
            catch (Exception)
            {

                throw;
            }
        }

        // POST api/<controller>
        public void Post([FromBody] string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}