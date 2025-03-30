package com.alcholater.controller;

import com.alcholater.dto.ProductFilter;
import com.alcholater.dto.ProductInput;
import com.alcholater.model.AlcoholProduct;
import com.alcholater.service.AlcoholProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class AlcoholProductController {
    
    private final AlcoholProductService productService;
    
    @QueryMapping
    public List<AlcoholProduct> products(@Argument ProductFilter where) {
        return productService.getAllProducts(where);
    }
    
    @QueryMapping
    public AlcoholProduct product(@Argument String id) {
        return productService.getProductById(id).orElse(null);
    }
    
    @MutationMapping
    public AlcoholProduct createProduct(@Argument ProductInput input) {
        return productService.createProduct(input);
    }
    
    @MutationMapping
    public AlcoholProduct updateProduct(@Argument String id, @Argument ProductInput input) {
        return productService.updateProduct(id, input)
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));
    }
    
    @MutationMapping
    public Boolean deleteProduct(@Argument String id) {
        return productService.deleteProduct(id);
    }
}