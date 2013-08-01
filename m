Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3HANDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:03:49 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34453 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3HANDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:03:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130731143936.GA7641@gmail.com>
References: <1375278775-3430-1-git-send-email-pyrasis@gmail.com>
	<20130731143936.GA7641@gmail.com>
Date: Thu, 1 Aug 2013 22:03:45 +0900
Message-ID: <CAN-bk8ziuL2nJ5v9djotfFi_Y8o1qrGA9VMy4e+4v2DrMup50Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] type fix on HOWTO in ko_KR
From: "Lee, Jae-Hong" <pyrasis@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: rob@landley.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=EUC-KR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r71D3sxk020803

2013³â 7¿ù 31ÀÏ ¿ÀÈÄ 11:40, Minchan Kim <minchan@kernel.org>´ÔÀÇ ¸»:
> On Wed, Jul 31, 2013 at 10:52:53PM +0900, Lee, Jae-Hong wrote:
>> From: "Lee, Jae-Hong" <pyrasis@gmail.com>
>
> Please add description although it's trivial.
> And please Cc lkml if you respin.
>
>>
>> Signed-off-by: Lee, Jae-Hong <pyrasis@gmail.com>
>> ---
>>  Documentation/ko_KR/HOWTO |   21 +++++++++++----------
>>  1 file changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
>> index ab5189a..4aa79f9 100644
>> --- a/Documentation/ko_KR/HOWTO
>> +++ b/Documentation/ko_KR/HOWTO
>> @@ -182,8 +182,8 @@ Documentation/DocBook/ µğ·ºÅä¸® ³»¿¡¼­ ¸¸µé¾îÁö¸ç PDF, Postscript, H
>>  ÇÁ·ÎÁ§Æ®¸¦ ºÁ¾ß ÇÑ´Ù.
>>      http://kernelnewbies.org
>>  ±×°÷Àº °ÅÀÇ ¸ğµç Á¾·ùÀÇ ±âº»ÀûÀÎ Ä¿³Î °³¹ß Áú¹®µé(Áú¹®ÇÏ±â Àü¿¡ ¸ÕÀú
>> -¾ÆÄ«ÀÌºê¸¦ Ã£¾ÆºÁ¶ó. °ú°Å¿¡ ÀÌ¹Ì ´äº¯µÇ¾úÀ» ¼öµµ ÀÖ´Ù)À» ÇÒ¼öÀÖ´Â µµ¿òÀÌ
>> -µÉ¸¸ÇÑ ¸ŞÀÏ¸µ ¸®½ºÆ®°¡ ÀÖ´Ù. ¶ÇÇÑ ½Ç½Ã°£À¸·Î Áú¹® ÇÒ¼ö ÀÖ´Â IRC Ã¤³Îµµ
>> +¾ÆÄ«ÀÌºê¸¦ Ã£¾ÆºÁ¶ó. °ú°Å¿¡ ÀÌ¹Ì ´äº¯µÇ¾úÀ» ¼öµµ ÀÖ´Ù)À» ÇÒ ¼öÀÖ´Â µµ¿òÀÌ
>                                                             ^^^^^^^^
>                                                             ÇÒ ¼ö ÀÖ´Â?

OK. I will fix it.

