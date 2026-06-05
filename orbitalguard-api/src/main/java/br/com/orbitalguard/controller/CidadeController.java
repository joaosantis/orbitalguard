package br.com.orbitalguard.controller;

import br.com.orbitalguard.model.Cidade;
import br.com.orbitalguard.repository.CidadeRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cidades")
public class CidadeController {

    private final CidadeRepository repo;

    public CidadeController(CidadeRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Cidade> listar() {
        return repo.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Cidade> buscar(@PathVariable Long id) {
        return repo.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Cidade criar(@RequestBody Cidade cidade) {
        return repo.save(cidade);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Cidade> atualizar(@PathVariable Long id, @RequestBody Cidade dados) {
        return repo.findById(id).map(cidade -> {
            cidade.setNome(dados.getNome());
            cidade.setEstado(dados.getEstado());
            cidade.setLatitude(dados.getLatitude());
            cidade.setLongitude(dados.getLongitude());
            cidade.setPopulacao(dados.getPopulacao());
            return ResponseEntity.ok(repo.save(cidade));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        if (!repo.existsById(id)) return ResponseEntity.notFound().build();
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
