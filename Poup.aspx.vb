Public Class Poup
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub attachmentsBtn_Click(sender As Object, e As EventArgs)
        attachmentsPopup.Style("display") = "block"
    End Sub

    Protected Sub btnClose_Click(sender As Object, e As EventArgs)
        attachmentsPopup.Style("display") = "none"
    End Sub


End Class