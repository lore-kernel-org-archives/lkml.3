Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3CDH6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:58:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12927 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3CDH56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:57:58 -0500
X-AuditID: cbfee68d-b7f636d0000009be-27-513454050f37
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 02/24] rtc: rtc-at32ap700x: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 16:57:57 +0900
Message-id: <013b01ce18ad$fbb428a0$f31c79e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAAbjQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zfV3WEJNAgxMNkhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj4dOzrAWf2Csad8xjb2B8wdbFyMkhIWAi0fF5OTOELSZx4d56
	oDgXh5DAMkaJA+vPs8MUtf66ywSRWMQo8bHxLVi3kMBsJokLX/JAbDYBNYkvXw4DNXBwiAjo
	S7S1aIDUMwv0Mkqc6d3NDlFvK/Hl4QMmEJtTwE7i/rlVrCD1wgJ+EucXh4GEWQRUJb7NWcUC
	YvMCle9susMGYQtK/Jh8DyzOLKAlsX7ncSYIW15i85q3zCBjJATUJR791QUJiwgYSTyZPRWq
	RERi34t3jCDnSAgsYpf4cn8XI8QuAYlvkw+xQPTKSmw6AA0HSYmDK26wTGCUmIVk8ywkm2ch
	2TwLyYoFjCyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MULiqncH4+0D1ocYk4HWT2SWEk3O
	B8ZlXkm8obGxiZmJqYm5pam5KWnCSuK8cpdkAoUE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw
	btnw4ubirx296pbmKv9WanC9f7443efa33PNG6PnKu0tZ835UhJxSVPywfe9QinKC+6s99WN
	PvL9o1romh9P7RTvZ01Ufikbo2PQw/Ft/uSHmnmMtv+29n27+26j578S2aiUB45Tfb+xlORx
	MH2z5V60YLm2wvbkG7szWab941X9FiQu/WbBLCWW4oxEQy3mouJEAN/S66vBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgC5riEmgwbZmYYvLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsfDpWdaCT+wVjTvmsTcw
	vmDrYuTkkBAwkWj9dZcJwhaTuHBvPVCci0NIYBGjxMfGt2BFQgKzmSQufMkDsdkE1CS+fDnM
	3sXIwSEioC/R1qIBUs8s0MsocaZ3NztEva3El4cPwIZyCthJ3D+3ihWkXljAT+L84jCQMIuA
	qsS3OatYQGxeoPKdTXfYIGxBiR+T74HFmQW0JNbvPM4EYctLbF7zlhlkjISAusSjv7ogYREB
	I4kns6dClYhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvX
	S87P3cQIjtpnUjsYVzZYHGIU4GBU4uEV+GQcKMSaWFZcmXuIUYKDWUmEt0zCJFCINyWxsiq1
	KD++qDQntfgQYzLQoxOZpUST84EJJa8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1Kz
	U1MLUotgtjBxcEo1MBo4ezqWbLl/ul/ZznfFosl9AkFGp7Ijjy7qNvqWxMTDUrtAacV9/6cP
	9incPPm38ZOC8P42zt9O9YKW71j8vALWfrFIecdqVy/TnFZ2TFzEV8bn0bulqko/ZRa4Bhrs
	rPJwYl50It9i3puVjyqepr5zv8Q/RcfSl1fu84Ku52/m37/S/uVwhRJLcUaioRZzUXEiAPbh
	PLgeAwAA
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
 drivers/rtc/rtc-at32ap700x.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index 8dd0830..619c887 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -302,17 +302,7 @@ static struct platform_driver at32_rtc_driver = {
 	},
 };
 
-static int __init at32_rtc_init(void)
-{
-	return platform_driver_probe(&at32_rtc_driver, at32_rtc_probe);
-}
-module_init(at32_rtc_init);
-
-static void __exit at32_rtc_exit(void)
-{
-	platform_driver_unregister(&at32_rtc_driver);
-}
-module_exit(at32_rtc_exit);
+module_platform_driver_probe(at32_rtc_driver, at32_rtc_probe);
 
 MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
 MODULE_DESCRIPTION("Real time clock for AVR32 AT32AP700x");
-- 
1.7.2.5


