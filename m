Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3CDH51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:57:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49861 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3CDH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:57:26 -0500
X-AuditID: cbfee68d-b7f636d0000009be-eb-513453defaf5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/24] rtc: rtc-ab3100: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 16:57:17 +0900
Message-id: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t8zA917wSaBBnMe81tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M3nXzWQumcFQ0HT/D1MD4j62LkZNDQsBE4s2V+cwQtpjEhXvr
	geJcHEICyxglnrVcYIYpmtk3BSqxiFHi0r+VrBDObCaJZ1emsINUsQmoSXz5chjI5uAQEdCX
	aGvRAKlhFuhllDjTuxusRljAS2L6jb1gU1kEVCXWzdsFFucVsJXoXXOMGcIWlPgx+R4LiM0s
	oCWxfudxJghbXmLzmrfMIPMlBNQlHv3VBQmLCOhJPF93lBmiRERi34t3jCB7JQS62SX2bmxn
	h9glIPFt8iEWiF5ZiU0HoB6TlDi44gbLBEaxWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9
	yFCvODG3uDQvXS85P3cTIyRWencw3j5gfYgxGWj9RGYp0eR8YKzllcQbGhubmJmYmphbmpqb
	kiasJM4rd0kmUEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjZ7bNkqtTFrpkfF9ZOuGVzTrF
	NM0M4TPNTx34RHMzrCM4v+7gUwta5HvkXegaOb7bDt46N9m2/egxf7Hu7SHv7ZKTZhV/2/pa
	aufc9sfmb9Ovrtt5+MM09+AHaYfd+V+nrypcrVimxhAtvuOxh4rgNTO/ede/rD8RI6Jru3r7
	I3/Or+rbKmeHK7EUZyQaajEXFScCAH511ZKrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd17wSaBBu8PcVlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjN5181kLpnBUNB0/w9TA
	+I+ti5GTQ0LARGJm3xQoW0ziwr31QDYXh5DAIkaJS/9WskI4s5kknl2Zwg5SxSagJvHly2Eg
	m4NDREBfoq1FA6SGWaCXUeJM726wGmEBL4npN/Yyg9gsAqoS6+btAovzCthK9K45xgxhC0r8
	mHyPBcRmFtCSWL/zOBOELS+xec1bZpD5EgLqEo/+6oKERQT0JJ6vO8oMUSIise/FO8YJjAKz
	kEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOBKfSe9gXNVgcYhR
	gINRiYdX4JNxoBBrYllxZe4hRgkOZiUR3jIJk0Ah3pTEyqrUovz4otKc1OJDjMlAj05klhJN
	zgcmibySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhPLEnNTk0tSC2C2cLEwSnVwLiVY0X8
	vN1tptNnfDI8u+CkwX3ph0u76o2771jv0Tl6ovg/w5aTiXZt8+RDjnGzKzYJOKmm127emSZq
	xjf1/9zlicpC0jcU5rgwbpr1uvDhfIb46xKdh/99vVDzRnHObUtfQQbDP7s2+e8r/17MtfV0
	uoB31haWY3F/1Xxik+41HYgO1q3M+6jEUpyRaKjFXFScCAChCJ9YCAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ab3100.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
index 261a07e..c2f12d3 100644
--- a/drivers/rtc/rtc-ab3100.c
+++ b/drivers/rtc/rtc-ab3100.c
@@ -257,19 +257,7 @@ static struct platform_driver ab3100_rtc_driver = {
 	.remove	 = __exit_p(ab3100_rtc_remove),
 };
 
-static int __init ab3100_rtc_init(void)
-{
-	return platform_driver_probe(&ab3100_rtc_driver,
-				     ab3100_rtc_probe);
-}
-
-static void __exit ab3100_rtc_exit(void)
-{
-	platform_driver_unregister(&ab3100_rtc_driver);
-}
-
-module_init(ab3100_rtc_init);
-module_exit(ab3100_rtc_exit);
+module_platform_driver_probe(ab3100_rtc_driver, ab3100_rtc_probe);
 
 MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
 MODULE_DESCRIPTION("AB3100 RTC Driver");
-- 
1.7.2.5


