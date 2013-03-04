Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3CDIEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:04:05 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51547 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab3CDIEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:04:02 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-9c-51345570e045
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 16/24] rtc: rtc-pcap: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:04:00 +0900
Message-id: <014901ce18ae$d42b0b90$7c8122b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAN99g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY92CUJNAg3tTlS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG2Z7VrAX72Suauv4yNjBuZeti5OSQEDCRmLH3EzOELSZx4d56
	sLiQwDJGiV2bAmFq9szbwtjFyAUUX8Qo0b38IwuEM5tJ4sKnblaQKjYBNYkvXw6zdzFycIgI
	6Eu0tWiA1DAL9DJKnOndzQ4x1Vbiy8MHTCA2p4CdxP1zq8B6hQU8JK5/nAYWZxFQlWg9dJEN
	ZA4vUP3LdeEgYV4BQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDFIuIaAu8eivLkhYRMBI4tzq
	XVDlIhL7XrwDu19CYBW7xPGdZ5ghVglIfJt8iAWiV1Zi0wFoOEhKHFxxg2UCo8QsJJtnIdk8
	C8nmWUhWLGBkWcUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRElcTdzDeP2B9iDEZaP1EZinR
	5HxgXOaVxBsaG5uYmZiamFuampuSJqwkzit/SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	A+Okd7amcw+1ta5K9O6N6Q4wZdbS06uevODv7DNbLh0+VK3ZamnnWxJ/a+qFf2osaUs+zF/d
	07Lb7XH95elB7oK8Umvt76noHndvlTW2/7ncykTjQtO76gkc5xovpTKq/bv4tr/h7Oummqlz
	TQ9W3pHeWhqWzpjic+Tdh7cspRl7PY4wlmzcdUeJpTgj0VCLuag4EQDey7B4wQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG5BqEmgQdMKeYvLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcbZnNWvBfvaKpq6/jA2M
	W9m6GDk5JARMJPbM28IIYYtJXLi3HijOxSEksIhRonv5RxYIZzaTxIVP3awgVWwCahJfvhxm
	72Lk4BAR0Jdoa9EAqWEW6GWUONO7mx2kRkjAVuLLwwdMIDangJ3E/XOrwHqFBTwkrn+cBhZn
	EVCVaD10kQ1kDi9Q/ct14SBhXgFBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMUi4hoC7x6K8u
	SFhEwEji3OpdUOUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OL
	S/PS9ZLzczcxguP2mfQOxlUNFocYBTgYlXh4BT4ZBwqxJpYVV+YeYpTgYFYS4S2TMAkU4k1J
	rKxKLcqPLyrNSS0+xJgM9OdEZinR5HxgSskriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0
	xJLU7NTUgtQimC1MHJxSDYzeS00UP756fbks/u6bc8sWLvZZZbTrqNm/Z9m8NlZCj2NnuZin
	8Cr+zrA9e+zJCuNvUmVVO3V/1BztW22cNHvS1jXePiui/RwOTvr1xVDbQ+eU12nZBE3ZuTun
	Sa2aL1vM9tN2XcaX9T8i0m2Dcu6sUbe65RVYcD4t5v/TzQYuFYeO6HnptV9TYinOSDTUYi4q
	TgQAHoTTqB8DAAA=
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
 drivers/rtc/rtc-pcap.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index 48db88a..ce09824 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -203,18 +203,7 @@ static struct platform_driver pcap_rtc_driver = {
 	},
 };
 
-static int __init rtc_pcap_init(void)
-{
-	return platform_driver_probe(&pcap_rtc_driver, pcap_rtc_probe);
-}
-
-static void __exit rtc_pcap_exit(void)
-{
-	platform_driver_unregister(&pcap_rtc_driver);
-}
-
-module_init(rtc_pcap_init);
-module_exit(rtc_pcap_exit);
+module_platform_driver_probe(pcap_rtc_driver, pcap_rtc_probe);
 
 MODULE_DESCRIPTION("Motorola pcap rtc driver");
 MODULE_AUTHOR("guiming zhuo <gmzhuo@gmail.com>");
-- 
1.7.2.5


