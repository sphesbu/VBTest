<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Main.Master" CodeBehind="QuestionnaireReport.aspx.vb" Inherits="TimeAndAttendance.QuestionnaireReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
          <link href="ErrorStyle.css" rel="stylesheet" />
<script src="AjaxScript.js" type="text/javascript"></script>

    <link href="ErrorStyle.css" rel="stylesheet" />

    <script src="Scripts/jquery-ui-timepicker-addon.js"></script>

    <link href ="Styles/TimePicker.css" rel="stylesheet" type ="text/css" />

    <script src="https://maps.googleapis.com/maps/api/js?libraries=places&key=AIzaSyBEgtfVpo-cjU6HwnCn_SC5yc2y107aqs0"></script>
    <link href="ErrorStyle.css" rel="stylesheet" />

    <script src="AjaxScript.js" type="text/javascript"></script>
    
    <script type="text/javascript">

        function GetChildControl(element, id) {
            var child_elements = element.getElementsByTagName("*");
            for (var i = 0; i < child_elements.length; i++) {
                if (child_elements[i].id.indexOf(id) != -1) {
                    return child_elements[i];
                }
            }
        };

        function preventBackspace(e) {
            var evt = e || window.event;
            if (evt) {
                var keyCode = evt.charCode || evt.keyCode;
                if (keyCode === 8) {
                    if (evt.preventDefault) {
                        evt.preventDefault();
                    } else {
                        evt.returnValue = false;
                    }
                }
            }
        }

        function HideAdjustTimePopup2() {
            $find("AdjustTimePopup2").hide();
            return false;
        }

        function HideSelectLocationPopup1() {

            $find("SelectLocationPopup1").hide();

            return false;
        }

        function HideSelectLocationPopup2() {

            $find("SelectLocationPopup2").hide();

            return false;
        }

        function pageLoad() {
            OnLoadScripts();
        }

        $(document).ready(function () {
            OnLoadScripts();
        });



        var popUpWin = 0;

        function popUpWindow(URLStr) {

            if (popUpWin) {

                if (!popUpWin.closed) popUpWin.close();

            }

            popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes');

        }

        function oGMap_Dispose() {
            var divDealerMap = document.getElementById("LocationMap");
            if (divDealerMap) divDealerMap.parentNode.removeChild(divDealerMap);
        }



        function ClientMap(button) {
            // alert("Just a Test");
            var row = button.parentNode.parentNode;

            var Long = "";
            var Lat = "";
            var Cn = "";

            var Longitude = GetChildControl(row, "Longitude");
            var Latitude = GetChildControl(row, "Latitude");
            var ClientName = GetChildControl(row, "HidClientName");


           // document.getElementById("<%=CleintN.ClientID%>").innerHTML = ClientName.value;

            Long = Longitude.value;
            Lat = Latitude.value;
           // Cn = ClientName.value


            var markers = [
               {

                   "title": '' + "ml" + '',
                   "lat": '' + Lat + '',
                   "lng": '' + Long + '',
                   "description": '' + Cn + ''
               }
            ];
           
            if (markers[0] != null) {

                document.getElementById("LocationMap").style.display = "block";

                var mapOptions = {
                    center: new google.maps.LatLng(markers[0].lat, markers[0].lng),
                    zoom: 16,
                    mapTypeControl: true,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };

                var infoWindow = new google.maps.InfoWindow();
                var map = new google.maps.Map(document.getElementById("LocationMap"), mapOptions);
                Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(oGMap_Dispose);

                for (i = 0; i < markers.length; i++) {
                    var data = markers[i];
                    var myLatlng = new google.maps.LatLng(data.lat, data.lng);
                    var marker = new google.maps.Marker({
                        position: myLatlng,
                        map: map,
                        title: data.title
                    });
                    (function (marker, data) {
                        google.maps.event.addListener(marker, "click", function (e) {
                            infoWindow.setContent(data.description);
                            infoWindow.open(map, marker);

                        });
                    })(marker, data);
                }
                google.maps.event.trigger(map, 'resize');
                //            //document.getElementById("hrefShowHideLink").innerHTML = "Hide Map";
                //        //}

            } else {
                document.getElementById("LocationMap").style.display = "none";
            }


            $find("SelectLocationPopup3").show();
        }


    </script>

     <style type="text/css">

        .ui-widget { font-size: 12px; z-index: 10000000 !important;}

        .ui-widget-overlay{background-color:Gray;filter:alpha(opacity=50);opacity:0.5;}

         .ui-widget-header { font-size: 12pt; }

        .ui-accordion-header
        {
            line-height:16pt;

            background-color:#99bbe8;
            background-image:none;
            color:white;

        }

        .ui-accordion .ui-accordion-content {
	        padding: 1em 2.2em;
	        border-top: 0;
	        overflow: auto;
            background-color:#f1f1f1;
            background-image:none;
            
        }

        .GridRow
        {
            padding:5px;
        }

        .GridRowStyle td{

            padding:5px;
        }

        .GridHeaderStyle th{

            padding:5px;
        }

        .RepeatItemStyle0
{
    background-color:#99bbe8;
}

