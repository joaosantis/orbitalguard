package br.com.dimdim.controller;

import br.com.dimdim.model.Transacao;
import br.com.dimdim.repository.TransacaoRepository;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/transacoes")
public class TransacaoController {

    private final TransacaoRepository repository;

    public TransacaoController(TransacaoRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Transacao> listar() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public Transacao buscar(@PathVariable Long id) {
        return repository.findById(id).orElseThrow();
    }
}
