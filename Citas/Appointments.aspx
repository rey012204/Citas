<%@ Page Title="Appointments" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Appointments.aspx.cs" Inherits="Citas.Appointments" %>
<%@ Register Assembly="DayPilot" Namespace="DayPilot.Web.Ui" TagPrefix="DayPilot" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link href="Themes/calendar_traditional.css" rel="stylesheet" />
    <h2><%: Title %>.</h2>
    <div class="row">
        <div class="col-md-4">
            <label class="control-label" for="date">Date</label>
            <asp:TextBox ID="txtDate" runat="server" placeholder="mm/dd/yyyy" Textmode="Date" ReadOnly = "false" AutoPostBack="True" OnTextChanged="txtDate_TextChanged"></asp:TextBox>
        </div>
        <div class="col-md-4">
            <label class="control-label" for="date">Location</label>
            <asp:DropDownList ID="ddlLocation" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlLocation_SelectedIndexChanged"></asp:DropDownList>
        </div>
        <div class="col-md-4">
            <label class="control-label" for="date">Consultant</label>
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
                    <table class="appointment-table">
                       <tr>
                            <td>Date:</td>
                            <td>
                                <%--<input type="text" id="txtstart" readonly />--%>
                                <input id="txtstartdate" type="date" />
                                <input type="time" id="txtstarttime" name="txtstarttime"> to <input type="time" id="txtendtime" name="txtendtime">
                                <input type="hidden" id="txtstartval" />
                                <input type="hidden" id="txtendval" />                            
                            </td>
                       </tr>
                       <tr>
                            <td>Location:</td>
                            <td>
                                <select name="selectlocation" id="selectlocation"></select>
                                <span id="reqlocation" style="color:red;font-weight: bold;font-size:medium;"> * </span>
                            </td>
                       </tr>
                       <tr>
                            <td>Consultant:</td>
                            <td>
                                <select name="selectconsultant" id="selectconsultant"></select>
                                <span id="reqconsultant" style="color:red;font-weight: bold;font-size:medium;"> * </span>
                            </td>
                       </tr>
                       <tr>
                            <td>Service:</td>
                            <td>
                                <select name="selectservice" id="selectservice"></select>
                                <span id="reqservice" style="color:red;font-weight: bold;font-size:medium;"> * </span>
                            </td> 
                       </tr>
                       <tr>
                            <td>First Name:</td>
                            <td>
                                 <input type="text" id="txtfirstname" />
                                <span id="reqfirstname" style="color:red;font-weight: bold;font-size:medium;"> * </span>
                            </td>
                       </tr>
                       <tr>
                            <td>Last Name:</td>
                            <td>
                                 <input type="text" id="txtlastname" />
                                <span id="reqlastname" style="color:red;font-weight: bold;font-size:medium;"> * </span>
                            </td>
                       </tr>
                       <tr>
                            <td>Phone No:</td>
                            <td>
                                <input type="tel" id="txtphone" name="txtphone" />
                                <span id="reqphone" style="color:red;font-weight: bold;font-size:medium;"> * </span>
                            </td>
                       </tr>
                       <tr>
                            <td>Notes:</td>
                            <td>
                                <textarea rows = "8" cols = "60" id = "txtnote"></textarea>
                            </td>
                       </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <button id="btnCancelAppointment" type="button" class="btn btn-danger pull-left" data-dismiss="modal" onclick="$('#btnShowConfirmDelete').click();">Delete appointment</button>
                    <button id="btnCloseAppointment" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button id="btnSaveAppointment" type="button" class="btn btn-primary" onclick="SaveAppointment();">Save changes</button>
                </div>
            </div> <!-- /.modal-content -->
        </div> <!-- /.modal-dialog -->
    </div> <!-- /.modal -->  

    <div class="modal fade" id="confirm-delete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    Delete Appointment Confirmation
                </div>
                <div class="modal-body">
                    Are you sure you want to Delete this appointment?
                </div>
                <div class="modal-footer">
                    <button id="btnCancelDelete" type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button class="btn btn-danger btn-ok" onclick="DeleteAppt();">Delete</button>
                </div>
            </div>
        </div>
    </div>
            
    <button type="button" style="display: none;" id="btnShowPopup" class="btn btn-primary btn-lg"
                data-toggle="modal" data-target="#apptPopup">Modal1</button>  
    <button type="button" style="display: none;" id="btnShowConfirmDelete" class="btn btn-primary btn-lg"
                data-toggle="modal" data-target="#confirm-delete">Modal2</button>  

