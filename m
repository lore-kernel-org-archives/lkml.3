Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3EFEFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:05:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46641 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3EFEFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:05:45 -0400
X-AuditID: cbfee691-b7fe56d000004b96-44-51872c17e3c1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/8] mfd: jz4740-adc: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:05:43 +0900
Message-id: <002f01ce4a0e$faaad3e0$f0007ba0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KDtf0EjEBxSG2Rfma0hdQMb/kIA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zfV1xnfZAg8UNehaXF15itVgyeT6r
	xeVdc9gsTnezOrB4zDsZ6LHkzSFWj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mr4N/kBe8Ei
	jooP1y4xNjB+Y+ti5OSQEDCR+NW3hgnCFpO4cG89UJyLQ0hgGaNE2+W7jDBFC/bOZoJILGKU
	2P/9IlTVL0aJ+fubwUaxCahJfPlymB3EFhHQkug+dh4sziyQJXHk60SwFcIC/hJHXzWwdDFy
	cLAIqEpsmOIIEuYVsJQ4/W8tC4QtKPFj8j0WiFYtifU7jzNB2PISm9e8ZYY4SEFix9nXjBCr
	9CR+nnrHDFEjIrHvxTtGkNskBNaxS6z8+wKsiEVAQOLb5ENgeyUEZCU2HYCaIylxcMUNlgmM
	YrOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZIjE3cwXj/gPUh
	xmSg9ROZpUST84ExmlcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlO
	avEhRiYOTqkGRqm3HH9PazxjmNv0cp/Qgv92q3SPWYnM3yuSnL5M2TlmlklA1q5XK/au3uJY
	/GbCzBlX9l8r8r7z+4ju9m0FekXuvKpV2mfm9B0/KLKxYufNf+o5vtYlZ86Uttt3VP/jX5uU
	zrzJT3eV4s9DQt6/03edyDgon2i8MuqKxu4deqZPLmw7c+xXqrsSS3FGoqEWc1FxIgDKq7r2
	xwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAV1xnfZAg9PrtCwuL7zEarFk8nxW
	i8u75rBZnO5mdWDxmHcy0GPJm0OsHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeY8W/yA/aCRRwVH65dYmxg/MbWxcjJISFgIrFg72wmCFtM4sK99UBx
	Lg4hgUWMEvu/X4RyfjFKzN/fDNbBJqAm8eXLYXYQW0RAS6L72HmwOLNAlsSRrxPBJgkL+Esc
	fdXA0sXIwcEioCqxYYojSJhXwFLi9L+1LBC2oMSPyfdYIFq1JNbvPM4EYctLbF7zlhniIAWJ
	HWdfM0Ks0pP4eeodM0SNiMS+F+8YJzAKzEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XEO9
	4sTc4tK8dL3k/NxNjOAIfia1g3Flg8UhRgEORiUe3oInbYFCrIllxZW5hxglOJiVRHh99gKF
	eFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YXPJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0o
	JJCeWJKanZpakFoEs4WJg1OqgTFi5w/dpoWVprorPf9vNPrzhOHq8jkC8dvXbzmhcZ7DbJ9H
	weX+p+cVXu5WvD9vwazEWGeWJZJO216yLFyuEx7XfqVe+2aoxJdlkyace/9qXjpn0qNlm07z
	VmfKrJTTaThbP8HR/v8z1cDSJMMXaQu5t+9WdCk9HHPj+IHvZSfkF98zVtp+9NsuJZbijERD
	Leai4kQA6MvRdCQDAAA=
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
 drivers/mfd/jz4740-adc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index e80587f..01e86ce 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -294,7 +294,6 @@ static int jz4740_adc_probe(struct platform_device *pdev)
 err_clk_put:
 	clk_put(adc->clk);
 err_iounmap:
-	platform_set_drvdata(pdev, NULL);
 	iounmap(adc->base);
 err_release_mem_region:
 	release_mem_region(adc->mem->start, resource_size(adc->mem));
@@ -317,8 +316,6 @@ static int jz4740_adc_remove(struct platform_device *pdev)
 
 	clk_put(adc->clk);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


