apiVersion: v1
kind: Secret
metadata:
  name: postgres-credentials
  namespace: burger-shop
type: Opaque
data:
  # Generated secure passwords (base64 encoded)
  requests-db-password: UEAkc3cwcmQxMjM0NTY3ODk=  # P@ssw0rd123456789
  shelf-db-password: QDBtcGxAeF8xMjM0NTY3ODk=    # C0mpl@x_123456789