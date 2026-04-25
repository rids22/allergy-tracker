<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AllergyReport.aspx.cs" Inherits="AllergyTracker.AllergyReport" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Allergy Report - Allergy Tracker</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar { background: #2c7be5; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.15); }
        .navbar h1 { font-size: 20px; }
        .navbar a { color: white; text-decoration: none; background: rgba(255,255,255,0.2); padding: 7px 14px; border-radius: 5px; margin-left: 8px; font-size: 13px; }
        .navbar a:hover { background: rgba(255,255,255,0.35); }
        .container { max-width: 850px; margin: 30px auto; padding: 0 20px; }
        .btn-print { background: #27ae60; color: white; padding: 10px 22px; border: none; border-radius: 6px; font-size: 14px; cursor: pointer; font-weight: bold; float: right; margin-bottom: 15px; }
        .btn-print:hover { background: #1e8449; }

        /* Report card */
        .report { background: white; border-radius: 12px; padding: 35px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
        .report-header { text-align: center; border-bottom: 3px solid #2c7be5; padding-bottom: 18px; margin-bottom: 24px; }
        .report-header h2 { color: #2c7be5; font-size: 24px; }
        .report-header p  { color: #666; font-size: 14px; margin-top: 5px; }
        .report-header .patient-name { font-size: 18px; font-weight: bold; color: #333; margin-top: 8px; }

        /* Summary boxes */
        .summary-boxes { display: flex; gap: 15px; margin-bottom: 25px; flex-wrap: wrap; }
        .s-box { flex: 1; min-width: 110px; border-radius: 8px; padding: 15px; text-align: center; }
        .s-box .num  { font-size: 30px; font-weight: bold; }
        .s-box .lbl  { font-size: 12px; margin-top: 3px; }
        .s-box.blue   { background: #e8f0fd; color: #2c7be5; }
        .s-box.red    { background: #fde8e8; color: #c0392b; }
        .s-box.yellow { background: #fef9e7; color: #d4ac0d; }
        .s-box.green  { background: #e8f8f0; color: #27ae60; }

        /* Section */
        .r-section { margin-bottom: 24px; }
        .r-section h3 { font-size: 15px; color: #2c7be5; border-left: 4px solid #2c7be5; padding-left: 10px; margin-bottom: 12px; }
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th { background: #f0f4f8; color: #555; padding: 9px 10px; text-align: left; font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px; }
        td { padding: 8px 10px; border-bottom: 1px solid #f5f5f5; }
        tr:hover td { background: #fafbff; }
        .badge { padding: 2px 10px; border-radius: 20px; font-size: 11px; font-weight: bold; display: inline-block; }
        .badge-Mild     { background: #d4edda; color: #155724; }
        .badge-Moderate { background: #fff3cd; color: #856404; }
        .badge-Severe   { background: #f8d7da; color: #721c24; }
        .report-footer { text-align: center; margin-top: 25px; padding-top: 15px; border-top: 1px solid #eee; color: #999; font-size: 12px; }
        .no-data { color: #bbb; text-align: center; padding: 15px; font-size: 13px; }

        /* Emergency box */
        .emergency-box { background: #fff5f5; border: 2px solid #e74c3c; border-radius: 8px; padding: 15px; margin-bottom: 24px; }
        .emergency-box h3 { color: #c0392b; font-size: 14px; margin-bottom: 10px; }
        .emergency-box .ec-row { font-size: 13px; color: #444; margin-bottom: 5px; }
        .emergency-box .ec-row strong { color: #222; }

        @media print {
            .navbar, .btn-print, .no-print { display: none !important; }
            body { background: white; }
            .container { max-width: 100%; margin: 0; padding: 0; }
            .report { box-shadow: none; border-radius: 0; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar no-print">
            <h1>🩺 Allergy Tracker</h1>
            <div>
                <a href="Dashboard.aspx">Dashboard</a>
                <a href="AllergyList.aspx">My Allergies</a>
                <a href="MedicineReminder.aspx">💊 Medicines</a>
                <a href="Logout.aspx">Logout</a>
            </div>
        </div>

        <div class="container">
            <button class="btn-print no-print" onclick="window.print(); return false;">🖨️ Print / Save as PDF</button>
            <div style="clear:both; margin-bottom:10px;"></div>

            <div class="report">
                <!-- Header -->
                <div class="report-header">
                    <h2>🩺 Allergy Medical Report</h2>
                    <div class="patient-name">
                        Patient: <asp:Label ID="lblPatientName" runat="server" />
                    </div>
                    <p>Generated on: <asp:Label ID="lblDate" runat="server" /> &nbsp;|&nbsp; Username: <asp:Label ID="lblUsername" runat="server" /></p>
                </div>

                <!-- Summary -->
                <div class="summary-boxes">
                    <div class="s-box blue">
                        <div class="num"><asp:Label ID="lblTotal" runat="server" Text="0" /></div>
                        <div class="lbl">Total Allergies</div>
                    </div>
                    <div class="s-box red">
                        <div class="num"><asp:Label ID="lblSevere" runat="server" Text="0" /></div>
                        <div class="lbl">Severe</div>
                    </div>
                    <div class="s-box yellow">
                        <div class="num"><asp:Label ID="lblModerate" runat="server" Text="0" /></div>
                        <div class="lbl">Moderate</div>
                    </div>
                    <div class="s-box green">
                        <div class="num"><asp:Label ID="lblMild" runat="server" Text="0" /></div>
                        <div class="lbl">Mild</div>
                    </div>
                </div>

                <!-- Emergency Contact -->
                <div class="emergency-box">
                    <h3>🚨 Primary Emergency Contact</h3>
                    <asp:Label ID="lblEmergency" runat="server" />
                </div>

                <!-- Allergies Table -->
                <div class="r-section">
                    <h3>📋 Allergy List</h3>
                    <asp:GridView ID="gvAllergies" runat="server" AutoGenerateColumns="false"
                        EmptyDataText="No allergies recorded.">
                        <EmptyDataRowStyle CssClass="no-data" />
                        <Columns>
                            <asp:BoundField DataField="AllergyName"   HeaderText="Allergy"   />
                            <asp:BoundField DataField="CategoryName"  HeaderText="Category"  />
                            <asp:TemplateField HeaderText="Severity">
                                <ItemTemplate>
                                    <span class='badge badge-<%# Eval("SeverityLevel") %>'><%# Eval("SeverityLevel") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="DiagnosedDate" HeaderText="Diagnosed" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="DoctorName"    HeaderText="Doctor"    />
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Symptoms Table -->
                <div class="r-section">
                    <h3>⚡ Symptoms</h3>
                    <asp:GridView ID="gvSymptoms" runat="server" AutoGenerateColumns="false"
                        EmptyDataText="No symptoms recorded.">
                        <EmptyDataRowStyle CssClass="no-data" />
                        <Columns>
                            <asp:BoundField DataField="AllergyName"  HeaderText="Allergy"  />
                            <asp:BoundField DataField="SymptomName"  HeaderText="Symptom"  />
                            <asp:BoundField DataField="Notes"        HeaderText="Notes"    />
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Medications Table -->
                <div class="r-section">
                    <h3>💊 Medications</h3>
                    <asp:GridView ID="gvMeds" runat="server" AutoGenerateColumns="false"
                        EmptyDataText="No medications recorded.">
                        <EmptyDataRowStyle CssClass="no-data" />
                        <Columns>
                            <asp:BoundField DataField="AllergyName"    HeaderText="Allergy"    />
                            <asp:BoundField DataField="MedicationName" HeaderText="Medication" />
                            <asp:BoundField DataField="Dosage"         HeaderText="Dosage"     />
                            <asp:BoundField DataField="Frequency"      HeaderText="Frequency"  />
                            <asp:BoundField DataField="PrescribedBy"   HeaderText="Prescribed By" />
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Incidents Table -->
                <div class="r-section">
                    <h3>⚠️ Incident History</h3>
                    <asp:GridView ID="gvIncidents" runat="server" AutoGenerateColumns="false"
                        EmptyDataText="No incidents recorded.">
                        <EmptyDataRowStyle CssClass="no-data" />
                        <Columns>
                            <asp:BoundField DataField="AllergyName"     HeaderText="Allergy"   />
                            <asp:BoundField DataField="IncidentDate"    HeaderText="Date"      DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="ReactionDetails" HeaderText="Reaction"  />
                            <asp:BoundField DataField="TreatmentTaken"  HeaderText="Treatment" />
                            <asp:CheckBoxField DataField="HospitalVisit" HeaderText="Hospital?" />
                        </Columns>
                    </asp:GridView>
                </div>

                <div class="report-footer">
                    This report was auto-generated by Allergy Tracker &nbsp;|&nbsp;
                    <asp:Label ID="lblFooterDate" runat="server" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
