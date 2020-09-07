<%@ Page Title="Appointments" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Appointments.aspx.cs" Inherits="Citas.Appointments" %>
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
        TimeRangeSelectedJavaScript="ShowPopupNew();"
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

    <div class="modal fade" id="apptPopup">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Appointment Information</h4>
                </div>
                <div class="modal-body">
                    <table>
                        <tr style="padding:5px">
                            <td>
                                <table>
                                    <tr>
                                        <td>Duration:</td>
                                        <td>
                                            <input type="text" id="txtduration" readonly />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Location:</td>
                                        <td>
                                            <select name="ddllocation" id="ddllocation"></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Consultant:</td>
                                        <td>
                                            <select name="ddlconsultant" id="ddlconsultant"></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Service:</td>
                                         <td>
                                            <select name="ddlservice" id="ddlservice"></select>
                                        </td>                       
                                    </tr>
                                    <tr>
                                        <td>First Name:</td>
                                        <td>
                                            <input type="text" id="txtfirstname" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Last Name:</td>
                                        <td>
                                            <input type="text" id="txtlastname" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Phone No:</td>
                                        <td>
                                            <input type="text" id="txtphone" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" style="padding-left:10px">
                                <table>
                                    <tr>
                                        <td>Notes:</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <textarea rows = "10" cols = "38" id = "txtnote"></textarea>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <button id="brnCancelAppointment" type="button" class="btn btn-danger pull-left" data-dismiss="modal">Cancel appointment</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button id="btnSaveAppointment" type="button" class="btn btn-primary">Save changes</button>
                </div>
            </div> <!-- /.modal-content -->
        </div> <!-- /.modal-dialog -->
    </div> <!-- /.modal -->  
            
    <button type="button" style="display: none;" id="btnShowPopup" class="btn btn-primary btn-lg"
                data-toggle="modal" data-target="#apptPopup">
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
                    $("#txtduration").val(appt.StartTime + " to " + appt.EndTime);
                    $("#txtfirstname").val(appt.FirstName);
                    $("#txtlastname").val(appt.LastName);
                    $("#txtphone").val(appt.Phone);
                    $("#txtnote").val(appt.Note);
                    PopulateDDL($("#ddllocation"),appt.Locations, appt.LocationId);
                    PopulateDDL($("#ddlconsultant"), appt.Consultants, appt.ConsultantId);
                    PopulateDDL($("#ddlservice"), appt.Services, appt.ServiceId);
                    $("#btnShowPopup").click();
                },
                error: function (e) {
                    alert("Error: " + e.status + " " + e.statusText);
                }
            });
    }

    function PopulateDDL(ddl, list, id) {
        try {
            for (k = 0; k < list.length; k++) {
                var s = list[k];
                var selected = '';
                if (s.value == id) selected = 'selected';
                ddl.append("<option value='" + s.value + "' " + selected + ">" + s.text + "</option>");
            }
        }
        catch (e) {
            console.log("Error: " + e)
        }
    }
    function ShowPopupNew(start, end) {
        alert("ShowPopupNew: ");
        $("#btnShowPopup").click();
    }

</script>    
</asp:Content>

