/*
Copyright (c) 2018 ZSC Dev Team
*/

function hF_loadLogin(elementId) {
    var funcLoad = "checkUser('controlApisAdvAdr', 'userName', 'password')";
    var text = ''
    text += '<div class="well">'
    text += '   <text>Login ZSC system</text><br><br>'
    text += '   <text>ZSC platform address </text> <br>'
    text += '   <input class="form-control"  type="text" id="controlApisAdvAdr" value="0x1ac03ee2171d22aa7b7d68231018f7169ba2d8ac"></input> <br> <br>'
    text += '   <text>User Name </text> <br>' 
    text += '   <input type="text" id="userName" value="test"></input> <br>' 
    text += '   <text>Password</text> <br> '
    text += '   <input type="password" id="password" value="aaa"></input> <br> <br> '
    text += '   <button type="button" onClick="' + funcLoad + '">Enter</button>'
    text += '</div>'
    document.getElementById(elementId).innerHTML = text;  
}




