Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3EFDgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:36:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42106 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3EFDgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:36:53 -0400
X-AuditID: cbfee68f-b7f066d000003683-12-51872554ccc8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 7/7] gpio: vx855: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:36:51 +0900
Message-id: <001d01ce4a0a$f2e02fb0$d8a08f10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KCsQ3FJmG67cYSf2YcoWjJnMS3Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zQ90Q1fZAg5s7dC1endnIZnF54SVW
	iyl/ljNZXN41h82BxePOtT1sHn1bVjF6/Hyp4/F5k1wASxSXTUpqTmZZapG+XQJXxrerlQVr
	OCqWr7nH1sD4m62LkZNDQsBEYsGsVlYIW0ziwr31QHEuDiGBZYwSZ/qb2GGKFm99ygqRWMQo
	MeH7RKiqX4wSi+8+YQSpYhNQk/jy5TBYh4iAnsSNCx1gcWaBAonTB9+CrRMW8JZ4e2kXWJxF
	QFWi8+4EsNW8ApYSW+ZsYYewBSV+TL7HAtGrJbF+53EmCFteYvOat8wQFylI7Dj7mhFm15zO
	5cwQNSIS+168YwQ5TkJgFbvExrNvWSCWCUh8m3wIyOYASshKbDoANUdS4uCKGywTGMVmIVk9
	C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkCjr38F494D1IcZkoPUT
	maVEk/OBUZpXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBsb2+fd1sjwfN6wpDj12PkMl6HOd+tlrPZKHJ7OzLo/dfVG1SsOvkSHj/YZ/HxKnLbBX
	mn/bP2/SegcxvQ+h1kd4Jf6Uf9Rhjmdvs0g4LMlsJ9WXNkdrVuxsXQEBheD2A2pse54we4fG
	H/2w8uP3ier7TLbnxjDMv9dQYf7p9/Q7PAsXirNyblFiKc5INNRiLipOBAB2tcdlyAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAd0Q1fZAg0WXNS1endnIZnF54SVW
	iyl/ljNZXN41h82BxePOtT1sHn1bVjF6/Hyp4/F5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8a3q5UFazgqlq+5x9bA+Juti5GTQ0LARGLx1qesELaYxIV764Hi
	XBxCAosYJSZ8nwjl/GKUWHz3CSNIFZuAmsSXL4fZQWwRAT2JGxc6wOLMAgUSpw++BZsqLOAt
	8fbSLrA4i4CqROfdCWAbeAUsJbbM2cIOYQtK/Jh8jwWiV0ti/c7jTBC2vMTmNW+ZIS5SkNhx
	9jUjzK45ncuZIWpEJPa9eMc4gVFgFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YW
	l+al6yXn525iBMfwM6kdjCsbLA4xCnAwKvHwFjxpCxRiTSwrrsw9xCjBwawkwuuzFyjEm5JY
	WZValB9fVJqTWnyIMRno04nMUqLJ+cD0klcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTE
	ktTs1NSC1CKYLUwcnFINjJEeHF9fG67+M7PXOP7+vGUPnfJOxB53EOJyi5A947ah7EDQkh2l
	bYxSN+O3rHq0M86tR1S5cpte0MSpByr9npU4PTLa+uWwR0Sg54xHzz7qPgl+MFnNwmjlcr9m
	jcMPvZ9deKApuzRrduuVkyxNnx4cELEVkfn3/vRVtg1PTbS0Z/9m0+ItlVRiKc5INNRiLipO
	BAAUgMPHJQMAAA==
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
 drivers/gpio/gpio-vx855.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-vx855.c b/drivers/gpio/gpio-vx855.c
index 2b7252c..cddfa22 100644
--- a/drivers/gpio/gpio-vx855.c
+++ b/drivers/gpio/gpio-vx855.c
@@ -279,7 +279,6 @@ out_release:
 		release_region(res_gpi->start, resource_size(res_gpi));
 	if (vg->gpo_reserved)
 		release_region(res_gpi->start, resource_size(res_gpo));
-	platform_set_drvdata(pdev, NULL);
 	kfree(vg);
 	return ret;
 }
@@ -301,7 +300,6 @@ static int vx855gpio_remove(struct platform_device *pdev)
 		release_region(res->start, resource_size(res));
 	}
 
-	platform_set_drvdata(pdev, NULL);
 	kfree(vg);
 	return 0;
 }
-- 
1.7.2.5


