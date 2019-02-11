import uuid,random,string
user = uuid.uuid4()
chars =  string.ascii_letters+string.digits
pswd = "".join(random.choices(chars,k=64))
print("%s:%s" % (user, pswd))
