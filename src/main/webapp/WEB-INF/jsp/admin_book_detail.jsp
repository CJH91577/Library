<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>《 ${detail.name}》</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/jquery-3.2.1.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script>
        $(function () {
            $('#header').load('admin_header.html');
        })
    </script>
</head>
<body background="../../static/img/book2.jpg" style=" background-repeat:no-repeat ;
background-size:100% 100%;
background-attachment: fixed;">
<div id="header" style="padding-bottom: 80px"></div>

<div class="col-xs-6 col-md-offset-3">
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">《 ${detail.name}》</h3>
        </div>
        <div class="panel-body">
            <table class="table table-hover">
                <tbody>
                <tr>
                    <th width="15%">书名</th>
                    <td>${detail.name}</td>
                </tr>
                <tr>
                    <th>作者</th>
                    <td>${detail.author}</td>
                </tr>
                <tr>
                    <th>出版社</th>
                    <td>${detail.publish}</td>
                </tr>
                <tr>
                    <th>ISBN</th>
                    <td>${detail.isbn}</td>
                </tr>
                <tr>
                    <th>简介</th>
                    <td>${detail.introduction}</td>
                </tr>
                <tr>
                    <th>语言</th>
                    <td>${detail.language}</td>
                </tr>
                <tr>
                    <th>价格</th>
                    <td>${detail.price}</td>
                </tr>
                <tr>
                    <th>出版日期</th>
                    <td>${detail.pubdate}</td>
                </tr>
                <tr>
                    <th>分类号</th>
                    <td>${detail.classId}</td>
                </tr>
                <tr>
                    <th>数量</th>
                    <td>${detail.number}</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="panel panel-danger">
        <div class="panel-heading">
            <h3 class="panel-title">读者评价（<span id="evalCount">0</span> 条）</h3>
        </div>
        <div class="panel-body">
            <ul id="evalList" class="list-group" style="margin-bottom:0;"></ul>
        </div>
    </div>
    <script>
        var bookId = ${detail.bookId};

        function escapeHtml(text) {
            if (text == null) return '';
            return $('<div>').text(text).html();
        }

        function starHtml(score) {
            var html = '';
            for (var i = 1; i <= 5; i++) {
                html += '<span style="color:#f0ad4e;">' + (i <= score ? '★' : '☆') + '</span>';
            }
            return html;
        }

        function formatTime(t) {
            if (!t) return '';
            var d = new Date(t);
            return d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2) + '-' + ('0' + d.getDate()).slice(-2) + ' '
                + ('0' + d.getHours()).slice(-2) + ':' + ('0' + d.getMinutes()).slice(-2);
        }

        function loadEvaluations() {
            $.ajax({
                type: "GET",
                url: "api/evaluations",
                data: {bookId: bookId},
                dataType: "json",
                success: function (data) {
                    $('#evalCount').text(data.count);
                    var html = '';
                    $.each(data.list, function (i, e) {
                        html += '<li class="list-group-item"><strong>' + escapeHtml(e.reader_name) + '</strong> '
                            + starHtml(e.score) + ' <small>' + formatTime(e.create_time) + '</small>'
                            + '<p style="margin:5px 0 5px 0;">' + escapeHtml(e.content) + '</p>'
                            + '<button type="button" class="btn btn-danger btn-xs" onclick="deleteEvaluation(' + e.eval_id + ')">删除</button></li>';
                    });
                    if (data.list.length == 0) {
                        html = '<li class="list-group-item">暂无评价</li>';
                    }
                    $('#evalList').html(html);
                }
            });
        }

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
                        loadEvaluations();
                    }
                }
            });
        }

        $(function () {
            loadEvaluations();
        });
    </script>
</div>

</body>
</html>
