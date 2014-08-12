Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaHLNrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 09:47:55 -0400
Received: from [14.17.44.34] ([14.17.44.34]:41665 "EHLO smtpbg339.qq.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbaHLNry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 09:47:54 -0400
X-QQ-GoodBg: 0
X-QQ-SSF: 0010000000B000F0
X-QQ-BUSINESS-ORIGIN: 2
X-Originating-IP: 49.75.173.2
X-QQ-STYLE: 
X-QQ-mid: bizmail38t1407850866t4853563
From: "=?utf-8?B?6ZmI5Y2O5omN?=" <chenhc@lemote.com>
To: "=?utf-8?B?d2VpeWpfbGs=?=" <weiyj_lk@163.com>,
        "=?utf-8?B?UmFsZiBCYWVjaGxl?=" <ralf@linux-mips.org>
Cc: "=?utf-8?B?V2VpIFlvbmdqdW4=?=" <yongjun_wei@trendmicro.com.cn>,
        "=?utf-8?B?bGludXgtbWlwcw==?=" <linux-mips@linux-mips.org>,
        "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>
Subject: Re:[PATCH -next] MIPS: Remove duplicated include from numa.c
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Date: Tue, 12 Aug 2014 21:41:06 +0800
X-Priority: 3
Message-ID: <tencent_21B4C02448BEE43D0A470063@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <1407846382-29951-1-git-send-email-weiyj_lk@163.com>
In-Reply-To: <1407846382-29951-1-git-send-email-weiyj_lk@163.com>
X-QQ-ReplyHash: 3719488126
X-QQ-SENDSIZE: 520
X-QQ-Bgrelay: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7CDm09C013970

Reviewed-off-by: Huacai Chen <chenhc@lemote.com>
 
------------------ Original ------------------
From:  "weiyj_lk"<weiyj_lk@163.com>;
Date:  Tue, Aug 12, 2014 08:26 PM
To:  "Ralf Baechle"<ralf@linux-mips.org>; "Huacai Chen"<chenhc@lemote.com>; 
Cc:  "Wei Yongjun"<yongjun_wei@trendmicro.com.cn>; "linux-mips"<linux-mips@linux-mips.org>; "linux-kernel"<linux-kernel@vger.kernel.org>; 
Subject:  [PATCH -next] MIPS: Remove duplicated include from numa.c

 
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/mips/loongson/loongson-3/numa.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/mips/loongson/loongson-3/numa.c b/arch/mips/loongson/loongson-3/numa.c
index ca025a6..37ed184 100644
--- a/arch/mips/loongson/loongson-3/numa.c
+++ b/arch/mips/loongson/loongson-3/numa.c
@@ -24,8 +24,6 @@
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
-#include <linux/bootmem.h>
-#include <linux/init.h>
 #include <linux/irq.h>
 #include <asm/bootinfo.h>
 #include <asm/mc146818-time.h>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