>> +µÉ¸¸ÇÑ ¸ŞÀÏ¸µ ¸®½ºÆ®°¡ ÀÖ´Ù. ¶ÇÇÑ ½Ç½Ã°£À¸·Î Áú¹® ÇÒ ¼ö ÀÖ´Â IRC Ã¤³Îµµ
>>  °¡Áö°í ÀÖÀ¸¸ç ¸®´ª½º Ä¿³Î °³¹ßÀ» ¹è¿ì´Â µ¥ À¯¿ëÇÑ ¹®¼­µéÀ» º¸À¯ÇÏ°í ÀÖ´Ù.
>>
>>  À¥»çÀÌÆ®´Â ÄÚµå±¸¼º, ¼­ºê½Ã½ºÅÛµé, ±×¸®°í ÇöÀç ÇÁ·ÎÁ§Æ®µé
>> @@ -245,7 +245,7 @@ Documentation/DocBook/ µğ·ºÅä¸® ³»¿¡¼­ ¸¸µé¾îÁö¸ç PDF, Postscript, H
>>      °ÍÀ» ±â¾ïÇØ¶ó. ¿Ö³ÄÇÏ¸é º¯°æÀÌ ÀÚÃ¼³»¿¡¼­¸¸ ¹ß»ıÇÏ°í Ãß°¡µÈ ÄÚµå°¡
>>      µå¶óÀÌ¹ö ¿ÜºÎÀÇ ´Ù¸¥ ºÎºĞ¿¡´Â ¿µÇâÀ» ÁÖÁö ¾ÊÀ¸¹Ç·Î ±×·± º¯°æÀº
>>      È¸±Í(¿ªÀÚÁÖ: ÀÌÀü¿¡´Â Á¸ÀçÇÏÁö ¾Ê¾ÒÁö¸¸ »õ·Î¿î ±â´ÉÃß°¡³ª º¯°æÀ¸·Î ÀÎÇØ
>> -             »ı°Ü³­ ¹ö±×)¸¦ ÀÏÀ¸Å³ ¸¸ÇÑ À§ÇèÀ» °¡Áö°í ÀÖÁö ¾Ê±â ¶§¹®ÀÌ´Ù. -rc1ÀÌ
>> +    »ı°Ü³­ ¹ö±×)¸¦ ÀÏÀ¸Å³ ¸¸ÇÑ À§ÇèÀ» °¡Áö°í ÀÖÁö ¾Ê±â ¶§¹®ÀÌ´Ù. -rc1ÀÌ
>>      ¹èÆ÷µÈ ÀÌÈÄ¿¡ git¸¦ »ç¿ëÇÏ¿© ÆĞÄ¡µéÀ» Linus¿¡°Ô º¸³¾¼ö ÀÖÁö¸¸ ÆĞÄ¡µéÀº
>>      °ø½ÄÀûÀÎ ¸ŞÀÏ¸µ ¸®½ºÆ®·Î º¸³»¼­ °ËÅä¸¦ ¹ŞÀ» ÇÊ¿ä°¡ ÀÖ´Ù.
>>    - »õ·Î¿î -rc´Â Linus°¡ ÇöÀç git tree°¡ Å×½ºÆ® ÇÏ±â¿¡ ÃæºĞÈ÷ ¾ÈÁ¤µÈ »óÅÂ¿¡
>> @@ -472,7 +472,7 @@ bugme-janitor ¸ŞÀÏ¸µ ¸®½ºÆ®(bugzilla¿¡ ¸ğµç º¯È­µéÀÌ ¿©±â¼­ ¸Ş
>>  °¡´ÉÇÑÇÑ °¡Àå ÁÁÀº ±â¼úÀûÀÎ ÇØ´äÀ» Ã£°í ÀÖ´Â Ä¿¹Â´ÏÆ¼¿¡¼­´Â Ç×»ó
>>  ¾î¶² ÆĞÄ¡°¡ ¾ó¸¶³ª ÁÁÀºÁö¿¡ °üÇÏ¿© ´Ù¸¥ ÀÇ°ßµéÀÌ ÀÖÀ» ¼ö ÀÖ´Ù. ¿©·¯ºĞÀº
>>  ÇùÁ¶ÀûÀÌ¾î¾ß ÇÏ°í ±â²¨ÀÌ ¿©·¯ºĞÀÇ »ı°¢À» Ä¿³Î ³»¿¡ ¸ÂÃß¾î¾ß ÇÑ´Ù. ¾Æ´Ï¸é
>> -Àû¾îµµ ¿©·¯ºĞÀÇ °ÍÀÌ °¡Ä¡ÀÖ´Ù´Â °ÍÀ» Áß¸íÇÏ¿©¾ß ÇÑ´Ù. Àß¸øµÈ °Íµµ ¿©·¯ºĞÀÌ
>> +Àû¾îµµ ¿©·¯ºĞÀÇ °ÍÀÌ °¡Ä¡ÀÖ´Ù´Â °ÍÀ» Áõ¸íÇÏ¿©¾ß ÇÑ´Ù. Àß¸øµÈ °Íµµ ¿©·¯ºĞÀÌ
>>  ¿Ã¹Ù¸¥ ¹æÇâÀÇ ÇØ°áÃ¥À¸·Î ÀÌ²ø¾î°¥ ÀÇÁö°¡ ÀÖ´Ù¸é ¹Ş¾Æµé¿©Áú °ÍÀÌ¶ó´Â Á¡À»
>>  ±â¾ïÇÏ¶ó.
>>
>> @@ -488,21 +488,21 @@ bugme-janitor ¸ŞÀÏ¸µ ¸®½ºÆ®(bugzilla¿¡ ¸ğµç º¯È­µéÀÌ ¿©±â¼­ ¸Ş
>>  Ä¿³Î Ä¿¹Â´ÏÆ¼´Â °¡Àå ÀüÅëÀûÀÎ È¸»çÀÇ °³¹ß È¯°æ°ú´Â ´Ù¸£´Ù. ¿©±â¿¡ ¿©·¯ºĞµéÀÇ
>>  ¹®Á¦¸¦ ÇÇÇÏ±â À§ÇÑ ¸ñ·ÏÀÌ ÀÖ´Ù.
>>    ¿©·¯ºĞµéÀÌ Á¦¾ÈÇÑ º¯°æµé¿¡ °üÇÏ¿© ¸»ÇÒ ¶§ ÁÁÀº °Íµé :
>> -    - "ÀÌ°ÍÀº ¿©·¯ ¹®Á¦µéÀ» ÇØ°ãÇÕ´Ï´Ù."
>> +    - "ÀÌ°ÍÀº ¿©·¯ ¹®Á¦µéÀ» ÇØ°áÇÕ´Ï´Ù."
>>      - "ÀÌ°ÍÀº 2000 ¶óÀÎÀÇ ÄÚµå¸¦ Á¦°ÅÇÕ´Ï´Ù."
>>      - "ÀÌ°ÍÀº ³»°¡ ¸»ÇÏ·Á´Â °Í¿¡ °üÇØ ¼³¸íÇÏ´Â ÆĞÄ¡ÀÔ´Ï´Ù."
>> -    - "³ª´Â 5°³ÀÇ ´Ù¸¥ ¾ÆÅ°ÅØÃÄ¿¡¼­ ±×°ÍÀ» Å×½ºÆ®Çß½¿À¸·Î..."
>> -    - "¿©±â¿¡ ÀÏ·ÃÀÇ ÀÛÀº ÆĞÄ¡µéÀÌ ÀÖ½¿À½·Î..."
>> -    - "ÀÌ°ÍÀº ÀÏ¹İÀûÀÎ ¸Ó½Å¿¡¼­ ¼º´ÉÀ» Çâ»ó½ÃÅ´À¸·Î..."
>> +    - "³ª´Â 5°³ÀÇ ´Ù¸¥ ¾ÆÅ°ÅØÃÄ¿¡¼­ ±×°ÍÀ» Å×½ºÆ® ÇßÀ¸¹Ç·Î..."
>                                                       ^^^^^^
>                                                      ÇßÀ½À¸·Î?
>
>> +    - "¿©±â¿¡ ÀÏ·ÃÀÇ ÀÛÀº ÆĞÄ¡µéÀÌ ÀÖÀ¸¹Ç·Î..."
>                                        ^^^^^^
>                                       ÀÖÀ½À¸·Î
>
>> +    - "ÀÌ°ÍÀº ÀÏ¹İÀûÀÎ ¸Ó½Å¿¡¼­ ¼º´ÉÀ» Çâ»ó½ÃÅ°¹Ç·Î..."
>                                           ^^^^^^^^^^^
>                                           Çâ»ó½ÃÅ´À¸·Î
>
> I am not a Korean teacher so I checked it with below [1].
>
> [1] http://search.naver.com/search.naver?sm=tab_sug.top&where=nexearch&acq=%EB%84%A4%EC%9D%B4%EB%B2%84+%EB%A7%9E%EC%B6%94&acr=1&qdt=0&ie=utf8&query=%EB%84%A4%EC%9D%B4%EB%B2%84+%EB%A7%9E%EC%B6%A4%EB%B2%95+%EA%B2%80%EC%82%AC%EA%B8%B0&x=-595&y=-51
>

1. I searched "ÇßÀ½À¸·Î" on The National Institute of the Korean Language website[2]
"³ª´Â 5°³ÀÇ ´Ù¸¥ ¾ÆÅ°ÅØÃÄ¿¡¼­ ±×°ÍÀ» Å×½ºÆ®ÇßÀ½À¸·Î" means a reason.
ex) "³ª´Â 5°³ÀÇ ´Ù¸¥ ¾ÆÅ°ÅØÃÄ¿¡¼­ ±×°ÍÀ» Å×½ºÆ® Çß±â ¶§¹®¿¡"
therefore, we should use "ÇßÀ¸¹Ç·Î".

2. this link[3] is in explanation of "ÀÖÀ¸¹Ç·Î vs. ÀÖÀ½À¸·Î".
therefore, we should use "ÀÖÀ¸¹Ç·Î".

3. I checked "Çâ»ó½ÃÅ´À¸·Î" with Korean spelling checker of Pusan
University[4]. It is more detailed than checker of naver.com.
unfortunately, spelling check result cannot link. so, I copied the result.

ÀÔ·Â ³»¿ë : Çâ»ó½ÃÅ´À¸·Î
´ëÄ¡¾î  : Çâ»óÇÔÀ¸·Î, Çâ»óÇÏ°Ô ½ÃÅ´À¸·Î
µµ¿ò¸» : ¿ì¸®¸»Àº ÇàÀ§ÀÚ ÀÚ½ÅÀÌ ÇÏ´Â Çàµ¿À» 'ÇÑ´Ù'°í ÇÏÁö '½ÃÅ²´Ù'°í ÇÏÁö ¾Ê½À´Ï´Ù. µû¶ó¼­ Á¦½Ã¾î Áß¿¡¼­ ÀÇ¹Ì¸¦
°í·ÁÇÏ¿© ¹Ù¸¥ ¿¹¸¦ ¼±ÅÃÇÏ¿© ½á¾ß ¿ì¸®¸»¿¡ ¸Â´Â Ç¥ÇöÀÔ´Ï´Ù.
therefore, we should use "Çâ»óÇÔÀ¸·Î".

[2] http://krdic.naver.com/rescript_detail.nhn?seq=5679
[3] http://korean.go.kr/09_new/minwon/qna_view.jsp?idx=72178
[4] http://speller.cs.pusan.ac.kr/

>>
>>    ¿©·¯ºĞµéÀÌ ¸»ÇÒ ¶§ ÇÇÇØ¾ß ÇÒ ÁÁÁö ¾ÊÀº °Íµé :
>> -    - "¿ì¸®¸¦ ±×°ÍÀ» AIT/ptx/Solaris¿¡¼­ ÀÌ·¯ÇÑ ¹æ¹ıÀ¸·Î Çß´Ù. ±×·¯¹Ç·Î ±×°ÍÀº ÁÁÀº °ÍÀÓ¿¡ Æ²¸³¾ø´Ù..."
>> +    - "¿ì¸®¸¦ ±×°ÍÀ» AIT/ptx/Solaris¿¡¼­ ÀÌ·¯ÇÑ ¹æ¹ıÀ¸·Î Çß´Ù. ±×·¯¹Ç·Î ±×°ÍÀº ÁÁÀº °ÍÀÓ¿¡ Æ²¸²¾ø´Ù..."
>
>           ¿ì¸®´Â        AIX

OK. I will fix it.

>
>>      - "³ª´Â 20³âµ¿¾È ÀÌ°ÍÀ» ÇØ¿Ô´Ù. ±×·¯¹Ç·Î..."
>>      - "ÀÌ°ÍÀº µ·À» ¹ú±âÀ§ÇØ ³ªÀÇ È¸»ç°¡ ÇÊ¿ä·Î ÇÏ´Â °ÍÀÌ´Ù."
>>      - "ÀÌ°ÍÀº ¿ì¸®ÀÇ ¿£ÅÍÇÁ¶óÀÌÁî »óÇ° ¶óÀÎÀ» À§ÇÑ °ÍÀÌ´Ù."
>>      - "¿©±â¿¡ ³ªÀÇ »ı°¢À» ¸»ÇÏ°í ÀÖ´Â 1000 ÆäÀÌÁö ¼³°è ¹®¼­°¡ ÀÖ´Ù."
>>      - "³ª´Â 6´Şµ¿¾È ÀÌ°ÍÀ» ÇßÀ¸´Ï..."
>> -    - "¿©±â¿¡ 5000¶óÀÎ Â¥¸® ÆĞÄ¡°¡ ÀÖÀ¸´Ï..."
>> +    - "¿©±â¿¡ 5000 ¶óÀÎ Â¥¸® ÆĞÄ¡°¡ ÀÖÀ¸´Ï..."
>>      - "³ª´Â ÇöÀç µÚÁ×¹ÚÁ×ÀÎ °ÍÀ» ÀçÀÛ¼ºÇß´Ù. ±×¸®°í ¿©±â¿¡..."
>>      - "³ª´Â ¸¶°¨½ÃÇÑÀ» °¡Áö°í ÀÖÀ¸¹Ç·Î ÀÌ ÆĞÄ¡´Â Áö±İ Àû¿ëµÉ ÇÊ¿ä°¡ ÀÖ´Ù."
>>
>> @@ -574,6 +574,7 @@ PatÀÌ¶ó´Â ÀÌ¸§À» °¡Áø ¿©ÀÚ°¡ ÀÖÀ» ¼öµµ ÀÖ´Â °ÍÀÌ´Ù. ¸®´ª
>>  ¶ÇÇÑ ¿Ï¼ºµÇÁö ¾Ê¾Ò°í "³ªÁß¿¡ ¼öÁ¤µÉ °ÍÀÌ´Ù." ¿Í °°Àº °ÍµéÀ» Æ÷ÇÔÇÏ´Â
>>  ÆĞÄ¡µéÀº ¹Ş¾Æµé¿©ÁöÁö ¾ÊÀ» °ÍÀÌ¶ó´Â Á¡À» À¯³äÇÏ¶ó.
>>
>> +
>>  º¯°æÀ» Á¤´çÈ­ÇØ¶ó
>>  -----------------
>>
>> --
>> 1.7.10.4
>>
>
> --
> Kind regards,
> Minchan Kim
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
