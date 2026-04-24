package com.example.work_program.dto;

import lombok.Data;

@Data
public class ImageUploadDTO {
    private Long elderId;
    private String imageType;
    private String description;
    private String imageData;
}
