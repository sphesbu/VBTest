<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Home.aspx.vb" Inherits="VbNet.Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>


        <asp:TextBox ID="ClientAddress" runat="server"></asp:TextBox>

        <div style="cursor:pointer;color:blue" onclick="getLatLng()">Get Map</div>

        <div>
            <strong>Latitude:</strong> <span id="lat"></span><br />
            <strong>Longitude:</strong> <span id="lng"></span>
        </div>


        <script>
            function getLatLng() {
                const address = document.getElementById('<%= ClientAddress.ClientID %>').value;

                if (!address.trim()) {
                    alert("Please enter an address");
                    return;
                }

                fetch('GoogleMap.ashx?address=' + encodeURIComponent(address))
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('lat').innerText = data.lat;
                        document.getElementById('lng').innerText = data.lng;
                    })
                    .catch(err => console.error(err));
            }
        </script>






        </div>
    </form>
</body>
</html>
