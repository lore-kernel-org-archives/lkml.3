Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaCHJxm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:53:42 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:65469 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaCHJxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:53:38 -0500
From: Linyongting <linyongting@huawei.com>
To: "harryxiyou@gmail.com" <harryxiyou@gmail.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-kernel@zh-kernel.org" <linux-kernel@zh-kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linyongting@gmail.com" <linyongting@gmail.com>
Subject: [PATCH] Chinese: add translation of io_ordering.txt
Thread-Topic: [PATCH] Chinese: add translation of io_ordering.txt
Thread-Index: Ac86tDp9BRHeukExQliiUC7puEtJEg==
Date: Sat, 8 Mar 2014 09:53:17 +0000
Message-ID: <42719C9A3BC7524EB9C1B67FB83BF30C82600E9F@SZXEMA501-MBS.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.66.68.239]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s289rljA008107

This is a Chinese translated version of Documentation/io_ordering.txt

Signed-off-by: Lin Yongting <linyongting@gmail.com>
---
 Documentation/zh_CN/io_ordering.txt |   67 +++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 Documentation/zh_CN/io_ordering.txt

diff --git a/Documentation/zh_CN/io_ordering.txt b/Documentation/zh_CN/io_ordering.txt
new file mode 100644
index 0000000..e592daf
--- /dev/null
+++ b/Documentation/zh_CN/io_ordering.txt
@@ -0,0 +1,67 @@
+Chinese translated version of Documentation/io_orderings.txt
+
+If you have any comment or update to the content, please contact the
+original document maintainer directly.  However, if you have a problem
+communicating in English you can also ask the Chinese maintainer for
+help.  Contact the Chinese maintainer if this translation is outdated
+or if there is a problem with the translation.
+
+Chinese maintainer: Lin Yongting <linyongting@gmail.com>
+---------------------------------------------------------------------
+Documentation/io_ordering.txt µÄÖĞÎÄ·­Òë
+
+Èç¹ûÏëÆÀÂÛ»ò¸üĞÂ±¾ÎÄµÄÄÚÈİ£¬ÇëÖ±½ÓÁªÏµÔ­ÎÄµµµÄÎ¬»¤Õß¡£Èç¹ûÄãÊ¹ÓÃÓ¢ÎÄ
+½»Á÷ÓĞÀ§ÄÑµÄ»°£¬Ò²¿ÉÒÔÏòÖĞÎÄ°æÎ¬»¤ÕßÇóÖú¡£Èç¹û±¾·­Òë¸üĞÂ²»¼°Ê±»òÕß·­
+Òë´æÔÚÎÊÌâ£¬ÇëÁªÏµÖĞÎÄ°æÎ¬»¤Õß¡£
+
+ÖĞÎÄ°æÎ¬»¤Õß£º ÁÖÓÀÌı Lin Yongting <linyongting@gmail.com>
+ÖĞÎÄ°æ·­ÒëÕß£º ÁÖÓÀÌı Lin Yongting <linyongting@gmail.com>
+ÖĞÎÄ°æĞ£ÒëÕß£º ÁÖÓÀÌı Lin Yongting <linyongting@gmail.com>
+
+
+ÒÔÏÂÎªÕıÎÄ
+---------------------------------------------------------------------
+
+ÔÚÄ³Ğ©Æ½Ì¨ÉÏ£¬ËùÎ½µÄÄÚ´æÓ³ÉäI/OÊÇÈõË³Ğò¡£ÔÚÕâĞ©Æ½Ì¨ÉÏ£¬Çı¶¯¿ª·¢ÕßÓĞÔğÈÎ
+±£Ö¤I/OÄÚ´æÓ³ÉäµØÖ·µÄĞ´²Ù×÷°´³ÌĞòÍ¼ÒâµÄË³Ğò´ïµ½Éè±¸¡£Í¨³£¶ÁÈ¡Ò»¸ö¡°°²È«¡±
+Éè±¸¼Ä´æÆ÷»òÇÅ¼Ä´æÆ÷£¬´¥·¢IOĞ¾Æ¬ÇåË¢Î´´¦ÀíµÄĞ´²Ù×÷µ½´ïÉè±¸ºó²Å´¦Àí¶Á²Ù×÷£¬
+¶ø´ïµ½±£Ö¤Ä¿µÄ¡£Çı¶¯³ÌĞòÍ¨³£ÔÚspinlock±£»¤µÄÁÙ½çÇøÍË³öÖ®Ç°Ê¹ÓÃÕâÖÖ¼¼Êõ¡£
+ÕâÒ²¿ÉÒÔ±£Ö¤ºóÃæµÄĞ´²Ù×÷Ö»ÔÚÇ°ÃæµÄĞ´²Ù×÷Ö®ºóµ½´ïÉè±¸£¨Õâ·Ç³£ÀàËÆÓÚÄÚ´æ
+ÆÁÕÏ²Ù×÷£¬mb()£¬²»¹ı½öÊÊÓÃÓÚI/O£©¡£
+
+¼ÙÉèÒ»¸öÉè±¸Çı¶¯³ÌµÄ¾ßÌåÀı×Ó£º
+
+        ...
+CPU A:  spin_lock_irqsave(&dev_lock, flags)
+CPU A:  val = readl(my_status);
+CPU A:  ...
+CPU A:  writel(newval, ring_ptr);
+CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
+        ...
+CPU B:  spin_lock_irqsave(&dev_lock, flags)
+CPU B:  val = readl(my_status);
+CPU B:  ...
+CPU B:  writel(newval2, ring_ptr);
+CPU B:  spin_unlock_irqrestore(&dev_lock, flags)
+        ...
+
+ÉÏÊöÀı×ÓÖĞ£¬Éè±¸¿ÉÄÜ»áÏÈ½ÓÊÕµ½newval2µÄÖµ£¬È»ºó½ÓÊÕµ½newvalµÄÖµ£¬ÎÊÌâ¾Í
+·¢ÉúÁË¡£²»¹ıºÜÈİÒ×Í¨¹ıÏÂÃæ·½·¨À´ĞŞ¸´£º
+
+        ...
+CPU A:  spin_lock_irqsave(&dev_lock, flags)
+CPU A:  val = readl(my_status);
+CPU A:  ...
+CPU A:  writel(newval, ring_ptr);
+CPU A:  (void)readl(safe_register); /* ÅäÖÃ¼Ä´æÆ÷£¿*/
+CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
+        ...
+CPU B:  spin_lock_irqsave(&dev_lock, flags)
+CPU B:  val = readl(my_status);
+CPU B:  ...
+CPU B:  writel(newval2, ring_ptr);
+CPU B:  (void)readl(safe_register); /* ÅäÖÃ¼Ä´æÆ÷£¿*/
+CPU B:  spin_unlock_irqrestore(&dev_lock, flags)
+
+ÔÚ½â¾ö·½°¸ÖĞ£¬¶ÁÈ¡safe_register¼Ä´æÆ÷£¬´¥·¢IOĞ¾Æ¬ÇåË¢Î´´¦ÀíµÄĞ´²Ù×÷£¬
+ÔÙ´¦ÀíºóÃæµÄ¶Á²Ù×÷£¬·ÀÖ¹Òı·¢Êı¾İ²»Ò»ÖÂÎÊÌâ¡£
-- 
1.7.9.5

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
