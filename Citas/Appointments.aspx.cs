﻿using DayPilot.Web.Ui.Events;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.DynamicData;
using System.Web.Helpers;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Citas
{
    public partial class Appointments : System.Web.UI.Page
    {
        private DataTable table;

        protected void Page_Load(object sender, EventArgs e)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "alert", "ShowPopup();", true);
            //this.lblMessage.Text = "Your Registration is done successfully. Our team will contact you shotly";

            if (!IsPostBack)
            {
                PopulateDDL();
            }
            if (Session["CalendarStartDate"] == null)
            {
                Session["CalendarStartDate"] = firstDayOfWeek(DateTime.Now, DayOfWeek.Sunday);
            }
            DayPilotCalendar1.StartDate = (DateTime)Session["CalendarStartDate"];
            if (Session["CalendarData"] == null)
            {
                Session["CalendarData"] = CalendarData.GetData(ddlLocation.SelectedValue, ddlConsultant.SelectedValue, DayPilotCalendar1.StartDate, DayPilotCalendar1.StartDate.AddDays(7));
            }
            table = (DataTable)Session["CalendarData"];
            DayPilotCalendar1.DataSource = table;
            DataBind();
        }
        protected DataTable getDataDemo()
        {
            DataTable dt;
            dt = new DataTable();
            dt.Columns.Add("start", typeof(DateTime));
            dt.Columns.Add("end", typeof(DateTime));
            dt.Columns.Add("name", typeof(string));
            dt.Columns.Add("id", typeof(string));
            dt.Columns.Add("color", typeof(string));

            DataRow dr;

            dr = dt.NewRow();
            dr["id"] = 0;
            dr["start"] = Convert.ToDateTime("13:30");
            dr["end"] = Convert.ToDateTime("16:00");
            dr["name"] = "Event 1";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = 1;
            dr["start"] = Convert.ToDateTime("16:00").AddDays(1);
            dr["end"] = Convert.ToDateTime("17:00").AddDays(1);
            dr["name"] = "Event 2";
            dr["color"] = "red";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = 2;
            dr["start"] = Convert.ToDateTime("9:15").AddDays(1);
            dr["end"] = Convert.ToDateTime("12:45").AddDays(1);
            dr["name"] = "Event 3";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = 3;
            dr["start"] = Convert.ToDateTime("16:30");
            dr["end"] = Convert.ToDateTime("17:30");
            dr["name"] = "Sales Dept. Meeting Once Again";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = 4;
            dr["start"] = Convert.ToDateTime("8:00");
            dr["end"] = Convert.ToDateTime("9:00");
            dr["name"] = "Event 4";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr["id"] = 5;
            dr["start"] = Convert.ToDateTime("22:00");
            dr["end"] = Convert.ToDateTime("6:00").AddDays(1);
            dr["name"] = "Event 5";
            dt.Rows.Add(dr);


            dr = dt.NewRow();
            dr["id"] = 6;
            dr["start"] = Convert.ToDateTime("11:00");
            dr["end"] = Convert.ToDateTime("13:00");
            dr["name"] = "Event 6";
            dt.Rows.Add(dr);

            return dt;

        }

        /// <summary>
        /// Gets the first day of a week where day (parameter) belongs. weekStart (parameter) specifies the starting day of week.
        /// </summary>
        /// <returns></returns> 
        private static DateTime firstDayOfWeek(DateTime day, DayOfWeek weekStarts)
        {
            DateTime d = day;
            while (d.DayOfWeek != weekStarts)
            {
                d = d.AddDays(-1);
            }

            return d;
        }

        protected void DayPilotCalendar1_BeforeEventRender(object sender, DayPilot.Web.Ui.Events.Calendar.BeforeEventRenderEventArgs e)
        {
            string color = e.DataItem["color"] as string;
            if (!String.IsNullOrEmpty(color))
            {
                e.DurationBarColor = color;
            }
        }
        protected void PopulateDDL()
        {
            try
            {
                string userID = User.Identity.GetUserId();
                using (CallTraxEntities callTraxDb = new CallTraxEntities())
                {
                    ClientUser user = callTraxDb.ClientUsers.Where(u => u.AspNetUserId == userID).FirstOrDefault();
                    if (user != null)
                    {
                        List<ClientLocation> locations = callTraxDb.ClientLocations.Where(l => l.ClientId == user.ClientId).ToList();
                        foreach (ClientLocation location in user.Client.ClientLocations)
                        {
                            ddlLocation.Items.Add(new ListItem { Text = location.LocationName, Value = location.ClientLocationId.ToString() });
                        }
                        List<Consultant> consultants = callTraxDb.Consultants.Where(c => c.ClientId == user.ClientId).ToList();
                        foreach (Consultant consultant in consultants)
                        {
                            ddlConsultant.Items.Add(new ListItem { Text = consultant.ConsultantName, Value = consultant.ConsultantId.ToString() });
                        }
                    }
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
        protected void UpdateAppointmentTime(string id, DateTime start, DateTime end)
        {
            try
            {
                long lid;

                if (long.TryParse(id, out lid))
                {
                    CalendarData.MoveAppointment(lid, start, end);
                    DataRow dr = table.Rows.Find(id);
                    if (dr != null)
                    {
                        dr["start"] = start;
                        dr["end"] = end;
                        table.AcceptChanges();
                    }

                    Session["CalendarData"] = table;
                    DayPilotCalendar1.DataBind();
                    DayPilotCalendar1.Update();
                }

               
            }
            catch (Exception)
            {

                throw;
            }
        }
        protected void DayPilotCalendar1_OnEventMove(object sender, EventMoveEventArgs e)
        {
            UpdateAppointmentTime(e.Id, e.NewStart, e.NewEnd);
        }
        protected void DayPilotCalendar1_OnEventResize(object sender, EventResizeEventArgs e)
        {
            UpdateAppointmentTime(e.Id, e.NewStart, e.NewEnd);
        }
        //protected void DayPilotCalendar1_OnEventClick(object sender, EventClickEventArgs e)
        //{
        //    ClientScript.RegisterStartupScript(this.GetType(), "alert", "ShowPopup();", true);
        //    this.lblMessage.Text = "Your Registration is done successfully. Our team will contact you shotly";
        //}
 

    }
}