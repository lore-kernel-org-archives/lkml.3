Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3IXJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:16:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24875 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3IXJQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:16:54 -0400
X-AuditID: cbfee68e-b7f756d000004512-fc-5241587fa285
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 15/22] backlight: lm3533_bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:16:47 +0900
Message-id: <005501ceb906$cb98e3a0$62caaae0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAbVCg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zI936CMcgg1PzLCzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsEroybv2+z
	FnTxVSy9MZm5gfErdxcjJ4eEgInEr8WfWSFsMYkL99azgdhCAssYJR7fZIGpedp9EcjmAoov
	YpS4faeFHcL5xSjx5sBXZpAqNgE1iS9fDgMlODhEBPQl2lo0QMLMAjkS95/MYocYaiux7sNs
	MJtTwE7i1NIzYMuEBYIlzp9/xghiswioSvyc/hVsMS9Q/ayPz9kgbEGJH5PvsUDM1JLYvK2J
	FcKWl9i85i0zyFoJAXWJR391IS4wkpj+0guiQkRi34t3jBAV59glDoVBLBKQ+Db5EAtEWFZi
	0wFmiGclJQ6uuMEygVFiFpK1s5CsnYVk7SwkCxYwsqxiFE0tSC4oTkovMtIrTswtLs1L10vO
	z93ECInGvh2MNw9YH2JMBlo/kVlKNDkfGM15JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmk
	J5akZqemFqQWxReV5qQWH2Jk4uCUamCsfvOP8+E54dvtR9Qu1hssMNGOtyqTvRc2w+2PWTTP
	um9ml1tFf5cz3f2VclxtNY/Rj6rDSbPyJ7t+DSrovm90eHpVh5mfcnLUjH/r81ddKgw9HcBV
	yrNfuHsJW17xiseVpsKdNtx2TjquOdHsVXGiep5SPf8UHR2PfInyvPKntI5T+8mSECWW4oxE
	Qy3mouJEAOR61UPcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd36CMcgg7b9JhZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGzd+3WQu6+CqW3pjM3MD4lbuLkZNDQsBE4mn3RRYIW0ziwr31
	bF2MXBxCAosYJW7faWGHcH4xSrw58JUZpIpNQE3iy5fDQAkODhEBfYm2Fg2QMLNAjsT9J7PY
	QWwhAVuJdR9mg9mcAnYSp5aeYQOxhQWCJc6ff8YIYrMIqEr8nP4VbDEvUP2sj8/ZIGxBiR+T
	77FAzNSS2LytiRXClpfYvOYtM8haCQF1iUd/dSEuMJKY/tILokJEYt+Ld4wTGIVmIRk0C8mg
	WUgGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcMQ/k97BuKrB4hCjAAejEg/v
	hQSHICHWxLLiytxDjBIczEoivDdsHYOEeFMSK6tSi/Lji0pzUosPMSYD/TmRWUo0OR+YjPJK
	4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgVGsInTDL6/7k89e
	Z1G2eFsetHTmv6k+x64cZDYr+eP4Wqu+rqysNfrksocad5Isvk1R6F63hnUa3+MpSjLHutti
	tkbaWbG7/pHYz+35+rm7dGzc58lb1HQu39nwQnp5pm9To8wypsVfu9xaw48XaKdUfYlbEzFV
	v//Rioul62Z+qxD6Z8RunKXEUpyRaKjFXFScCAAJtb+CPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lm3533_bl.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
index 93eea65..187d1c2 100644
--- a/drivers/video/backlight/lm3533_bl.c
+++ b/drivers/video/backlight/lm3533_bl.c
@@ -313,8 +313,9 @@ static int lm3533_bl_probe(struct platform_device *pdev)
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = LM3533_BL_MAX_BRIGHTNESS;
 	props.brightness = pdata->default_brightness;
-	bd = backlight_device_register(pdata->name, pdev->dev.parent, bl,
-						&lm3533_bl_ops, &props);
+	bd = devm_backlight_device_register(&pdev->dev, pdata->name,
+					pdev->dev.parent, bl, &lm3533_bl_ops,
+					&props);
 	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev, "failed to register backlight device\n");
 		return PTR_ERR(bd);
@@ -328,7 +329,7 @@ static int lm3533_bl_probe(struct platform_device *pdev)
 	ret = sysfs_create_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to create sysfs attributes\n");
-		goto err_unregister;
+		return ret;
 	}
 
 	backlight_update_status(bd);
@@ -345,8 +346,6 @@ static int lm3533_bl_probe(struct platform_device *pdev)
 
 err_sysfs_remove:
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
-err_unregister:
-	backlight_device_unregister(bd);
 
 	return ret;
 }
@@ -363,7 +362,6 @@ static int lm3533_bl_remove(struct platform_device *pdev)
 
 	lm3533_ctrlbank_disable(&bl->cb);
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
-	backlight_device_unregister(bd);
 
 	return 0;
 }
-- 
1.7.10.4


