<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>회원가입 페이지</title>
    <!-- css 가져오기 -->
    <link rel="stylesheet" type="text/css" href="semantic.min.css">

    <style type="text/css">
        body {
            background-color: #DADADA;
        }

        body>.grid {
            height: 100%;
        }

        .image {
            margin-top: -100px;
        }

        .column {
            max-width: 450px;
        }

    </style>
</head>

<body>
    <div class="ui middle aligned center aligned grid">
        <div class="column">
            <h2 class="ui teal image header">
                회원가입 페이지
            </h2>
            <div class="ui large form">
                <div class="ui stacked segment">
                    <div class="field">
                        <div class="ui left icon input">
                            <input type="text" id="u_name" placeholder="이름">
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <input type="text" id="u_id" placeholder="아이디" autofocus autocomplete="off">
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <input type="password" id="u_pw" placeholder="비밀번호">
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <input type="password" id="u_pw2" placeholder="비밀번호 확인">
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <input type="tel" id="u_tel" placeholder="전화번호">
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <input type="text" id="u_email" placeholder="Email">
                        </div>
                    </div>
                    <button class="ui fluid large teal submit button" id="register_btn">회원가입</button>
                </div>

                <div class="ui error message"></div>

            </div>

            <div class="ui message">
                로그인 할 계정이 있다면 <a href="/index">여기</a>를 눌러주세요.
            </div>
        </div>
    </div>
    <!-- js 가져오기 -->
    <script src="/jquery3.3.1.min.js"></script>
    <script src="/semantic.min.js"></script>
    <script>
        $(document).ready(function() {
            $("#register_btn").click(function() {
                var json = {
                    u_name: $("#u_name").val(),
                    u_id: $("#u_id").val(),
                    u_pw: $("#u_pw").val(),
                    u_pw2: $("#u_pw2").val(),
                    u_tel: $("#u_tel").val(),
                    u_email: $("#u_email").val()
                };

                for (var str in json) {
                    if (json[str].length == 0) {
                        alert($("#" + str).attr("placeholder") + " 정보를 입력해주세요.");
                        $("#" + str).focus();
                        return false;
                    }
                }

                $.ajax({
                    contentType: 'application/json; charset=utf-8',
					type : "POST",
					url : "/doRegister",
					data : JSON.stringify(json),
					success : function(data) {
                        if (data == "occupied") {
                            alert('이미 사용중인 아이디입니다.')
                        }
                        else if (data == "wrongCheck") {
                            alert('비밀번호를 다시 확인해 주십시오.')
                        }
                        else if(data == "available"){
                            alert('회원가입 성공!')
                            location.href = "/";
                        }
					},
					/*error : function(error) {
						alert("오류 발생"+ error);
					}*/
				});
            });
        });

    </script>
</body>

</html>
