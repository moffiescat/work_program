package com.example.work_program.service;

import com.example.work_program.entity.InterventionPlan;

import java.util.List;

public interface InterventionPlanService {
    List<InterventionPlan> findAll(Long elderId, String status);
    InterventionPlan findById(Long id);
    void add(InterventionPlan plan);
    void update(InterventionPlan plan);
    void deleteById(Long id);
}
