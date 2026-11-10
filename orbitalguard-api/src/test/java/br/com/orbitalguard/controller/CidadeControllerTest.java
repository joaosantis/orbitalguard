package br.com.orbitalguard.controller;

import br.com.orbitalguard.model.Cidade;
import br.com.orbitalguard.repository.CidadeRepository;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Optional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(CidadeController.class)
class CidadeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private CidadeRepository repo;

    @Test
    void deveListarCidades() throws Exception {
        Cidade c = new Cidade();
        c.setId(1L);
        c.setNome("São Paulo");
        c.setEstado("SP");
        c.setLatitude(-23.5505);
        c.setLongitude(-46.6333);
        c.setPopulacao(12300000);
        Mockito.when(repo.findAll()).thenReturn(List.of(c));

        mockMvc.perform(get("/cidades"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].nome").value("São Paulo"))
                .andExpect(jsonPath("$[0].estado").value("SP"));
    }

    @Test
    void deveRetornar404QuandoCidadeNaoExiste() throws Exception {
        Mockito.when(repo.findById(99L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/cidades/99"))
                .andExpect(status().isNotFound());
    }

    @Test
    void deveBuscarCidadePorId() throws Exception {
        Cidade c = new Cidade();
        c.setId(1L);
        c.setNome("Rio de Janeiro");
        c.setEstado("RJ");
        c.setLatitude(-22.9068);
        c.setLongitude(-43.1729);
        Mockito.when(repo.findById(1L)).thenReturn(Optional.of(c));

        mockMvc.perform(get("/cidades/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nome").value("Rio de Janeiro"));
    }
}
