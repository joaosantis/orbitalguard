package br.com.dimdim.controller;

import br.com.dimdim.model.Conta;
import br.com.dimdim.repository.ContaRepository;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/contas")
public class ContaController {

    private final ContaRepository repository;

    public ContaController(ContaRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Conta> listar() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public Conta buscar(@PathVariable Long id) {
        return repository.findById(id).orElseThrow();
    }
}
