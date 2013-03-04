Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab3CDIB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:01:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13701 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab3CDIBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:01:54 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-65-513454f1929b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 11/24] rtc: rtc-mc13xxx: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:01:53 +0900
Message-id: <014401ce18ae$88969870$99c3c950$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAJjfg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ91PISaBBtfmMlpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Ml3d/sBX8Za9Y1vmcuYHxM1sXIyeHhICJxM3d3SwQtpjEhXvr
	geJcHEICyxgltizZzg5TdOD+DCaIxCJGib9/1oMlhARmM0lc6/AHsdkE1CS+fDkMFOfgEBHQ
	l2hr0QCpZxboZZQ407sbqt5W4svDB0wgNqeAncT9c6tYQWxhAW+J9r9LwK5gEVCV+HjrJyOI
	zQtUf+HAcjYIW1Dix+R7YDXMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxJPJh6HK
	RST2vXjHCHKPhMAidom7yw6xQewSkPg2+RALRK+sxKYDzBD/SkocXHGDZQKjxCwkm2ch2TwL
	yeZZSFYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESWX07GG8esD7EmAy0fiKzlGhy
	PjAy80riDY2NTcxMTE3MLU3NTUkTVhLnlb8kEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	setyx/c4S8vTHW8FQlo749i/9afO1n9Y92Ou8xSeZnbT11eFzqcde1baq5yj0Kx682K7W9lS
	xxBNzlWfVn6LLpxxxDK1UkJEh+NXWFS55UTlLLZq2T3tx3PVPu9ujs5eV9qoee2QylzV8qCH
	z5V2PZnj8/iuIXf/veqi3RN+V710n/3ywIcLSizFGYmGWsxFxYkAbS3NI8ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO7HEJNAg5VvtSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxsu7P9gK/rJXLOt8ztzA
	+Jmti5GTQ0LAROLA/RlMELaYxIV764HiXBxCAosYJf7+Wc8OkhASmM0kca3DH8RmE1CT+PLl
	MFCcg0NEQF+irUUDpJ5ZoJdR4kzvbqh6W4kvDx+ADeUUsJO4f24VK4gtLOAt0f53CQuIzSKg
	KvHx1k9GEJsXqP7CgeVsELagxI/J98BqmAW0JNbvPM4EYctLbF7zlhlkr4SAusSjv7ogYREB
	I4knkw9DlYtI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvX
	S87P3cQIjttnUjsYVzZYHGIU4GBU4uEV+GQcKMSaWFZcmXuIUYKDWUmEt0zCJFCINyWxsiq1
	KD++qDQntfgQYzLQoxOZpUST84EpJa8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1Kz
	U1MLUotgtjBxcEo1MC7wZDq/KeDBVoXvW5Mc3WquWS6c+PpxCLvSGfcnX5WSDjFkSToyJU/c
	MTvhfJB5RH0TU/kMh8bpFjJdj1wZXnBYa+3quB05W9Fl7sHNxT9iboYeitydbOM9+fykU6dZ
	k2V+OiyMbBcr09j6pOl0wrsg49svl0ybVF3ptPe//oWyoIpDjgaW65RYijMSDbWYi4oTAf0C
	+TUfAwAA
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
 drivers/rtc/rtc-mc13xxx.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 2643d88..5391b15 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -420,17 +420,7 @@ static struct platform_driver mc13xxx_rtc_driver = {
 	},
 };
 
-static int __init mc13xxx_rtc_init(void)
-{
-	return platform_driver_probe(&mc13xxx_rtc_driver, &mc13xxx_rtc_probe);
-}
-module_init(mc13xxx_rtc_init);
-
-static void __exit mc13xxx_rtc_exit(void)
-{
-	platform_driver_unregister(&mc13xxx_rtc_driver);
-}
-module_exit(mc13xxx_rtc_exit);
+module_platform_driver_probe(mc13xxx_rtc_driver, &mc13xxx_rtc_probe);
 
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
 MODULE_DESCRIPTION("RTC driver for Freescale MC13XXX PMIC");
-- 
1.7.2.5


