USE KargoSistemi;
GO
-- adres bilgileri
CREATE TABLE ULKE
(
    ulke_id INT IDENTITY(1,1) NOT NULL,
    ad NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_ULKE PRIMARY KEY (ulke_id)
);
GO

CREATE TABLE IL
(
    il_id INT IDENTITY(1,1) NOT NULL,
    ulke_id INT NOT NULL,
    ad NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_IL PRIMARY KEY (il_id),
    CONSTRAINT FK_IL_ULKE FOREIGN KEY (ulke_id) REFERENCES ULKE(ulke_id)
);
GO

CREATE TABLE ILCE
(
    ilce_id INT IDENTITY(1,1) NOT NULL,
    il_id INT NOT NULL,
    ad NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_ILCE PRIMARY KEY (ilce_id),
    CONSTRAINT FK_ILCE_IL FOREIGN KEY (il_id) REFERENCES IL(il_id)
);
GO

CREATE TABLE MAHALLE
(
    mahalle_id INT IDENTITY(1,1) NOT NULL,
    ilce_id INT NOT NULL,
    mahalle_adi NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_MAHALLE PRIMARY KEY (mahalle_id),
    CONSTRAINT FK_MAHALLE_ILCE FOREIGN KEY (ilce_id) REFERENCES ILCE(ilce_id)
);
GO

CREATE TABLE CADDE_SOKAK
(
    cadde_sokak_id INT IDENTITY(1,1) NOT NULL,
    mahalle_id INT NOT NULL,
    cadde_sokak_adi NVARCHAR(150) NOT NULL,
    CONSTRAINT PK_CADDE_SOKAK PRIMARY KEY (cadde_sokak_id),
    CONSTRAINT FK_CADDE_SOKAK_MAHALLE FOREIGN KEY (mahalle_id) REFERENCES MAHALLE(mahalle_id)
);
GO

CREATE TABLE ADRES
(
    adres_id INT IDENTITY(1,1) NOT NULL,
    cadde_sokak_id INT NOT NULL,
    dis_kapi_no NVARCHAR(20) NOT NULL,
    ic_kapi_no NVARCHAR(20) NULL,
    adres_aciklama NVARCHAR(250) NULL,
    CONSTRAINT PK_ADRES PRIMARY KEY (adres_id),
    CONSTRAINT FK_ADRES_CADDE_SOKAK FOREIGN KEY (cadde_sokak_id) REFERENCES CADDE_SOKAK(cadde_sokak_id)
);
GO

-- müşteri ve firma bilgileri
CREATE TABLE MUSTERI
(
    musteri_tc CHAR(11) NOT NULL,
    adres_id INT NOT NULL,
    ad NVARCHAR(100) NOT NULL,
    soyad NVARCHAR(100) NOT NULL,
    telefon NVARCHAR(20) NOT NULL,
    e_posta NVARCHAR(150) NULL,
    CONSTRAINT PK_MUSTERI PRIMARY KEY (musteri_tc),
    CONSTRAINT FK_MUSTERI_ADRES FOREIGN KEY (adres_id) REFERENCES ADRES(adres_id)
);
GO

CREATE TABLE GONDERICI_MARKA
(
    firma_id INT IDENTITY(1,1) NOT NULL,
    firma_adi NVARCHAR(150) NOT NULL,
    vergi_no NVARCHAR(20) NOT NULL,
    CONSTRAINT PK_GONDERICI_MARKA PRIMARY KEY (firma_id)
);
GO

CREATE TABLE SIGORTA_SIRKETI
(
    sigorta_id INT IDENTITY(1,1) NOT NULL,
    sirket_adi NVARCHAR(150) NOT NULL,
    iletisim_bilgisi NVARCHAR(200) NULL,
    CONSTRAINT PK_SIGORTA_SIRKETI PRIMARY KEY (sigorta_id)
);
GO

-- şube ve personel bilgileri
CREATE TABLE SUBE
(
    sube_no INT IDENTITY(1,1) NOT NULL,
    adres_id INT NOT NULL,
    ad NVARCHAR(150) NOT NULL,
    telefon NVARCHAR(20) NOT NULL,
    e_posta NVARCHAR(150) NULL,
    CONSTRAINT PK_SUBE PRIMARY KEY (sube_no),
    CONSTRAINT FK_SUBE_ADRES FOREIGN KEY (adres_id) REFERENCES ADRES(adres_id)
);
GO

CREATE TABLE GOREV
(
    gorev_id INT IDENTITY(1,1) NOT NULL,
    gorev_adi NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_GOREV PRIMARY KEY (gorev_id)
);
GO

