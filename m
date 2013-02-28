Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3B1Iow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:44:52 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48697 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3B1Iot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:44:49 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-b5-512f19007b2a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 15/19] rtc: rtc-tx4939: remove erroneous __init/__exit
 annotations
Date: Thu, 28 Feb 2013 17:44:48 +0900
Message-id: <00b301ce158f$ddb0ef30$9912cd90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAOKgw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zI10GSf1Ag/+/tC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG0VutLAUfuCta5l5kbGD8ydnFyMkhIWAiceHYLDYIW0ziwr31
	QDYXh5DAMkaJtzPWM8IULdv6gRnEFhJYxChxZBtU0WwmiYWbl4B1swmoSXz5cpi9i5GDQ0RA
	X6KtRQOkhlmgl1HiTO9udohmW4ljbW0sIDangJ3E76dHWUHqhQVCJM6/dgQJswioSszp2wFW
	wgtU/m71UkYIW1Dix+R7YHFmAS2J9TuPM0HY8hKb17xlBhkjIaAu8eivLkhYRMBIYtLjZcwQ
	JSIS+168YwQ5R0JgEbvElRk32SF2CUh8m3yIBaJXVmLTAWaIdyUlDq64wTKBUWIWks2zkGye
	hWTzLCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIiau+HYw3D1gfYkwGWj+RWUo0
	OR8Yl3kl8YbGxiZmJqYm5pam5qakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wJh3/c/2+kzNEMVKzj0RB1kmWP1UVhZK4vhj8XWn1M6pnRUbbc9z8yryJfhO+d5+y/9Am9y6
	KtUrbluf9bEtyrA+/eiuQWPkz2nHDuTEfLb23/xQaGOKv3kj+48/whkVPosnJYtxZeh/nKGt
	fUG5fu6E9YpcvxdbGn18535gs/CnxS/iU5eZ2yuxFGckGmoxFxUnAgD1dAPewQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgC6DpH6gQcdcNYvLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcfRWK0vBB+6KlrkXGRsY
	f3J2MXJySAiYSCzb+oEZwhaTuHBvPRuILSSwiFHiyDYgmwvIns0ksXDzErAEm4CaxJcvh9m7
	GDk4RAT0JdpaNEBqmAV6GSXO9O5mh2i2lTjW1sYCYnMK2En8fnqUFaReWCBE4vxrR5Awi4Cq
	xJy+HWAlvEDl71YvZYSwBSV+TL4HFmcW0JJYv/M4E4QtL7F5zVtmkDESAuoSj/7qgoRFBIwk
	Jj1exgxRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10v
	OT93EyM4ap9J7WBc2WBxiFGAg1GJh7fDRC9QiDWxrLgy9xCjBAezkgivC79+oBBvSmJlVWpR
	fnxRaU5q8SHGZKBHJzJLiSbnAxNKXkm8obGJmZGlkZmFkYm5OWnCSuK8jKeeBAgJpCeWpGan
	phakFsFsYeLglGpgPBYe2PGOL3n6btEvd8/VtLVVTHQr/W56WFQ3/u8bvtlLqv1+FaUfTX61
	5ObO/Z+KH2h/W8DmNi9k/xqTjptcN/YUM79o0kz+yM/I1TDX4dChz/d7ZtzfzV8g0l983fvc
	2d0lQvGBvvl7VV4/aF2pohcs9ip7el1q2WXDnCWHVyWFLVvkIbzARImlOCPRUIu5qDgRAA0q
	RvkeAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__init/__exit annotations for probe()/remove() are supposed to be
__devinit/__devexit, because __init/__exit for probe()/remove()
are not correct. However, __devinit/__devexit are not used,
because CONFIG_HOTPLUG was removed. Thus, these annotations
should be removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-tx4939.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index a12bfac..f197773 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -237,7 +237,7 @@ static struct bin_attribute tx4939_rtc_nvram_attr = {
 	.write = tx4939_rtc_nvram_write,
 };
 
-static int __init tx4939_rtc_probe(struct platform_device *pdev)
+static int tx4939_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 	struct tx4939rtc_plat_data *pdata;
@@ -279,7 +279,7 @@ static int __init tx4939_rtc_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int __exit tx4939_rtc_remove(struct platform_device *pdev)
+static int tx4939_rtc_remove(struct platform_device *pdev)
 {
 	struct tx4939rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
@@ -292,7 +292,7 @@ static int __exit tx4939_rtc_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver tx4939_rtc_driver = {
-	.remove		= __exit_p(tx4939_rtc_remove),
+	.remove		= tx4939_rtc_remove,
 	.driver		= {
 		.name	= "tx4939rtc",
 		.owner	= THIS_MODULE,
-- 
1.7.2.5


