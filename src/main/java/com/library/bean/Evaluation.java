package com.library.bean;

import java.io.Serializable;
import java.util.Date;

public class Evaluation implements Serializable {

    private long eval_id;
    private long book_id;
    private long reader_id;
    private int score;
    private String content;
    private Date create_time;
    private String reader_name;
    private String book_name;
    private String reply;
    private Date reply_time;

    public long getEvalId() {
        return eval_id;
    }

    public void setEvalId(long eval_id) {
        this.eval_id = eval_id;
    }

    public long getBookId() {
        return book_id;
    }

    public void setBookId(long book_id) {
        this.book_id = book_id;
    }

    public long getReaderId() {
        return reader_id;
    }

    public void setReaderId(long reader_id) {
        this.reader_id = reader_id;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreateTime() {
        return create_time;
    }

    public void setCreateTime(Date create_time) {
        this.create_time = create_time;
    }

    public String getReaderName() {
        return reader_name;
    }

    public void setReaderName(String reader_name) {
        this.reader_name = reader_name;
    }

    public String getBookName() {
        return book_name;
    }

    public void setBookName(String book_name) {
        this.book_name = book_name;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public Date getReplyTime() {
        return reply_time;
    }

    public void setReplyTime(Date reply_time) {
        this.reply_time = reply_time;
    }
}
