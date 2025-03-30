package com.alcholater.service;

import com.alcholater.dto.ProductFilter;
import com.alcholater.dto.ProductInput;
import com.alcholater.model.AlcoholProduct;
import com.alcholater.repository.AlcoholProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AlcoholProductService {
    
    private final AlcoholProductRepository productRepository;
    
    /**
     * Get all products, optionally filtered by user
     * @param filter the filter criteria
     * @return list of products
     */
    public List<AlcoholProduct> getAllProducts(ProductFilter filter) {
        if (filter != null && filter.getUserId() != null && !filter.getUserId().isEmpty()) {
            return productRepository.findByUserId(filter.getUserId());
        }
        return productRepository.findAll();
    }
    
    /**
     * Get a product by ID
     * @param id the product ID
     * @return the product if found
     */
    public Optional<AlcoholProduct> getProductById(String id) {
        return productRepository.findById(id);
    }
    
    /**
     * Create a new product
     * @param input the product data
     * @return the created product
     */
    public AlcoholProduct createProduct(ProductInput input) {
        AlcoholProduct product = AlcoholProduct.builder()
                .name(input.getName())
                .price(input.getPrice())
                .volume(input.getVolume())
                .alcoholPercentage(input.getAlcoholPercentage())
                .userId(input.getUserId())
                .build();
                
        return productRepository.save(product);
    }
    
    /**
     * Update an existing product
     * @param id the product ID
     * @param input the updated product data
     * @return the updated product
     */
    public Optional<AlcoholProduct> updateProduct(String id, ProductInput input) {
        return productRepository.findById(id)
                .map(product -> {
                    product.setName(input.getName());
                    product.setPrice(input.getPrice());
                    product.setVolume(input.getVolume());
                    product.setAlcoholPercentage(input.getAlcoholPercentage());
                    if (input.getUserId() != null) {
                        product.setUserId(input.getUserId());
                    }
                    return productRepository.save(product);
                });
    }
    
    /**
     * Delete a product
     * @param id the product ID
     * @return true if deleted, false if not found
     */
    public boolean deleteProduct(String id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return true;
        }
        return false;
    }
}