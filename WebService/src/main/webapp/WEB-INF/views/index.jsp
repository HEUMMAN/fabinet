<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>로그인 페이지</title>
    <!-- css 가져오기 -->
    <link rel="stylesheet" type="text/css" href="/semantic.min.css">

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
 				로그인 페이지
            </h2>
            <form class="ui large form">
                <div class="ui stacked segment">
                    <div class="field">
                        <div class="ui left icon input">
                            <input type="text" id="u_id" placeholder="아이디">
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <input type="password" id="u_pw" placeholder="비밀번호">
                        </div>
                    </div>
                    <div class="ui fluid large teal submit button" id = "login_btn">로그인</div>
                </div>

                <div class="ui error message"></div>

            </form>

            <div class="ui message">
                로그인 할 계정이 없다면 <a href="createAccount">여기</a>를 눌러주세요.
            </div>
        </div>
    </div>
    <!-- js 가져오기 -->
    <script src="/jquery3.3.1.min.js"></script>
    <script src="/semantic.min.js"></script>
    <script>
	    $(document).ready(function(){
			$("#login_btn").click(function(){
				var json = {
					u_id : $("#u_id").val(),
					u_pw : $("#u_pw").val()
				};
				
				for(var str in json){
					if(json[str].length == 0){
						alert($("#" + str).attr("placeholder") + "를 입력해주세요.");
						$("#" + str).focus();
						return;
					}
				}
				
				 $.ajax({
					type : "POST",
					url : "/doLogin",
					data : json,
					success : function(data) {
					    console.log(data);
                        if (data == 'F-2') {
                            alert('비밀번호가 일치하지 않습니다.')
                        }
                        else if(data == 'F-1'){
                            alert('존재하지 않는 아이디입니다.')
                        }
                        else {
                            location.href = "/";
                        }
					},
					/*error : function(error) {
                        console.log(error);
						alert("오류 발생"+ error);
					}*/
				});
			});
		});
    </script>
</body>

</html>
