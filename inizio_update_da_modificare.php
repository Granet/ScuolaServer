UPDATE ftpuser set passwd=ENCRYPT(:newpw) where userid = :userid and passwd=ENCRYPT(:oldpw)



inserisci nome utente
inserisci vecchia password
inserisci nuova password