.RepeatItemStyle1
{
    background-color:#fff;
}

.ClientNotesTable td
{
    border: 1pt solid #dbd8d8;
}

.ClientNotesTableInner td
{
    border: none;
}

    </style>

    <script type="text/javascript">

        function ChangeAccordianIndex(Index) {
            if (Index == -1) {
                $("#ClientsAccordian").accordion({
                    header: "h3",
                    autoFill: true,
                    autoHeight: false,
                    heightStyle: "content",
                    active: 'none'
                });
            }
            else {
                $("#ClientsAccordian").accordion({
                    header: "h3",
                    autoFill: true,
                    autoHeight: false,
                    heightStyle: "content",
                    active: Index
                });
            }
        }

        function OnLoadScripts() {
            $(document).ready(function () {

                $("#ClientsAccordian").accordion({

                    activate: function (event, ui) {
                        var activeIndex = $("#ClientsAccordian").accordion("option", "active");
                        document.getElementById('<%= hidLastAccordianIndex.ClientID%>').value = activeIndex;
                        //alert(activeIndex);
                    }
                });

            });

        }

        function RemoveClientConfirm() {

            var answer = confirm("Are you sure you would like to remove this Client?");
            if (answer) {
                return true;
            }
            else {
                return false;
            }

        }

        function convertToXLS() {
            var rawHTML = '<table>' + $('#tblTest').html() + '</table>';

            Export(rawHTML, 'myExcelFile', 'xls');
        }

        function Export(htmltable, filename, extension) {
            var JsonHndlrx = "Downloader.ashx";

            htmltable = htmltable.replace(/</g, '⌐').replace(/>/g, '¬');

            $("body").append('<form id="exportform" action="' + JsonHndlrx + '?fileName=' + filename + '&extension=' + extension + '" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
            $("#exportdata").val(htmltable);
            $("#exportform").submit().remove();
            return true;
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div data-maincon="1">
        <div data-mainpad="0">
            <div style="display: none;">
<%--        <div class="panel-heading" style="font-size:xx-large">Questionnaire Report</div>--%>
                    <table align="left">
            <tr>
                <td  colspan="3">
                    <h3>Show Arrival locations from <b style="display: inline-block; width: 80px;"></b>  <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                    <ajaxToolkit:CalendarExtender ID="FromDateCalendar" runat="server" TargetControlID="txtFromDate" Format="dd/MM/yyyy"></ajaxToolkit:CalendarExtender>
&nbsp;&nbsp;&nbsp;&nbsp;
To              
                    <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                    <ajaxToolkit:CalendarExtender ID="ToDateCalendar" runat="server" TargetControlID="txtToDate" Format="dd/MM/yyyy"></ajaxToolkit:CalendarExtender>
                </h3>
                </td>
            </tr>
                        <tr>
                            <td width="180px">&nbsp;<h3>Select Staff Member</h3></td>
                           <%-- Width="250px" Height="27px" --%> 
                            <td colspan="2" width="250px"><a style="display: inline-block; width: 27px;"></a><asp:DropDownList ID="DropUsers" runat="server" AppendDataBoundItems="true">
                        <asp:ListItem Value="">----- ALL -----</asp:ListItem>
                    </asp:DropDownList></td>
                            </tr>
                        <tr>
                            <td  colspan="3">
                                <br />
                                <asp:CheckBox ID="chkToday" runat="server" Text="only Display Todays Questionnaires" Font-Bold="true" />
                                <br />
                            </td>
                        </tr>
                        <tr>
                <td align="center">
                    <div style="height:30px;"></div>
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btnsuccess " ForeColor="Black" />
                    <br />
                    <asp:Label ID="lblErrorOutput" runat="server" ForeColor="#CC3300" Font-Bold="True"></asp:Label><br />
                    <asp:UpdateProgress runat="server" ID="UpdateProgress1">
                        <ProgressTemplate>
                            <img src="images/loadingAnimation.gif" />
                        </ProgressTemplate>
                    </asp:UpdateProgress>
                </td>
               </tr>
        </table>
            <br /><br /><br />            <br /><br /><br />            <br /><br />
                        <br /><br /><br />            <br /><br /><br />            
                        <br /><br /><br />            <br /><br /><br />            
                        <br /><br /><br />            <br /><br /><br />            
                        <br /><br /><br />            <br /><br /><br />            
                        <br /><br /><br />            <br /><br /><br />            
             <asp:HiddenField ID="hidLastAccordianIndex" runat="server" />
  <div id="ClientsAccordian" style="margin: 0px auto;">
                        <br />

<div id="dvText" runat="server">
             <asp:Repeater ID="ClientsRepeater" runat="server">
                 <ItemTemplate>
                     <h3>
                     <table style="width:100%">
                         <tr>
                             <td style="width:40%">
                                 <asp:HiddenField ID="UserID" runat="server" Value='<%# Bind("UserID")%>' />
                                 <asp:HiddenField ID="ClientID" runat="server" Value='<%# Bind("ClientID")%>' />
                                 <asp:HiddenField ID="JobID" runat="server" Value='<%# Bind("JobID")%>' />
                                 <asp:HiddenField ID="AddedDate" runat="server" Value='<%# Bind("AddedDate")%>' />
                                 <asp:HiddenField ID="HidClientName" runat="server" Value="" />
                                 <asp:HiddenField ID="HasAnswers" runat="server" Value='<%# Bind("HasAnswers")%>' />
                                   Company Name :  <asp:Label ID="lblClientName" runat="server" Text='<%# Bind("CompanyName")%>'></asp:Label>
                             </td>
                             <td></td>
                             <td style="width:30%">
                                 Staff Member  :  <asp:Label ID="lblUsername" runat="server" Text='<%# Bind("Fullname")%>'></asp:Label>
                             </td>
                             <td></td>
                             <td style="width:30%">
                                 Date  :  <asp:Label ID="lblDate" runat="server" Text='<%# Bind("AddedDate")%>'></asp:Label>
                             </td>
                         </tr>
                     </table>
                     </h3>
                      <div>
                          <asp:Repeater ID="QuestionsRepeater" runat="server">
                              <ItemTemplate>
                                    <ul style="font-size:medium">
                                        <li><strong><asp:Label ID="Question" runat="server" Text='<%# Bind("Question")%>'></asp:Label></strong> 
                                            <ul><li style="color:red;">
                                                <asp:Label ID="Answer" runat="server" Text='<%# Bind("Answer")%>'></asp:Label>&nbsp;<asp:Label ID="AnswerText" runat="server" Text='<%# Bind("AnswerText")%>'></asp:Label>
                                                </li></ul>
                                        </li>
                                    </ul>
                              </ItemTemplate>
                          </asp:Repeater>
                          <br />
                          <table width="60%" style="border:1px solid black;" align="center">
                              <tr>
                                  <th align="left">Arrival Time</th>
                                  <th align="left">Depart Time</th>
                                  <th align="left">Duration</th>
                                  <th align="left">Map</th>
                              </tr>
                              <tr>
                                  <td>
                                      <asp:HiddenField ID="Latitude" runat="server" />  
                                       <asp:HiddenField ID="Longitude" runat="server" />  
                                      <asp:Label ID="ArrivalTime" runat="server" Text=""></asp:Label></td>
                                  <td><asp:Label ID="DepartTime" runat="server" Text=""></asp:Label></td>
                                  <td><asp:Label ID="Duration" runat="server" Text=""></asp:Label></td>
                                  <td> <asp:LinkButton ID="LinkShowMap" runat="server">Show Map</asp:LinkButton></td>
                              </tr>
                          </table>
                    </div>
                 </ItemTemplate>
            </asp:Repeater>
        </div>


      </div>
            <br />

            </div>


            <%-- sphe --%>
            <style>
                [data-mainpad="0"] {
                    background: linear-gradient(to top, #b8d6d8, #98d2d4);
                    background-image: url("TimeTagStyleV2/TimeTagBackImage.png");
                    background-position: center;
                    background-repeat: no-repeat; /* Do not repeat the image */
                    background-size: cover;
                    height: 100%;
                    padding: 60px 0;
                }

                .JobLayout {
                    max-width: 1200px;
                    margin: auto;
                    /*background: linear-gradient(to top, #B8D6D8, #98d2d4);*/
                }
            </style>
            <style>
                .JobBoard {
                    max-width: 1200px;
                    background: rgba(255, 255, 255, 0.9);
                    backdrop-filter: blur(4px);
                    margin: auto;
                    min-height: 80vh;
                    justify-content: space-between;
                    text-align: center;
                    border-radius: 30px;
                    padding-bottom: 30px;
                }

                .Job:first-child {
                    border-top: none;
                }

                .Job {
                    border-top-left-radius: 20px;
                    border-top-right-radius: 20px;
                    border-top: solid #acacac 1px;
                    padding: 10px 30px;
                }

                .jobline {
                    cursor: pointer;
                    border: 1px solid #acacac;
                    border-top-left-radius: 20px;
                    border-top-right-radius: 20px;
                    border-bottom: none;
                    margin-top: 40px;
                }

                .JobBoard table {
                    border-collapse: collapse;
                    width: 100%;
                }

                    .JobBoard table tr th {
                        padding: 20px 0;
                    }


                .JobBoard section {
                    width: 100%;
                }

                .Job i {
                    display: block;
                    margin: 10px 0;
                    color: #242424;
                }

                .JobBoard h2 {
                    font-size: 16px;
                    margin: 20px 0;
                    color: #242424;
                }
                .AddNewClient{
                    text-decoration: none;
                     margin-left: 60px;
                    background-color: #737373;
                    box-shadow: rgba(0, 0, 0, 0.5) 2px 2px 5px;
                    color: #fff;
                    height: 40px;
                    line-height: 40px;
                    width: 250px;
                    border-radius: 4px;
                    border: none;
                    font-weight: normal;
                    cursor: pointer;
                }
            </style>
            <style>
                .JobCardHeader {
                }

                .JobBoard input[type="submit"], .JobBoard input[type="file"] {
                    height: 40px;
                    width: 300px;
                    border-radius: 4px;
                    box-shadow: rgba(0, 0, 0, 0.5) 2px 2px 5px;
                    border: none;
                    font-weight: bold;
                    cursor: pointer;
                }

                .ViewQuestionnaire input[type=submit] {
                    background-color: #98d2d4 !important;
                    color: #000 !important;
                }

                .CreateNewJobBTN {
                    margin-left: 20px;
                    background-color: #737373;
                    background-color: #737373;
                    box-shadow: rgba(0, 0, 0, 0.5) 2px 2px 5px;
                    color: #fff;
                    height: 40px;
                    line-height: 40px;
                    width: 300px;
                    border-radius: 4px;
                    border: none;
                    font-weight: bold;
                    cursor: pointer;
                }

                .SendExcelBTN input[type="submit"] {
                    background-color: #98d2d4;
                    box-shadow: rgba(0, 0, 0, 0.5) 2px 2px 5px;
                }

                .CreateQuestionnaire input[type="submit"] {
                    background-color: #737373;
                    box-shadow: rgba(0, 0, 0, 0.5) 2px 2px 5px;
                    color: #fff;
                }

                .JobBoard select {
                    margin: 0;
                    width: 300px;
                }

                .Pending {
                    background-color: #ebeef5;
                }

                .Active {
                    background-color: #e9f3f5;
                }

                .Completed {
                    background-color: #c1ddd1;
                }
            </style>

            <style>
                .popup {
                    display: none;
                    position: fixed;
                    z-index: 1000;
                    left: 0;
                    top: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0,0,0,0.5);
                    border-radius: 30px;
                }

                #JobStatus {
                    padding: 20px 0;
                    border-bottom: 1px solid #d5d5d5;
                }

                .PopupContent {
                    background: #e9f3f5;
                    /*padding: 20px;*/
                    width: 700px;
                    margin: 10px auto;
                    border-radius: 8px;
                    position: relative;
                    padding-bottom: 30px;
                }
            </style>
            <style>
                        .PopupRow {
                            display: flex;
                            justify-content: space-around;
                        }

                            .PopupRow div {
                                margin: 10px;
                            }

                            .PopupRow label {
                                display: block;
                                margin-bottom: 10px;
                                text-align: start;
                            }

                            .PopupRow input[type="time"] {
                                height: 40px;
                                width: 300px;
                                border-radius: 4px;
                                border: none;
                                font-weight: bold;
                                cursor: pointer;
                            }

                            .PopupRow input[type=text] {
                                margin: 0;
                                font-family: 'arimo';
                                font-size: 14px;
                                width: 300px;
                                border: none;
                                padding: 0 12px;
                                border-radius: 6px;
                                /* font-weight: bold; */
                                height: 40px;
                            }

                        #BackBtn {
                            display: block;
                            width: 300px;
                            margin-top: 30px;
                            height: 40px;
                            line-height: 40px;
                            font-weight: normal;
                            cursor: pointer;
                            border: 1px solid #000;
                            border-radius: 6px;
                        }
                        #AddClientbtn, #UpdateClientbtn{
                            margin-top:38px;
                            
                        }
                        .BackBtn {
                            display: block;
                            width: 300px;
                            height: 40px;
                            line-height: 40px;
                            font-weight: normal;
                            cursor: pointer;
                            border: 1px solid #000;
                            border-radius: 6px;
                        }

                        .PopupRow input[type=submit] {
                            background-color: #545454;
                            color: #fff;
                            height: 40px;
                            font-family: 'arimo';
                            width: 300px;
                            border-radius: 4px;
                            border: none;
                            font-weight: normal;
                            cursor: pointer;
                        }
                    </style>
            <style>
                .table-sales {
                    width: 90%;
                    border-collapse: collapse;
                    background: #e0efef;
                    border: 1px solid #dcdcdc;
                }

                .table-sales th {
                    padding: 12px;
                    background: #a9c7c7;
                    border: 1px solid #dcdcdc;
                    font-weight: bold;
                }

                .table-sales td {
                    padding: 12px;
                    background: white;
                    border: 1px solid #dcdcdc;
                }

                .actions i {
                    font-size: 18px;
                    cursor: pointer;
                }

                .action-btn {
                    text-decoration: none;
                    color: black;
                }

            </style>
             <div class="JobLayout">
                <div class="JobBoard">
                    <div id="editPopup" class="popup">
                        <div class="PopupContent">

                            <h3 id="JobStatus">  Add new Questionnaire </h3>
      

                                <div class="PopupRow">
                                    <div>
                                        <label>Questionnaire Name</label>
                                        <asp:TextBox ID="QuestionnaireName" runat="server"  MaxLength="100" BackColor="Pink"></asp:TextBox>
                                    </div>
                                    <div>
                                        <label id="UpdateDepartmentDiplay">Select Department</label>
                                        <asp:DropDownList ID="SelectDeparment" runat="server"></asp:DropDownList>
                                    </div>

                                </div>
                                <div class="PopupRow">
                                    <div>
                                        <label id="Client Address">Question 1</label>
                                        <asp:TextBox ID="Question1" runat="server" />
                                    </div>
                                    <div>
                                        <label id="">Question 2</label>
                                        <asp:TextBox ID="Question2" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="PopupRow">
                                    <div>
                                        <label id="">Question 3</label>
                                        <asp:TextBox ID="Question3" runat="server"></asp:TextBox>                    
                                    </div>
                                    <div>
                                        <label id="aaa">Question 4</label>
                                        <asp:TextBox ID="Question4" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="PopupRow">
                                    <div>
                                        <label id="">Question 5</label>
                                        <asp:TextBox ID="Question5" runat="server"></asp:TextBox>                    
                                    </div>
                                    <div>
                                        <label id="a">is Questionnaire Mandatory</label>
                                        <asp:TextBox ID="QuestinnaireM" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="PopupRow">
                                    <div>
                                        <div><b id="BackBtn" onclick="Backbtn()" style="display: block;">Back</b></div>
                                    </div>
                                    <div id="AddClientbtn">
                                            <asp:Button ID="Button1" runat="server" Text="Add Questionnaire" />
                                    </div>
                                </div>
                        </div>
                    </div>
                    <table>
                        <tr>
                            <th class="CreateQuestionnaire">
                                <div id="AddNewClient"  class="AddNewClient" onclick="openPopup()"> Create Questionnaire</div>
                                
                            </th>
                            <th>
                                 <asp:DropDownList ID="SelectDepartment" runat="server"></asp:DropDownList>
                                <%--<asp:DropDownList ID="SelectDepartment" runat="server"> 🔍</asp:DropDownList>--%>
                            </th>
                            <th class="SendExcelBTN">
                                <asp:Button ID="Button5" runat="server" Text="Send Excel" />
                            </th>
                        </tr>
                    </table>
                    <style>
                        .actions{
                            width: 130px;
                        }
                        .actions img{
                            display: inline-block;
                            cursor: pointer;
                            width: 28px;
                        }
                        .MainQuestionnaire{
                            padding:20px 58px;
                        }
                    </style>
                    <div class="MainQuestionnaire">
                        <asp:Repeater ID="rptQuestionnaire" runat="server">
                            <HeaderTemplate>
                                <table class="table-sales">
                                    <thead>
                                        <tr>
                                            <th>Name</th>
                                            <th>Department</th>
                                            <th>Active</th>
                                            <th>Questions</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                            </HeaderTemplate>

                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Name") %></td>
                                    <td><%# Eval("Department") %></td>
                                    <td>
                                        <asp:CheckBox runat="server" Checked='<%# Eval("Active") %>' Enabled="false" />
                                    </td>
                                    <td>(<%# Eval("QuestionsCount") %>)</td>
                                    <td class="actions">
                                            <img id="ViewImage2" src="TimeTagStyleV2/mainicons/View2.png" />
                                                        <asp:LinkButton ID="RemoveQuestionnaire" runat="server" Onclick="RemoveQuestionnaire_Click">
                                                            <asp:Label ID="Remove" runat="server" Text="" >
                                                                <img  src="TimeTagStyleV2/mainicons/delete.png" />
                                                            </asp:Label>
                                                        </asp:LinkButton>
 <%--                                           <img src="TimeTagStyleV2/mainicons/delete.png" /> --%>
                                            <img src="TimeTagStyleV2/mainicons/Edit.png" onclick="" />
                                            
                                    </td>
                                </tr>
                            </ItemTemplate>

                            <FooterTemplate>
                                    </tbody>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>


                        <style>
                            #ViewImage2{
                                display: none;
                            }
                        </style>
                    </div>
                </div>
             </div>



            </div>
    </div>

       <br />
    <br />
        <asp:HiddenField ID="SelectLocationPopupTrigger3" runat="server" />
        <ajaxToolkit:ModalPopupExtender runat="server" ID="SelectLocationPopupExtend3"
             TargetControlID="SelectLocationPopupTrigger3" PopupControlID="SelectLocationPopupPanel3"
                PopupDragHandleControlID="SelectLocationPopupHeader3" BehaviorID="SelectLocationPopup3" 
             BackgroundCssClass="modalBackground" RepositionMode="None" ></ajaxToolkit:ModalPopupExtender>
        <asp:Panel ID="SelectLocationPopupPanel3" runat="server">
                        <div class="PopUpcontainer" style="width: 700px">
                            <div class="PopUpheader" id="SelectLocationPopupHeader3" style="cursor: move;">
                                <asp:Label ID="SelectLocationPopupTitle3" runat="server" CssClass="PopUpmsg" Text="CLIENT DETAILS" />
                                <asp:LinkButton ID="lnkSelectLocationPopupClose3" runat="server" CssClass="PopUpclose" OnClientClick="oGMap_Dispose();" />
                            </div>
                            <div class="PopUpbody">
                                 <asp:Panel ID="Panel5" runat="server">
                                    <div id="Div3" style="display:block;" >
                                         <h2>
                                             <asp:Label ID="CleintN" runat="server" Text=""></asp:Label>
                                         </h2>
                                    </div>
                                </asp:Panel>
                                 <asp:Panel ID="Panel4" runat="server" Height="400px">
                                    <div id="LocationMap" style="display:block; height: 405px;"></div>
                                </asp:Panel>
                            </div>
                            <div class="PopUpfooter" align="center">
                              
                            </div>
                        </div>
        </asp:Panel>
    <br />


    <script async="async" type="text/javascript">        
        function pageLoad() {
            OnLoadScripts();
        }

        function OnLoadScripts() {
            document.getElementById("SET_mainpagename").innerHTML = "Questionnaire Report";
        }

        function openPopup() {

            document.getElementById("editPopup").style.display = "block";


        }
        function Backbtn() {
            document.getElementById("editPopup").style.display = "none";

        }
    </script>

</asp:Content>