<script type = "text/javascript">
    $(document).ready(function () {
        var date_input = $('input[name="date"]'); //our date input has the name "date"
        var container = $('.bootstrap-iso form').length > 0 ? $('.bootstrap-iso form').parent() : "body";
        var options = {
            format: 'mm/dd/yyyy',
            container: container,
            todayHighlight: true,
            autoclose: true,
        };
        date_input.datepicker(options);
        //$(function () {
        //    $('#txtphone').usPhoneFormat();
        //});
        //$(function () {
        //    $('#txtphone').usPhoneFormat({
        //    format: '(xxx) xxx-xxxx'
        //    });
        //});
        //$("input[name='phone']").keyup(function () {
        //    $(this).val($(this).val().replace(/^(\d{3})(\d{3})(\d)+$/, "($1)$2-$3"));
        //});
    })
    function ShowPopup(id) {
            $.ajax({
                type: "GET",
                url: "api/appointment/" + id,
                data: "{}",
                contentType: "application/json; charset=utf-8",
                async: "true",
                cache: "false",
                success: function (response) {
                    var appt = $.parseJSON(response);
                    var d1 = new Date(appt.StartDateTime.valueOf())
                    var d2 = new Date(appt.EndDateTime.valueOf())
                    var startymd = formatDate2(d1);
                    var starttime = formatTime24(d1);
                    var endtime = formatTime24(d2);
                    $("#apptid").val(id);
                    $("#txtstartval").val(appt.StartDateTime.valueOf());
                    $("#txtstartdate").val(startymd);
                    $("#txtstarttime").val(starttime);
                    $("#txtendval").val(appt.EndDateTime.valueOf());
                    $("#txtendtime").val(endtime);
                    $("#txtfirstname").val(appt.FirstName);
                    $("#txtlastname").val(appt.LastName);
                    $("#txtphone").val(appt.Phone);
                    $("#txtnote").val(appt.Note);
                    PopulateDDL($("#selectlocation"), appt.LocationList, appt.LocationId);
                    PopulateDDL($("#selectconsultant"), appt.ConsultantList, appt.ConsultantId);
                    PopulateDDL($("#selectservice"), appt.ServiceList, appt.ServiceId);
                    ShowHideRequired();

                    $("#btnShowPopup").click();
                },
                error: function (e) {
                    alert("Error: " + e.status + " " + e.statusText);
                }
            });
    }
    function ShowPopupNew(start, end, resource) {
        try {
            $("#apptid").val(0);

            var d1 = new Date(start.valueOf())
            var d2 = new Date(end.valueOf())
            var startymd = formatDate2(d1);
            var starttime = formatTime24(d1);
            var endtime = formatTime24(d2);
            $("#txtstartval").val(start.valueOf());
            $("#txtendval").val(end.valueOf());
            $("#txtstartdate").val(startymd);
            $("#txtstarttime").val(starttime);
            $("#txtendtime").val(endtime);
            $("#txtfirstname").val('');
            $("#txtlastname").val('');
            $("#txtphone").val('');
            $("#txtnote").val('');
            $("#selectservice").empty();

            var loc = document.getElementById("<%=ddlLocation.ClientID%>");
            var loctext = loc.options[loc.selectedIndex].text;
            $("#txtlocation").val(loctext);

            var cons = document.getElementById("<%=ddlConsultant.ClientID%>");
            var constext = cons.options[cons.selectedIndex].text;
            $("#txtconsultant").val(constext);

            var loc = document.getElementById("<%=ddlLocation.ClientID%>");
            CopyDDL(loc, $("#selectlocation"), loc.options[loc.selectedIndex].value, null)

            var cons = document.getElementById("<%=ddlConsultant.ClientID%>");
            CopyDDL(cons, $("#selectconsultant"), cons.options[cons.selectedIndex].value, null)

            var serv = document.getElementById("<%=ddlService.ClientID%>");
            CopyDDL(serv, $("#selectservice"), 0, "-- Select Service --")

            $("#reqlocation").hide();
            $("#reqconsultant").hide();
            $("#reqservice").hide();
            $("#reqfirstname").hide();
            $("#reqlastname").hide();
            $("#reqphone").hide();

            $("#btnShowPopup").click();
        }
        catch (e) {
            alert("Error: " + e)
        }

    }
    function ShowHideRequired() {
        if ($("#selectlocation").val() == 0) $("#reqlocation").show();
        else $("#reqlocation").hide();
        if ($("#selectconsultant").val() == 0) $("#reqconsultant").show();
        else $("#reqconsultant").hide();
        if ($("#selectservice").val() == 0) $("#reqservice").show();
        else $("#reqservice").hide();
        if ($("#txtfirstname").val() == "") $("#reqfirstname").show();
        else $("#reqfirstname").hide();
        if ($("#txtlastname").val() == "") $("#reqlastname").show();
        else $("#reqlastname").hide();
        if ($("#txtphone").val() == "") $("#reqphone").show();
        else $("#reqphone").hide();
    }
    function SaveAppointment() {
        var valid = true;
        if ($("#txtfirstname").val() == "") {
            valid = false;
        }
        if ($("#txtlastname").val() == "") {
            valid = false;
        }
        if ($("#txtphone").val() == "") {
            valid = false;
        }

        ShowHideRequired();

        if (valid == false) {
            return false;
        }
        var apptdata = new Object();
        //var d1 = new Date($("#txtstartval").val());
        //var d2 = new Date($("#txtendval").val());
        var datestring1 = $("#txtstartdate").val() + " " + $("#txtstarttime").val() + ":00"
        var datestring2 = $("#txtstartdate").val() + " " + $("#txtendtime").val() + ":00"
        var d1 = stringToDateTime(datestring1)
        var d2 = stringToDateTime(datestring2)
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

        if (apptdata.Id == 0) {
            PostAppt(apptdata);
        }
        else {
            PutAppt(apptdata);
        }

        return true;
    }
    function PostAppt(apptdata) {
        try {
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
            alert("Error: " + e);
        }
    }
    function PutAppt(apptdata) {
        try {
            $.ajax({
                type: "PUT",
                url: "api/appointment/" + apptdata.Id,
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
            alert("Error: " + e);
        }
    }
    function DeleteAppt() {
        $.ajax({
                type: "DELETE",
                url: "api/appointment/" + $("#apptid").val(),
                data: "{}",
                contentType: "application/json; charset=utf-8",
                async: "true",
                cache: "false",
                success: function (response) {
                    //RefreshCalendar();
                    $("#btnCancelDelete").click();
                    location.reload();
                },
                error: function (e) {
                    alert("Error: " + e.status + " " + e.statusText);
                }
            });
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
            ddl.empty();
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
    function CopyDDL(fromddl, toddl, selval, seltxt) {
        try {
            if (seltxt != null) {
                toddl.append(("<option value='" + selval + "' selected>" + seltxt + "</option>"));
            }
            
            for (var i = 0; i < fromddl.length; i++) {
                var selected = '';
                if (seltxt == null && fromddl[i].value == selval) {
                    selected = ' selected';
                }
                toddl.append("<option value='" + fromddl[i].value + "'" + selected + ">" + fromddl[i].text + "</option>");
            }
        } catch (e) {
            console.log("Error: " + e)
        }
    }
   
</script>    
</asp:Content>

