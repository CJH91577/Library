<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>评价管理</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/jquery-3.2.1.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script>
        $(function () {
            $('#header').load('admin_header.html');
        })
    </script>
</head>
<body background="img/u5.jpeg" style=" background-repeat:no-repeat ;
background-size:100% 100%;
background-attachment: fixed;">
<div id="header"></div>

<div style="position: relative;padding-top: 100px">
    <c:if test="${!empty error}">
        <div class="alert alert-danger alert-dismissable">
            <button type="button" class="close" data-dismiss="alert"
                    aria-hidden="true">
                &times;
            </button>
                ${error}
        </div>
    </c:if>
</div>

<div style="padding: 0px 550px 10px">
    <form method="get" action="admin_evaluations.html" class="form-inline" id="searchform">
        <div class="input-group">
            <input type="text" placeholder="输入书名、读者名或评价内容" class="form-control" id="search"
                   name="searchWord" value="${searchWord}">
            <span class="input-group-btn">
                <input type="submit" value="查询" class="btn btn-default">
            </span>
        </div>
    </form>
</div>

<div class="panel panel-default" style="width: 90%;margin-left: 5%">
    <div class="panel-heading">
        <h3 class="panel-title">
            评价查询
        </h3>
    </div>
    <div class="panel-body">
        <table class="table table-hover">
            <thead>
            <tr>
                <th>图书</th>
                <th>读者</th>
                <th>评分</th>
                <th>评价内容</th>
                <th>评价时间</th>
                <th>管理员回复</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${list}" var="e">
                <tr>
                    <td><c:out value="${e.bookName}"></c:out></td>
                    <td><c:out value="${e.readerName}"></c:out></td>
                    <td>
                        <c:forEach begin="1" end="${e.score}"><span style="color:#f0ad4e">★</span></c:forEach>
                        <c:forEach begin="1" end="${5 - e.score}"><span style="color:#f0ad4e">☆</span></c:forEach>
                    </td>
                    <td><c:out value="${e.content}"></c:out></td>
                    <td><fmt:formatDate value="${e.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>
                        <c:if test="${!empty e.reply}"><c:out value="${e.reply}"></c:out></c:if>
                        <c:if test="${empty e.reply}"><span style="color:#999">未回复</span></c:if>
                    </td>
                    <td>
                        <button type="button" class="btn btn-primary btn-xs" data-toggle="modal"
                                data-target="#replyModal"
                                onclick="setReply(<c:out value='${e.evalId}'></c:out>)">回复
                        </button>
                        <button type="button" class="btn btn-danger btn-xs"
                                onclick="deleteEvaluation(<c:out value='${e.evalId}'></c:out>)">删除
                        </button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="replyModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">回复评价</h4>
            </div>
            <div class="modal-body">
                <textarea id="replyContent" class="form-control" rows="4" maxlength="250"
                          placeholder="输入回复内容"></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="replySubmit">提交回复</button>
            </div>
        </div>
    </div>
</div>

<script>
    var currentEvalId = 0;

    function setReply(evalId) {
        currentEvalId = evalId;
        $('#replyContent').val('');
    }

    $('#replySubmit').click(function () {
        var reply = $('#replyContent').val();
        if (reply == '') {
            alert('回复内容不能为空！');
            return;
        }
        $.ajax({
            type: "POST",
            url: "api/evaluation/reply",
            data: {evalId: currentEvalId, reply: reply},
            dataType: "json",
            success: function (data) {
                alert(data.msg);
                if (data.stateCode.trim() === "1") {
                    window.location.reload();
                }
            }
        });
    });

    function deleteEvaluation(evalId) {
        if (!confirm('确定删除该评价？')) return;
        $.ajax({
            type: "POST",
            url: "api/evaluation/delete",
            data: {evalId: evalId},
            dataType: "json",
            success: function (data) {
                alert(data.msg);
                if (data.stateCode.trim() === "1") {
                    window.location.reload();
                }
            }
        });
    }
</script>

</body>
</html>
