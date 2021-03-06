﻿using Citas.Models;
using Microsoft.AspNet.Identity;
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
        public string Get(string locationId, string consultantId, DateTime start, DateTime end)
        {
            try
            {
                long locId = 0;
                long.TryParse(locationId, out locId);
                long consId = 0;
                long.TryParse(consultantId, out consId);
                using (CallTraxEntities callTraxDb = new CallTraxEntities())
                {
                    string userID = User.Identity.GetUserId();
                    ClientUser user = callTraxDb.ClientUsers.Where(u => u.AspNetUserId == userID).FirstOrDefault();
                    List<object> listLoc = new List<object>();
                    List<object> listCons = new List<object>();
                    if (user != null)
                    {
                        List<ClientLocation> listlocations = callTraxDb.ClientLocations.Where(l => l.ClientId == user.ClientId).ToList();
                        List<Consultant> listconsultants = callTraxDb.Consultants.Where(c => c.ClientId == user.ClientId).ToList();

                        foreach (ClientLocation loc in listlocations)
                        {
                            listLoc.Add(new { value = loc.ClientLocationId.ToString(), text = loc.LocationName.Trim() });
                        }
                        foreach (Consultant cons in listconsultants)
                        {
                            listCons.Add(new { value = cons.ConsultantId, text = cons.ConsultantName.Trim() });
                        }
                    }
                    List<SessionTime> sessions = callTraxDb.SessionTimes.Where(st => st.ConsultantId == consId).ToList();
                    List<object> services = new List<object>();
                    bool first = true;
                    long selService = 0;
                    foreach (SessionTime session in sessions)
                    {
                        if (first)
                        {
                            selService = session.ServiceCategory.ServiceCategoryId;
                            first = false;
                        }
                        services.Add(new { value = session.ServiceCategory.ServiceCategoryId.ToString().Trim(), text = session.ServiceCategory.Name.Trim() });
                    }
                    var data = new AppointmentViewModel
                        {
                            Id = 0,
                            StartDateTime = start,
                            EndDateTime = end,
                            FirstName = "",
                            LastName = "",
                            Phone = "",
                            LocationId = locId,
                            ConsultantId = consId,
                            ServiceId = selService,
                            LocationList = listLoc,
                            ConsultantList = listCons,
                            ServiceList = services,
                            Note = ""
                        };
                    return JsonConvert.SerializeObject(data);

                }
            }
            catch (Exception)
            {

                throw;
            }
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
                        string userID = User.Identity.GetUserId();
                        ClientUser user = callTraxDb.ClientUsers.Where(u => u.AspNetUserId == userID).FirstOrDefault();
                        List<object> listLoc = new List<object>();
                        List<object> listCons = new List<object>();
                        if (user != null)
                        {
                            List<ClientLocation> listlocations = callTraxDb.ClientLocations.Where(l => l.ClientId == user.ClientId).ToList();
                            List <Consultant> listconsultants = callTraxDb.Consultants.Where(c => c.ClientId == user.ClientId).ToList();

                            foreach (ClientLocation loc in listlocations)
                            {
                                listLoc.Add(new { value = loc.ClientLocationId.ToString(), text = loc.LocationName.Trim() });
                            }
                            foreach (Consultant cons in listconsultants)
                            {
                                listCons.Add(new { value = cons.ConsultantId, text = cons.ConsultantName.Trim() });
                            }
                        }
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
                        var data = new AppointmentViewModel
                        {
                            Id = appt.AppointmentId,
                            StartDateTime = appt.StartDateTime,
                            EndDateTime = appt.EndDateTime,
                            FirstName = appt.CustomerFirstName.Trim(),
                            LastName = appt.CustomerLastName.Trim(),
                            Phone = appt.CustomerPhoneNumber.Trim(),
                            LocationId = appt.ClientLocation.ClientLocationId,
                            ConsultantId = appt.Consultant.ConsultantId,
                            ServiceId = appt.ServiceCategory.ServiceCategoryId,
                            LocationList = listLoc,
                            ConsultantList = listCons,
                            ServiceList = services,
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
        public void Post([FromBody] AppointmentViewModel value)
        {
            try
            {
                AppointmentViewModel appt = value;
                using (CallTraxEntities callTraxDb = new CallTraxEntities())
                {
                    Appointment newappt = new Appointment
                    {
                        StartDateTime = value.StartDateTime.ToLocalTime(),
                        EndDateTime = value.EndDateTime.ToLocalTime(),
                        LocationId = value.LocationId,
                        ConsultantId = value.ConsultantId,
                        ServiceCategoryId = appt.ServiceId,
                        CustomerFirstName = value.FirstName,
                        CustomerLastName = value.LastName,
                        CustomerPhoneNumber = value.Phone,
                        Note = value.Note
                    };
                    callTraxDb.Appointments.Add(newappt);
                    callTraxDb.SaveChanges();
                }
            }
            catch (Exception)
            {

                throw;
            }
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody] AppointmentViewModel value)
        {
            try
            {
                AppointmentViewModel appt = value;
                using (CallTraxEntities callTraxDb = new CallTraxEntities())
                {
                    Appointment appointment = callTraxDb.Appointments.Where(a => a.AppointmentId == appt.Id).FirstOrDefault();
                    if (appointment != null)
                    {
                        appointment.LocationId = appt.LocationId;
                        appointment.ConsultantId = appt.ConsultantId;
                        appointment.StartDateTime = appt.StartDateTime.ToLocalTime();
                        appointment.EndDateTime = appt.EndDateTime.ToLocalTime();
                        appointment.CustomerFirstName = appt.FirstName;
                        appointment.CustomerLastName = appt.LastName;
                        appointment.CustomerPhoneNumber = appt.Phone;
                        appointment.ServiceCategoryId = appt.ServiceId;
                        appointment.Note = appt.Note;
                        callTraxDb.SaveChanges();
                    }
                }
            }
            catch (Exception)
            {

                throw;
            }
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
            try
            {
                using (CallTraxEntities callTraxDb = new CallTraxEntities())
                {
                    Appointment appt = callTraxDb.Appointments.Where(a => a.AppointmentId == id).FirstOrDefault();
                    if(appt != null)
                    {
                        callTraxDb.Appointments.Remove(appt);
                        callTraxDb.SaveChanges();
                    }
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}