package com.alcholater.repository;

import com.alcholater.model.AlcoholProduct;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AlcoholProductRepository extends MongoRepository<AlcoholProduct, String> {
    
    /**
     * Find all products for a specific user
     * @param userId the ID of the user
     * @return list of products
     */
    List<AlcoholProduct> findByUserId(String userId);
}