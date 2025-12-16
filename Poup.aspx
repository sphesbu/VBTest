<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Poup.aspx.vb" Inherits="TutoralVB.Poup" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />

        <style>
            .attachmentsPoup { 
                display:none;
                position:fixed; 
                z-index:1000;
                left:0; 
                top:0;
                width:100%; 
                height:100%; 
                background:rgba(0,0,0,0.5); 
                border-radius:30px; 
            }
            .attachmentsPopupContent { 
                background:#e9f3f5; 
                width:700px; 
                margin:10px auto; 
                border-radius:8px; 
                position:relative; 
            }
        </style>

        <asp:UpdatePanel ID="updAttachments" runat="server">
            <ContentTemplate>

                <asp:Button 
                    ID="attachmentsBtn" 
                    runat="server" 
                    Text="Button"
                    OnClick="attachmentsBtn_Click" />

                <div id="attachmentsPopup" runat="server" class="attachmentsPoup">
                    <div class="attachmentsPopupContent">
                        <h1>Test</h1>

                        <asp:Button 
                            ID="btnClose" 
                            runat="server" 
                            Text="Close"
                            OnClick="btnClose_Click" />
                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>

    </form>
</body>
</html>
