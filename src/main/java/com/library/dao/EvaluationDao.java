package com.library.dao;

import com.library.bean.Evaluation;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class EvaluationDao {

    private final static String NAMESPACE = "com.library.dao.EvaluationDao.";
    @Resource
    private SqlSessionTemplate sqlSessionTemplate;

    public int addEvaluation(final Evaluation evaluation) {
        return sqlSessionTemplate.insert(NAMESPACE + "addEvaluation", evaluation);
    }

    public ArrayList<Evaluation> getEvaluationsByBookId(final long book_id) {
        List<Evaluation> result = sqlSessionTemplate.selectList(NAMESPACE + "getEvaluationsByBookId", book_id);
        return (ArrayList<Evaluation>) result;
    }

    public Evaluation getEvaluationByReader(final long book_id, final long reader_id) {
        Map<String, Object> map = new HashMap<>();
        map.put("book_id", book_id);
        map.put("reader_id", reader_id);
        return sqlSessionTemplate.selectOne(NAMESPACE + "getEvaluationByReader", map);
    }

    public double getAvgScore(final long book_id) {
        Double avg = sqlSessionTemplate.selectOne(NAMESPACE + "getAvgScore", book_id);
        return avg == null ? 0 : avg;
    }

    public int deleteEvaluation(final long eval_id) {
        return sqlSessionTemplate.delete(NAMESPACE + "deleteEvaluation", eval_id);
    }

    public int hasReturnedLend(final long book_id, final long reader_id) {
        Map<String, Object> map = new HashMap<>();
        map.put("book_id", book_id);
        map.put("reader_id", reader_id);
        return sqlSessionTemplate.selectOne(NAMESPACE + "hasReturnedLend", map);
    }

    public ArrayList<Evaluation> getAllEvaluations(final String search) {
        List<Evaluation> result = sqlSessionTemplate.selectList(NAMESPACE + "getAllEvaluations", search);
        return (ArrayList<Evaluation>) result;
    }

    public int replyEvaluation(final long eval_id, final String reply) {
        Map<String, Object> map = new HashMap<>();
        map.put("eval_id", eval_id);
        map.put("reply", reply);
        return sqlSessionTemplate.update(NAMESPACE + "replyEvaluation", map);
    }
}
