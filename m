Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaBFIba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:31:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31406 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbaBFIb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:31:28 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-e0-52f3485e6d82
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Ben Dooks'" <ben.dooks@codethink.co.uk>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 11/12] backlight: platform_lcd: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:31:26 +0900
Message-id: <000c01cf2315$d36fd240$7a4f76c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAAbK6w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zQ904j89BBguPWlvMWb+GzeLBrVYm
	i8sLL7FaXN41h82BxePZy8lMHidm/Gbx6NuyitHj8ya5AJYoLpuU1JzMstQifbsEroxrc1cy
	FWxhq+g7K9TAuIy1i5GTQ0LAROLuuQZGCFtM4sK99WxdjFwcQgLLGCUWrDwFV7RrxnaoxCJG
	iW0TpjFCOL8YJTruTWYGqWITUJP48uUwexcjB4eIgL5EW4sGiMkskC/xbJo+SIWQgK3E7tMn
	wWZyCthJbPvUygRiCwv4S3w+eJINxGYRUJWYOnEGO4jNC1R/+vohZghbUOLH5HssIDazgJbE
	+p3HmSBseYnNa94yg6ySEFCXePRXFyQsImAk8e34V2aIEhGJfS/egV0sIXCJXeLVI4gbWAQE
	JL5NPsQC0SsrsekAM8S7khIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelFxnq
	FSfmFpfmpesl5+duYoREZO8OxtsHrA8xJgOtn8gsJZqcD4zovJJ4Q2MzIwtTE1NjI3NLM9KE
	lcR5kx4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgFBdyni8q5+2nb1L/1yz58XkHTg+T
	+N9n/a7e/tteJO9mlpMqVX3BJeMjY9o9pxS/+dr8M5QbHxiu9/deXs6UfmuWy63PpmdL8oRZ
	Wa53+WpP+HSk8+nLqkU5YsxfeFc2J/x9UcN8fecpm13nSmuF/rpsb+27ojgjUeLBs2tHXz7d
	Ka2YVnVTiaU4I9FQi7moOBEA1wvJut4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd04j89BBl3NFhZz1q9hs3hwq5XJ
	4vLCS6wWl3fNYXNg8Xj2cjKTx4kZv1k8+rasYvT4vEkugCWqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwjjHj2tyVTAVb2Cr6zgo1MC5j7WLk5JAQMJHYNWM7G4QtJnHh3nog
	m4tDSGARo8S2CdMYIZxfjBId9yYzg1SxCahJfPlymL2LkYNDREBfoq1FA8RkFsiXeDZNH6RC
	SMBWYvfpk2DzOQXsJLZ9amUCsYUF/CU+HzwJtotFQFVi6sQZ7CA2L1D96euHmCFsQYkfk++x
	gNjMAloS63ceZ4Kw5SU2r3nLDLJKQkBd4tFfXZCwiICRxLfjX5khSkQk9r14xziBUWgWkkmz
	kEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx/szqR2MKxssDjEKcDAq
	8fBuWP8pSIg1say4MvcQowQHs5II71bzz0FCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9M
	RXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwNhYssf70Y/H
	x+f6XA154GruWavOoCwo+Py7x2Gpc7vnC+y5eWPP/NL+mZsP+Rfsi9kRau+/xnvT/UkL9xWE
	+29O9dGLF3EMPf+/uvPdOtv1lbNyVBmatmzT8b5z0cpmtr3nwb2rb2Xy2JY46vats9Bbd0Tc
	o9Mk6FX0zohd4X0Hy9L9fwt+v67EUpyRaKjFXFScCACxuR3EOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/platform_lcd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index d01884d..c3d2e20 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -94,10 +94,8 @@ static int platform_lcd_probe(struct platform_device *pdev)
 
 	plcd = devm_kzalloc(&pdev->dev, sizeof(struct platform_lcd),
 			    GFP_KERNEL);
-	if (!plcd) {
-		dev_err(dev, "no memory for state\n");
+	if (!plcd)
 		return -ENOMEM;
-	}
 
 	plcd->us = dev;
 	plcd->pdata = pdata;
-- 
1.7.10.4


