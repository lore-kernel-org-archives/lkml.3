Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3EFEIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:08:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29855 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3EFEIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:08:10 -0400
X-AuditID: cbfee68d-b7f016d000007930-5d-51872ca90c00
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        "'J Keerthy'" <j-keerthy@ti.com>
Subject: [PATCH 4/8] mfd: twl4030-madc: remove unnecessary
 platform_set_drvdata()
Date: Mon, 06 May 2013 13:08:08 +0900
Message-id: <003101ce4a0f$513696e0$f3a3c4a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KDyeeSZNGDmMmQLqF+Was+hDcaQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zI92VOu2BBquPMVuc2t7EZHF54SVW
	i8u75rBZzPr4g9XidDerA6vHvJOBHn1bVjF6HL+xncnj8ya5AJYoLpuU1JzMstQifbsErowN
	f7YyFdziqnj7oY21gfEnRxcjB4eEgInEnH85XYycQKaYxIV769m6GLk4hASWMUpcmz+DESIB
	VNPTwgqRmM4oce/qUnYI5xejxOof39lBqtgE1CS+fDkMZosIaEl0HzsPNopZoIdRYtOy+2wg
	CWGBYImTJ8+C2SwCqhJrZ2xnArF5BSwlWp/ehbIFJX5MvscCYjMDDVq/8zgThC0vsXnNW2aI
	kxQkdpx9zQixTE/i4L2nzBA1IhL7XryDOnsbu0TrihKIXQIS3yYfYoF4WVZi0wGoMZISB1fc
	YJnAKDYLyeZZSDbPQrJ5FpINCxhZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmKERFvvDsbb
	B6wPMSYDrZ/ILCWanA+M1rySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MM7xF3I/Ymg0Q9xw/4tFqlOvPC1lEP/3pvPgJ+Hj+yuuhYiw5xRYnTJu
	fezt19M2i1WgQvnnjtvvZ6rydoo9FJ84J0X7nLXShs2yFZG353/fNSeLZ8WuwNCij5UH3A5p
	ChRsTX735OzDn48eL286wvbxa+iW9Nj+uzMWnvgarG9z6E3v0zXblvYpsRRnJBpqMRcVJwIA
	Bh20gMwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jQd0VOu2BBk2vbCxObW9isri88BKr
	xeVdc9gsZn38wWpxupvVgdVj3slAj74tqxg9jt/YzuTxeZNcAEtUA6NNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr4dpgmh
	IW66FjCNEbq+IUFwPUYGaCBhHWPGhj9bmQpucVW8/dDG2sD4k6OLkZNDQsBEYk5PCyuELSZx
	4d56ti5GLg4hgemMEveuLmWHcH4xSqz+8Z0dpIpNQE3iy5fDYLaIgJZE97HzYB3MAj2MEpuW
	3WcDSQgLBEucPHkWzGYRUJVYO2M7E4jNK2Ap0fr0LpQtKPFj8j0WEJsZaND6nceZIGx5ic1r
	3jJDnKQgsePsa0aIZXoSB+89ZYaoEZHY9+Id4wRGgVlIRs1CMmoWklGzkLQsYGRZxSiaWpBc
	UJyUnmuoV5yYW1yal66XnJ+7iREcz8+kdjCubLA4xCjAwajEw1vwpC1QiDWxrLgy9xCjBAez
	kgivz16gEG9KYmVValF+fFFpTmrxIcZkoE8nMkuJJucDU01eSbyhsYmZkaWRmYWRibk5acJK
	4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAeTZ143/KA5KNP26433rptV1p/8TurxlMFl/XV
	yzPe7tQQOR/17YX0cgtGmQPT53wzdzTMmMQ2YfmmdjP5ZKeEj7eDpvOJa/L+PNR2eM22C4Xu
	k0u87LRTZwXd0QnmvjeX/0guh6aZ7E83s9ZFvYF86QKbm3c2PDROPju9qiM+yT2FQ+bSPnsl
	luKMREMt5qLiRACH3+SBKwMAAA==
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
 drivers/mfd/twl4030-madc.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 42bd3ea..1ea54d4 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -775,12 +775,10 @@ static int twl4030_madc_probe(struct platform_device *pdev)
 				   IRQF_TRIGGER_RISING, "twl4030_madc", madc);
 	if (ret) {
 		dev_dbg(&pdev->dev, "could not request irq\n");
-		goto err_irq;
+		goto err_i2c;
 	}
 	twl4030_madc = madc;
 	return 0;
-err_irq:
-	platform_set_drvdata(pdev, NULL);
 err_i2c:
 	twl4030_madc_set_current_generator(madc, 0, 0);
 err_current_generator:
@@ -796,7 +794,6 @@ static int twl4030_madc_remove(struct platform_device *pdev)
 	struct twl4030_madc_data *madc = platform_get_drvdata(pdev);
 
 	free_irq(platform_get_irq(pdev, 0), madc);
-	platform_set_drvdata(pdev, NULL);
 	twl4030_madc_set_current_generator(madc, 0, 0);
 	twl4030_madc_set_power(madc, 0);
 	kfree(madc);
-- 
1.7.2.5


