<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MedicineReminder.aspx.cs" Inherits="AllergyTracker.MedicineReminder" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Medicine Reminders - Allergy Tracker</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar { background: #2c7be5; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.15); }
        .navbar h1 { font-size: 20px; }
        .navbar a { color: white; text-decoration: none; background: rgba(255,255,255,0.2); padding: 7px 14px; border-radius: 5px; margin-left: 8px; font-size: 13px; }
        .navbar a:hover { background: rgba(255,255,255,0.35); }
        .container { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        .page-title h2 { color: #8e44ad; font-size: 24px; margin-bottom: 5px; }
        .page-title p  { color: #777; font-size: 14px; margin-bottom: 22px; }
        .layout { display: flex; gap: 22px; flex-wrap: wrap; }
        .form-card { background: white; border-radius: 12px; padding: 26px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); flex: 1; min-width: 280px; }
        .list-card { background: white; border-radius: 12px; padding: 26px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); flex: 2; min-width: 320px; }
        .card-title { font-size: 15px; font-weight: bold; color: #333; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 2px solid #f0f4f8; }
        .form-group { margin-bottom: 14px; }
        .row { display: flex; gap: 12px; }
        .row .form-group { flex: 1; }
        label { display: block; font-weight: bold; font-size: 13px; color: #555; margin-bottom: 4px; }
        input[type=text], select, textarea { width: 100%; padding: 9px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        input:focus, select:focus { border-color: #8e44ad; outline: none; }
        textarea { height: 70px; resize: vertical; }
        .error { color: #e74c3c; font-size: 12px; display: block; margin-top: 3px; }
        .btn-save { width: 100%; padding: 11px; background: #8e44ad; color: white; border: none; border-radius: 6px; font-size: 15px; cursor: pointer; font-weight: bold; margin-top: 5px; }
        .btn-save:hover { background: #7d3c98; }
        .alert { padding: 11px 15px; border-radius: 6px; margin-bottom: 15px; font-size: 14px; }
        .alert-success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .alert-error   { background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }
        .med-section { margin-bottom: 22px; }
        .med-section-title { font-size: 14px; font-weight: bold; color: #8e44ad; margin-bottom: 10px; display: flex; align-items: center; gap: 6px; }
        .med-card { border: 1px solid #e9ecef; border-radius: 10px; padding: 14px 16px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center; transition: box-shadow 0.2s; }
        .med-card:hover { box-shadow: 0 3px 10px rgba(0,0,0,0.08); }
        .med-card.inactive { opacity: 0.55; }
        .med-info .med-name { font-weight: bold; font-size: 15px; color: #222; }
        .med-info .med-detail { font-size: 13px; color: #666; margin-top: 3px; }
        .med-actions { display: flex; gap: 8px; align-items: center; flex-shrink: 0; }
        .badge-active   { background: #d4edda; color: #155724; padding: 2px 8px; border-radius: 10px; font-size: 11px; font-weight: bold; }
        .badge-inactive { background: #e2e3e5; color: #383d41; padding: 2px 8px; border-radius: 10px; font-size: 11px; font-weight: bold; }
        .btn-toggle { background: none; border: 1px solid #27ae60; color: #27ae60; padding: 4px 10px; border-radius: 5px; font-size: 12px; cursor: pointer; }
        .btn-toggle:hover { background: #27ae60; color: white; }
        .btn-del { background: none; border: 1px solid #e74c3c; color: #e74c3c; padding: 4px 10px; border-radius: 5px; font-size: 12px; cursor: pointer; }
        .btn-del:hover { background: #e74c3c; color: white; }
        .empty-msg { text-align: center; color: #bbb; padding: 15px; font-size: 13px; background: #fafafa; border-radius: 8px; border: 1px dashed #e0e0e0; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <h1>🩺 Allergy Tracker</h1>
            <div>
                <a href="Dashboard.aspx">Dashboard</a>
                <a href="AllergyList.aspx">My Allergies</a>
                <a href="AllergyReport.aspx">📄 Report</a>
                <a href="EmergencyContact.aspx">🚨 Emergency</a>
                <a href="Logout.aspx">Logout</a>
            </div>
        </div>

        <div class="container">
            <div class="page-title">
                <h2>💊 Medicine Reminders</h2>
                <p>Track your daily allergy medicines and never miss a dose</p>
            </div>

            <div class="layout">
                <!-- Add Form -->
                <div class="form-card">
                    <div class="card-title">➕ Add New Reminder</div>
                    <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="alert" />

                    <div class="form-group">
                        <label>Medicine Name *</label>
                        <asp:TextBox ID="txtMedName" runat="server" placeholder="e.g. Cetirizine" />
                        <asp:RequiredFieldValidator ControlToValidate="txtMedName" runat="server"
                            ErrorMessage="Medicine name is required." CssClass="error" Display="Dynamic" />
                    </div>

                    <div class="row">
                        <div class="form-group">
                            <label>Dosage</label>
                            <asp:TextBox ID="txtDosage" runat="server" placeholder="e.g. 10mg" />
                        </div>
                        <div class="form-group">
                            <label>Time of Day *</label>
                            <asp:DropDownList ID="ddlTime" runat="server">
                                <asp:ListItem Value="">-- Select --</asp:ListItem>
                                <asp:ListItem Value="Morning">🌅 Morning</asp:ListItem>
                                <asp:ListItem Value="Afternoon">☀️ Afternoon</asp:ListItem>
                                <asp:ListItem Value="Evening">🌆 Evening</asp:ListItem>
                                <asp:ListItem Value="Night">🌙 Night</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ControlToValidate="ddlTime" runat="server"
                                InitialValue="" ErrorMessage="Select time of day." CssClass="error" Display="Dynamic" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Frequency</label>
                        <asp:DropDownList ID="ddlFrequency" runat="server">
                            <asp:ListItem Value="Daily">Daily</asp:ListItem>
                            <asp:ListItem Value="Every other day">Every other day</asp:ListItem>
                            <asp:ListItem Value="Weekly">Weekly</asp:ListItem>
                            <asp:ListItem Value="As needed">As needed</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="row">
                        <div class="form-group">
                            <label>Start Date</label>
                            <asp:TextBox ID="txtStart" runat="server" placeholder="YYYY-MM-DD" />
                            <asp:RangeValidator ControlToValidate="txtStart" runat="server"
                                MinimumValue="2000-01-01" MaximumValue="2100-12-31" Type="Date"
                                ErrorMessage="Invalid date." CssClass="error" Display="Dynamic" />
                        </div>
                        <div class="form-group">
                            <label>End Date</label>
                            <asp:TextBox ID="txtEnd" runat="server" placeholder="YYYY-MM-DD" />
                            <asp:RangeValidator ControlToValidate="txtEnd" runat="server"
                                MinimumValue="2000-01-01" MaximumValue="2100-12-31" Type="Date"
                                ErrorMessage="Invalid date." CssClass="error" Display="Dynamic" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Notes</label>
                        <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" placeholder="e.g. Take after food..." />
                    </div>

                    <asp:Button ID="btnSave" runat="server" Text="💾 Save Reminder"
                        CssClass="btn-save" OnClick="btnSave_Click" />
                </div>

                <!-- Reminders List -->
                <div class="list-card">
                    <div class="card-title">📋 My Reminders &nbsp;
                        <span style="font-size:12px;color:#999;font-weight:normal;">
                            <asp:Label ID="lblCount" runat="server" />
                        </span>
                    </div>

                    <!-- Morning -->
                    <div class="med-section">
                        <div class="med-section-title">🌅 Morning</div>
                        <asp:Repeater ID="rptMorning" runat="server" OnItemCommand="rpt_ItemCommand">
                            <ItemTemplate>
                                <div class="med-card <%# !Convert.ToBoolean(Eval("IsActive")) ? "inactive" : "" %>">
                                    <div class="med-info">
                                        <div class="med-name"><%# Eval("MedicineName") %>
                                            <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge-active" : "badge-inactive" %>'>
                                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                            </span>
                                        </div>
                                        <div class="med-detail">
                                            <%# !string.IsNullOrEmpty(Eval("Dosage").ToString()) ? Eval("Dosage") + " | " : "" %>
                                            <%# Eval("Frequency") %>
                                            <%# !string.IsNullOrEmpty(Eval("Notes").ToString()) ? " | " + Eval("Notes") : "" %>
                                        </div>
                                    </div>
                                    <div class="med-actions">
                                        <asp:LinkButton runat="server" CommandName="Toggle"
                                            CommandArgument='<%# Eval("ReminderID") %>' CssClass="btn-toggle">⟳ Toggle</asp:LinkButton>
                                        <asp:LinkButton runat="server" CommandName="Delete"
                                            CommandArgument='<%# Eval("ReminderID") %>' CssClass="btn-del"
                                            OnClientClick="return confirm('Delete this reminder?');">🗑</asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Label ID="lblNoMorning" runat="server" Visible="false" CssClass="empty-msg" Text="No morning reminders added yet." />
                    </div>

                    <!-- Afternoon -->
                    <div class="med-section">
                        <div class="med-section-title">☀️ Afternoon</div>
                        <asp:Repeater ID="rptAfternoon" runat="server" OnItemCommand="rpt_ItemCommand">
                            <ItemTemplate>
                                <div class="med-card <%# !Convert.ToBoolean(Eval("IsActive")) ? "inactive" : "" %>">
                                    <div class="med-info">
                                        <div class="med-name"><%# Eval("MedicineName") %>
                                            <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge-active" : "badge-inactive" %>'>
                                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                            </span>
                                        </div>
                                        <div class="med-detail"><%# Eval("Dosage") %> | <%# Eval("Frequency") %></div>
                                    </div>
                                    <div class="med-actions">
                                        <asp:LinkButton runat="server" CommandName="Toggle"
                                            CommandArgument='<%# Eval("ReminderID") %>' CssClass="btn-toggle">⟳ Toggle</asp:LinkButton>
                                        <asp:LinkButton runat="server" CommandName="Delete"
                                            CommandArgument='<%# Eval("ReminderID") %>' CssClass="btn-del"
                                            OnClientClick="return confirm('Delete this reminder?');">🗑</asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Label ID="lblNoAfternoon" runat="server" Visible="false" CssClass="empty-msg" Text="No afternoon reminders added yet." />
                    </div>

                    <!-- Evening -->
                    <div class="med-section">
                        <div class="med-section-title">🌆 Evening</div>
                        <asp:Repeater ID="rptEvening" runat="server" OnItemCommand="rpt_ItemCommand">
                            <ItemTemplate>
                                <div class="med-card <%# !Convert.ToBoolean(Eval("IsActive")) ? "inactive" : "" %>">
                                    <div class="med-info">
                                        <div class="med-name"><%# Eval("MedicineName") %>
                                            <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge-active" : "badge-inactive" %>'>
                                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                            </span>
                                        </div>
                                        <div class="med-detail"><%# Eval("Dosage") %> | <%# Eval("Frequency") %></div>
                                    </div>
                                    <div class="med-actions">
                                        <asp:LinkButton runat="server" CommandName="Toggle"
                                            CommandArgument='<%# Eval("ReminderID") %>' CssClass="btn-toggle">⟳ Toggle</asp:LinkButton>
                                        <asp:LinkButton runat="server" CommandName="Delete"
                                            CommandArgument='<%# Eval("ReminderID") %>' CssClass="btn-del"
                                            OnClientClick="return confirm('Delete this reminder?');">🗑</asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Label ID="lblNoEvening" runat="server" Visible="false" CssClass="empty-msg" Text="No evening reminders added yet." />
                    </div>

                    <!-- Night -->
                    <div class="med-section">
                        <div class="med-section-title">🌙 Night</div>
                        <asp:Repeater ID="rptNight" runat="server" OnItemCommand="rpt_ItemCommand">
                            <ItemTemplate>
                                <div class="med-card <%# !Convert.ToBoolean(Eval("IsActive")) ? "inactive" : "" %>">
                                    <div class="med-info">
                                        <div class="med-name"><%# Eval("MedicineName") %>
                                            <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge-active" : "badge-inactive" %>'>
                                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                            </span>
                                        </div>
                                        <div class="med-detail"><%# Eval("Dosage") %> | <%# Eval("Frequency") %></div>
                                    </div>
                                    <div class="med-actions">
                                        <asp:LinkButton runat="server" CommandName="Toggle"
                                            CommandArgument='<%# Eval("ReminderID") %>' CssClass="btn-toggle">⟳ Toggle</asp:LinkButton>
                                        <asp:LinkButton runat="server" CommandName="Delete"
                                            CommandArgument='<%# Eval("ReminderID") %>' CssClass="btn-del"
                                            OnClientClick="return confirm('Delete this reminder?');">🗑</asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Label ID="lblNoNight" runat="server" Visible="false" CssClass="empty-msg" Text="No night reminders added yet." />
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>
