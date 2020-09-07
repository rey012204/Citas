using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.UI.WebControls;

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
                    Appointment appt = callTraxDb.Appointments.Where(a => a.AppointmentId == id).FirstOrDefault();
                    if(appt != null)
                    {
                        List<SessionTime> sessions = callTraxDb.SessionTimes.Where(st => st.ConsultantId == appt.ConsultantId).ToList();
                        List<object> services = new List<object>();
                        List<object> locations = new List<object>();
                        locations.Add(new { value = appt.ClientLocation.ClientLocationId, text = appt.ClientLocation.LocationName.Trim() });
                        List<object> consultants = new List<object>();
                        consultants.Add(new { value = appt.Consultant.ConsultantId, text = appt.Consultant.ConsultantName.Trim() });
                        foreach (SessionTime session in sessions)
                        {
                            services.Add( new { value = session.ServiceCategory.ServiceCategoryId.ToString().Trim(), text = session.ServiceCategory.Name.Trim() });
                        }
                        var data = new
                        {
                            StartTime = appt.StartDateTime.ToString("hh:mm tt"),
                            EndTime = appt.EndDateTime.ToString("hh:mm tt"),
                            FirstName = appt.CustomerFirstName.Trim(),
                            LastName = appt.CustomerLastName.Trim(),
                            Phone = appt.CustomerPhoneNumber.Trim(),
                            LocationId = appt.ClientLocation.ClientLocationId,
                            Locations = locations,
                            Consultants= consultants,
                            ConsultantId = appt.Consultant.ConsultantId,
                            ServiceId = appt.ServiceCategory.ServiceCategoryId,
                            Services = services,
                            Note = appt.Note 
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