package com.alcholater.dto;

import lombok.Data;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;

@Data
public class ProductInput {
    
    @NotBlank(message = "Product name is required")
    private String name;
    
    @NotNull(message = "Price is required")
    @Positive(message = "Price must be positive")
    private BigDecimal price;
    
    @NotNull(message = "Volume is required")
    @Positive(message = "Volume must be positive")
    private BigDecimal volume;
    
    @NotNull(message = "Alcohol percentage is required")
    @Positive(message = "Alcohol percentage must be positive")
    private BigDecimal alcoholPercentage;
    
    private String userId;
}