package com.example.work_program.service;

import com.example.work_program.entity.ImageReport;

import java.util.List;

public interface ImageReportService {
    ImageReport findById(Long id);
    List<ImageReport> findByElderId(Long elderId);
    List<ImageReport> findByCollectionId(Long collectionId);
    List<ImageReport> findAll(Long elderId, String imageType);
    void add(ImageReport report);
    void update(ImageReport report);
    void deleteById(Long id);
    Long countByElderId(Long elderId);
}
