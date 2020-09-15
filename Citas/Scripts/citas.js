function formatTimeAMPM(date) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0' + minutes : minutes;
    var strTime = hours + ':' + minutes + ' ' + ampm;
    return strTime;
}
function formatTime24(date) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    minutes = minutes < 10 ? '0' + minutes : minutes;
    hours = hours < 10 ? '0' + hours : hours;
    var strTime = hours + ':' + minutes;
    return strTime;
}
function formatDateTime(date) {
    return formatDate(date) + " " + formatTimeAMPM(date);
}
function stringToDateTime(dateString) {
    try {
        var reggie = /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/;
        var dateArray = reggie.exec(dateString);
        var dateObject = new Date(
            (+dateArray[1]),
            (+dateArray[2]) - 1, // Careful, month starts at 0!
            (+dateArray[3]),
            (+dateArray[4]),
            (+dateArray[5]),
            (+dateArray[6])
        );
        return dateObject;
    }
    catch (e) {
        console.log("Error: " + e)
        return null
    }

}
function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2)
        month = '0' + month;
    if (day.length < 2)
        day = '0' + day;

    return [month, day, year].join("/");
}
function formatDate2(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2)
        month = '0' + month;
    if (day.length < 2)
        day = '0' + day;

    return [year, month, day].join('-');
}

function formatPhone(objFormField) {
    var sMask = "01234567890x";
    var KeyTyped = String.fromCharCode(window.event.keyCode);

    if (sMask.indexOf(KeyTyped.toString()) == -1) {
        window.event.preventDefault();
        //window.event.keyCode = 0;
        return false;
    }

    intFieldLength = objFormField.value.length;

    if (intFieldLength == 3) {
        objFormField.value = "(" + objFormField.value + ") ";
        return false;
    }

    if (intFieldLength >= 9 && intFieldLength <= 10) {
        objFormField.value = objFormField.value + "-";

        return false;
    }
}