<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="AllergyTracker.Register" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Allergy Tracker - Register</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f4f8; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; padding: 20px 0; box-sizing: border-box; }
        .box { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 420px; }
        h2 { text-align: center; color: #2c7be5; margin-bottom: 25px; }
        .form-group { margin-bottom: 14px; }
        label { display: block; font-weight: bold; margin-bottom: 4px; color: #333; font-size: 14px; }
        input[type=text], input[type=password], select { width: 100%; padding: 9px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; font-size: 14px; }
        .btn { width: 100%; padding: 12px; background: #27ae60; color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; margin-top: 10px; }
        .btn:hover { background: #1e8449; }
        .error { color: red; font-size: 12px; display: block; margin-top: 2px; }
        .msg { text-align: center; margin-top: 15px; font-size: 14px; }
        .msg a { color: #2c7be5; text-decoration: none; }
        .alert-success { background: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center; }
        .alert-error   { background: #ffe0e0; color: #c0392b; padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="box">
            <h2>📝 Create Account</h2>

            <asp:Label ID="lblMessage" runat="server" Visible="false" />

            <div class="form-group">
                <label>Full Name</label>
                <asp:TextBox ID="txtFullName" runat="server" />
                <asp:RequiredFieldValidator ControlToValidate="txtFullName" runat="server"
                    ErrorMessage="Full name is required." CssClass="error" Display="Dynamic" />
            </div>

            <div class="form-group">
                <label>Email</label>
                <asp:TextBox ID="txtEmail" runat="server" />
                <asp:RequiredFieldValidator ControlToValidate="txtEmail" runat="server"
                    ErrorMessage="Email is required." CssClass="error" Display="Dynamic" />
                <asp:RegularExpressionValidator ControlToValidate="txtEmail" runat="server"
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                    ErrorMessage="Enter a valid email address." CssClass="error" Display="Dynamic" />
            </div>

            <div class="form-group">
                <label>Username</label>
                <asp:TextBox ID="txtUsername" runat="server" />
                <asp:RequiredFieldValidator ControlToValidate="txtUsername" runat="server"
                    ErrorMessage="Username is required." CssClass="error" Display="Dynamic" />
                <asp:RegularExpressionValidator ControlToValidate="txtUsername" runat="server"
                    ValidationExpression="^[a-zA-Z0-9_]{4,20}$"
                    ErrorMessage="4-20 characters, letters/numbers/underscore only." CssClass="error" Display="Dynamic" />
            </div>

            <div class="form-group">
                <label>Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
                <asp:RequiredFieldValidator ControlToValidate="txtPassword" runat="server"
                    ErrorMessage="Password is required." CssClass="error" Display="Dynamic" />
                <asp:RegularExpressionValidator ControlToValidate="txtPassword" runat="server"
                    ValidationExpression="^(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{6,}$"
                    ErrorMessage="Min 6 chars, 1 uppercase, 1 number, 1 special char." CssClass="error" Display="Dynamic" />
            </div>

            <div class="form-group">
                <label>Confirm Password</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" />
                <asp:RequiredFieldValidator ControlToValidate="txtConfirmPassword" runat="server"
                    ErrorMessage="Please confirm password." CssClass="error" Display="Dynamic" />
                <asp:CompareValidator ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" runat="server"
                    ErrorMessage="Passwords do not match." CssClass="error" Display="Dynamic" />
            </div>

            <div class="form-group">
                <label>Date of Birth</label>
                <asp:TextBox ID="txtDOB" runat="server" placeholder="YYYY-MM-DD" />
                <asp:RangeValidator ControlToValidate="txtDOB" runat="server"
                    MinimumValue="1900-01-01" MaximumValue="2015-12-31"
                    Type="Date"
                    ErrorMessage="Enter a valid date of birth." CssClass="error" Display="Dynamic" />
            </div>

            <div class="form-group">
                <label>Gender</label>
                <asp:DropDownList ID="ddlGender" runat="server">
                    <asp:ListItem Value="">-- Select --</asp:ListItem>
                    <asp:ListItem Value="Male">Male</asp:ListItem>
                    <asp:ListItem Value="Female">Female</asp:ListItem>
                    <asp:ListItem Value="Other">Other</asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn" OnClick="btnRegister_Click" />

            <div class="msg">Already have an account? <a href="Login.aspx">Login here</a></div>
        </div>
    </form>
</body>
</html>
