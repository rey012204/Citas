using DayPilot.Web.Ui.Events;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace Citas
{
    public class CalendarData
    {
        public static DataTable GetData(string locationId, string consultantId, DateTime startDate, DateTime endDate)
        {
            DataTable dt;
            dt = new DataTable();

            try
            {
                dt.Columns.Add("start", typeof(DateTime));
                dt.Columns.Add("end", typeof(DateTime));
                dt.Columns.Add("name", typeof(string));
                dt.Columns.Add("id", typeof(string));
                dt.Columns.Add("color", typeof(string));

                
                using (CallTraxEntities callTraxDb = new CallTraxEntities())
                {
                    List<Appointment> appointments = callTraxDb.Appointments.Where(a => a.LocationId.ToString() == locationId && a.ConsultantId.ToString() == consultantId && a.StartDateTime >= startDate && a.EndDateTime <= endDate).ToList();
                    foreach (Appointment appointment in appointments)
                    {
                        DataRow dr;

                        dr = dt.NewRow();
                        dr["id"] = appointment.AppointmentId.ToString();
                        dr["start"] = appointment.StartDateTime;
                        dr["end"] = appointment.EndDateTime;
                        dr["name"] = $"{appointment.CustomerFirstName} {appointment.CustomerLastName}";
                    ;
                        dt.Rows.Add(dr);
                    }
                }

                dt.PrimaryKey = new DataColumn[] { dt.Columns["id"] };
            }
            catch (Exception)
            {

                //throw;
                //TODO:Log Error
            }

            return dt;

        }
        public static void MoveAppointment(long appointmentId, DateTime startDate, DateTime endDate)
        {
            try
            {
                using (CallTraxEntities callTraxDb = new CallTraxEntities())
                {
                    Appointment app = callTraxDb.Appointments.Where(a => a.AppointmentId == appointmentId).FirstOrDefault();
                    if (app != null)
                    {
                        app.StartDateTime = startDate;
                        app.EndDateTime = endDate;
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