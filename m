Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3EGFcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:32:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62416 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3EGFcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:32:13 -0400
X-AuditID: cbfee68f-b7f066d000003683-94-518891dccb7c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] misc: arm-charlcd: remove unnecessary
 platform_set_drvdata()
Date: Tue, 07 May 2013 14:32:11 +0900
Message-id: <003701ce4ae4$39926f20$acb74d60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5K5B99LZDrDkjmT0urYwRGn5u+pw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zQ907EzsCDR7v47T4O+kYu0Xz4vVs
	FpcXXmK1mPJnOZPF5V1z2BxYPX7/msTocefaHjaP/XPXsHv0bVnF6PF5k1wAaxSXTUpqTmZZ
	apG+XQJXxrT1X9kLergrrt54wtzAOJ+zi5GTQ0LAROLFhHvMELaYxIV769m6GLk4hASWMUrM
	3bSFHaZo38f37BCJ6YwS63fOYIVwfjFKdE4+ygRSxSagJvHly2GwDhGBCImW1mbGLkYODmaB
	IokP5/VAwsICwRI9p5eChVkEVCVazseDhHkFLCWuzXjACmELSvyYfI8FxGYW0AJadZwJwpaX
	2LzmLdShChI7zr5mhNikJ7F50XaoGhGJfS/eMYKcJiFwiF3i+b89YEUsAgIS3yYfYgHZKyEg
	K7HpANQcSYmDK26wTGAUm4Vk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSi4z1ihNzi0vz0vWS
	83M3MUIir38H490D1ocYk4HWT2SWEk3OB0ZuXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC
	6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYRTaXvU34npQTt3VG7WWX+jliNv1dxsXm05buuxX0
	3j9dadppJ3Mu0UPsnbXVQqwV7QXa9nG5XNsf11zlm7y+zG7j9QnJ9XKZK/epvlrx98DxkJeV
	9aebtu+fcIbf1LPl2kl9+exJLed3ZV19+tm/XWDGtn+FP1y/Rk22eDh1zcPqG/GbdVzvKLEU
	ZyQaajEXFScCAHRCRmTSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd07EzsCDV6+Y7X4O+kYu0Xz4vVs
	FpcXXmK1mPJnOZPF5V1z2BxYPX7/msTocefaHjaP/XPXsHv0bVnF6PF5k1wAa1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0HYlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8a09V/ZC3q4K67eeMLcwDifs4uRk0NCwERi
	38f37BC2mMSFe+vZuhi5OIQEpjNKrN85gxXC+cUo0Tn5KBNIFZuAmsSXL4fBOkQEIiRaWpsZ
	uxg5OJgFiiQ+nNcDCQsLBEv0nF4KFmYRUJVoOR8PEuYVsJS4NuMBK4QtKPFj8j0WEJtZQAto
	1XEmCFteYvOat8wQ9yhI7Dj7mhFik57E5kXboWpEJPa9eMc4gVFgFpJRs5CMmoVk1CwkLQsY
	WVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMf1M+kdjKsaLA4xCnAwKvHwKpxqDxRiTSwr
	rsw9xCjBwawkwiut3REoxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAlJNXEm9obGJmZGlk
	ZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyGAaZftFKqnjOxfS1Uuv2puu+p
	uYbeqaNfKqb0PN2c632yV+b/13OxmzcZLyywm1PA+Cx9pc4B/b6DgRtW7Cy5kjb1a6XE7Peb
	X5/wyT17WG7BxLAXfLbHdy3b8cY09rqL4+XC6NvBvMfYElOF/svGP7lyqDUwSHeejB7LDu5r
	PXvW3rLLPXxHiaU4I9FQi7moOBEAFvHUMC8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/arm-charlcd.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/arm-charlcd.c b/drivers/misc/arm-charlcd.c
index 48651ef..1256a4b 100644
--- a/drivers/misc/arm-charlcd.c
+++ b/drivers/misc/arm-charlcd.c
@@ -291,7 +291,7 @@ static int __init charlcd_probe(struct platform_device *pdev)
 	lcd->virtbase = ioremap(lcd->phybase, lcd->physize);
 	if (!lcd->virtbase) {
 		ret = -ENOMEM;
-		goto out_no_remap;
+		goto out_no_memregion;
 	}
 
 	lcd->irq = platform_get_irq(pdev, 0);
@@ -320,8 +320,6 @@ static int __init charlcd_probe(struct platform_device *pdev)
 
 out_no_irq:
 	iounmap(lcd->virtbase);
-out_no_remap:
-	platform_set_drvdata(pdev, NULL);
 out_no_memregion:
 	release_mem_region(lcd->phybase, SZ_4K);
 out_no_resource:
@@ -337,7 +335,6 @@ static int __exit charlcd_remove(struct platform_device *pdev)
 		free_irq(lcd->irq, lcd);
 		iounmap(lcd->virtbase);
 		release_mem_region(lcd->phybase, lcd->physize);
-		platform_set_drvdata(pdev, NULL);
 		kfree(lcd);
 	}
 
-- 
1.7.2.5


