<%@ Page Title="Dashboard" Language="C#" 
AutoEventWireup="true" CodeBehind="Login.aspx.cs"
Inherits="AllergyTracker.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Allergy Tracker - Login</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f4f8; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; flex-direction: column; }
        .login-box { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 380px; }
        h2 { text-align: center; color: #2c7be5; margin-bottom: 25px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; color: #333; }
        input[type=text], input[type=password] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; font-size: 14px; }
        .btn { width: 100%; padding: 12px; background: #2c7be5; color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; margin-top: 10px; }
        .btn:hover { background: #1a5fc8; }
        .error { color: red; font-size: 13px; margin-top: 3px; display: block; }
        .msg { text-align: center; margin-top: 15px; }
        .msg a { color: #2c7be5; text-decoration: none; }
        .alert-error { background: #ffe0e0; color: #c0392b; padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center; }
    </style>
</head>

<body>

    <form id="form1" runat="server">
        <div class="login-box">
            <h2>🩺 Allergy Tracker</h2>
       
            <asp:Label ID="lblMessage" runat="server" CssClass="alert-error" Visible="false" />
          
            <div class="form-group">
                <label>Username</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                    ControlToValidate="txtUsername"
                    ErrorMessage="Username is required."
                    CssClass="error" Display="Dynamic" />
            </div>

            <div class="form-group">
                <label>Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                    ControlToValidate="txtPassword"
                    ErrorMessage="Password is required."
                    CssClass="error" Display="Dynamic" />
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn" OnClick="btnLogin_Click" />

            <div class="msg">
                Don't have an account? <a href="Register.aspx">Register here</a>
            </div>
        </div>
    </form>

</body>
</html>