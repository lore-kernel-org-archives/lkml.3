Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3CDIDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:03:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51424 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab3CDIDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:03:32 -0500
X-AuditID: cbfee68d-b7f636d0000009be-3f-513455526f8f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 15/24] rtc: rtc-omap: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:03:30 +0900
Message-id: <014801ce18ae$c2836450$478a2cf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAANBWw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zA92gUJNAg8YfVhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj9IouloJl7BWNG1vZGxjnsnUxcnBICJhI3J+g2cXICWSKSVy4
	tx4ozMUhJLCMUeLmmpnsEAkTiWWr+8FsIYFFjBIT/ytCFM1mkliy4g4jSIJNQE3iy5fD7CBD
	RQT0JdpaNEBqmAV6GSXO9O6GaraV+PLwAROIzSlgJ3H/3CpWEFtYwEPi5pLjYHEWAVWJH9ue
	MIPYvED1hzZ/Y4KwBSV+TL7HAmIzC2hJrN8JUc8sIC+xec1bZohn1CUe/dUFCYsIGEkcm94H
	VS4ise/FO0aQeyQElrFLnJqwEGqXgMS3yYdYIHplJTYdYIb4V1Li4IobLBMYJWYh2TwLyeZZ
	SDbPQrJiASPLKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYyQuOrdwXj7gPUhxmSg9ROZpUST
	84FxmVcSb2hsbGJmYmpibmlqbkqasJI4r9wlmUAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jAs7PrIVva7/ELNfmCW9rzxuzz0+s9pJJo+8OE7N/NWoo56h9+FlT/Pe3v9nGBfvSKo2uWqq
	4cCvUHY6+NEKnaYdpZPu3//ps2nBgvVLEnnfTHnEayy8dPn+uHonnX31+z79i5ptJJCf8mtK
	fj9D+TW5/tyZhzfVGy9+4rfw0c7eiOm9s9hkxZVYijMSDbWYi4oTAcA6lQHBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG5QqEmgwerPphaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/SKLpaCZewVjRtb2RsY
	57J1MXJySAiYSCxb3c8OYYtJXLi3HiwuJLCIUWLif8UuRi4gezaTxJIVdxhBEmwCahJfvhwG
	auDgEBHQl2hr0QCpYRboZZQ407ubHaLZVuLLwwdMIDangJ3E/XOrWEFsYQEPiZtLjoPFWQRU
	JX5se8IMYvMC1R/a/I0JwhaU+DH5HguIzSygJbF+J0Q9s4C8xOY1b5lB9koIqEs8+qsLEhYR
	MJI4Nr0PqlxEYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66
	XnJ+7iZGcNw+k9rBuLLB4hCjAAejEg+vwCfjQCHWxLLiytxDjBIczEoivGUSJoFCvCmJlVWp
	RfnxRaU5qcWHGJOBHp3ILCWanA9MKXkl8YbGJmZGlkZmFkYm5uakCSuJ8zKeehIgJJCeWJKa
	nZpakFoEs4WJg1OqgXH3sWtenhdiGf1kP0gmP3K10Ts4pUC/9pORB7eRu3utbR7zUpZjqyN2
	sTu9KZ66arvhgbaFfyZs2s2/pHltUmK5Y72E0A5VtllTH6xor34yoyXx7dwbrIKWov+iplWI
	RNnc/Xt72uv9PItvfNqkM0X0dnrOFtPkFMuVDIax3rZXet7fUl1/iEOJpTgj0VCLuag4EQBj
	Lfy1HwMAAA==
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
 drivers/rtc/rtc-omap.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 6009714..172cc5c 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -550,17 +550,7 @@ static struct platform_driver omap_rtc_driver = {
 	.id_table	= omap_rtc_devtype,
 };
 
-static int __init rtc_init(void)
-{
-	return platform_driver_probe(&omap_rtc_driver, omap_rtc_probe);
-}
-module_init(rtc_init);
-
-static void __exit rtc_exit(void)
-{
-	platform_driver_unregister(&omap_rtc_driver);
-}
-module_exit(rtc_exit);
+module_platform_driver_probe(omap_rtc_driver, omap_rtc_probe);
 
 MODULE_AUTHOR("George G. Davis (and others)");
 MODULE_LICENSE("GPL");
-- 
1.7.2.5


