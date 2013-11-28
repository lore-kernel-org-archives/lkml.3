Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab3K1OUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:20:08 -0500
Received: from ip2.televic.com ([81.82.194.222]:50815 "EHLO ip2.televic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab3K1OUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:20:05 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Nov 2013 09:20:05 EST
From: =?utf-8?B?TGFtYnJlY2h0IErDvHJnZW4=?= <J.Lambrecht@TELEVIC.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: =?utf-8?B?TGFtYnJlY2h0IErDvHJnZW4=?= <J.Lambrecht@TELEVIC.com>
Date: Thu, 28 Nov 2013 15:13:30 +0100
Subject: [PATCH] fix typo in X86_INTEL_PSTATE description
Thread-Topic: [PATCH] fix typo in X86_INTEL_PSTATE description
Thread-Index: Ac7sRCzcZOQ1Lz+sRM22ga2t5l9Z7A==
Message-ID: <1385648010-27478-1-git-send-email-J.Lambrecht@televic.com>
Accept-Language: en-US, nl-BE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, nl-BE
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rASEKELx028469


Signed-off-by: JÃ¼rgen Lambrecht <J.Lambrecht@televic.com>
---
 drivers/cpufreq/Kconfig.x86 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index d369349..5fd5236 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -10,7 +10,7 @@ config X86_INTEL_PSTATE
 	  The driver implements an internal governor and will become
           the scaling driver and governor for Sandy bridge processors.
 
-	  When this driver is enabled it will become the perferred
+	  When this driver is enabled it will become the preferred
           scaling driver for Sandy bridge processors.
 
 	  If in doubt, say N.
-- 
1.7.10.4
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
