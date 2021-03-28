package Fabinet.Fabinet.Repository;

import Fabinet.Fabinet.Domain.Board;

import java.util.List;

public interface BoardRepository {

    public void save(Board board);

    public List<Board> findAll();
}
