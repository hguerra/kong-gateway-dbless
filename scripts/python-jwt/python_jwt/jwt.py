import jwt
import requests
from uuid import uuid4
from datetime import datetime, timezone, timedelta

KONG_JWT_KEY = 'a36c3049b36249a3c9f8891cb127243c'
KONG_JWT_SECRET = 'e71829c351aa4242c2719cbfbe671c09'
JWT_EXP_MINUTES = 10


def encode():
    """
    encode user payload as a jwt
    :param user:
    :return:
    """
    return jwt.encode(
        payload={
            'iss': KONG_JWT_KEY,
            'iat': datetime.now(tz=timezone.utc),
            'exp': datetime.now(tz=timezone.utc) + timedelta(minutes=JWT_EXP_MINUTES),
            'sub': str(uuid4()),
            'given_name': 'Heitor',
            'family_name': 'Carneiro',
            'email': 'heitor@example.com',
            'roles': [
                'viewer',
                'accessapproval.approver',
            ],
        },
        key=KONG_JWT_SECRET,
        algorithm='HS256'
    )


def decode(token: str):
    """
    :param token: jwt token
    :return:
    """
    return jwt.decode(
        jwt=token,
        key=KONG_JWT_SECRET,
        algorithms=['HS256']
    )


def request_kong():
    url = 'http://localhost:8080/mock/request'
    headers = {'Authorization': f'Bearer {encode()}'}
    response = requests.get(url, headers=headers)
    return response.json()
