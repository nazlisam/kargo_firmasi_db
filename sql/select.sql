USE KargoSistemi;
GO

-- yalova'dan ankara'ya giden kargolar
SELECT
    DATENAME(MONTH, k.teslim_tarih_saat) AS ay_adi,
    COUNT(*) AS teslimat_sayisi
FROM KARGO AS k
INNER JOIN SUBE AS s1
    ON k.alan_sube_no = s1.sube_no
INNER JOIN ADRES AS a1
    ON s1.adres_id = a1.adres_id
INNER JOIN CADDE_SOKAK AS cs1
    ON a1.cadde_sokak_id = cs1.cadde_sokak_id
INNER JOIN MAHALLE AS m1
    ON cs1.mahalle_id = m1.mahalle_id
INNER JOIN ILCE AS ic1
    ON m1.ilce_id = ic1.ilce_id
INNER JOIN IL AS il_cikis
    ON ic1.il_id = il_cikis.il_id
INNER JOIN ADRES AS a2
    ON k.teslimat_adres_id = a2.adres_id
INNER JOIN CADDE_SOKAK AS cs2
    ON a2.cadde_sokak_id = cs2.cadde_sokak_id
INNER JOIN MAHALLE AS m2
    ON cs2.mahalle_id = m2.mahalle_id
INNER JOIN ILCE AS ic2
    ON m2.ilce_id = ic2.ilce_id
INNER JOIN IL AS il_varis
    ON ic2.il_id = il_varis.il_id
WHERE il_cikis.ad = N'Yalova'
  AND il_varis.ad = N'Ankara'
  AND YEAR(k.teslim_tarih_saat) = YEAR(GETDATE())
  AND k.teslim_tarih_saat IS NOT NULL
  AND DATEDIFF(HOUR, k.alim_tarih_saat, k.teslim_tarih_saat) >
      (
          SELECT AVG(1.0 * DATEDIFF(HOUR, k2.alim_tarih_saat, k2.teslim_tarih_saat))
          FROM KARGO AS k2
          INNER JOIN SUBE AS s2
              ON k2.alan_sube_no = s2.sube_no
          INNER JOIN ADRES AS a3
              ON s2.adres_id = a3.adres_id
          INNER JOIN CADDE_SOKAK AS cs3
              ON a3.cadde_sokak_id = cs3.cadde_sokak_id
          INNER JOIN MAHALLE AS m3
              ON cs3.mahalle_id = m3.mahalle_id
          INNER JOIN ILCE AS ic3
              ON m3.ilce_id = ic3.ilce_id
          INNER JOIN IL AS il_cikis_gecen_yil
              ON ic3.il_id = il_cikis_gecen_yil.il_id
          INNER JOIN ADRES AS a4
              ON k2.teslimat_adres_id = a4.adres_id
          INNER JOIN CADDE_SOKAK AS cs4
              ON a4.cadde_sokak_id = cs4.cadde_sokak_id
          INNER JOIN MAHALLE AS m4
              ON cs4.mahalle_id = m4.mahalle_id
          INNER JOIN ILCE AS ic4
              ON m4.ilce_id = ic4.ilce_id
          INNER JOIN IL AS il_varis_gecen_yil
              ON ic4.il_id = il_varis_gecen_yil.il_id
          WHERE YEAR(k2.teslim_tarih_saat) = YEAR(GETDATE()) - 1
            AND k2.teslim_tarih_saat IS NOT NULL
            AND il_cikis_gecen_yil.il_id = il_cikis.il_id
            AND il_varis_gecen_yil.il_id = il_varis.il_id
      )
GROUP BY
    MONTH(k.teslim_tarih_saat),
    DATENAME(MONTH, k.teslim_tarih_saat)
HAVING COUNT(*) >= 100
ORDER BY
    CASE
        WHEN COUNT(*) >= 500 THEN 0
        ELSE 1
    END,
    CASE
        WHEN COUNT(*) < 500 THEN DATENAME(MONTH, k.teslim_tarih_saat)
    END ASC,
    CASE
        WHEN COUNT(*) >= 500 THEN COUNT(*)
    END DESC;

GO

-- en cok kullanilan ek ozellikler
SELECT TOP 3
    eo.ozellik_adi,
    COUNT(*) AS kullanim_sayisi
FROM KARGO_EK_OZELLIK AS ke
INNER JOIN EK_OZELLIK AS eo
    ON ke.ek_ozellik_id = eo.ek_ozellik_id
INNER JOIN KARGO AS k
    ON ke.gonderi_no = k.gonderi_no
WHERE YEAR(k.alim_tarih_saat) = YEAR(GETDATE())
GROUP BY
    eo.ek_ozellik_id,
    eo.ozellik_adi
ORDER BY
    COUNT(*) DESC,
    eo.ek_ozellik_id ASC;

GO

-- bu ay teslimat illerine gore kargolar
SELECT
    il.ad AS teslimat_ili,
    COUNT(*) AS top3_ek_ozellikli_kargo_sayisi,
    ISNULL(ROUND(AVG(CASE 
        WHEN k.teslim_tarih_saat IS NOT NULL THEN k.desi 
    END), 2), 0) AS teslim_edilen_ortalama_desi,
    ISNULL(ROUND(AVG(CASE 
        WHEN k.teslim_tarih_saat IS NULL THEN k.desi 
    END), 2), 0) AS teslim_edilmeyen_ortalama_desi
FROM KARGO AS k
INNER JOIN ADRES AS a
    ON k.teslimat_adres_id = a.adres_id
INNER JOIN CADDE_SOKAK AS cs
    ON a.cadde_sokak_id = cs.cadde_sokak_id
INNER JOIN MAHALLE AS m
    ON cs.mahalle_id = m.mahalle_id
INNER JOIN ILCE AS ic
    ON m.ilce_id = ic.ilce_id
INNER JOIN IL AS il
    ON ic.il_id = il.il_id
WHERE YEAR(k.alim_tarih_saat) = YEAR(GETDATE())
  AND MONTH(k.alim_tarih_saat) = MONTH(GETDATE())

  AND NOT EXISTS
      (
          SELECT *
          FROM
          (
              SELECT TOP 3
                  ke_top.ek_ozellik_id,
                  COUNT(*) AS kullanim_sayisi
              FROM KARGO_EK_OZELLIK AS ke_top
              INNER JOIN KARGO AS k_top
                  ON ke_top.gonderi_no = k_top.gonderi_no
              WHERE YEAR(k_top.alim_tarih_saat) = YEAR(GETDATE())
              GROUP BY
                  ke_top.ek_ozellik_id
              ORDER BY
                  COUNT(*) DESC,
                  ke_top.ek_ozellik_id ASC
          ) AS Top3EkOzellik
          WHERE NOT EXISTS
              (
                  SELECT *
                  FROM KARGO_EK_OZELLIK AS ke_kargo
                  WHERE ke_kargo.gonderi_no = k.gonderi_no
                    AND ke_kargo.ek_ozellik_id = Top3EkOzellik.ek_ozellik_id
              )
      )
GROUP BY
    il.ad
ORDER BY
    il.ad ASC;

GO