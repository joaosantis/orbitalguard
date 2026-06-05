package br.com.orbitalguard.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "alerta")
public class Alerta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "cidade_id", nullable = false)
    private Cidade cidade;

    @Column(nullable = false, length = 20)
    private String nivel; // BAIXO, MEDIO, ALTO, CRITICO

    @Column(nullable = false, length = 255)
    private String descricao;

    @Column(name = "tipo_desastre", nullable = false, length = 50)
    private String tipoDesastre; // ENCHENTE, QUEIMADA, DESLIZAMENTO

    @Column(name = "data_hora", nullable = false)
    private LocalDateTime dataHora;

    @Column(name = "ativo", nullable = false)
    private Boolean ativo = true;

    @PrePersist
    public void prePersist() {
        if (dataHora == null) dataHora = LocalDateTime.now();
    }
}
