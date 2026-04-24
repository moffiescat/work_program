package com.example.work_program.controller;

import com.example.work_program.annotation.LoginRequired;
import com.example.work_program.common.Result;
import com.example.work_program.entity.HealthDataCollection;
import com.example.work_program.service.HealthDataCollectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/data")
@LoginRequired
public class HealthDataCollectionController {

    @Autowired
    private HealthDataCollectionService healthDataCollectionService;

    @GetMapping("/list")
    public Result<List<HealthDataCollection>> list(
            @RequestParam(required = false) Long elderId,
            @RequestParam(required = false) String dataSource) {
        return Result.success(healthDataCollectionService.findAll(elderId, dataSource));
    }

    @GetMapping("/{id}")
    public Result<HealthDataCollection> getById(@PathVariable Long id) {
        return Result.success(healthDataCollectionService.findById(id));
    }

    @PostMapping("/add")
    @LoginRequired(roles = {"admin", "doctor", "nurse"})
    public Result<Void> add(@RequestBody HealthDataCollection data) {
        healthDataCollectionService.add(data);
        return Result.success("数据采集记录添加成功", null);
    }

    @PutMapping("/update")
    @LoginRequired(roles = {"admin", "doctor", "nurse"})
    public Result<Void> update(@RequestBody HealthDataCollection data) {
        healthDataCollectionService.update(data);
        return Result.success("更新成功", null);
    }

    @DeleteMapping("/delete/{id}")
    @LoginRequired(roles = {"admin", "doctor"})
    public Result<Void> delete(@PathVariable Long id) {
        healthDataCollectionService.deleteById(id);
        return Result.success("删除成功", null);
    }
}
