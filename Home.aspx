<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Main.Master" CodeBehind="ClientSearch.aspx.vb" Inherits="TimeAndAttendance.ClientSearch" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <link href="Scripts/overlaypopup.css" rel="stylesheet" />
      <%--<link href="GridViewCSSThemes/YahooGridView.css" rel="stylesheet" type="text/css" />--%>
    <link href="YUIAjaxModelPopupCSS.css" rel="stylesheet" type="text/css" />
    <%--<script type="text/javascript"  src="jquery-1.9.0.js"></script>--%>
    <script src="https://maps.googleapis.com/maps/api/js?libraries=places&key=AIzaSyBEgtfVpo-cjU6HwnCn_SC5yc2y107aqs0"></script>
    <style type="text/css">
        .PopUpbody {
         padding-left : 0px !important;
        }
        .modal1 {
            position: fixed;
            z-index: 99999999;
            height: 100%;
            width: 100%;
            top: 0;
            right: 0;
            background-color: Black;
            filter: alpha(opacity=60);
            opacity: 0.6;
        }
        
        .center {
            z-index: 1000;
            margin: 300px auto;
            padding: 10px;
            width: 130px;
            background-color: White;
            border-radius: 10px;
            filter: alpha(opacity=100);
            opacity: 1;
        }
    </style>
    <style type="text/css">
        .watermark {
         color : Gray;
        }
             
        fieldset {
    margin: 1em 0px;
    padding: 1em;
    border: 1px solid #ccc;
}

            fieldset p {
    margin: 2px 12px 10px 10px;
}

            fieldset.login label, fieldset.register label, fieldset.changePassword label {
    display: block;
}

            fieldset label.inline {
    display: inline;
}

        legend {
    font-size: 1.1em;
    font-weight: 600;
    padding: 2px 4px 8px 4px;
}

        input.textEntry {
    width: 320px;
    border: 1px solid #ccc;
}

        input.passwordEntry {
    width: 320px;
    border: 1px solid #ccc;
}

        div.accountInfo {
    width: 42%;
}
        #AddClient {
            width: 493px;
        }
    </style>
        <script type="text/javascript" >
            function ClearSearchFields(ThisBox) {
                divs = $('.SearchField')
                var x = 0;
                var check = 0;
                for (i = 0; i < divs.length; i++) { // Loop through the stored textboxes and output the value

                    if (divs[i].id != ThisBox) {
                        divs[i].value = "";
                    }
                    //alert(divs[i].id + "|" + ThisBox);

                }
            }

            function ClientMap(button) {
                // alert("Just a Test");
                var row = button.parentNode.parentNode;

                var Long = "";
                var Lat = "";
                var Cn = "";
                var CID = "";

                var Longitude = GetChildControl(row, "Longitude");
                var Latitude = GetChildControl(row, "Latitude");
                var ClientName = GetChildControl(row, "HidClientName");
                var CID = GetChildControl(row, "ClientID");


                document.getElementById("<%=CleintN.ClientID%>").innerHTML = ClientName.value
                document.getElementById("<%=ClientID.ClientID%>").value = CID.value

                Long = Longitude.value;
                Lat = Latitude.value;
                Cn = ClientName.value


                var markers = [
                    {

                        "title": '' + Cn + '',
                        "lat": '' + Lat + '',
                        "lng": '' + Long + '',
                        "description": '' + Cn + ''
                    }
                ];

                if (markers[0] != null) {

                    var map_canvas = document.getElementById('LocationMap');
                    var map_options = {
                        center: new google.maps.LatLng(markers[0].lat, markers[0].lng),
                        zoom: 15,
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                    };
                    var map = new google.maps.Map(map_canvas, map_options);
                    var marker = new google.maps.Marker({
                        position: new google.maps.LatLng(markers[0].lat, markers[0].lng),
                        map: map,
                        draggable: true
                    });

                    var features = [{
                        position: new google.maps.LatLng(markers[0].lat, markers[0].lng),
                        type: 'info'
                    }];

                    google.maps.event.addListener(marker, 'dragend', function (event) {
                        document.getElementById('<%= lblLatitude.ClientID%>').innerHTML = "LATITUDE  :" + event.latLng.lat();
                        document.getElementById('<%= lblLongitude.ClientID%>').innerHTML = "LONGITUDE    :" + event.latLng.lng();
                        document.getElementById('<%= Latitude.ClientID%>').value = event.latLng.lat();
                        document.getElementById('<%= Longitude.ClientID%>').value = event.latLng.lng();
                    });

                } else {
                    document.getElementById("LocationMap").style.display = "none";
                }


                $find("SelectLocationPopup3").show();
            }

            function GetChildControl(element, id) {
                var child_elements = element.getElementsByTagName("*");
                for (var i = 0; i < child_elements.length; i++) {
                    if (child_elements[i].id.indexOf(id) != -1) {
                        return child_elements[i];
                    }
                }
            };

            function oGMap_Dispose() {
                var divDealerMap = document.getElementById("LocationMap");
                if (divDealerMap) divDealerMap.parentNode.removeChild(divDealerMap);
            }

            function fnExcelReport(id, name) {
                var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';
                tab_text = tab_text + '<head><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>';
                tab_text = tab_text + '<x:Name>Test Sheet</x:Name>';
                tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
                tab_text = tab_text + '</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body style=color:black;text-decoration:none;>';
                tab_text = tab_text + "<table border='1px'>";
                var exportTable = $('#' + id).clone();
                exportTable.find('input').each(function (index, elem) { $(elem).remove(); });
                tab_text = tab_text + exportTable.html();
                tab_text = tab_text + '</table></body></html>';
                var data_type = 'data:application/vnd.ms-excel';
                var ua = window.navigator.userAgent;
                var msie = ua.indexOf("MSIE ");

                var fileName = name + '_' + parseInt(Math.random() * 10000000000) + '.xls';
                if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
                    if (window.navigator.msSaveBlob) {
                        var blob = new Blob([tab_text], {
                            type: "application/csv;charset=utf-8;"
                        });
                        navigator.msSaveBlob(blob, fileName);
                    }
                } else {
                    $('#exportExcel').attr('href', data_type + ', ' + encodeURIComponent(tab_text));
                    $('#exportExcel').attr('download', fileName);
                }
            }

        </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <asp:ImageButton ID="btnRefresh" runat="server" ImageUrl="~/images/view-refresh_48.png" Visible="false" />

    <div data-maincon="0">
        <div data-mainpad="0">
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
                .lookupsection a{
                    display: block;
                    margin-top: 28px;
                    width: 300px;
                    line-height: 40px;
                    height: 40px;
                    background-color: #98d2d4;
                    box-shadow: rgba(0, 0, 0, 0.5) 2px 2px 5px;
                    color: #000;
                    text-decoration: none;
                    border-radius: 6px;
                    cursor: pointer;
                }
            </style>
            <div class="JobLayout">
                <div class="JobBoard">
                <div id="editPopup" class="popup">
                    <div class="PopupContent">

                        <h3 id="JobStatus"> Add New Client</h3>
                       
                            <div class="PopupRow">
                                <div>
                                    <label>Client Name</label>
                                    <asp:TextBox ID="ClientName" runat="server"  MaxLength="100" BackColor="Pink"></asp:TextBox>
                                </div>
                                <div>
                                    <label id="UpdateDepartmentDiplay">Contact Person</label>
                                    <asp:TextBox ID="ContactPerson" runat="server"></asp:TextBox>
                                </div>

                            </div>
                            <div class="PopupRow">
                                <div>
                                    <label id="Client Address">Clinet Address</label>
                                    <asp:TextBox ID="ClientAddress" runat="server" />
                                </div>
                                <div>
                                    <label id="UpdateStaffDisplay">Contact Number</label>
                                    <asp:TextBox ID="ContactNumber" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="PopupRow">
                                <div class="lookupsection">
                                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:LinkButton 
                                                Text="Lookup Address" 
                                                ID="Lookup" 
                                                runat="server" 
                                                OnClick="Lookup_Click" />
                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="Lookup" EventName="Click" />
                                        </Triggers>
                                    </asp:UpdatePanel>
                                </div>
                                <div>
                                    <label id="aaa">Contact Email</label>
                                    <asp:TextBox ID="ContactEmail" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="PopupRow">
                                <div>
                                    <div><b id="BackBtn" onclick="Backbtn()" style="display: block;">Back</b></div>
                                </div>
                                <div id="AddClientbtn">
                                    
                                    <asp:Button ID="AddClient" runat="server" Text="Add Client"  />
                                </div>
                                <div id="UpdateClientbtn">
                                    
                                    <asp:Button ID="UpdateClient" runat="server" Text="Update Client"  />
                                </div>
                            </div>
                    </div>
                </div>
                    <table>
                        <tr>
                            <th class="CreateQuestionnaire">
                                <i style="display: none;">
                                <asp:LinkButton ID="LinkButton3" runat="server" Text="Add New Client"  ></asp:LinkButton>
                                </i>
                                <div id="AddNewClient"  class="AddNewClient" onclick="openPopup('AddNewClient')"> Add New Client</div>


                                <div style="display: none;">
                                    <asp:LinkButton ID="lnkImportClients" OnClick="lnkImportClients_Click" runat="server" CssClass="nexrBtn">Import Clients</asp:LinkButton>
                                </div>
                                <div style="display: none;" class="CreateNewJobBTN" onclick="CreateNewJob()">Create New Job</div>
                            </th>
                            <th>
                                 <input type="text" id="txtSearch" placeholder=" Search By Client Name..." style="margin-left: 0px;" />
                                <%--<asp:DropDownList ID="SelectDepartment" runat="server"> 🔍</asp:DropDownList>--%>
                            </th>
                            <th class="SendExcelBTN">
                                <asp:Button ID="Button5" runat="server" Text="Send Excel" />
                            </th>
                        </tr>
                    </table>

                    <style>
                        .ClientDeshboardBox {
                            width: 100%;
                            padding: 0 60px;
                        }

                         .ClientDeshboardBox table {
                             border-collapse: collapse !important;
                             border-right: none !important;
                         }

                        .ClientDeshboardBox table tr td {
                             border: 1px solid #d5d5d5;
                             height: 40px;
                        }

                        .ClientDeshboardBox table tr th {
                            border: 1px solid #d5d5d5;
                        }
                    </style>
                    <div class="ClientDeshboardBox">
     <asp:panel ID="Panel1" runat="server" DefaultButton="LinkButton1">
                            <table align="center" style="display: none;">
    <tr> 
        <td>
        <fieldset class="login" style="width:620px;align-content:center">
            <table class="searchTlb">
                <tr>
                    <td>
                <asp:Label ID="lblFirstNameHead" runat="server" Text="First Name :" AssociatedControlID="txtFirstNameSearch"></asp:Label>
                    </td>
                    <td>
                <asp:TextBox ID="txtFirstNameSearch" runat="server" CssClass="textEntry SearchField"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                <asp:Label ID="lblLastNameHead" runat="server" Text="Last Name :" AssociatedControlID="txtLastNameSearch"></asp:Label>
                    </td>
                    <td>
                <asp:TextBox ID="txtLastNameSearch" runat="server" CssClass="textEntry SearchField"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                <asp:Label ID="lblCompanyNameHead" runat="server" Text="Company Name :" AssociatedControlID="txtCompanyNameSearch"></asp:Label>
                    </td>
                    <td>
                <asp:TextBox ID="txtCompanyNameSearch" runat="server" CssClass="textEntry SearchField"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                <asp:Label ID="lblCompanyCode" runat="server" Text="Company Number / Code :" AssociatedControlID="txtCompanyCodeSearch"></asp:Label>
                    </td>
                    <td>
                <asp:TextBox ID="txtCompanyCodeSearch" runat="server" CssClass="textEntry SearchField"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                <asp:Label ID="lblContactNumberHead" runat="server" Text="Contact Number :" AssociatedControlID="txtContactNumberSearch"></asp:Label>
                    </td>
                    <td>
                <asp:TextBox ID="txtContactNumberSearch" runat="server" CssClass="textEntry SearchField"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                <asp:Label ID="Label1" runat="server" Text="Region :" AssociatedControlID="txtContactNumberSearch"></asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList ID="Region" runat="server"  DataTextField="Region" DataValueField="RegionID" AppendDataBoundItems="True" CssClass="Maindropdown" AutoPostBack="true">
                    <asp:ListItem Text="------------" Value="" />
                </asp:DropDownList>
                    </td>
                </tr>
            </table>

            <p>

            </p>
            <p>
               <%--Active : <asp:CheckBox ID="chkActiveSearch" runat="server" />--%>
            </p>
            <p style="margin: 40px auto; text-align: center;">
                <asp:LinkButton ID="LinkButton1" runat="server" CssClass="nexrBtn">Search</asp:LinkButton>
            </p>
        </fieldset>
        </td>
    </tr>
    </table>
                            <p align="center">
                            </p>
                            <p align="center">
                                <asp:LinkButton ID="TopCombine" runat="server" Visible="false">Combine</asp:LinkButton>&nbsp;&nbsp;<asp:LinkButton ID="Topuncombine" runat="server" Visible="false">Uncombine</asp:LinkButton>
                            </p>
       <!--  <a href="#" id="exportExcel" onclick="javascript:fnExcelReport('myTable', 'myExcel');">Export to Excel</a> -->


                                        <asp:GridView ID="ClientDetails" runat="server" ClientIDMode="Static" AutoGenerateColumns="False" align="Center" EmptyDataText="No Results Found">
                    <Columns>
                                                <asp:TemplateField HeaderText="&nbsp; Client Name">
                            <ItemTemplate>
                                                        <div style="display:none;">
                                   <asp:HiddenField ID="Latitude" runat="server" Value='<%# Bind("Latitude")%>' />
                                   <asp:HiddenField ID="Longitude" runat="server" Value='<%# Bind("Longitude")%>' />
                                <asp:HiddenField ID="HidClientName" runat="server" Value='<%# Bind("CompanyName")%>' />
                                <asp:HiddenField ID="AssignTo_TeamID" runat="server" Value='<%# Bind("UserID")%>' />
                                                        &nbsp;<asp:HiddenField ID="ClientID" runat="server" Value='<%# Bind("ClientID")%>'></asp:HiddenField>
                                                        <asp:LinkButton ID="LinkClient1" runat="server" OnClick="LinkClient_Click">
                                                            
                                                        </asp:LinkButton>&nbsp;
                                                        </div>
                                                        <asp:Label ID="CompanyName" runat="server" Text='<%# Bind("CompanyName")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                                                <asp:TemplateField HeaderText="&nbsp; Address " HeaderStyle-Width="200px">
                            <ItemTemplate>
                                                        <div style="line-height:24px;">
                                                            <asp:Label ID="Address" runat="server" Text='<%# Bind("ContactAddress")%>'></asp:Label>
                                                        </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                                                <asp:TemplateField HeaderText="&nbsp;Map&nbsp;">
                            <ItemTemplate>
                                                        &nbsp;<asp:LinkButton ID="LinkClient4" runat="server" OnClick="LinkClient_Click">
                                                            <asp:Label ID="Map" runat="server" Text="show Map"></asp:Label>
                                                        </asp:LinkButton>&nbsp;
                            </ItemTemplate>
                        </asp:TemplateField>
                                                <asp:TemplateField HeaderText="&nbsp;Contact Person&nbsp;">
                            <ItemTemplate>
                                                        &nbsp;<asp:LinkButton ID="LinkClient2" runat="server" OnClick="LinkClient_Click">

                                                            <asp:Label ID="FirstName" runat="server" Text='<%# Bind("FirstName")%>'></asp:Label>&nbsp;<asp:Label ID="LastName" runat="server" Text='<%# Bind("LastName")%>'></asp:Label>
                                                        </asp:LinkButton>&nbsp;
                            </ItemTemplate>
                        </asp:TemplateField>
                                                <asp:TemplateField HeaderText="&nbsp;Contact Number &nbsp;">
                            <ItemTemplate>
                                                        &nbsp;<asp:LinkButton ID="LinkClient3" runat="server">
                                                            <asp:Label ID="ContactNum" runat="server" Text='<%# Bind("ContactNum")%>'></asp:Label>
                                                        </asp:LinkButton>&nbsp;
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="&nbsp;Contact Email &nbsp;">
                                                    <ItemTemplate>
                                                        <asp:Label ID="EmailAddress1" runat="server" Text='<%# Bind("ContactNum")%>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="&nbsp;Combine&nbsp;" Visible="false">
                                                    <ItemTemplate>
                                                        &nbsp;
                                            <asp:CheckBox ID="CheckCombine" runat="server" AutoPostBack="true" OnCheckedChanged="CheckCombineClient_CheckedChanged" />&nbsp;
                            <asp:LinkButton ID="Uncombine" runat="server" Visible="false" OnClick="UncombineClient_Click">Uncombine</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                                                <asp:TemplateField HeaderText="&nbsp; Actions ">
                            <ItemTemplate>
                                                        <div class="setColor">
                                                        <asp:LinkButton ID="LinkClient6" runat="server" OnClick="LinkUpdateClient_Click">
                                                            <asp:HiddenField ID="CurrentClientID" runat="server" Value='<%# Bind("ClientID")%>'></asp:HiddenField>
                                                            <asp:Label ID="Update" runat="server" Text="" >
                                                                   <img  src="TimeTagStyleV2/mainicons/Edit.png" /> 
                                                            </asp:Label>
                                                        </asp:LinkButton> 
                                                        <asp:LinkButton ID="LinkClient5" runat="server" OnClick="LinkRemoveClient_Click">
                                                            <asp:Label ID="Remove" runat="server" Text="" >
                                                                <img  src="TimeTagStyleV2/mainicons/delete.png" />
                                                            </asp:Label>
                                                        </asp:LinkButton>
                                                        </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                                        <p id="noResults" style="display:none; color:red; font-weight:bold;">
                                            No results found.
                                        </p>
         <br />
                            <p align="center">
                                <asp:LinkButton ID="CombineClients" runat="server" Visible="false">Combine</asp:LinkButton>
                            </p>
    <br />
  <!--<p align="center"><asp:LinkButton ID="LinkButton2" runat="server" Text="Add New Client" Visible="false" ></asp:LinkButton></p>  -->
