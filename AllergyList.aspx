<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AllergyList.aspx.cs" Inherits="AllergyTracker.AllergyList" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Allergies - Allergy Tracker</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; }
        .navbar { background: #2c7be5; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.15); }
        .navbar h1 { font-size: 20px; }
        .navbar a { color: white; text-decoration: none; background: rgba(255,255,255,0.2); padding: 7px 14px; border-radius: 5px; margin-left: 8px; font-size: 13px; }
        .navbar a:hover { background: rgba(255,255,255,0.35); }
        .container { max-width: 1050px; margin: 30px auto; padding: 0 20px; }
        .card { background: white; padding: 28px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 2px solid #f0f4f8; }
        .page-header h2 { color: #333; font-size: 20px; }

        .search-bar { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; margin-bottom: 18px; }
        input[type=text], select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        input[type=text]:focus, select:focus { border-color: #2c7be5; outline: none; }

        .btn { padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: bold; }
        .btn-search { background: #2c7be5; color: white; }
        .btn-reset  { background: #6c757d; color: white; }
        .btn-add    { background: #27ae60; color: white; text-decoration: none; display: inline-block; padding: 8px 16px; border-radius: 6px; font-size: 13px; font-weight: bold; }

        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th { background: #2c7be5; color: white; padding: 11px 12px; text-align: left; font-size: 13px; }
        td { padding: 10px 12px; border-bottom: 1px solid #f0f4f8; vertical-align: middle; }
        tr:hover td { background: #f7f9ff; }

        /* Severity Badges */
        .badge { padding: 4px 13px; border-radius: 20px; font-size: 12px; font-weight: bold; display: inline-block; }
        .badge-Mild     { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .badge-Moderate { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .badge-Severe   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .empty { color: #bbb; text-align: center; padding: 30px; font-size: 14px; }

        /* Toast */
        #toast { position: fixed; bottom: 28px; right: 28px; background: #2ecc71; color: white; padding: 13px 22px; border-radius: 8px; font-size: 14px; font-weight: bold; box-shadow: 0 4px 15px rgba(0,0,0,0.2); display: none; z-index: 9999; }
        #toast.error { background: #e74c3c; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="toast"></div>

        <div class="navbar">
            <h1>🩺 Allergy Tracker</h1>
            <div>
                <a href="Dashboard.aspx">Dashboard</a>
                <a href="AddAllergy.aspx">+ Add Allergy</a>
                <a href="LogIncident.aspx">Log Incident</a>
                <a href="EmergencyContact.aspx">🚨 Emergency</a>
                <a href="Logout.aspx">Logout</a>
            </div>
        </div>

        <div class="container">
            <div class="card">
                <div class="page-header">
                    <h2>📋 My Allergy List</h2>
                    <a href="AddAllergy.aspx" class="btn-add">➕ Add New Allergy</a>
                </div>

                <!-- Search & Filter -->
                <div class="search-bar">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search allergy name..." Style="width:200px;" />
                    <asp:DropDownList ID="ddlFilterSeverity" runat="server">
                        <asp:ListItem Value="">All Severities</asp:ListItem>
                        <asp:ListItem Value="Mild">🟢 Mild</asp:ListItem>
                        <asp:ListItem Value="Moderate">🟡 Moderate</asp:ListItem>
                        <asp:ListItem Value="Severe">🔴 Severe</asp:ListItem>
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlFilterCategory" runat="server" />
                    <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" CssClass="btn btn-search" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnReset"  runat="server" Text="↺ Reset"   CssClass="btn btn-reset"  OnClick="btnReset_Click" />
                </div>

                <!-- GridView with badges + confirm delete -->
                <asp:GridView ID="gvAllergies" runat="server"
                    AutoGenerateColumns="false"
                    AllowPaging="true" PageSize="7"
                    AllowSorting="true"
                    DataKeyNames="AllergyID"
                    OnPageIndexChanging="gvAllergies_PageIndexChanging"
                    OnSorting="gvAllergies_Sorting"
                    OnRowCommand="gvAllergies_RowCommand"
                    EmptyDataText="No allergies found."
                    PagerStyle-HorizontalAlign="Center">
                    <EmptyDataRowStyle CssClass="empty" />
                    <Columns>
                        <asp:BoundField DataField="AllergyID"    HeaderText="#"        SortExpression="AllergyID"    ItemStyle-Width="40px" />
                        <asp:BoundField DataField="AllergyName"  HeaderText="Allergy"  SortExpression="AllergyName"  />
                        <asp:BoundField DataField="CategoryName" HeaderText="Category" SortExpression="CategoryName" />
                        <asp:TemplateField HeaderText="Severity" SortExpression="SeverityLevel">
                            <ItemTemplate>
                                <span class='badge badge-<%# Eval("SeverityLevel") %>'>
                                    <%# Eval("SeverityLevel").ToString() == "Mild" ? "🟢" :
                                        Eval("SeverityLevel").ToString() == "Moderate" ? "🟡" : "🔴" %>
                                    <%# Eval("SeverityLevel") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="DiagnosedDate" HeaderText="Diagnosed" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="DoctorName"   HeaderText="Doctor" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton CommandName="ViewDetail" CommandArgument='<%# Eval("AllergyID") %>'
                                    runat="server" ForeColor="#2c7be5" Font-Bold="true">🔍 View</asp:LinkButton>
                                &nbsp;|&nbsp;
                                <asp:LinkButton CommandName="DeleteRow" CommandArgument='<%# Eval("AllergyID") %>'
                                    runat="server" ForeColor="#e74c3c"
                                    OnClientClick="return confirmDelete();">🗑 Delete</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <script type="text/javascript">
            // Confirmation popup before delete
            function confirmDelete() {
                return confirm('Are you sure you want to delete this allergy?\n\nThis will also delete all related symptoms, medications and incidents.');
            }
        </script>
    </form>
</body>
</html>
