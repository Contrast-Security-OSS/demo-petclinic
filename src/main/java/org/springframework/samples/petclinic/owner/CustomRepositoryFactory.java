package org.springframework.samples.petclinic.owner;

import java.io.Serializable;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
//import org.springframework.data.jpa.repository.support.QueryDslJpaRepository; //1.5.4.RELEASE
//import org.springframework.data.jpa.repository.support.QuerydslJpaPredicateExecutor; //2.1.0.RELEASE
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.data.repository.core.RepositoryInformation;
import org.springframework.data.repository.core.RepositoryMetadata;

/**
 *
 * The purpose of this class is to override the default behaviour of the spring JpaRepositoryFactory class.
 * It will produce a GenericRepositoryImpl object instead of SimpleJpaRepository.
 *
 */
public class CustomRepositoryFactory extends JpaRepositoryFactory {
 
    public CustomRepositoryFactory(EntityManager entityManager) {
    		super(entityManager);
    }
     
    @SuppressWarnings({ "unchecked", "rawtypes" })
    protected <T, ID extends Serializable> JpaRepository<?, ?> getTargetRepository(
            RepositoryMetadata metadata, EntityManager entityManager) {
 
        Class<?> repositoryInterface = metadata.getRepositoryInterface();
        
        RepositoryInformation information = 
        			getRepositoryInformation(metadata, null);
        
        JpaEntityInformation<?, Serializable> entityInformation =
                getEntityInformation(metadata.getDomainType());
 
        System.out.println("CustomRepositoryFactory1 - repositoryInterface: " + repositoryInterface.getName());
        if (repositoryInterface.getName().endsWith("OwnerRepository")) {
            //return new OwnerRepositoryCustomImpl((JpaEntityInformation<Owner, ?>) entityInformation, entityManager); //custom implementation
        		return null;
        } else {
        		return getTargetRepositoryViaReflection(information, entityInformation, entityManager);
        }
    }
  
    @Override
    protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {
    	 
        Class<?> repositoryInterface = metadata.getRepositoryInterface();

        System.out.println("CustomRepositoryFactory2 - repositoryInterface: " + repositoryInterface.getName());
        if (repositoryInterface.getName().endsWith("OwnerRepository")) {
            return OwnerRepositoryCustomImpl.class;  // custom implementation
        } else {
            return SimpleJpaRepository.class;
        }
    } 
}
