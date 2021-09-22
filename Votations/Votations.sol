// SPDX-License_Identifier: MIT
pragma solidity >=0.5.4 <0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------
//  CANDIDATO  /   EDAD  /   ID
// -----------------------------
//  Joan    /   20  /   12345X
//  Maria   /   23  /   02468T
//  Marta   /   21  /   13579U
//  Alba    /   19  /   98765Z

contract Votations {

    //  Direccion del propietario del contrato
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    //  relacion entre nombre de candidato y hash de datos personales
    mapping(string => bytes32) candidateDataMapping;

    //  relacion entre nombre de candidato y cantidad de votos
    mapping(string => uint) candidateVotesMapping;

    //  lista de candidatos
    string[] candidateList;

    //  lista de votantes en formate bytes32
    bytes32[] voterList;

    //  funcion para presentarse a las elecciones
    function represent(string memory personName, uint personAge, string memory personId) public {
        bytes32 personIdHash = keccak256(abi.encodePacked(personName, personAge, personId));
        candidateDataMapping[personName] = personIdHash;
        candidateList.push(personIdHash);
    }

    function viewCandidate() public view returns (string[] memory) {
        return candidateList;
    }

    function votingCandidate(string memory candidateName) public {
        bytes32 voterHash = keccak256(abi.encodePacked(msg.sender));
        for (uint i = 0; i < voterList.length(); i++) {
            require(voterList[i] != voterHash, "El votante ya voto");
        }
        voterList.push(voterHash);
        candidateVotesMapping[candidateName] ++;
    }

    //  funcion para visualizar la cantidad de votos que tiene un candidato
    function viewVotes(string memory candidateName) public view returns (uint){
        return candidateVotesMapping[candidateName];
    }

    function viewResults() public view returns (string memory){
        string memory results;
        for (uint i = 0; i < candidateList.length(); i++) {
            results = string(abi.encodePacked(results, candidateList[i], uint2str(viewVotes(candidateList[i]))));
        }
        return results;
    }

    function candidateWinner() public view returns (string memory) {
        string memory winner = candidateList[0];
        bool flag;
        for (uint i = 1; i < candidateList.length(); i++) {
            if (candidateVotesMapping[winner] < candidateVotesMapping[candidateList[i]]) {
                winner = candidateList[i];
                flag = false;
            } else if (candidateVotesMapping[winner] == candidateVotesMapping[candidateList[i]]) {
                flag = true;
            }
            if (flag == true) {
                winner = "Empate";
            }
        }
        return winner;
    }

}
