pragma solidity ^0.8.0;

contract Decoder {
    function decodeData(
        bytes calldata data
    ) external view returns (address owner, uint256 threshold) {
        // Inicializar las variables de retorno con valores nulos.
        owner = address(0);
        threshold = 0;

        // Verificar si la data es al menos del tamaño mínimo esperado.
        if (data.length < 4 + 32 + 32) {
            return (owner, threshold);
        }

        // Intentar decodificar la data, manejando el caso en que la decodificación falle.
        try this.decodeParameters(data) returns (
            address _owner,
            uint256 _threshold
        ) {
            return (_owner, _threshold);
        } catch {
            // En caso de fallo, simplemente retornar los valores nulos.
            return (owner, threshold);
        }
    }

    // Una función auxiliar para realizar la decodificación. Debe ser `external` para usar `try-catch`.
    function decodeParameters(
        bytes calldata data
    ) external pure returns (address owner, uint256 threshold) {
        // Omitir el selector de función y decodificar.
        (owner, threshold) = abi.decode(data[4:], (address, uint256));
    }
}
