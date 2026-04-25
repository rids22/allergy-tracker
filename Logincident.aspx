<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogIncident.aspx.cs" Inherits="AllergyTracker.LogIncident" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Log Incident - Allergy Tracker</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; margin: 0; }
        .navbar { background: #2c7be5; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { margin: 0; font-size: 20px; }
        .navbar a { color: white; text-decoration: none; background: rgba(255,255,255,0.2); padding: 8px 16px; border-radius: 5px; margin-left: 8px; font-size: 14px; }
        .container { max-width: 620px; margin: 30px auto; padding: 0 20px; }
        .card { background: white; padding: 35px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        h2 { color: #e67e22; margin-top: 0; }
        .form-group { margin-bottom: 16px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; color: #444; font-size: 14px; }
        input[type=text], select, textarea { width: 100%; padding: 9px 12px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; }
        textarea { height: 90px; resize: vertical; }
        .error { color: red; font-size: 12px; display: block; margin-top: 3px; }
        .checkbox-group { display: flex; align-items: center; gap: 10px; }
        .btn { padding: 12px 28px; border: none; border-radius: 5px; font-size: 15px; cursor: pointer; }
        .btn-submit { background: #e67e22; color: white; }
        .btn-submit:hover { background: #ca6f1e; }
        .btn-back { background: #6c757d; color: white; text-decoration: none; display: inline-block; padding: 12px 20px; border-radius: 5px; font-size: 15px; margin-right: 10px; }
        .alert-success { background: #d4edda; color: #155724; padding: 12px; border-radius: 5px; margin-bottom: 15px; }
        .alert-error   { background: #f8d7da; color: #721c24; padding: 12px; border-radius: 5px; margin-bottom: 15px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1>🩺 Allergy Tracker</h1>
            <div>
                <a href="Dashboard.aspx">Dashboard</a>
                <a href="AllergyList.aspx">My Allergies</a>
                <a href="Logout.aspx">Logout</a>
            </div>
        </div>

        <div class="container">
            <div class="card">
                <h2>⚠️ Log Allergy Incident</h2>

                <asp:Label ID="lblMessage" runat="server" Visible="false" />

                <div class="form-group">
                    <label>Select Allergy *</label>
                    <asp:DropDownList ID="ddlAllergy" runat="server" />
                    <asp:RequiredFieldValidator ControlToValidate="ddlAllergy" runat="server"
                        InitialValue="0"
                        ErrorMessage="Please select an allergy." CssClass="error" Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label>Incident Date *</label>
                    <asp:TextBox ID="txtIncidentDate" runat="server" placeholder="YYYY-MM-DD" />
                    <asp:RequiredFieldValidator ControlToValidate="txtIncidentDate" runat="server"
                        ErrorMessage="Incident date is required." CssClass="error" Display="Dynamic" />
                    <asp:RangeValidator ControlToValidate="txtIncidentDate" runat="server"
                        MinimumValue="2000-01-01" MaximumValue="2100-12-31"
                        Type="Date"
                        ErrorMessage="Enter a valid date." CssClass="error" Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label>Reaction Details *</label>
                    <asp:TextBox ID="txtReaction" runat="server" TextMode="MultiLine"
                        placeholder="Describe the reaction that occurred..." />
                    <asp:RequiredFieldValidator ControlToValidate="txtReaction" runat="server"
                        ErrorMessage="Reaction details are required." CssClass="error" Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label>Treatment Taken</label>
                    <asp:TextBox ID="txtTreatment" runat="server" TextMode="MultiLine"
                        placeholder="What treatment was taken? e.g. EpiPen, antihistamine..." />
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <asp:CheckBox ID="chkHospital" runat="server" />
                        <label style="margin:0;">Was a hospital visit required?</label>
                    </div>
                </div>

                <div style="margin-top:20px;">
                    <a href="Dashboard.aspx" class="btn-back">← Back</a>
                    <asp:Button ID="btnLog" runat="server" Text="⚠️ Log Incident" CssClass="btn btn-submit" OnClick="btnLog_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
