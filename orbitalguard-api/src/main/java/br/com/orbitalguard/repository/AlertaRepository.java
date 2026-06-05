package br.com.orbitalguard.repository;

import br.com.orbitalguard.model.Alerta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface AlertaRepository extends JpaRepository<Alerta, Long> {
    List<Alerta> findByCidadeId(Long cidadeId);
    List<Alerta> findByAtivoTrue();
}