CREATE TABLE PERSONEL
(
    personel_tc CHAR(11) NOT NULL,
    gorev_id INT NOT NULL,
    sube_no INT NOT NULL,
    adres_id INT NOT NULL,
    ad NVARCHAR(100) NOT NULL,
    soyad NVARCHAR(100) NOT NULL,
    telefon NVARCHAR(20) NOT NULL,
    maas DECIMAL(10,2) NOT NULL,
    ise_giris_tarihi DATE NOT NULL,
    isten_cikis_tarihi DATE NULL,
    CONSTRAINT PK_PERSONEL PRIMARY KEY (personel_tc),
    CONSTRAINT FK_PERSONEL_GOREV FOREIGN KEY (gorev_id) REFERENCES GOREV(gorev_id),
    CONSTRAINT FK_PERSONEL_SUBE FOREIGN KEY (sube_no) REFERENCES SUBE(sube_no),
    CONSTRAINT FK_PERSONEL_ADRES FOREIGN KEY (adres_id) REFERENCES ADRES(adres_id)
);
GO

CREATE TABLE ARAC
(
    plaka NVARCHAR(15) NOT NULL,
    sube_no INT NOT NULL,
    marka NVARCHAR(100) NOT NULL,
    model NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_ARAC PRIMARY KEY (plaka),
    CONSTRAINT FK_ARAC_SUBE FOREIGN KEY (sube_no) REFERENCES SUBE(sube_no)
);
GO

-- kargo ile ilgili bilgiler
CREATE TABLE ICERIK_TURU
(
    icerik_id INT IDENTITY(1,1) NOT NULL,
    ad NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_ICERIK_TURU PRIMARY KEY (icerik_id)
);
GO

CREATE TABLE UCRET_TARIFESI
(
    tarife_id INT IDENTITY(1,1) NOT NULL,
    firma_id INT NULL,
    baslangic_tarihi DATE NOT NULL,
    bitis_tarihi DATE NOT NULL,
    desi_alt_sinir DECIMAL(10,2) NOT NULL,
    desi_ust_sinir DECIMAL(10,2) NOT NULL,
    ucret DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_UCRET_TARIFESI PRIMARY KEY (tarife_id),
    CONSTRAINT FK_UCRET_TARIFESI_GONDERICI_MARKA FOREIGN KEY (firma_id) REFERENCES GONDERICI_MARKA(firma_id)
);
GO

CREATE TABLE EK_OZELLIK
(
    ek_ozellik_id INT IDENTITY(1,1) NOT NULL,
    ozellik_adi NVARCHAR(100) NOT NULL,
    ek_ozellik_ucret DECIMAL(10,2) NOT NULL,
    gecerlilik_baslangic_tarihi DATE NOT NULL,
    gecerlilik_bitis_tarihi DATE NULL,
    CONSTRAINT PK_EK_OZELLIK PRIMARY KEY (ek_ozellik_id)
);
GO

CREATE TABLE DURUM
(
    durum_id INT IDENTITY(1,1) NOT NULL,
    durum_adi NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_DURUM PRIMARY KEY (durum_id)
);
GO

CREATE TABLE GEL_AL_NOKTASI
(
    nokta_id INT IDENTITY(1,1) NOT NULL,
    adres_id INT NOT NULL,
    nokta_adi NVARCHAR(150) NOT NULL,
    kapasite INT NOT NULL,
    CONSTRAINT PK_GEL_AL_NOKTASI PRIMARY KEY (nokta_id),
    CONSTRAINT FK_GEL_AL_NOKTASI_ADRES FOREIGN KEY (adres_id) REFERENCES ADRES(adres_id)
);
GO

