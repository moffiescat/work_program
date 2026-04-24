package com.example.work_program.service.impl;

import com.example.work_program.entity.User;
import com.example.work_program.mapper.UserMapper;
import com.example.work_program.service.UserService;
import com.example.work_program.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    public User login(String username, String password) {
        User user = userMapper.findByUsernameAndPassword(username, password);
        if (user != null) {
            String token = jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole());
            user.setPassword(null);
            return user;
        }
        return null;
    }

    @Override
    public User findById(Long id) {
        return userMapper.findById(id);
    }

    @Override
    public List<User> findAll(String username, String realName) {
        return userMapper.findAll(username, realName);
    }

    @Override
    public void add(User user) {
        userMapper.insert(user);
    }

    @Override
    public void update(User user) {
        userMapper.update(user);
    }

    @Override
    public void deleteById(Long id) {
        userMapper.deleteById(id);
    }
}
