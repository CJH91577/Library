package com.library.controller;

import com.library.bean.Admin;
import com.library.bean.Evaluation;
import com.library.bean.ReaderCard;
import com.library.service.EvaluationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;

@Controller
public class EvaluationController {

    @Autowired
    private EvaluationService evaluationService;

    //获取某本书的评价列表、平均分，以及当前读者已提交的评价（用于表单回填）
    @RequestMapping(value = "/api/evaluations", method = RequestMethod.GET)
    public @ResponseBody
    Object evaluations(HttpServletRequest request) {
        long bookId = Long.parseLong(request.getParameter("bookId"));
        HashMap<String, Object> res = new HashMap<>();
        ArrayList<Evaluation> list = evaluationService.getEvaluationsByBookId(bookId);
        res.put("list", list);
        res.put("avgScore", evaluationService.getAvgScore(bookId));
        res.put("count", list.size());
        ReaderCard readerCard = (ReaderCard) request.getSession().getAttribute("readercard");
        res.put("loggedIn", readerCard != null);
        if (readerCard != null) {
            res.put("mine", evaluationService.getEvaluationByReader(bookId, readerCard.getReaderId()));
        }
        return res;
    }

    //提交或修改评价：仅限借阅过并已归还该书的读者
    @RequestMapping(value = "/api/evaluation/add", method = RequestMethod.POST)
    public @ResponseBody
    Object addEvaluation(HttpServletRequest request) {
        HashMap<String, Object> res = new HashMap<>();
        ReaderCard readerCard = (ReaderCard) request.getSession().getAttribute("readercard");
        if (readerCard == null) {
            res.put("stateCode", "0");
            res.put("msg", "请先登录！");
            return res;
        }
        long bookId = Long.parseLong(request.getParameter("bookId"));
        int score = Integer.parseInt(request.getParameter("score"));
        String content = request.getParameter("content");
        if (score < 1 || score > 5) {
            res.put("stateCode", "0");
            res.put("msg", "评分必须在1到5星之间！");
            return res;
        }
        if (!evaluationService.hasReturnedLend(bookId, readerCard.getReaderId())) {
            res.put("stateCode", "0");
            res.put("msg", "只有借阅过并已归还该书的读者才能评价！");
            return res;
        }
        Evaluation evaluation = new Evaluation();
        evaluation.setBookId(bookId);
        evaluation.setReaderId(readerCard.getReaderId());
        evaluation.setScore(score);
        evaluation.setContent(content);
        if (evaluationService.addEvaluation(evaluation)) {
            res.put("stateCode", "1");
            res.put("msg", "评价成功！");
        } else {
            res.put("stateCode", "0");
            res.put("msg", "评价失败！");
        }
        return res;
    }

    //管理员删除评价
    @RequestMapping(value = "/api/evaluation/delete", method = RequestMethod.POST)
    public @ResponseBody
    Object deleteEvaluation(HttpServletRequest request) {
        HashMap<String, Object> res = new HashMap<>();
        Admin admin = (Admin) request.getSession().getAttribute("admin");
        if (admin == null) {
            res.put("stateCode", "0");
            res.put("msg", "请先登录管理员账号！");
            return res;
        }
        long evalId = Long.parseLong(request.getParameter("evalId"));
        if (evaluationService.deleteEvaluation(evalId)) {
            res.put("stateCode", "1");
            res.put("msg", "评价删除成功！");
        } else {
            res.put("stateCode", "0");
            res.put("msg", "评价删除失败！");
        }
        return res;
    }

    //评价管理页：查询全部评价（支持按书名、读者名、评价内容模糊查询）
    @RequestMapping("/admin_evaluations.html")
    public ModelAndView adminEvaluations(HttpServletRequest request) {
        String searchWord = request.getParameter("searchWord");
        if (searchWord == null || searchWord.trim().equals("")) {
            searchWord = "%%";
        } else {
            searchWord = "%" + searchWord.trim() + "%";
        }
        ModelAndView modelAndView = new ModelAndView("admin_evaluations");
        modelAndView.addObject("list", evaluationService.getAllEvaluations(searchWord));
        modelAndView.addObject("searchWord", request.getParameter("searchWord"));
        return modelAndView;
    }

    //管理员回复评价
    @RequestMapping(value = "/api/evaluation/reply", method = RequestMethod.POST)
    public @ResponseBody
    Object replyEvaluation(HttpServletRequest request) {
        HashMap<String, Object> res = new HashMap<>();
        Admin admin = (Admin) request.getSession().getAttribute("admin");
        if (admin == null) {
            res.put("stateCode", "0");
            res.put("msg", "请先登录管理员账号！");
            return res;
        }
        long evalId = Long.parseLong(request.getParameter("evalId"));
        String reply = request.getParameter("reply");
        if (reply == null || reply.trim().equals("")) {
            res.put("stateCode", "0");
            res.put("msg", "回复内容不能为空！");
            return res;
        }
        if (evaluationService.replyEvaluation(evalId, reply.trim())) {
            res.put("stateCode", "1");
            res.put("msg", "回复成功！");
        } else {
            res.put("stateCode", "0");
            res.put("msg", "回复失败！");
        }
        return res;
    }
}
