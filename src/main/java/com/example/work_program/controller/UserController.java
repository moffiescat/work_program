package com.example.work_program.controller;

import com.example.work_program.annotation.LoginRequired;
import com.example.work_program.common.Result;
import com.example.work_program.entity.User;
import com.example.work_program.service.UserService;
import com.example.work_program.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody User user) {
        User loginUser = userService.login(user.getUsername(), user.getPassword());
        if (loginUser != null) {
            String token = jwtUtil.generateToken(loginUser.getId(), loginUser.getUsername(), loginUser.getRole());
            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("user", loginUser);
            return Result.success("登录成功", data);
        }
        return Result.error(401, "用户名或密码错误");
    }

    @GetMapping("/list")
    @LoginRequired
    public Result<List<User>> list(
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String realName) {
        return Result.success(userService.findAll(username, realName));
    }

    @GetMapping("/{id}")
    @LoginRequired
    public Result<User> getById(@PathVariable Long id) {
        return Result.success(userService.findById(id));
    }

    @PostMapping("/add")
    @LoginRequired(roles = {"admin"})
    public Result<Void> add(@RequestBody User user) {
        userService.add(user);
        return Result.success("添加成功", null);
    }

    @PutMapping("/update")
    @LoginRequired(roles = {"admin", "doctor"})
    public Result<Void> update(@RequestBody User user) {
        userService.update(user);
        return Result.success("更新成功", null);
    }

    @DeleteMapping("/delete/{id}")
    @LoginRequired(roles = {"admin"})
    public Result<Void> delete(@PathVariable Long id) {
        userService.deleteById(id);
        return Result.success("删除成功", null);
    }
}
