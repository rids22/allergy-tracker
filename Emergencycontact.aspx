<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmergencyContact.aspx.cs" Inherits="AllergyTracker.EmergencyContact" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Emergency Contacts - Allergy Tracker</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar { background: #2c7be5; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.15); }
        .navbar h1 { font-size: 20px; }
        .navbar a { color: white; text-decoration: none; background: rgba(255,255,255,0.2); padding: 7px 14px; border-radius: 5px; margin-left: 8px; font-size: 13px; }
        .navbar a:hover { background: rgba(255,255,255,0.35); }
        .container { max-width: 1050px; margin: 30px auto; padding: 0 20px; }
        .page-title { margin-bottom: 22px; }
        .page-title h2 { color: #c0392b; font-size: 22px; }
        .page-title p  { color: #666; font-size: 13px; margin-top: 4px; }
        .layout { display: flex; gap: 22px; flex-wrap: wrap; }
        .form-card { background: white; border-radius: 12px; padding: 26px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); flex: 1; min-width: 290px; }
        .list-card { background: white; border-radius: 12px; padding: 26px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); flex: 2; min-width: 320px; }
        .card-title { font-size: 15px; font-weight: bold; color: #333; margin-bottom: 16px; padding-bottom: 10px; border-bottom: 2px solid #f0f4f8; }
        .form-group { margin-bottom: 13px; }
        label { display: block; font-weight: bold; font-size: 13px; color: #555; margin-bottom: 4px; }
        input[type=text], select { width: 100%; padding: 9px 11px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        input[type=text]:focus, select:focus { border-color: #2c7be5; outline: none; }
        .error { color: #e74c3c; font-size: 12px; display: block; margin-top: 3px; }
        .checkbox-row { display: flex; align-items: center; gap: 8px; margin-bottom: 14px; }
        .checkbox-row label { margin: 0; font-weight: normal; }
        .btn-save { width: 100%; padding: 11px; background: #c0392b; color: white; border: none; border-radius: 6px; font-size: 15px; cursor: pointer; font-weight: bold; }
        .btn-save:hover { background: #a93226; }
        .alert { padding: 10px 14px; border-radius: 6px; margin-bottom: 14px; font-size: 13px; }
        .alert-success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .alert-error   { background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }

        /* GridView table styling */
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th { background: #c0392b; color: white; padding: 10px 12px; text-align: left; }
        td { padding: 9px 12px; border-bottom: 1px solid #f0f4f8; vertical-align: middle; }
        tr:hover td { background: #fff8f8; }
        .primary-row td { background: #fff0f0 !important; font-weight: bold; }
        .badge-primary { background: #c0392b; color: white; font-size: 11px; padding: 2px 8px; border-radius: 20px; font-weight: bold; }
        .empty { text-align: center; color: #bbb; padding: 30px; font-size: 14px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="navbar">
            <h1>🩺 Allergy Tracker</h1>
            <div>
                <a href="Dashboard.aspx">Dashboard</a>
                <a href="AllergyList.aspx">My Allergies</a>
                <a href="LogIncident.aspx">Log Incident</a>
                <a href="Logout.aspx">Logout</a>
            </div>
        </div>

        <div class="container">
            <div class="page-title">
                <h2>🚨 Emergency Contacts</h2>
                <p>People to contact in case of a severe allergic reaction</p>
            </div>

            <div class="layout">

                <!-- Add Contact Form -->
                <div class="form-card">
                    <div class="card-title">➕ Add New Contact</div>

                    <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert" />

                    <div class="form-group">
                        <label>Full Name *</label>
                        <asp:TextBox ID="txtName" runat="server" placeholder="e.g. John Doe" />
                        <asp:RequiredFieldValidator ControlToValidate="txtName" runat="server"
                            ErrorMessage="Name is required." CssClass="error" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>Relationship *</label>
                        <asp:DropDownList ID="ddlRelationship" runat="server">
                            <asp:ListItem Value="">-- Select --</asp:ListItem>
                            <asp:ListItem Value="Parent">Parent</asp:ListItem>
                            <asp:ListItem Value="Spouse">Spouse</asp:ListItem>
                            <asp:ListItem Value="Sibling">Sibling</asp:ListItem>
                            <asp:ListItem Value="Friend">Friend</asp:ListItem>
                            <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                            <asp:ListItem Value="Caregiver">Caregiver</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ControlToValidate="ddlRelationship" runat="server"
                            InitialValue="" ErrorMessage="Please select relationship." CssClass="error" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>Phone Number *</label>
                        <asp:TextBox ID="txtPhone" runat="server" placeholder="e.g. +91 9876543210" />
                        <asp:RequiredFieldValidator ControlToValidate="txtPhone" runat="server"
                            ErrorMessage="Phone number is required." CssClass="error" Display="Dynamic" />
                        <asp:RegularExpressionValidator ControlToValidate="txtPhone" runat="server"
                            ValidationExpression="^[\+]?[\d\s\-]{7,15}$"
                            ErrorMessage="Enter a valid phone number." CssClass="error" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>Email (optional)</label>
                        <asp:TextBox ID="txtEmail" runat="server" placeholder="e.g. john@email.com" />
                        <asp:RegularExpressionValidator ControlToValidate="txtEmail" runat="server"
                            ValidationExpression="^$|\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            ErrorMessage="Enter a valid email." CssClass="error" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>Address (optional)</label>
                        <asp:TextBox ID="txtAddress" runat="server" placeholder="e.g. 123 Main St, Mumbai" />
                    </div>

                    <div class="checkbox-row">
                        <asp:CheckBox ID="chkPrimary" runat="server" />
                        <label>Set as Primary Emergency Contact</label>
                    </div>

                    <asp:Button ID="btnSave" runat="server" Text="💾 Save Contact"
                        CssClass="btn-save" OnClick="btnSave_Click" />
                </div>

                <!-- Contacts List using GridView (Repeater does not support EmptyDataTemplate) -->
                <div class="list-card">
                    <div class="card-title">
                        📋 My Emergency Contacts &nbsp;
                        <asp:Label ID="lblCount" runat="server" Style="font-size:12px; color:#999; font-weight:normal;" />
                    </div>

                    <asp:GridView ID="gvContacts" runat="server"
                        AutoGenerateColumns="false"
                        DataKeyNames="ContactID"
                        OnRowCommand="gvContacts_RowCommand"
                        EmptyDataText="No emergency contacts added yet."
                        GridLines="None">
                        <EmptyDataRowStyle CssClass="empty" />
                        <Columns>
                            <asp:TemplateField HeaderText="Primary">
                                <ItemTemplate>
                                    <%# Convert.ToBoolean(Eval("IsPrimary")) ? "<span class='badge-primary'>⭐ PRIMARY</span>" : "" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="ContactName"  HeaderText="Name"         />
                            <asp:BoundField DataField="Relationship" HeaderText="Relationship" />
                            <asp:BoundField DataField="PhoneNumber"  HeaderText="Phone"        />
                            <asp:BoundField DataField="Email"        HeaderText="Email"        />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:LinkButton CommandName="SetPrimary"
                                        CommandArgument='<%# Eval("ContactID") %>'
                                        runat="server" ForeColor="#2c7be5">⭐ Set Primary</asp:LinkButton>
                                    &nbsp;|&nbsp;
                                    <asp:LinkButton CommandName="DeleteContact"
                                        CommandArgument='<%# Eval("ContactID") %>'
                                        runat="server" ForeColor="#e74c3c"
                                        OnClientClick="return confirm('Delete this emergency contact?');">🗑 Delete</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

            </div>
        </div>

    </form>
</body>
</html>
