package com.library.service;

import com.library.bean.Evaluation;
import com.library.dao.EvaluationDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

@Service
public class EvaluationService {
    @Autowired
    private EvaluationDao evaluationDao;

    public boolean hasReturnedLend(long bookId, long readerId) {
        return evaluationDao.hasReturnedLend(bookId, readerId) > 0;
    }

    public boolean addEvaluation(Evaluation evaluation) {
        return evaluationDao.addEvaluation(evaluation) > 0;
    }

    public ArrayList<Evaluation> getEvaluationsByBookId(long bookId) {
        return evaluationDao.getEvaluationsByBookId(bookId);
    }

    public Evaluation getEvaluationByReader(long bookId, long readerId) {
        return evaluationDao.getEvaluationByReader(bookId, readerId);
    }

    public double getAvgScore(long bookId) {
        return evaluationDao.getAvgScore(bookId);
    }

    public boolean deleteEvaluation(long evalId) {
        return evaluationDao.deleteEvaluation(evalId) > 0;
    }

    public ArrayList<Evaluation> getAllEvaluations(String search) {
        return evaluationDao.getAllEvaluations(search);
    }

    public boolean replyEvaluation(long evalId, String reply) {
        return evaluationDao.replyEvaluation(evalId, reply) > 0;
    }
}
