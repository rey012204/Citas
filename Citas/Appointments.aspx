﻿<%@ Page Title="Appointments" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Appointments.aspx.cs" Inherits="Citas.Appointments" %>
<%@ Register Assembly="DayPilot" Namespace="DayPilot.Web.Ui" TagPrefix="DayPilot" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link href="Themes/calendar_traditional.css" rel="stylesheet" />
    <h2><%: Title %>.</h2>
    <div class="row">
        <div class="col-md-6">
            <asp:Label ID="lblLocation" runat="server" Text="Location"></asp:Label>
            <asp:DropDownList ID="ddlLocation" runat="server"></asp:DropDownList>
        </div>
        <div class="col-md-6">
            <asp:Label ID="lblConsultant" runat="server" Text="Consultant"></asp:Label>
            <asp:DropDownList ID="ddlConsultant" runat="server"></asp:DropDownList>
        </div>
    </div>
    <br />
<%--<div class="note"><b>Note:</b> You can create a theme using the online <strong>DayPilot Theme Designer</strong>: <a href="http://themes.daypilot.org/">http://themes.daypilot.org/</a></div>--%>
    <DayPilot:DayPilotCalendar ID="DayPilotCalendar1" runat="server" 
        DataTextField="name" 
        DataValueField="id" 
        TimeFormat="Clock12Hours" 
        DataStartField="Start" 
        DataEndField="End" 
        Days="7" 
        NonBusinessHours="Hide" 
        onbeforeeventrender="DayPilotCalendar1_BeforeEventRender"
        TimeRangeSelectedHandling="JavaScript"
        CssOnly="true"
        CssClassPrefix="calendar_traditional"
        EventMoveHandling="CallBack"
        OnEventMove="DayPilotCalendar1_OnEventMove"
        EventResizeHandling="CallBack"
        OnEventResize="DayPilotCalendar1_OnEventResize"
        EventClickHandling="JavaScript"
        EventClickJavaScript="ShowPopup(e.id());"
     >
    </DayPilot:DayPilotCalendar>

    <div class="modal fade" id="myModal">

        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">
                                Registration done Successfully</h4>
                </div>
                <div class="modal-body">
                    <input type="text" id="lblhour" /><br />
                    <input type="text" id="lblname" /><br />
                    <input type="text" id="lblphone" /><br />
                    <input type="text" id="lblconsultant" /><br />
                    <input type="text" id="lblservice" /><br />
                    <input type="text" id="lblnote" /><br />
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button id="btnSaveAppointment" type="button" class="btn btn-primary">Save changes</button>
                </div>
            </div> <!-- /.modal-content -->
        </div> <!-- /.modal-dialog -->
    </div> <!-- /.modal -->  
            
    <button type="button" style="display: none;" id="btnShowPopup" class="btn btn-primary btn-lg"
                data-toggle="modal" data-target="#myModal">
                Launch demo modal
            </button>   




<script type = "text/javascript">

    function ShowPopup(id) {
            $.ajax({
                type: "GET",
                url: "api/appointment/" + id,
                data: "{}",
                contentType: "application/json; charset=utf-8",
                async: "true",
                cache: "false",
                success: function (response) {
                    //var app = response.d;
                    console.log(response);
                    var appt = $.parseJSON(response);
                    $("#lblhour").val(appt.StartTime + " to " + appt.EndTime);
                    $("#lblname").val(appt.FirstName + " " + appt.LastName);
                    $("#lblphone").val(appt.Phone);
                    $("#lblconsultant").val("Consultant: " + appt.Consultant);
                    $("#lblservice").val("Service: " + appt.Service);
                    $("#lblnote").val(appt.Note);
                    //alert("Hello ");
                    //$("#lblid").val(msg.Customer.FirstName);
                    $("#btnShowPopup").click();   
                    //$("#Button1").click(); 
                },
                error: function (e) {
                    alert("Error: " + e.status + " " + e.statusText);
                }
            });
        }


</script>    
</asp:Content>

