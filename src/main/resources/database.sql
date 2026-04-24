-- 数据影像采集系统数据库更新脚本
-- MySQL 5.7版本

USE cognitive_health;

-- 添加新字段（如果不存在则添加）
SET @column_exists = 0;
SELECT COUNT(*) INTO @column_exists
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'cognitive_health'
AND TABLE_NAME = 'health_data_collection'
AND COLUMN_NAME = 'report_no';
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE health_data_collection ADD COLUMN report_no VARCHAR(50) COMMENT "报告编号" AFTER data_type',
    'SELECT "Column report_no already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists = 0;
SELECT COUNT(*) INTO @column_exists
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'cognitive_health'
AND TABLE_NAME = 'health_data_collection'
AND COLUMN_NAME = 'institution';
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE health_data_collection ADD COLUMN institution VARCHAR(100) COMMENT "检测机构"',
    'SELECT "Column institution already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists = 0;
SELECT COUNT(*) INTO @column_exists
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'cognitive_health'
AND TABLE_NAME = 'health_data_collection'
AND COLUMN_NAME = 'doctor_name';
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE health_data_collection ADD COLUMN doctor_name VARCHAR(50) COMMENT "诊断医生"',
    'SELECT "Column doctor_name already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists = 0;
SELECT COUNT(*) INTO @column_exists
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'cognitive_health'
AND TABLE_NAME = 'health_data_collection'
AND COLUMN_NAME = 'diagnosis_date';
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE health_data_collection ADD COLUMN diagnosis_date DATE COMMENT "诊断日期"',
    'SELECT "Column diagnosis_date already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists = 0;
SELECT COUNT(*) INTO @column_exists
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'cognitive_health'
AND TABLE_NAME = 'health_data_collection'
AND COLUMN_NAME = 'examination_items';
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE health_data_collection ADD COLUMN examination_items TEXT COMMENT "检查项目"',
    'SELECT "Column examination_items already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists = 0;
SELECT COUNT(*) INTO @column_exists
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'cognitive_health'
AND TABLE_NAME = 'health_data_collection'
AND COLUMN_NAME = 'image_thumb_url';
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE health_data_collection ADD COLUMN image_thumb_url VARCHAR(500) COMMENT "影像缩略图URL"',
    'SELECT "Column image_thumb_url already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists = 0;
SELECT COUNT(*) INTO @column_exists
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'cognitive_health'
AND TABLE_NAME = 'health_data_collection'
AND COLUMN_NAME = 'report_status';
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE health_data_collection ADD COLUMN report_status VARCHAR(20) DEFAULT "pending" COMMENT "报告状态"',
    'SELECT "Column report_status already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 创建影像报告详情表
CREATE TABLE IF NOT EXISTS image_report (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    collection_id BIGINT NOT NULL COMMENT '采集记录ID',
    elder_id BIGINT NOT NULL COMMENT '老人ID',
    image_type VARCHAR(50) NOT NULL COMMENT '影像类型 ct/mri/xray/ultrasound/other',
    image_url VARCHAR(500) NOT NULL COMMENT '影像URL',
    thumb_url VARCHAR(500) COMMENT '缩略图URL',
    report_no VARCHAR(50) COMMENT '报告编号',
    institution VARCHAR(100) COMMENT '检测机构',
    doctor_name VARCHAR(50) COMMENT '阅片医生',
    diagnosis_date DATE COMMENT '诊断日期',
    diagnosis_result TEXT COMMENT '诊断结果',
    diagnosis_description TEXT COMMENT '诊断描述',
    abnormal_indicators TEXT COMMENT '异常指标',
    upload_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
    INDEX idx_elder_id (elder_id),
    INDEX idx_collection_id (collection_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='影像报告详情表';

-- 创建智能评估记录表
CREATE TABLE IF NOT EXISTS smart_assessment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    collection_id BIGINT NOT NULL COMMENT '采集记录ID',
    elder_id BIGINT NOT NULL COMMENT '老人ID',
    assessment_type VARCHAR(50) NOT NULL COMMENT '评估类型 cognitive/motor/vital',
    assessment_items TEXT COMMENT '评估项目(JSON格式)',
    total_score INT COMMENT '总分',
    score_level VARCHAR(20) COMMENT '得分等级 normal/mild/moderate/severe',
    assessment_result TEXT COMMENT '评估结果',
    recommendations TEXT COMMENT '建议',
    assessor VARCHAR(50) COMMENT '评估人',
    assessment_device VARCHAR(100) COMMENT '评估设备',
    assessment_time DATETIME COMMENT '评估时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_elder_id (elder_id),
    INDEX idx_collection_id (collection_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能评估记录表';

-- 创建健康问询记录表
CREATE TABLE IF NOT EXISTS health_questionnaire (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    collection_id BIGINT NOT NULL COMMENT '采集记录ID',
    elder_id BIGINT NOT NULL COMMENT '老人ID',
    questionnaire_type VARCHAR(50) NOT NULL COMMENT '问询类型 medical/family/lifestyle/symptom',
    questions TEXT NOT NULL COMMENT '问题内容(JSON格式问题数组)',
    answers TEXT NOT NULL COMMENT '回答内容(JSON格式回答数组)',
    risk_factors TEXT COMMENT '风险因素分析',
    summary TEXT COMMENT '问询摘要',
    surveyor VARCHAR(50) COMMENT '调查员',
    survey_time DATETIME COMMENT '问询时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_elder_id (elder_id),
    INDEX idx_collection_id (collection_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康问询记录表';
