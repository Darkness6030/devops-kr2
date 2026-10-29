from pathlib import Path
import grpc
from . import api_pb2, api_pb2_grpc

def roll_die(addr):
    creds = grpc.ssl_channel_credentials(
        Path('certs/ca.pem').read_bytes(),
        Path('certs/client-key.pem').read_bytes(),
        Path('certs/client.pem').read_bytes())
    with grpc.secure_channel(addr, creds) as channel:
        stub = api_pb2_grpc.DiceServiceStub(channel)
        return stub.RollDie(api_pb2.RollDieRequest(), timeout=5).value
