package br.com.orbitalguard.controller;

import br.com.orbitalguard.model.Alerta;
import br.com.orbitalguard.repository.AlertaRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/alertas")
public class AlertaController {

    private final AlertaRepository repo;

    public AlertaController(AlertaRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Alerta> listar() {
        return repo.findAll();
    }

    @GetMapping("/ativos")
    public List<Alerta> listarAtivos() {
        return repo.findByAtivoTrue();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Alerta> buscar(@PathVariable Long id) {
        return repo.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/cidade/{cidadeId}")
    public List<Alerta> porCidade(@PathVariable Long cidadeId) {
        return repo.findByCidadeId(cidadeId);
    }

    @PostMapping
    public Alerta criar(@RequestBody Alerta alerta) {
        return repo.save(alerta);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Alerta> atualizar(@PathVariable Long id, @RequestBody Alerta dados) {
        return repo.findById(id).map(alerta -> {
            alerta.setNivel(dados.getNivel());
            alerta.setDescricao(dados.getDescricao());
            alerta.setTipoDesastre(dados.getTipoDesastre());
            alerta.setAtivo(dados.getAtivo());
            return ResponseEntity.ok(repo.save(alerta));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        if (!repo.existsById(id)) return ResponseEntity.notFound().build();
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
