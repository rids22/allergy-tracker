<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AllergyDetail.aspx.cs" Inherits="AllergyTracker.AllergyDetail" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Allergy Detail - Allergy Tracker</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; margin: 0; }
        .navbar { background: #2c7be5; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { margin: 0; font-size: 20px; }
        .navbar a { color: white; text-decoration: none; background: rgba(255,255,255,0.2); padding: 8px 16px; border-radius: 5px; margin-left: 8px; font-size: 14px; }
        .container { max-width: 800px; margin: 30px auto; padding: 0 20px; }
        .card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 20px; }
        h2 { color: #2c7be5; margin-top: 0; }
        h3 { color: #444; border-bottom: 2px solid #eee; padding-bottom: 8px; }
        .detail-row { display: flex; margin-bottom: 10px; font-size: 15px; }
        .detail-label { font-weight: bold; width: 160px; color: #555; }
        .detail-value { flex: 1; color: #222; }
        .badge { padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: bold; }
        .badge-Mild     { background: #d4edda; color: #155724; }
        .badge-Moderate { background: #fff3cd; color: #856404; }
        .badge-Severe   { background: #f8d7da; color: #721c24; }
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th { background: #2c7be5; color: white; padding: 9px 10px; text-align: left; }
        td { padding: 8px 10px; border-bottom: 1px solid #eee; }
        tr:hover td { background: #f7f9ff; }
        .btn-back { background: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 5px; text-decoration: none; font-size: 14px; display: inline-block; }
        .btn-incident { background: #e67e22; color: white; padding: 10px 20px; border: none; border-radius: 5px; text-decoration: none; font-size: 14px; display: inline-block; margin-left: 10px; }
        .alert-error { background: #f8d7da; color: #721c24; padding: 12px; border-radius: 5px; }
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

            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div class="alert-error">Allergy not found or you don't have permission to view it.</div>
            </asp:Panel>

            <asp:Panel ID="pnlDetail" runat="server">
                <!-- Main Info -->
                <div class="card">
                    <h2>🔍 Allergy Detail</h2>
                    <div class="detail-row">
                        <div class="detail-label">Allergy Name:</div>
                        <div class="detail-value"><asp:Label ID="lblName"     runat="server" /></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Category:</div>
                        <div class="detail-value"><asp:Label ID="lblCategory" runat="server" /></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Severity:</div>
                        <div class="detail-value"><asp:Label ID="lblSeverity" runat="server" /></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Diagnosed Date:</div>
                        <div class="detail-value"><asp:Label ID="lblDiagnosed" runat="server" /></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Doctor:</div>
                        <div class="detail-value"><asp:Label ID="lblDoctor" runat="server" /></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Description:</div>
                        <div class="detail-value"><asp:Label ID="lblDescription" runat="server" /></div>
                    </div>
                </div>

                <!-- Symptoms -->
                <div class="card">
                    <h3>⚡ Symptoms</h3>
                    <asp:GridView ID="gvSymptoms" runat="server"
                        AutoGenerateColumns="false"
                        EmptyDataText="No symptoms recorded.">
                        <Columns>
                            <asp:BoundField DataField="SymptomName" HeaderText="Symptom" />
                            <asp:BoundField DataField="Notes"       HeaderText="Notes"   />
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Medications -->
                <div class="card">
                    <h3>💊 Medications</h3>
                    <asp:GridView ID="gvMedications" runat="server"
                        AutoGenerateColumns="false"
                        EmptyDataText="No medications recorded.">
                        <Columns>
                            <asp:BoundField DataField="MedicationName" HeaderText="Medication" />
                            <asp:BoundField DataField="Dosage"         HeaderText="Dosage"     />
                            <asp:BoundField DataField="Frequency"      HeaderText="Frequency"  />
                            <asp:BoundField DataField="PrescribedBy"   HeaderText="Prescribed By" />
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Incidents -->
                <div class="card">
                    <h3>📅 Incident History</h3>
                    <asp:GridView ID="gvIncidents" runat="server"
                        AutoGenerateColumns="false"
                        EmptyDataText="No incidents logged for this allergy.">
                        <Columns>
                            <asp:BoundField DataField="IncidentDate"    HeaderText="Date"      DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="ReactionDetails" HeaderText="Reaction"  />
                            <asp:BoundField DataField="TreatmentTaken"  HeaderText="Treatment" />
                            <asp:CheckBoxField DataField="HospitalVisit" HeaderText="Hospital?" />
                        </Columns>
                    </asp:GridView>
                </div>

                <a href="AllergyList.aspx" class="btn-back">← Back to List</a>
                <asp:HyperLink ID="hlLogIncident" runat="server" CssClass="btn-incident">⚠️ Log Incident</asp:HyperLink>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
