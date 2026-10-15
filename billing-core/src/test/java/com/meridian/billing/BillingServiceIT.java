package com.meridian.billing;

import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertTrue;

class BillingServiceIT {

    @Test
    void packagedJarShouldExist() {
        Path jar = Path.of(
            "target",
            "billing-core-1.0-SNAPSHOT.jar"
        );

        assertTrue(
            Files.exists(jar),
            "The billing-core JAR should exist after packaging"
        );
    }
}