</asp:panel>
        </div>

                    <style>
                        .setColor{
                            display: flex;
                            justify-content: space-around;
                        }
                        .setColor img{
                            display: block;
                            width: 28px;
                        }
                    </style>

                    <script>
                        function filterGrid() {
                            var input = document.getElementById("txtSearch").value.toLowerCase();
                            var table = document.getElementById("ClientDetails");
                            if (!table) return; 

                            var rows = table.getElementsByTagName("tr");
                            var matchFound = false;

                            for (var i = 1; i < rows.length; i++) { 
                                var cells = rows[i].getElementsByTagName("td");
                                if (cells.length === 0) continue;

                                var companyText = cells[0].textContent.toLowerCase(); 
                                if (companyText.indexOf(input) > -1) {
                                    rows[i].style.display = "";
                                    matchFound = true;
                                } else {
                                    rows[i].style.display = "none";
                                }
                            }

                            document.getElementById("noResults").style.display = matchFound ? "none" : "";
                        }

                        window.onload = function () {
                            document.getElementById("txtSearch").addEventListener("keyup", filterGrid);
                           
                        };




                    </script>



                </div>
            </div>
            <style>
                .LookUpMap{
                    position: fixed;
                    top: 50%;
                    left: 20px;
                    z-index: 999999;
                    background-color: #000;
                }
            </style>
        <style>
            .LookUpMapPoup { 
                position:fixed; 
                z-index:1000;
                left:0; 
                top:0;
                width:100%; 
                height:100%; 
                background:rgba(0,0,0,0.5); 
                border-radius:30px; 
            }
            .LookUpMapPopupContent { 
                background:#e9f3f5; 
                width:700px; 
                justify-items: center;
                justify-content: center;
                margin:10px auto; 
                border-radius:8px; 
                position:relative; 
            }
        </style>
         <div id="LookUpMapPopup" runat="server" class="LookUpMapPoup">
                    <div class="LookUpMapPopupContent">
                        <h1>Test</h1>
                        <h1>Test</h1>
                     </div>
         </div>


            <script>
                function openPopup(status) {


                    if (status == "Update") {
                        document.getElementById("editPopup").style.display = "block";
                        document.getElementById("AddClientbtn").style.display = "none";
                        document.getElementById("UpdateClientbtn").style.display = "block";

                    }
                    if (status == "AddNewClient") {

                        document.getElementById("editPopup").style.display = "block";
                        document.getElementById("UpdateClientbtn").style.display = "none";
                        document.getElementById("AddClientbtn").style.display = "block";
                        console.log(status)

                    }
                }
                function Backbtn() {
                    document.getElementById("editPopup").style.display = "none";

                }
            </script>
    </div>
    </div>

    <asp:UpdateProgress runat="server" ID="UpdateProgress1">
        <ProgressTemplate>
            <img src="images/loadingAnimation.gif" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <style>
        .Maindropdown {
            margin-left: 30px;
        }
    </style>

        <asp:HiddenField ID="SelectLocationPopupTrigger3" runat="server" />
        <ajaxToolkit:ModalPopupExtender runat="server" ID="SelectLocationPopupExtend3"
             TargetControlID="SelectLocationPopupTrigger3" PopupControlID="SelectLocationPopupPanel3"
                PopupDragHandleControlID="SelectLocationPopupHeader3" BehaviorID="SelectLocationPopup3" 
             BackgroundCssClass="modalBackground" RepositionMode="None" >
        </ajaxToolkit:ModalPopupExtender>
        <asp:Panel ID="SelectLocationPopupPanel3" runat="server">
                        <div class="PopUpcontainer" style="width: 900px;height:850px">
                            <div class="PopUpheader" id="SelectLocationPopupHeader3" style="cursor: move;">
                                <asp:Label ID="SelectLocationPopupTitle3" runat="server" CssClass="PopUpmsg" Text="CLIENT DETAILS" />
                                <asp:LinkButton ID="lnkSelectLocationPopupClose3" runat="server" CssClass="PopUpclose" />
                            </div>
                            <div class="PopUpbody">
                                 <asp:Panel ID="Panel5" runat="server">
                                    <div id="Div3" style="display:block;" >
                                         <h2>
                                             <asp:Label ID="CleintN" runat="server" Text=""></asp:Label>
                                         </h2>
                                        <asp:HiddenField ID="Latitude" runat="server" />
                                        <asp:HiddenField ID="Longitude" runat="server" />
                                        <asp:HiddenField ID="ClientID" runat="server" />
                        <asp:Label ID="lblLatitude" runat="server" Text="" Font-Bold="true"></asp:Label><br />
                        <br />
                        <asp:Label ID="lblLongitude" runat="server" Text="" Font-Bold="true"></asp:Label><br />
                        <br />
                                    </div>
                                </asp:Panel>
                                 <asp:Panel ID="Panel4" runat="server" Height="500px">
                                    <div id="LocationMap" style="display:block; height: 505px;"></div>
                                   <p align="center">
                                        <asp:Label ID="Saved" runat="server" Text=""></asp:Label><br />
                        <asp:Button ID="Button1" runat="server" Text="Save" Width="216px" />
                        &nbsp;&nbsp;
                        <asp:Button ID="Button2" runat="server" Text="Close" Width="216px" />
                               </p>
                                </asp:Panel>
                                <br />
                            </div>
                            <div class="PopUpfooter" align="center">
                              
                            </div>
                        </div>
        </asp:Panel>
    <br />
        <asp:HiddenField ID="HiddenFieldPopUpWarning" runat="server" />
        <ajaxToolkit:ModalPopupExtender runat="server" ID="PopUpWarningModalPopupExtender" TargetControlID="HiddenFieldPopUpWarning" PopupControlID="PopUpWarning"
                PopupDragHandleControlID="PopUpWarningHeader" BackgroundCssClass="modalBackground" RepositionMode="RepositionOnWindowResizeAndScroll" >
        </ajaxToolkit:ModalPopupExtender>
        <asp:Panel ID="PopUpWarning" runat="server" Height="133px" Width="600px">
            <div class="PopUpcontainer">
                <div class="PopUpheader" id="PopUpWarningHeader">
                    <asp:Label ID="Label2" runat="server" CssClass="PopUpmsg" Text="Warning" />
                </div>
                <div class="PopUpbody">
                     <asp:Label ID="lblPopUpWarning" runat="server" Text="Are you sure you want to remove" Font-Size="Larger" ></asp:Label>&nbsp;&nbsp;<asp:Label ID="CompanyName" runat="server" Text="" Font-Bold="true" ForeColor="Red" Font-Size="Larger"></asp:Label>&nbsp;&nbsp;<asp:Label ID="Label3" runat="server" Text="?" Font-Size="Larger"></asp:Label>
                    <br />
                     <asp:HiddenField ID="HideClientID" runat="server" />
                    <br />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                   <table align="center">
                       <tr>
                           <td>
                               <asp:Button ID="Button4" runat="server" Text="Yes" Width="162px" /></td>
                           <td>
                               <asp:Button ID="Button3" runat="server" Text="No" OnClick="PopUpWarningBtn_Click" Width="162px" /></td>
                       </tr>
                   </table>
                </div>
            </div>
        </asp:Panel>
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
        <asp:HiddenField ID="HiddenFieldPopUpWarning1" runat="server" />
        <ajaxToolkit:ModalPopupExtender runat="server" ID="PopUpWarningModalPopupExtender1" TargetControlID="HiddenFieldPopUpWarning1" PopupControlID="PopUpWarning1"
                PopupDragHandleControlID="PopUpWarningHeader1" BackgroundCssClass="modalBackground" RepositionMode="RepositionOnWindowResizeAndScroll" >
        </ajaxToolkit:ModalPopupExtender>
        <asp:Panel ID="PopUpWarning1" runat="server" Height="500px" Width="600px">
            <div class="PopUpcontainer">
                <div class="PopUpheader" id="PopUpWarningHeader11">
                    <asp:Label ID="Label4" runat="server" CssClass="PopUpmsg" Text="Combine Clients" />
                      <asp:LinkButton ID="LinkClosing" runat="server" CssClass="PopUpclose" />
                </div>
                <div class="PopUpbody">
                              <h3 align="center">Combine Clients</h3>
                    <br />
                    <h3 align="center">List of clients to combine</h3>
                    <br />
                    <asp:GridView ID="ClientsGrid" runat="server" AutoGenerateColumns="false" Width="500" HorizontalAlign="Center" >
                        <Columns>
                            <asp:TemplateField HeaderText="ClientName">
                                <ItemTemplate>
                                    <asp:HiddenField ID="ClientID" runat="server" Value='<%# Bind("ClientID")%>' />
                                    <asp:Label ID="ClientName" runat="server" Text='<%# Bind("CompanyName")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <br />
                    <table style="width:500px;" align="center">
                        <tr>
                        <td>
                            <h3>Combined Client Name</h3>
                        </td>
                        <td>&nbsp;<h3>:</h3>
                            &nbsp;</td>
                            <td>
                                <asp:TextBox ID="CombinedName" runat="server" BackColor="Pink" Width="188px" ></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" align="center">
                                <asp:Label ID="lblCombined" runat="server" Text="" ForeColor="Red" Font-Bold="true" ></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" align="center">
                                <asp:Button ID="CombineBTN" runat="server" Text="Save" Width="181px" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </asp:Panel>
    <br />
    <br />
    <asp:HiddenField ID="HiddenFieldPopUpWarning2" runat="server" />
        <ajaxToolkit:ModalPopupExtender runat="server" ID="PopUpWarningModalPopupExtender2" TargetControlID="HiddenFieldPopUpWarning2" PopupControlID="PopUpWarning2"
                PopupDragHandleControlID="PopUpWarningHeader2" BackgroundCssClass="modalBackground" RepositionMode="RepositionOnWindowResizeAndScroll" >
        </ajaxToolkit:ModalPopupExtender>
        <asp:Panel ID="PopUpWarning2" runat="server" Height="500px" Width="600px">
            <div class="PopUpcontainer">
                <div class="PopUpheader" id="PopUpWarningHeader12">
                    <asp:Label ID="Label5" runat="server" CssClass="PopUpmsg" Text="Combine Clients" />
                      <asp:LinkButton ID="LinkClosing2" runat="server" CssClass="PopUpclose" />
                </div>
                <div class="PopUpbody">
                              <h3 align="center">Uncombine Clients</h3>
                    <br />
                    <h3 align="center">List of clients to uncombine</h3>
                    <br />
                    <asp:GridView ID="UncombineClientsGrid" runat="server" AutoGenerateColumns="false" Width="500" HorizontalAlign="Center" >
                        <Columns>
                            <asp:TemplateField HeaderText="ClientName">
                                <ItemTemplate>
                                    <asp:HiddenField ID="ClientID" runat="server" Value='<%# Bind("ClientID")%>' />
                                    <asp:Label ID="ClientName" runat="server" Text='<%# Bind("CompanyName")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <br />
                    <p align="center">
                        <asp:Button ID="UncombinClients" runat="server" Text="Uncombine" />
                    </p>
                </div>
            </div>
        </asp:Panel>


    <div class="overlay-bg">
                <div class="overlay-content" id="RemoveStockPopup1" style="width: 1304px; height: 600px;" align="left">
					<asp:Label ID="Label14" runat="server" CssClass="PopUpmsg" Text="Import TimeTag Client List" />
					<asp:LinkButton ID="LinkButton21" runat="server" CssClass="PopUpclose" OnClick="LinkButton21_Click" />

					<div class="PopUpbody">
						<asp:UpdatePanel ID="UpdatePanelRS1" runat="server" UpdateMode="Conditional">
							<ContentTemplate>
								<asp:UpdateProgress ID="UpdateProgress4" runat="server">
									<ProgressTemplate>
										<div class="modal1">
											<div class="center">
												<img alt="" src="images/loader.gif" />
											</div>
										</div>
									</ProgressTemplate>
								</asp:UpdateProgress>
                                <iframe runat="server" id="FrameImport" name="FrameImport1" width="1300px" frameborder="0" scrolling="yes" height="550px"></iframe>
							</ContentTemplate>
						</asp:UpdatePanel>
					</div>

					<div class="PopUpfooter">
					</div>

				</div>
				</div>




    <script async="async" type="text/javascript">        
        function pageLoad() {
            OnLoadScripts();
        }

        function OnLoadScripts() {
            document.getElementById("SET_mainpagename").innerHTML = "Search Clients";
        }


    </script>

</asp:Content>
