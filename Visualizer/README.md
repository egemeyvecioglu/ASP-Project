# Hakkında

[rules.lp](https://github.com/egemeyvecioglu/ASP-Project/blob/main/rules.lp)'nin çıktısını bir dosyaya yazdırıp (`clingo rules.lp 1024 > output.txt`) bu dosyayı [tables.html](https://github.com/egemeyvecioglu/ASP-Project/blob/main/Visualizer/tables.html) sayfasına girdi olarak vererek sonuçları görselleştirebilirsiniz. Girdi işlendikten sonra sayfanın üstündeki butonlara basarak veya klavyenizin ok tuşlarını kullanarak oluşturulan schedule'lar arasında gezebilirsiniz.

### HTML/CSS hakkında

- `nav` class'ı programlar arası gezmeye yardımcı olan içeriklere karşılık geliyor.
- `prev` class'ı `nav` class'ının içindeki bir önceki programa geçmeyi sağlayan butona karşılık geliyor.
- `next` class'ı `nav` class'ının içindeki bir sonraki programa geçmeyi sağlayan butona karşılık geliyor.
- `counter` class'ı oluşturulan programların sayısına ve şu an gösterilen programın numarasına karşılık geliyor.
- `schedule` class'ı bir programın tek bir gününe karşılık geliyor.
- `eatd` class'ı bir programın tek bir gününün tek bir amfi için olan sütununa karşılık geliyor. Girdi verildikten sonra ders blokları bu sütunları dolduruyor.
- `block` class'ı ders bloklarına karşılık geliyor.
- `start_time` class'ı günün ilk dersinin başlangıç saatine karşılık geliyor.
- `end_time` class'ı günün son dersinin bitiş saatine karşılık geliyor.

### JS hakkında

- `blocks` değişkeni oluşturulan ders bloklarını tutuyor. Girdi verilince bu değişken ilk programın dersleriyle dolduruluyor. Programlar arasında geçiş yapılırken temizlenip tekrar dolduruluyor.
  - Her bir ders bloğunun `day` attribute'u onun gününü, `place` attribute'u onun yerini, `s` attribute'u onun günün başlangıcından kaç dakika sonra başladığını, `e` attribute'u onun günün başlangıcından kaç dakika sonra bittiğini ve `t` attribute'u o ders bloğunun içine başka ne yazılması gerektiğini tutuyor.
- `schedules` değişkeni oluşturulan her bir programı ([rules.lp](https://github.com/egemeyvecioglu/ASP-Project/blob/main/rules.lp)'nin bir cevabını) tutuyor.
- `current_schedule` değişkeni şu an kaçıncı programın gösterildiğini tutuyor.
- `palette` değişkeni renk paletini tutuyor.
- `shuffle` fonksiyonu paletteki renklerin sırasını karıştırmak için kullanılıyor.
- `current_color` değişkeni bir dahaki oluşturulacak ders bloğunun renginin endeksini tutuyor.
- `get_color` fonksiyonu `current_color` değişkeninin değerine ve `palette` permütasyonuna bağlı olarak rastgele bir renk döndürüyor.
- `to_clock` fonksiyonu günün başlangıcından (`00.00`) beri kaç dakika geçtiğini okunaklı bir saate dönüştürüyor.
- `day_start` değişkeni günün ilk dersinin başlangıcının günün başlangıcından kaç dakika sonra olduğunu tutuyor.
- `day_end` değişkeni günün son dersinin bitişinin günün başlangıcından kaç dakika sonra olduğunu tutuyor.
- `block` fonksiyonu verilen gün, yer, başlangıç saati ve bitiş saati için bir ders bloğu oluşturuyor ve bu bloğa verilen yazıyı ekliyor.
- `prev` fonksiyonu bir önceki programa geçiyor.
- `next` fonksiyonu bir sonraki programa geçiyor.
- `draw` fonksiyonu şu anki programı sayfaya çiziyor.
- '`main`' fonksiyonu [rules.lp](https://github.com/egemeyvecioglu/ASP-Project/blob/main/rules.lp)'nin çıktısından ders programlarını oluşturuyor.
