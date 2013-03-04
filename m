Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3CDIGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:06:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52023 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3CDIGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:06:15 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-dc-513455f67fa9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 21/24] rtc: rtc-starfire: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:06:13 +0900
Message-id: <014e01ce18af$23c41700$6b4c4500$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAASjEw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY91voSaBBqvviFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M8zMaGAu2s1fMeziPrYFxB1sXIyeHhICJxIwfi9ghbDGJC/fW
	g8WFBJYxSrT9dOpi5ACr2f4yoouRCyi8iFGiu2EGK4Qzm0li0o6FYA1sAmoSX74cZgdpEBHQ
	l2hr0QCpYRboZZQ407ubHWKorcSXhw+YQGxOATuJ++dWsYLYwgI+EvMnvWABsVkEVCU+rp0K
	ZvMC1Z/oWs4KYQtK/Jh8DyzOLKAlsX7ncSYIW15i85q3zBCHqks8+qsLEhYRMJL4/PsCM0SJ
	iMS+F+8YQe6REFjGLrFp2XtWiF0CEt8mH2KB6JWV2HSAGRIOkhIHV9xgmcAoMQvJ5llINs9C
	snkWkhULGFlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoTE1cQdjPcPWB9iTAZaP5FZSjQ5
	HxiXeSXxhsbGJmYmpibmlqbmpqQJK4nzyl+SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	GF/svePidsazvlLJfPpMHVUszcfjcwvst/cElHxRP2u9MV32bteHpa3brQIf5myUPuk2ic+o
	P+vpOkXT3ivc63JuduflLZI85iZRyhJTPrdr7ozY+AhPe/PsI9cLs3aWW538lXOFUX6KqrDI
	pZsat1WesIp9sN7ue/BJ9spVpYsEXp/1+HRRiaU4I9FQi7moOBEA5DDA7sECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO63UJNAg0XLBS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxvkZDYwF29kr5j2cx9bA
	uIOti5GDQ0LARGL7y4guRk4gU0ziwr31QGEuDiGBRYwS3Q0zWCGc2UwSk3YsZAOpYhNQk/jy
	5TA7SLOIgL5EW4sGSA2zQC+jxJne3ewgNUICthJfHj5gArE5Bewk7p9bxQpiCwv4SMyf9IIF
	xGYRUJX4uHYqmM0LVH+iazkrhC0o8WPyPbA4s4CWxPqdx5kgbHmJzWveMkMcrS7x6K8uSFhE
	wEji8+8LzBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz
	0vWS83M3MYLj9pnUDsaVDRaHGAU4GJV4eAU+GQcKsSaWFVfmHmKU4GBWEuEtkzAJFOJNSays
	Si3Kjy8qzUktPsSYDPToRGYp0eR8YErJK4k3NDYxM7I0MrMwMjE3J01YSZyX8dSTACGB9MSS
	1OzU1ILUIpgtTBycUg2MRwpll7aubPlywcdbSk+5KOmOjdk+/Xuz6q8w7bd7weFdIWoYZ9Yz
	Zf0X0+0ff5Wtvl7j+2qPsYPr10s3mc8t+7137gHbMkNzibTD/pMXNuXdeJ92V5F/vtMev8Wh
	jK929hdeW5LZ8zKDkXGfhmSI8wL5eZrLnx57XxH5muWwUrb134MtvzjXKbEUZyQaajEXFScC
	ABTdy+QfAwAA
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
 drivers/rtc/rtc-starfire.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-starfire.c b/drivers/rtc/rtc-starfire.c
index 5be98bf..db7d076 100644
--- a/drivers/rtc/rtc-starfire.c
+++ b/drivers/rtc/rtc-starfire.c
@@ -66,15 +66,4 @@ static struct platform_driver starfire_rtc_driver = {
 	.remove		= __exit_p(starfire_rtc_remove),
 };
 
-static int __init starfire_rtc_init(void)
-{
-	return platform_driver_probe(&starfire_rtc_driver, starfire_rtc_probe);
-}
-
-static void __exit starfire_rtc_exit(void)
-{
-	platform_driver_unregister(&starfire_rtc_driver);
-}
-
-module_init(starfire_rtc_init);
-module_exit(starfire_rtc_exit);
+module_platform_driver_probe(starfire_rtc_driver, starfire_rtc_probe);
-- 
1.7.2.5


