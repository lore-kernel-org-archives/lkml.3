Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab3CDH7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:59:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:53425 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3CDH7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:59:31 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-a4-51345445db4e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 04/24] rtc: rtc-au1xxx: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 16:59:01 +0900
Message-id: <013d01ce18ae$2227c190$667744b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAC1ng
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zfV3XEJNAg9N3LSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG+a+nWAtaOCpW3H/A1MD4na2LkZNDQsBE4umW86wQtpjEhXvr
	geJcHEICyxgleib9YIcp+nl6EVRiEaPErfUtUM5sJombO7eCtbMJqEl8+XIYqIODQ0RAX6Kt
	RQOkhlmgl1HiTO9usElCArYSXx4+YAKxOQXsJO6fWwXWKyzgJdF1aQdYDYuAqkTDlDeMIDYv
	UP3/WRvYIGxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMsldCQF3i0V9diBOMJA6vk4OoEJHY
	9+IdI8g5EgKL2CUa1x9khlglIPFt8iEWiFZZiU0HmCH+lZQ4uOIGywRGiVlIFs9CsngWksWz
	kKxYwMiyilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMksibuYLx/wPoQYzLQ+onMUqLJ+cDI
	zCuJNzQ2NjEzMTUxtzQ1NyVNWEmcV/6STKCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRv19
	zX+K07cyBmrZzLZLPMzpWJm49dKdLdIbHI5tmHTUKOjUmfUZonIG4UuW24tkzhHnddyyLHnC
	CYcmrll3H6/9Fzt1pbFo7N5UT/GHb+UXuWpUNgs/CnScJtP/91GYf2Oa6s2CTv7jizT9lBgM
	6nbp3nh++fCMqXOuF237t6UxridPPP56jRJLcUaioRZzUXEiALRufVvCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK5riEmgQf9zI4vLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcf7rKdaCFo6KFfcfMDUw
	fmfrYuTkkBAwkfh5ehGULSZx4d56IJuLQ0hgEaPErfUtUM5sJombO7eyglSxCahJfPlymL2L
	kYNDREBfoq1FA6SGWaCXUeJM7252kBohAVuJLw8fMIHYnAJ2EvfPrQLrFRbwkui6tAOshkVA
	VaJhyhtGEJsXqP7/rA1sELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8uxAlG
	EofXyUFUiEjse/GOcQKj0Cwkg2YhGTQLyaBZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dL
	zs/dxAiO22fSOxhXNVgcYhTgYFTi4RX4ZBwoxJpYVlyZe4hRgoNZSYS3TMIkUIg3JbGyKrUo
	P76oNCe1+BBjMtCfE5mlRJPzgSklryTe0NjEzMjSyMzCyMTcnDRhJXFexlNPAoQE0hNLUrNT
	UwtSi2C2MHFwSjUw1idLOgq+LVriJ93yrOzwxfme6h//P9l3yzy//danz+lcWmFzmtfEnlnb
	8WX1wydHlrxm2rywR75gerGs0J6Kr5bcpzO5sqZtreKYO/Nv8eQV+bf3epuH7TkafE/+nMQP
	Ti2T9OeTPwV+eKV39njG+aySOy9UfBrEdNr1OY9OU/5wQu23oFjNJyWW4oxEQy3mouJEAH10
	sqQfAwAA
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
 drivers/rtc/rtc-au1xxx.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-au1xxx.c b/drivers/rtc/rtc-au1xxx.c
index b309da4..dfd6d66 100644
--- a/drivers/rtc/rtc-au1xxx.c
+++ b/drivers/rtc/rtc-au1xxx.c
@@ -134,18 +134,7 @@ static struct platform_driver au1xrtc_driver = {
 	.remove		= au1xtoy_rtc_remove,
 };
 
-static int __init au1xtoy_rtc_init(void)
-{
-	return platform_driver_probe(&au1xrtc_driver, au1xtoy_rtc_probe);
-}
-
-static void __exit au1xtoy_rtc_exit(void)
-{
-	platform_driver_unregister(&au1xrtc_driver);
-}
-
-module_init(au1xtoy_rtc_init);
-module_exit(au1xtoy_rtc_exit);
+module_platform_driver_probe(au1xrtc_driver, au1xtoy_rtc_probe);
 
 MODULE_DESCRIPTION("Au1xxx TOY-counter-based RTC driver");
 MODULE_AUTHOR("Manuel Lauss <manuel.lauss@gmail.com>");
-- 
1.7.2.5


