-- AI+老年认知衰弱分级干预与智能管理系统 - 数据库初始化脚本

CREATE DATABASE IF NOT EXISTS cognitive_health DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE cognitive_health;

-- 用户表
CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    status INT DEFAULT 1 COMMENT '状态 0:禁用 1:正常',
    role VARCHAR(20) COMMENT '角色 admin/doctor/nurse',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

-- 老年人健康档案表
CREATE TABLE IF NOT EXISTS elder_health_record (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    gender VARCHAR(10) COMMENT '性别',
    birth_date DATE COMMENT '出生日期',
    id_card VARCHAR(20) UNIQUE COMMENT '身份证号',
    phone VARCHAR(20) COMMENT '联系电话',
    address VARCHAR(200) COMMENT '住址',
    emergency_contact VARCHAR(50) COMMENT '紧急联系人',
    emergency_phone VARCHAR(20) COMMENT '紧急联系电话',
    medical_history TEXT COMMENT '既往病史',
    family_history TEXT COMMENT '家族病史',
    cognitive_baseline VARCHAR(20) COMMENT '认知基线',
    risk_level VARCHAR(20) COMMENT '风险等级 normal/mild/moderate/severe',
    status INT DEFAULT 1 COMMENT '状态 0:非活跃 1:活跃',
    create_by VARCHAR(50) COMMENT '创建人',
    update_by VARCHAR(50) COMMENT '更新人',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='老年人健康档案表';

-- 认知评估记录表
CREATE TABLE IF NOT EXISTS cognitive_assessment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    elder_id BIGINT NOT NULL COMMENT '老人ID',
    assessment_type VARCHAR(50) COMMENT '评估类型',
    total_score INT COMMENT '总分',
    risk_level VARCHAR(20) COMMENT '风险等级',
    assessment_result TEXT COMMENT '评估结果',
    recommendations TEXT COMMENT '建议',
    assessor VARCHAR(50) COMMENT '评估人',
    assessment_place VARCHAR(100) COMMENT '评估地点',
    assessment_time DATETIME COMMENT '评估时间',
    next_assessment_date DATE COMMENT '下次评估日期',
    remark TEXT COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (elder_id) REFERENCES elder_health_record(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='认知评估记录表';

-- 干预计划表
CREATE TABLE IF NOT EXISTS intervention_plan (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    elder_id BIGINT NOT NULL COMMENT '老人ID',
    plan_name VARCHAR(100) NOT NULL COMMENT '计划名称',
    plan_type VARCHAR(50) COMMENT '计划类型 cognitive/lifestyle/rehabilitation',
    risk_level VARCHAR(20) COMMENT '风险等级',
    cognitive_training TEXT COMMENT '认知训练内容',
    lifestyle_intervention TEXT COMMENT '生活方式干预',
    rehabilitation_plan TEXT COMMENT '康复计划',
    goals TEXT COMMENT '目标',
    start_date DATE COMMENT '开始日期',
    end_date DATE COMMENT '结束日期',
    responsible_doctor VARCHAR(50) COMMENT '负责人',
    status INT DEFAULT 0 COMMENT '状态 0:待执行 1:进行中 2:已完成 3:已暂停',
    remark TEXT COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (elder_id) REFERENCES elder_health_record(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='干预计划表';

-- 干预执行记录表
CREATE TABLE IF NOT EXISTS intervention_execution (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    plan_id BIGINT COMMENT '计划ID',
    elder_id BIGINT NOT NULL COMMENT '老人ID',
    execution_type VARCHAR(50) COMMENT '执行类型',
    content TEXT COMMENT '执行内容',
    execution_date DATE COMMENT '执行日期',
    duration INT COMMENT '持续时间(分钟)',
    effect_evaluation TEXT COMMENT '效果评价',
    evaluator VARCHAR(50) COMMENT '评价人',
    remark TEXT COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (plan_id) REFERENCES intervention_plan(id),
    FOREIGN KEY (elder_id) REFERENCES elder_health_record(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='干预执行记录表';

-- 健康数据采集表
CREATE TABLE IF NOT EXISTS health_data_collection (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    elder_id BIGINT NOT NULL COMMENT '老人ID',
    data_source VARCHAR(50) COMMENT '数据来源 smart/questionnaire/image',
    data_type VARCHAR(50) COMMENT '数据类型',
    data_content TEXT COMMENT '数据内容',
    attachment_url VARCHAR(500) COMMENT '附件URL',
    collection_date DATE COMMENT '采集日期',
    collector VARCHAR(50) COMMENT '采集人',
    remark TEXT COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (elder_id) REFERENCES elder_health_record(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康数据采集表';

-- 插入默认管理员账户
INSERT INTO sys_user (username, password, real_name, role, status) VALUES
('admin', 'admin123', '系统管理员', 'admin', 1),
('doctor1', 'doctor123', '张医生', 'doctor', 1),
('nurse1', 'nurse123', '李护士', 'nurse', 1);
