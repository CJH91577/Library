<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>《 ${detail.name}》</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/jquery-3.2.1.js"></script>
    <script src="js/bootstrap.min.js" ></script>
    <script>
        $(function () {
            $('#header').load('reader_header.html');
        })
    </script>
</head>
<body background="img/lizhi.jpg" style=" background-repeat:no-repeat ;
background-size:100% 100%;
background-attachment: fixed;">
<div id="header"></div>
<div class="col-xs-6 col-md-offset-3" style="position: relative;top: 3%">
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">《 ${detail.name}》</h3>
        </div>
        <div class="panel-body">
            <table class="table table-hover">
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
                    <th>状态</th>
                    <c:if test="${detail.number>1}">
                        <td>在馆</td>
                    </c:if>
                    <c:if test="${detail.number==0}">
                        <td>借出</td>
                    </c:if>

                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="panel panel-info">
        <div class="panel-heading">
            <h3 class="panel-title">读者评价（<span id="evalAvg">-</span> 分 · <span id="evalCount">0</span> 条）</h3>
        </div>
        <div class="panel-body">
            <div id="evalForm" style="display:none;margin-bottom:15px;padding:10px;border:1px solid #ddd;border-radius:4px;">
                <label style="display:block">评分：<span id="starInput"></span></label>
                <textarea id="evalContent" class="form-control" rows="3" maxlength="250" placeholder="写下你的评价（可留空）"></textarea>
                <button id="evalSubmit" type="button" class="btn btn-primary" style="margin-top:10px;">提交评价</button>
            </div>
            <ul id="evalList" class="list-group" style="margin-bottom:0;"></ul>
        </div>
    </div>
    <script>
        var bookId = ${detail.bookId};
        var selectedScore = 0;

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

        function renderStarInput() {
            var html = '';
            for (var i = 1; i <= 5; i++) {
                html += '<span class="star-btn" data-star="' + i + '" style="cursor:pointer;color:#f0ad4e;font-size:22px;">' + (i <= selectedScore ? '★' : '☆') + '</span>';
            }
            $('#starInput').html(html);
        }

        function loadEvaluations() {
            $.ajax({
                type: "GET",
                url: "api/evaluations",
                data: {bookId: bookId},
                dataType: "json",
                success: function (data) {
                    $('#evalAvg').text(data.avgScore);
                    $('#evalCount').text(data.count);
                    var html = '';
                    $.each(data.list, function (i, e) {
                        html += '<li class="list-group-item"><strong>' + escapeHtml(e.reader_name) + '</strong> '
                            + starHtml(e.score) + ' <small>' + formatTime(e.create_time) + '</small>'
                            + '<p style="margin:5px 0 0 0;">' + escapeHtml(e.content) + '</p>'
                            + (e.reply != null
                                ? '<div style="margin-top:5px;padding:5px;background:#f5f5f5;border-radius:4px;"><small><strong>管理员回复：</strong>' + escapeHtml(e.reply) + '</small></div>'
                                : '')
                            + '</li>';
                    });
                    if (data.list.length == 0) {
                        html = '<li class="list-group-item">暂无评价</li>';
                    }
                    $('#evalList').html(html);
                    if (data.loggedIn) {
                        $('#evalForm').show();
                        if (data.mine != null) {
                            selectedScore = data.mine.score;
                            $('#evalContent').val(data.mine.content);
                            $('#evalSubmit').text('修改评价');
                        } else {
                            selectedScore = 0;
                            $('#evalContent').val('');
                            $('#evalSubmit').text('提交评价');
                        }
                        renderStarInput();
                    }
                }
            });
        }

        $(document).on('click', '.star-btn', function () {
            selectedScore = parseInt($(this).data('star'));
            renderStarInput();
        });

        $('#evalSubmit').click(function () {
            if (selectedScore == 0) {
                alert('请先选择星级！');
                return;
            }
            $.ajax({
                type: "POST",
                url: "api/evaluation/add",
                data: {bookId: bookId, score: selectedScore, content: $('#evalContent').val()},
                dataType: "json",
                success: function (data) {
                    alert(data.msg);
                    if (data.stateCode.trim() === "1") {
                        loadEvaluations();
                    }
                }
            });
        });

        $(function () {
            loadEvaluations();
        });
    </script>
</div>

</body>
</html>
