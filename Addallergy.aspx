<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddAllergy.aspx.cs" Inherits="AllergyTracker.AddAllergy" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Allergy - Allergy Tracker</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; margin: 0; }
        .navbar { background: #2c7be5; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { margin: 0; font-size: 20px; }
        .navbar a { color: white; text-decoration: none; background: rgba(255,255,255,0.2); padding: 8px 16px; border-radius: 5px; margin-left: 8px; font-size: 14px; }
        .container { max-width: 700px; margin: 30px auto; padding: 0 20px; }
        .card { background: white; padding: 35px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        h2 { color: #2c7be5; margin-top: 0; }
        .form-group { margin-bottom: 16px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; color: #444; font-size: 14px; }
        input[type=text], select, textarea { width: 100%; padding: 9px 12px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; }
        textarea { height: 90px; resize: vertical; }
        .error { color: red; font-size: 12px; display: block; margin-top: 3px; }
        .row { display: flex; gap: 15px; }
        .row .form-group { flex: 1; }
        .btn-submit { background: #2c7be5; color: white; padding: 12px 30px; border: none; border-radius: 5px; font-size: 15px; cursor: pointer; }
        .btn-submit:hover { background: #1a5fc8; }
        .btn-back { background: #6c757d; color: white; padding: 12px 20px; border: none; border-radius: 5px; font-size: 15px; cursor: pointer; text-decoration: none; margin-right: 10px; }
        .alert-success { background: #d4edda; color: #155724; padding: 12px; border-radius: 5px; margin-bottom: 15px; }
        .alert-error   { background: #f8d7da; color: #721c24; padding: 12px; border-radius: 5px; margin-bottom: 15px; }
        .symptom-box { border: 1px solid #ddd; border-radius: 5px; padding: 15px; margin-top: 5px; }
        .symptom-row { display: flex; gap: 10px; margin-bottom: 8px; align-items: center; }
        .symptom-row input { flex: 1; }
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
                <h2>➕ Add New Allergy</h2>

                <asp:Label ID="lblMessage" runat="server" Visible="false" />

                <div class="row">
                    <div class="form-group">
                        <label>Allergy Name *</label>
                        <asp:TextBox ID="txtAllergyName" runat="server" placeholder="e.g. Peanut Allergy" />
                        <asp:RequiredFieldValidator ControlToValidate="txtAllergyName" runat="server"
                            ErrorMessage="Allergy name is required." CssClass="error" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Category *</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" />
                        <asp:RequiredFieldValidator ControlToValidate="ddlCategory" runat="server"
                            InitialValue="0"
                            ErrorMessage="Please select a category." CssClass="error" Display="Dynamic" />
                    </div>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" placeholder="Describe the allergy..." />
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Severity Level *</label>
                        <asp:DropDownList ID="ddlSeverity" runat="server">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Mild">Mild</asp:ListItem>
                            <asp:ListItem Value="Moderate">Moderate</asp:ListItem>
                            <asp:ListItem Value="Severe">Severe</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ControlToValidate="ddlSeverity" runat="server"
                            InitialValue=""
                            ErrorMessage="Please select severity level." CssClass="error" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Diagnosed Date</label>
                        <asp:TextBox ID="txtDiagnosedDate" runat="server" placeholder="YYYY-MM-DD" />
                        <asp:RangeValidator ControlToValidate="txtDiagnosedDate" runat="server"
                            MinimumValue="1900-01-01" MaximumValue="2100-12-31"
                            Type="Date"
                            ErrorMessage="Enter a valid diagnosed date." CssClass="error" Display="Dynamic" />
                    </div>
                </div>

                <div class="form-group">
                    <label>Doctor / Specialist Name</label>
                    <asp:TextBox ID="txtDoctorName" runat="server" placeholder="e.g. Dr. Smith" />
                </div>

                <!-- Symptoms Section -->
                <div class="form-group">
                    <label>Symptoms (enter up to 3)</label>
                    <div class="symptom-box">
                        <div class="symptom-row">
                            <asp:TextBox ID="txtSymptom1" runat="server" placeholder="Symptom 1" />
                        </div>
                        <div class="symptom-row">
                            <asp:TextBox ID="txtSymptom2" runat="server" placeholder="Symptom 2" />
                        </div>
                        <div class="symptom-row">
                            <asp:TextBox ID="txtSymptom3" runat="server" placeholder="Symptom 3" />
                        </div>
                    </div>
                </div>

                <!-- Medication Section -->
                <div class="form-group">
                    <label>Medication Name</label>
                    <asp:TextBox ID="txtMedName" runat="server" placeholder="e.g. EpiPen" />
                </div>
                <div class="row">
                    <div class="form-group">
                        <label>Dosage</label>
                        <asp:TextBox ID="txtDosage" runat="server" placeholder="e.g. 0.3mg" />
                    </div>
                    <div class="form-group">
                        <label>Frequency</label>
                        <asp:TextBox ID="txtFrequency" runat="server" placeholder="e.g. As needed" />
                    </div>
                </div>

                <div style="margin-top:20px;">
                    <a href="Dashboard.aspx" class="btn-back">← Back</a>
                    <asp:Button ID="btnSave" runat="server" Text="💾 Save Allergy" CssClass="btn-submit" OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
