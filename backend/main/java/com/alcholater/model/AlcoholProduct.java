package com.alcholater.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "alcohol_products")
public class AlcoholProduct {
    
    @Id
    private String id;
    
    private String name;
    
    private BigDecimal price;
    
    private BigDecimal volume;
    
    private BigDecimal alcoholPercentage;
    
    private String userId;
    
    /**
     * Calculate the value ratio (ml of pure alcohol per dollar)
     * @return value ratio in ml of pure alcohol per dollar
     */
    public BigDecimal getValueRatio() {
        if (price.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal pureAlcoholMl = volume.multiply(alcoholPercentage);
        return pureAlcoholMl.divide(price, 4, RoundingMode.HALF_UP);
    }
    
    /**
     * Calculate the price per liter
     * @return price per liter
     */
    public BigDecimal getPricePerLiter() {
        if (volume.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        return price.divide(volume, 4, RoundingMode.HALF_UP)
                .multiply(new BigDecimal("1000"));
    }
    
    /**
     * Calculate the standard drinks
     * @return number of standard drinks
     */
    public BigDecimal getStandardDrinks() {
        // A standard drink contains about 14 grams of pure alcohol
        // Density of alcohol is about 0.789 g/ml
        BigDecimal pureAlcoholMl = volume.multiply(alcoholPercentage);
        BigDecimal pureAlcoholGrams = pureAlcoholMl.multiply(new BigDecimal("0.789"));
        return pureAlcoholGrams.divide(new BigDecimal("14"), 2, RoundingMode.HALF_UP);
    }
    
    /**
     * Calculate the price per standard drink
     * @return price per standard drink
     */
    public BigDecimal getPricePerStandardDrink() {
        BigDecimal drinks = getStandardDrinks();
        if (drinks.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        return price.divide(drinks, 2, RoundingMode.HALF_UP);
    }
}