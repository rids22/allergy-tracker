<%@ Page Title="Dashboard" Language="C#" 
AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs"
Inherits="AllergyTracker.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard - Allergy Tracker</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar { background: #2c7be5; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.15); }
        .navbar h1 { font-size: 20px; }
        .navbar a { color: white; text-decoration: none; background: rgba(255,255,255,0.2); padding: 7px 14px; border-radius: 5px; margin-left: 8px; font-size: 13px; }
        .navbar a:hover { background: rgba(255,255,255,0.35); }
        .container { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
        .welcome { font-size: 20px; color: #333; margin-bottom: 22px; }

        /* Summary Cards */
        .cards { display: flex; gap: 16px; margin-bottom: 24px; flex-wrap: wrap; }
        .card { background: white; border-radius: 12px; padding: 20px; flex: 1; min-width: 150px; text-align: center; box-shadow: 0 2px 10px rgba(0,0,0,0.07); border-top: 4px solid transparent; }
        .card .number { font-size: 36px; font-weight: bold; }
        .card .label  { color: #888; margin-top: 5px; font-size: 13px; }
        .card.blue   { border-color: #2c7be5; } .card.blue   .number { color: #2c7be5; }
        .card.red    { border-color: #e74c3c; } .card.red    .number { color: #e74c3c; }
        .card.green  { border-color: #27ae60; } .card.green  .number { color: #27ae60; }
        .card.orange { border-color: #e67e22; } .card.orange .number { color: #e67e22; }

        /* Quick actions */
        .quick-actions { display: flex; gap: 12px; margin-bottom: 24px; flex-wrap: wrap; }
        .qa-btn { flex: 1; min-width: 140px; background: white; border: 2px solid #e9ecef; border-radius: 10px; padding: 14px; text-align: center; text-decoration: none; color: #333; font-size: 13px; font-weight: bold; transition: all 0.2s; }
        .qa-btn:hover { border-color: #2c7be5; color: #2c7be5; box-shadow: 0 3px 10px rgba(44,123,229,0.15); }
        .qa-btn .icon { font-size: 24px; display: block; margin-bottom: 5px; }

        /* Two column layout */
        .two-col { display: flex; gap: 20px; margin-bottom: 22px; flex-wrap: wrap; }
        .two-col .section { flex: 1; min-width: 280px; }

        /* Section */
        .section { background: white; border-radius: 12px; padding: 22px; margin-bottom: 22px; box-shadow: 0 2px 10px rgba(0,0,0,0.07); }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 2px solid #f0f4f8; }
        .section-header h3 { color: #333; font-size: 15px; }
        .btn-sm { background: #27ae60; color: white; padding: 6px 14px; border: none; border-radius: 6px; text-decoration: none; font-size: 12px; display: inline-block; font-weight: bold; }
        .btn-emergency { background: #c0392b; color: white; padding: 6px 14px; border: none; border-radius: 6px; text-decoration: none; font-size: 12px; display: inline-block; font-weight: bold; }

        /* Chart */
        .chart-container { position: relative; height: 240px; display: flex; justify-content: center; }

        /* GridView */
        .grid-wrapper { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th { background: #2c7be5; color: white; padding: 9px 10px; text-align: left; font-size: 12px; }
        td { padding: 8px 10px; border-bottom: 1px solid #f0f4f8; vertical-align: middle; }
        tr:hover td { background: #f7f9ff; }
        .badge { padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: bold; display: inline-block; }
        .badge-Mild     { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .badge-Moderate { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .badge-Severe   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .empty { color: #bbb; text-align: center; padding: 20px; font-size: 13px; }

        /* Calendar */
        .cal-wrapper { display: flex; justify-content: center; }
    </style>
</head>
<body>
     
    <form id="form1" runat="server">
        <!-- Hidden fields for chart data -->
        <asp:HiddenField ID="hfChartLabels" runat="server" />
        <asp:HiddenField ID="hfChartValues" runat="server" />

        <div class="navbar">
            <h1>🩺 Allergy Tracker</h1>
            <div>

                <asp:Label ID="lblNavUser" runat="server" Style="margin-right:8px; font-size:13px;" />
                <a href="AddAllergy.aspx">+ Allergy</a>
                <a href="AllergyList.aspx">My Allergies</a>
                <a href="MedicineReminder.aspx">💊 Medicines</a>
                <a href="AllergyReport.aspx">📄 Report</a>
                <a href="EmergencyContact.aspx">🚨 Emergency</a>
                <a href="Logout.aspx">Logout</a>
            </div>
        </div>

        <div class="container">
            <div class="welcome">Welcome back, <strong><asp:Label ID="lblWelcome" runat="server" /></strong>! 👋</div>

            <!-- Summary Cards -->
            <div class="cards">
                <div class="card blue">
                    <div class="number"><asp:Label ID="lblTotalAllergies" runat="server" Text="0" /></div>
                    <div class="label">Total Allergies</div>
                </div>
                <div class="card red">
                    <div class="number"><asp:Label ID="lblSevere" runat="server" Text="0" /></div>
                    <div class="label">Severe</div>
                </div>
                <div class="card orange">
                    <div class="number"><asp:Label ID="lblIncidents" runat="server" Text="0" /></div>
                    <div class="label">Incidents</div>
                </div>
                <div class="card green">
                    <div class="number"><asp:Label ID="lblMedications" runat="server" Text="0" /></div>
                    <div class="label">Medications</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <a href="AddAllergy.aspx"        class="qa-btn"><span class="icon">🤧</span>Add Allergy</a>
                <a href="LogIncident.aspx"        class="qa-btn"><span class="icon">⚠️</span>Log Incident</a>
                <a href="MedicineReminder.aspx"   class="qa-btn"><span class="icon">💊</span>Medicines</a>
                <a href="AllergyReport.aspx"      class="qa-btn"><span class="icon">📄</span>View Report</a>
                <a href="EmergencyContact.aspx"   class="qa-btn"><span class="icon">🚨</span>Emergency</a>
            </div>

            <!-- Chart + Calendar row -->
            <div class="two-col">
                <!-- Pie Chart -->
                <div class="section">
                    <div class="section-header"><h3>🥧 Allergies by Category</h3></div>
                    <div class="chart-container">
                        <canvas id="pieChart"></canvas>
                    </div>
                    <p id="noChartMsg" style="text-align:center;color:#bbb;font-size:13px;display:none;margin-top:10px;">No allergy data to display.</p>
                </div>

                <!-- Calendar -->
                <div class="section">
                    <div class="section-header"><h3>📅 Incident Calendar</h3></div>
                    <p style="color:#888;font-size:12px;margin-bottom:10px;">🔴 = incident logged on that date</p>
                    <div class="cal-wrapper">
                        <asp:Calendar ID="calIncidents" runat="server"
                            OnDayRender="calIncidents_DayRender"
                            SelectionMode="None"
                            BackColor="White" BorderColor="#ddd"
                            CellPadding="4" Font-Names="Arial" Font-Size="10pt"
                            ForeColor="#333" Width="100%"
                            TitleStyle-BackColor="#2c7be5" TitleStyle-ForeColor="White" TitleStyle-Font-Bold="true"
                            DayHeaderStyle-BackColor="#e9f0fb" DayHeaderStyle-ForeColor="#2c7be5"
                            TodayDayStyle-BackColor="#d0e8ff"
                            WeekendDayStyle-BackColor="#f9f9f9" />
                    </div>
                </div>
            </div>

            <!-- Allergies GridView -->
            <div class="section">
                <div class="section-header">
                    <h3>📋 My Allergies</h3>
                    <div>
                        <a href="EmergencyContact.aspx" class="btn-emergency">🚨 Emergency</a>
                        &nbsp;
                        <a href="AddAllergy.aspx" class="btn-sm">➕ Add New</a>
                    </div>
                </div>
                <div class="grid-wrapper">
                    <asp:GridView ID="gvAllergies" runat="server"
                        AutoGenerateColumns="false"
                        EmptyDataText="No allergies found."
                        OnRowCommand="gvAllergies_RowCommand"
                        DataKeyNames="AllergyID">
                        <EmptyDataRowStyle CssClass="empty" />
                        <Columns>
                            <asp:BoundField DataField="AllergyName"  HeaderText="Allergy"  />
                            <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                            <asp:TemplateField HeaderText="Severity">
                                <ItemTemplate>
                                    <span class='badge badge-<%# Eval("SeverityLevel") %>'><%# Eval("SeverityLevel") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="DiagnosedDate" HeaderText="Diagnosed" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="DoctorName"   HeaderText="Doctor" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton CommandName="ViewDetail" CommandArgument='<%# Eval("AllergyID") %>'
                                        runat="server" ForeColor="#2c7be5" Font-Bold="true">View</asp:LinkButton>
                                    &nbsp;|&nbsp;
                                    <asp:LinkButton CommandName="DeleteRow" CommandArgument='<%# Eval("AllergyID") %>'
                                        runat="server" ForeColor="#e74c3c"
                                        OnClientClick="return confirm('Delete this allergy? All related data will be removed.');">Delete</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- Recent Incidents -->
            <div class="section">
                <div class="section-header">
                    <h3>⚠️ Recent Incidents</h3>
                    <a href="LogIncident.aspx" class="btn-sm">+ Log Incident</a>
                </div>
                <div class="grid-wrapper">
                    <asp:GridView ID="gvIncidents" runat="server"
                        AutoGenerateColumns="false" EmptyDataText="No incidents logged yet.">
                        <EmptyDataRowStyle CssClass="empty" />
                        <Columns>
                            <asp:BoundField DataField="AllergyName"     HeaderText="Allergy"   />
                            <asp:BoundField DataField="IncidentDate"    HeaderText="Date"      DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="ReactionDetails" HeaderText="Reaction"  />
                            <asp:BoundField DataField="TreatmentTaken"  HeaderText="Treatment" />
                            <asp:CheckBoxField DataField="HospitalVisit" HeaderText="Hospital?" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            window.onload = function () {
                var labels = document.getElementById('<%= hfChartLabels.ClientID %>').value;
                var values = document.getElementById('<%= hfChartValues.ClientID %>').value;

                if (!labels || labels.trim() === '') {
                    document.getElementById('noChartMsg').style.display = 'block';
                    return;
                }

                var labelArr = labels.split(',').map(function (l) { return l.replace(/'/g, '').trim(); });
                var valueArr = values.split(',').map(function (v) { return parseInt(v.trim()); });

                var colors = ['#2c7be5', '#e74c3c', '#27ae60', '#e67e22', '#8e44ad', '#16a085', '#d4ac0d'];

                var ctx = document.getElementById('pieChart').getContext('2d');
                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: labelArr,
                        datasets: [{
                            data: valueArr,
                            backgroundColor: colors.slice(0, labelArr.length),
                            borderWidth: 2,
                            borderColor: '#fff'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'right', labels: { font: { size: 12 }, padding: 12 } }
                        }
                    }
                });
            };
        </script>
    </form>
</body>
</html>
