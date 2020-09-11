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
function formatDateTime(date) {
    //return "${date.getMonth()}/${date.getDate()}/${date.getFullYear()} " + formatAMPM(date);
    var mm = date.getMonth();
    var dd = date.getDate();
    var yyyy = date.getFullYear();
    var d = date.toString().substring(0, 10);
    //return mm.padStart(2, '0') + "/" + dd.padStart(2, '0') + "/" + yyyy + " " + formatAMPM(date);
    return formatDate(date) + " " + formatTimeAMPM(date);
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

    return [month, day, year].join('/');
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