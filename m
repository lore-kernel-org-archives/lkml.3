Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbaHVGYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 02:24:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45769 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaHVGX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 02:23:58 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-a9-53f6e1fcfa8f
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: platform_lcd: remove unnecessary #ifdef CONFIG_OF
Date: Fri, 22 Aug 2014 15:23:56 +0900
Message-id: <007701cfbdd1$a70486e0$f50d94a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+90aayJDYJFIIwRAaC+rX6YUehnw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zQ90/D78FG+z8q25xdOdEJovLCy+x
	Wtz/epTR4kTfB1aLy7vmsDmweuycdZfd4861PWwefVtWMXp83iQXwBLFZZOSmpNZllqkb5fA
	lfHm0gm2gunsFYeW7GdpYOxl62Lk5JAQMJF4+foalC0mceHeeiCbi0NIYBmjxN62WawwRQu2
	vGKESCxilDizdhkLhPObUWLulstMIFVsAmoSX74cZgexRQQUJDb3PmMFKWIW6GKU+HvnBjNI
	QljAV2L9nvNgDSwCqhIr794Gi/MK2Eo8nngPyhaU+DH5HguIzSygJbF+53EmCFteYvOat0A1
	HEAnqUs8+qsLsUtP4sXmn2wQJSIS+168A7tUQmAfu8TWufegdglIfJt8iAWiV1Zi0wFmiM8k
	JQ6uuMEygVFsFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECIm5
	/h2Mdw9YH2JMBlo/kVlKNDkfGLN5JfGGxmZGFqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2a
	WpBaFF9UmpNafIiRiYNTqoGx4mDOe+/HRyMfbjx23FuoolJK+95cdo5iXz+ftacmiHwUevjy
	5XK++d5z73/KLLjYszxFiH1R0i25rT/XuzmKGKYe4jBaOsWpI0InPN5XPjX458un+S//x+cX
	RPswbNp5Im5Lx8fVzr4TTjKfu547Y++O4JPTXnaGpEuyzL6+eB7Ty3CpX6wdSizFGYmGWsxF
	xYkAagSqd88CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAd0/D78FG7zYoGJxdOdEJovLCy+x
	Wtz/epTR4kTfB1aLy7vmsDmweuycdZfd4861PWwefVtWMXp83iQXwBLVwGiTkZqYklqkkJqX
	nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RYSaEsMacUKBSQWFyspG+H
	aUJoiJuuBUxjhK5vSBBcj5EBGkhYx5jx5tIJtoLp7BWHluxnaWDsZeti5OSQEDCRWLDlFSOE
	LSZx4d56oDgXh5DAIkaJM2uXsUA4vxkl5m65zARSxSagJvHly2F2EFtEQEFic+8zVpAiZoEu
	Rom/d24wgySEBXwl1u85D9bAIqAqsfLubbA4r4CtxOOJ96BsQYkfk++xgNjMAloS63ceZ4Kw
	5SU2r3kLVMMBdJK6xKO/uhC79CRebP7JBlEiIrHvxTvGCYwCs5BMmoVk0iwkk2YhaVnAyLKK
	UTS1ILmgOCk910ivODG3uDQvXS85P3cTIziin0nvYFzVYHGIUYCDUYmHN+LL12Ah1sSy4src
	Q4wSHMxKIryb5n0LFuJNSaysSi3Kjy8qzUktPsRoCvToRGYp0eR8YLLJK4k3NDYxM7I0MrMw
	MjE3VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAKH3xXlDj9A1HxeY6fr113fJsccKeu/uV
	Vtjs4/tpvmjzeZ53k2tFQybNSPq/fF+05W+hFZFfj+zsDZVzPMTLcv+HsVfE7i3dinfzaz3i
	5F8bHV8+63OZkfNbnjviK9f0/5ljmx4UE2nE3er3IYzfZ+riV4n5vkFN6pPShDO3Nh9/u2fR
	9i0f9ymxFGckGmoxFxUnAgArAfx4/gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary #ifdef CONFIG_OF, because this is already
handled by the of_match_ptr macro.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/platform_lcd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index c3d2e209fc8f..2bca5ca760ee 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -137,13 +137,11 @@ static int platform_lcd_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(platform_lcd_pm_ops, platform_lcd_suspend,
 			platform_lcd_resume);
 
-#ifdef CONFIG_OF
 static const struct of_device_id platform_lcd_of_match[] = {
 	{ .compatible = "platform-lcd" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, platform_lcd_of_match);
-#endif
 
 static struct platform_driver platform_lcd_driver = {
 	.driver		= {
-- 
2.0.0


