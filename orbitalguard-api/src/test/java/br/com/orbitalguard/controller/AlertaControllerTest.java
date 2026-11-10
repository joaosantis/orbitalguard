package br.com.orbitalguard.controller;

import br.com.orbitalguard.model.Alerta;
import br.com.orbitalguard.model.Cidade;
import br.com.orbitalguard.repository.AlertaRepository;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AlertaController.class)
class AlertaControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private AlertaRepository repo;

    private Alerta criarAlerta(Long id, String nivel, String tipo, boolean ativo) {
        Alerta a = new Alerta();
        a.setId(id);
        a.setNivel(nivel);
        a.setDescricao("Alerta de teste");
        a.setTipoDesastre(tipo);
        a.setAtivo(ativo);
        a.setDataHora(LocalDateTime.now());
        Cidade c = new Cidade();
        c.setId(1L);
        c.setNome("São Paulo");
        c.setEstado("SP");
        c.setLatitude(-23.5505);
        c.setLongitude(-46.6333);
        a.setCidade(c);
        return a;
    }

    @Test
    void deveListarTodosAlertas() throws Exception {
        Mockito.when(repo.findAll()).thenReturn(List.of(
                criarAlerta(1L, "ALTO", "ENCHENTE", true),
                criarAlerta(2L, "CRITICO", "DESLIZAMENTO", true)
        ));

        mockMvc.perform(get("/alertas"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2));
    }

    @Test
    void deveListarAlertasAtivos() throws Exception {
        Mockito.when(repo.findByAtivoTrue()).thenReturn(List.of(
                criarAlerta(1L, "ALTO", "ENCHENTE", true)
        ));

        mockMvc.perform(get("/alertas/ativos"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].nivel").value("ALTO"))
                .andExpect(jsonPath("$[0].ativo").value(true));
    }

    @Test
    void deveRetornar404QuandoAlertaNaoExiste() throws Exception {
        Mockito.when(repo.findById(99L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/alertas/99"))
                .andExpect(status().isNotFound());
    }

    @Test
    void deveListarAlertasPorCidade() throws Exception {
        Mockito.when(repo.findByCidadeId(1L)).thenReturn(List.of(
                criarAlerta(1L, "ALTO", "ENCHENTE", true)
        ));

        mockMvc.perform(get("/alertas/cidade/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].tipoDesastre").value("ENCHENTE"));
    }
}
