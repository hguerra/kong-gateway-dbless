from python_jwt import jwt

if __name__ == '__main__':
    print ('Encode: ')
    token = jwt.encode()
    print(f'Bearer {token}')

    print ('\n\nDecode: ')
    print(jwt.decode(token))

    print ('\n\nRequest Example: ')
    print(jwt.request_kong())
