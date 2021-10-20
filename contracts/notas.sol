// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract notas {

  address public profesor;

  mapping(bytes32 => uint) notasAsignatura;
  
  string[] revisiones;

  constructor () {
    profesor = msg.sender;
  }

  event alumnoEvaluado(bytes32, uint);
  event eventoRevision(string);
  
  // Funcion que evalua nota con los permisos restringidos para que la ejecute el profesor
  function evaluar(string memory _idAlumno, uint _nota) public unicamenteProfesor (msg.sender) {
    // Has identificacion del alumno
    bytes32 hasIdAlumno =  keccak256(abi.encode(_idAlumno));
    // Relacion entre el hasIdAlumno y la nota
    notasAsignatura[hasIdAlumno] = _nota;
    // Emision del evento
    emit alumnoEvaluado(hasIdAlumno, _nota);
  }

  modifier unicamenteProfesor (address _direccion) {
    // Requiere la direccion introducida sea igual al owner
    // Si no se cumple devuelve mensaje
    require(_direccion == profesor, "No tiene permiso para ralizar la operacion.");
    _;
  }
  
  function consultaNota(string memory _idAlumno) public view returns (uint) {
    // Has identificacion del alumno
    bytes32 hasIdAlumno =  keccak256(abi.encode(_idAlumno));
    uint notaAlumno = notasAsignatura[hasIdAlumno];
    return notaAlumno;
  }
  
  function revisionNota(string memory _idAlumno) public{
    revisiones.push(_idAlumno);
    emit eventoRevision(_idAlumno);
  }
  
  function verRevisiones() public view unicamenteProfesor (msg.sender) returns (string [] memory) {
      return revisiones;
  }
}
