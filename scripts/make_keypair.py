"""Create the keypair for the POC's read-only EHR client.

    python scripts/make_keypair.py <client_id> [output_folder]

Writes <client_id>.pem (PRIVATE: keep it on this machine, never commit it, never email it)
and <client_id>.jwks.json (PUBLIC: this is what you send to hospital IT to register your client).
Needs the packages in poc/requirements.txt (pyjwt and cryptography).
"""
import json
import os
import sys
from pathlib import Path

import jwt
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa


def main() -> None:
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    client_id = sys.argv[1]
    out = Path(sys.argv[2] if len(sys.argv) > 2 else ".")
    out.mkdir(parents=True, exist_ok=True)
    key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    pem = out / f"{client_id}.pem"
    pem.write_bytes(key.private_bytes(serialization.Encoding.PEM, serialization.PrivateFormat.PKCS8, serialization.NoEncryption()))
    os.chmod(pem, 0o600)
    jwk = json.loads(jwt.algorithms.RSAAlgorithm.to_jwk(key.public_key()))
    jwk.update(kid=client_id, use="sig", alg="RS256")
    jwks = out / f"{client_id}.jwks.json"
    jwks.write_text(json.dumps({"keys": [jwk]}, indent=2))
    print(f"private key (keep secret): {pem}")
    print(f"public keys (send to IT):   {jwks}")


if __name__ == "__main__":
    main()