CREATE TABLE KARGO
(
    gonderi_no INT IDENTITY(1,1) NOT NULL,
    gonderici_tc CHAR(11) NOT NULL,
    alici_tc CHAR(11) NOT NULL,
    teslimat_adres_id INT NOT NULL,
    alan_sube_no INT NOT NULL,
    alan_personel_tc CHAR(11) NOT NULL,
    teslim_sube_no INT NULL,
    teslim_personel_tc CHAR(11) NULL,
    durum_id INT NOT NULL,
    icerik_id INT NOT NULL,
    sigorta_id INT NULL,
    tarife_id INT NOT NULL,
    nokta_id INT NULL,
    alim_tarih_saat DATETIME NOT NULL,
    teslim_tarih_saat DATETIME NULL,
    en DECIMAL(10,2) NOT NULL,
    boy DECIMAL(10,2) NOT NULL,
    yukseklik DECIMAL(10,2) NOT NULL,
    agirlik DECIMAL(10,2) NOT NULL,
    desi DECIMAL(10,2) NOT NULL,
    kargo_ucreti DECIMAL(10,2) NOT NULL,
    ek_ucret_toplami DECIMAL(10,2) NOT NULL,
    toplam_ucret DECIMAL(10,2) NOT NULL,
    odeyen_taraf NVARCHAR(50) NOT NULL,
    odeme_yontemi NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_KARGO PRIMARY KEY (gonderi_no),
    CONSTRAINT FK_KARGO_GONDERICI FOREIGN KEY (gonderici_tc) REFERENCES MUSTERI(musteri_tc),
    CONSTRAINT FK_KARGO_ALICI FOREIGN KEY (alici_tc) REFERENCES MUSTERI(musteri_tc),
    CONSTRAINT FK_KARGO_TESLIMAT_ADRES FOREIGN KEY (teslimat_adres_id) REFERENCES ADRES(adres_id),
    CONSTRAINT FK_KARGO_ALAN_SUBE FOREIGN KEY (alan_sube_no) REFERENCES SUBE(sube_no),
    CONSTRAINT FK_KARGO_ALAN_PERSONEL FOREIGN KEY (alan_personel_tc) REFERENCES PERSONEL(personel_tc),
    CONSTRAINT FK_KARGO_TESLIM_SUBE FOREIGN KEY (teslim_sube_no) REFERENCES SUBE(sube_no),
    CONSTRAINT FK_KARGO_TESLIM_PERSONEL FOREIGN KEY (teslim_personel_tc) REFERENCES PERSONEL(personel_tc),
    CONSTRAINT FK_KARGO_DURUM FOREIGN KEY (durum_id) REFERENCES DURUM(durum_id),
    CONSTRAINT FK_KARGO_ICERIK_TURU FOREIGN KEY (icerik_id) REFERENCES ICERIK_TURU(icerik_id),
    CONSTRAINT FK_KARGO_SIGORTA_SIRKETI FOREIGN KEY (sigorta_id) REFERENCES SIGORTA_SIRKETI(sigorta_id),
    CONSTRAINT FK_KARGO_UCRET_TARIFESI FOREIGN KEY (tarife_id) REFERENCES UCRET_TARIFESI(tarife_id),
    CONSTRAINT FK_KARGO_GEL_AL_NOKTASI FOREIGN KEY (nokta_id) REFERENCES GEL_AL_NOKTASI(nokta_id)
);
GO

CREATE TABLE KARGO_EK_OZELLIK
(
    gonderi_no INT NOT NULL,
    ek_ozellik_id INT NOT NULL,
    CONSTRAINT PK_KARGO_EK_OZELLIK PRIMARY KEY (gonderi_no, ek_ozellik_id),
    CONSTRAINT FK_KARGO_EK_OZELLIK_KARGO FOREIGN KEY (gonderi_no) REFERENCES KARGO(gonderi_no),
    CONSTRAINT FK_KARGO_EK_OZELLIK_EK_OZELLIK FOREIGN KEY (ek_ozellik_id) REFERENCES EK_OZELLIK(ek_ozellik_id)
);
GO

-- kargo hareketleri
CREATE TABLE HAREKET_TURU
(
    hareket_turu_id INT IDENTITY(1,1) NOT NULL,
    ad NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_HAREKET_TURU PRIMARY KEY (hareket_turu_id)
);
GO

CREATE TABLE HAREKET
(
    hareket_id INT IDENTITY(1,1) NOT NULL,
    gonderi_no INT NOT NULL,
    hareket_turu_id INT NOT NULL,
    personel_tc CHAR(11) NOT NULL,
    plaka NVARCHAR(15) NULL,
    baslangic_sube_no INT NOT NULL,
    bitis_sube_no INT NULL,
    tarih_saat DATETIME NOT NULL,
    CONSTRAINT PK_HAREKET PRIMARY KEY (hareket_id),
    CONSTRAINT FK_HAREKET_KARGO FOREIGN KEY (gonderi_no) REFERENCES KARGO(gonderi_no),
    CONSTRAINT FK_HAREKET_HAREKET_TURU FOREIGN KEY (hareket_turu_id) REFERENCES HAREKET_TURU(hareket_turu_id),
    CONSTRAINT FK_HAREKET_PERSONEL FOREIGN KEY (personel_tc) REFERENCES PERSONEL(personel_tc),
    CONSTRAINT FK_HAREKET_ARAC FOREIGN KEY (plaka) REFERENCES ARAC(plaka),
    CONSTRAINT FK_HAREKET_BASLANGIC_SUBE FOREIGN KEY (baslangic_sube_no) REFERENCES SUBE(sube_no),
    CONSTRAINT FK_HAREKET_BITIS_SUBE FOREIGN KEY (bitis_sube_no) REFERENCES SUBE(sube_no)
);
GO