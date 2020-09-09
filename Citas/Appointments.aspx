<%@ Page Title="Appointments" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Appointments.aspx.cs" Inherits="Citas.Appointments" %>
<%@ Register Assembly="DayPilot" Namespace="DayPilot.Web.Ui" TagPrefix="DayPilot" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link href="Themes/calendar_traditional.css" rel="stylesheet" />
    <h2><%: Title %>.</h2>
    <div class="row">
        <div class="col-md-6">
            <asp:Label ID="lblLocation" runat="server" Text="Location"></asp:Label>
            <asp:DropDownList ID="ddlLocation" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlLocation_SelectedIndexChanged"></asp:DropDownList>
        </div>
        <div class="col-md-6">
            <asp:Label ID="lblConsultant" runat="server" Text="Consultant"></asp:Label>
            <asp:DropDownList ID="ddlConsultant" runat="server" OnSelectedIndexChanged="ddlConsultant_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
            <asp:DropDownList ID="ddlService" runat="server" Style="visibility: hidden;" ></asp:DropDownList>
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
        TimeRangeSelectedJavaScript="ShowPopupNew(start, end, resource)"
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
                    <input type="hidden" id="apptid" name="apptid" value="0">
                </div>
                <div class="modal-body">
                    <table>
                        <tr style="padding:5px">
                            <td>
                                <table>
                                    <tr>
                                        <td>Start:</td>
                                        <td>
                                            <input type="hidden" id="txtstartval" />
                                            <input type="text" id="txtstart" readonly />
                                        </td>
                                    </tr>
                                   <tr>
                                        <td>End:</td>
                                        <td>
                                            <input type="hidden" id="txtendval" />
                                            <input type="text" id="txtend" readonly />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Location:</td>
                                        <td>
                                            <select name="selectlocation" id="selectlocation"></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Consultant:</td>
                                        <td>
                                            <select name="selectconsultant" id="selectconsultant"></select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Service:</td>
                                         <td>
                                            <select name="selectservice" id="selectservice"></select>
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
                    <button id="btnCancelAppointment" type="button" class="btn btn-danger pull-left" data-dismiss="modal">Cancel appointment</button>
                    <button id="btnCloseAppointment" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button id="btnSaveAppointment" type="button" class="btn btn-primary" onclick="SaveAppt();">Save changes</button>
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
                    $("#apptid").val(id);
                    $("#txtstartval").val(appt.StartDateTime.valueOf());
                    $("#txtstart").val(appt.StartDateTime.toString());
                    $("#txtendval").val(appt.EndDateTime.valueOf());
                    $("#txtend").val(appt.EndDateTime.toString());
                    $("#txtfirstname").val(appt.FirstName);
                    $("#txtlastname").val(appt.LastName);
                    $("#txtphone").val(appt.Phone);
                    $("#txtnote").val(appt.Note);
                    PopulateDDL($("#selectlocation"), appt.LocationList, appt.LocationId);
                    PopulateDDL($("#selectconsultant"), appt.ConsultantList, appt.ConsultantId);
                    PopulateDDL($("#selectservice"), appt.ServiceList, appt.ServiceId);
                    $("#btnShowPopup").click();
                },
                error: function (e) {
                    alert("Error: " + e.status + " " + e.statusText);
                }
            });
    }

    function SaveAppt() {
        try {
            var apptdata = new Object();
            var d1 = new Date($("#txtstartval").val());
            var d2 = new Date($("#txtendval").val());
            apptdata.StartDateTime = d1;
            apptdata.EndDateTime = d2;
            apptdata.Id = Number($("#apptid").val());
            apptdata.LocationId = Number($("#selectlocation").val());
            apptdata.ConsultantId = Number($("#selectconsultant").val());
            apptdata.FirstName = $("#txtfirstname").val();
            apptdata.LastName = $("#txtlastname").val();
            apptdata.Phone = $("#txtphone").val();
            apptdata.ServiceId = Number($("#selectservice").val());
            apptdata.Note = $.trim($("#txtnote").val());

            $.ajax({
                type: "POST",
                url: "api/appointment/",
                data: JSON.stringify(apptdata),
                contentType: "application/json; charset=utf-8",
                async: "true",
                cache: "false",
                success: function (response) {
                    //RefreshCalendar();
                    $("#btnCloseAppointment").click();
                    location.reload();
                },
                error: function (e) {
                    alert("Error: " + e.status + " " + e.statusText);
                }
            });

        }
        catch (e) {
            alert("Error: " + e)
        }
    }

    function RefreshCalendar() {
        try {
            $.ajax({
                type: "GET",
                url: "Appointment.aspx/RefreshCalendar",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                async: "true",
                cache: "false",
                success: function (response) {
                    $("#btnCloseAppointment").click();
                },
                error: function (e) {
                    alert("Error: " + e.status + " " + e.statusText);
                }
            });

        }
        catch (e) {
            alert("Error: " + e)
        }
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

    function ShowPopupNew(start, end, resource) {
        try
        {
            $("#apptid").val(0);
            $("#txtstartval").val(start.valueOf());
            $("#txtstart").val(start.toStringSortable());
            $("#txtendval").val(end.valueOf());
            $("#txtend").val(end.toStringSortable());
            $("#txtfirstname").val('');
            $("#txtlastname").val('');
            $("#txtphone").val('');
            $("#txtnote").val('');
            $("#selectlocation").empty();
            $("#selectconsultant").empty();
            $("#selectservice").empty();

            var loc = document.getElementById("<%=ddlLocation.ClientID%>");
            var locvalue = loc.options[loc.selectedIndex].value;
            var loctext = loc.options[loc.selectedIndex].text;
            $("#selectlocation").append("<option value='" + locvalue + "' selected>" + loctext + "</option>");

            var con = document.getElementById("<%=ddlConsultant.ClientID%>");
            var convalue = con.options[con.selectedIndex].value;
            var context = con.options[con.selectedIndex].text;
            $("#selectconsultant").append("<option value='" + convalue + "' selected>" + context + "</option>");

            var serv = document.getElementById("<%=ddlService.ClientID%>");
            var first = true;
            for (var i = 0; i < serv.length; i++) {
                var selected = '';
                if (first) {
                    selected = 'selected';
                    first = false;
                }

                $("#selectservice").append("<option value='" + serv[i].value + "' " + selected + ">" + serv[i].text + "</option>");
            }

            $("#btnShowPopup").click();
        }
        catch (e) {
            alert("Error: " + e)
        }

    }

</script>    
</asp:Content>

