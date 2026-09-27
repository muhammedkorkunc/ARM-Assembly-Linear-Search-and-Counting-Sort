# ⚡ ARM Architecture: Linear Search & Counting Sort Implementation

### ARM Assembly Dili ile Doğrusal Arama ve Counting Sort Algoritmalarının Gerçeklenmesi

Bu depo; Bilgisayar Mühendisliği **Bilgisayar Mimarisi ve Organizasyonu (Computer Organization & Architecture)** dersi proje çalışması kapsamında ARMv7-M (STM32F4 / Keil uVision) mimarisinde geliştirilen doğrusal arama (`deger_bul`) ve frekans-kümülatif toplam tabanlı sayma sıralaması (`count_sirala`) rutinlerini barındırır.

---

## 🛠️ Mimari ve Bellek Yönetimi

| Alan / Fonksiyon               | Registerlar & Bellek                      | Görev & Çalışma Prensibi                                                                                                                                                      |
| :----------------------------- | :---------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`deger_bul`**                | `R0` (Aranan), `R1` (Adres), `R2` (Değer) | Lineer arama yapar. Bulunursa `R0 = 1`, bulunamazsa `R0 = 0` döndürür; stack korumalıdır (`PUSH/POP {R4-R6, LR}`).                                                            |
| **`count_sirala`**             | `R11` (Frekans/Kümülatif), `R12` (Sıralı) | $O(n)$ doğrusal zaman karmaşıklığı ile Counting Sort algoritmasını yürütür. Maksimum değer tespiti, frekans sayımı, kümülatif toplam ve diziye yerleştirme adımlarını içerir. |
| **`input_array`**              | `READONLY` Kod Alanı                      | İlk elemanı dizi boyutu ($n = 12$) olan ve sıralanacak 32-bit tamsayıları barındıran salt okunur veri alanı.                                                                  |
| **`muhammedeminkorkunc_data`** | `READWRITE` Veri Alanı                    | 400 baytlık (100 int) frekans ve sıralanmış geçici tampon dizileri (`SPACE 400`).                                                                                             |

---

## ⚡ Algoritmik Karmaşıklık

- **Zaman Karmaşıklığı (Time Complexity):** $O(n + k)$ (Burada $n$ dizi eleman sayısı, $k$ dizideki maksimum eleman değeridir). Karşılaştırma tabanlı sıralamaların ($\Omega(n \log n)$) aksine lineer sürede çalışır.
- **Alan Karmaşıklığı (Space Complexity):** $O(k)$ yardımcı bellek gereksinimi.

---

## 🔒 Copyright & License / Telif Hakkı Bildirimi

Bu proje, kaynak kodları ve beraberindeki proje raporu **Proprietary (Tescilli / Tüm Hakları Saklıdır)** lisansına tabidir.

```text
Copyright (c) 2026 Muhammed Emin Korkunç. All Rights Reserved.

Bu projedeki tüm ARM Assembly kodları, register konfigürasyonları,
algoritmik rutinler ve proje raporu Muhammed Emin Korkunç'a aittir.
Yazarın açık yazılı izni olmaksızın kısmen veya tamamen kopyalanması,
paylaşılması veya ticari/akademik amaçla izinsiz kullanımı kesinlikle yasaktır.
```

👨‍💻 Geliştirici / Author
Muhammed Emin Korkunç

GitHub: @muhammedkorkunc

LinkedIn: Muhammed Emin Korkunç

Email: muhammedemin.korkunc@gmail.com
