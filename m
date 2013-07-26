Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab3GZL0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:26:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50799 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3GZL0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:26:12 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-17-51f25cd2104e
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v8 01/12] iommu/exynos: do not include removed header
Date: Fri, 26 Jul 2013 20:26:10 +0900
Message-id: <003701ce89f2$eda94ef0$c8fbecd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6J8YDulexy5cd1TPWjw3BJWmK8lw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zke6lmE+BBu+eylvcuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzigum5TUnMyy1CJ9uwSujL5pM9kLJrNVPDpg2sDYy9rFyMkhIWAiMfPIXihb
	TOLCvfVsILaQwDJGiatP7GFqmv7sYO5i5AKKL2KUONjRxwTh/GWUeNO8CaybTUBLYvXc44wg
	tojAXUaJl+d5QIqYBW4zS0z7+QoowcEhLOAqse2kH0gNi4CqxMQd09hBbF4BS4kDzU0sELag
	xI/J98BsZqCZ63ceZ4Kw5SU2r3nLDHGRgsSOs6/BRooI6ElcuBMGUSIise/FO0aQtRICSzkk
	Jr3fxQyxS0Di2+RDLCD1EgKyEpsOQI2RlDi44gbLBEaxWUg2z0KyeRaSzbOQrFjAyLKKUTS1
	ILmgOCm9yFCvODG3uDQvXS85P3cTIyT+e3cw3j5gfYgxGWj9RGYp0eR8YPrIK4k3NDYzsjA1
	MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjrcdeNldWWO0y2vNp
	3WvJsrN20hZJabnT68T4l7+/l2pu0JrinRT8R+Vm35/piRL2161WLnz2xMrA89WK3wciPUMm
	sOWdXntmXlyqsayat6S65aqDc51yLV8wTpy/9Ua9tmjwJU/hubqHaxkDJ86bHuXUUXBTrT7k
	r8IukYjND/gvV91vcshWYinOSDTUYi4qTgQAEHXvxRUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jAd1LMZ8CDX7ulba4c/ccq8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGbx8dRxdotNj6+xWlzeNYfNYsb5fUwWF1ZsZLeY
	sugwq8XJP72MFi3Xe5kc+D2eHJzH5DG74SKLx51re9g8zm9aw+yxeUm9x+Qbyxk9+rasYvT4
	vEnO48rRM0wBnFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QB8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDP6ps1kL5jM
	VvHogGkDYy9rFyMnh4SAiUTTnx3MELaYxIV769m6GLk4hAQWMUoc7OhjgnD+Mkq8ad4E1sEm
	oCWxeu5xRhBbROAuo8TL8zwgRcwCt5klpv18BZTg4BAWcJXYdtIPpIZFQFVi4o5p7CA2r4Cl
	xIHmJhYIW1Dix+R7YDYz0Mz1O48zQdjyEpvXvIW6SEFix9nXYCNFBPQkLtwJgygRkdj34h3j
	BEaBWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZxenkntYFzZ
	YHGIUYCDUYmHV8HpY6AQa2JZcWXuIUYJDmYlEd7r3p8ChXhTEiurUovy44tKc1KLDzEmAz06
	kVlKNDkfmPrySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoFx
	o+t/Me/mI6d8Be+stZuWM7X9X0L66akvul9s15b4q9vTs4Dd7+u9NSfrvjU+EHb2CFu9eoP5
	oauLtYud2VfPD5ir6l+yjvPazLXasawPNNvEtdnTN1xu8TP2y1R/77AqwrftZB/b0qaFZ9a0
	SM6QX3C+J9P0yBrhuT9X2XUmOBxNSGm9lHJAiaU4I9FQi7moOBEA+mISUHMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit remove <mach/sysmmu.h> which is removed.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 3f32d64..233f382 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -12,6 +12,7 @@
 #define DEBUG
 #endif
 
+#include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
@@ -29,8 +30,6 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
-#include <mach/sysmmu.h>
-
 /* We does not consider super section mapping (16MB) */
 #define SECT_ORDER 20
 #define LPAGE_ORDER 16
-- 
1.7.2.5


