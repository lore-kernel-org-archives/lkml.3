Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab3EWK13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:27:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39682 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab3EWK12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:27:28 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-e1-519def0e9d20
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        "'Deepak Saxena'" <dsaxena@plexity.net>
Subject: [PATCH] hwrng: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:27:26 +0900
Message-id: <002801ce57a0$1f004ba0$5d00e2e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Xn/hhp/++TNZjToKTvcFueKOoqQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zY12+93MDDfZ/NLZon/yNyaL7lYzF
	5YWXWC0u75rDZrFgWx+jA6vHtgOqHo9bWpk9+rasYvToe7mB0ePzJrkA1igum5TUnMyy1CJ9
	uwSujPfn3jAXnJesmDuFpYHxqGgXIweHhICJxOObql2MnECmmMSFe+vZQGwhgWWMEpfeWEPE
	TSSOvH7O0sXIBRRfxChxbu0jNgjnF6PE2qdr2UGq2ATUJL58OQxmiwjoSfStb2QEKWIW6GWU
	2Nq+nAUkISxgIbHl7Skwm0VAVeLlhV2sIDavgKXEke+boWxBiR+T74HVMAtoSazfeZwJwpaX
	2LzmLTPESQoSO86+ZoRZtvnDKXaIGhGJfS/egS2WENjFLvHwyxV2iGUCEt8mH2KBeFlWYtMB
	qDmSEgdX3GCZwCg2C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525i
	hETdhB2M9w5YH2JMBlo/kVlKNDkfGLV5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamAssKl6sPn8zKuLrpW0TPnKVCEnvKps9ZlpSX/WV9g2T7qi
	4/bl3K4iJe3j+189q07eWf75+6KbMjXam5mW1lzSl4qftObxtWevkruX7Kkvu5bMkfii9M5H
	TdaYaxOlvS4fZ795LdCz7FrpV5Fr01g/cbF2vL+xWKeSU+1o2k7u/Fv7GpoEJi+6pMRSnJFo
	qMVcVJwIANuJoqvQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAV2+93MDDX5f07don/yNyaL7lYzF
	5YWXWC0u75rDZrFgWx+jA6vHtgOqHo9bWpk9+rasYvToe7mB0ePzJrkA1qgGRpuM1MSU1CKF
	1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoN1KCmWJOaVAoYDE4mIl
	fTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoz3594wF5yXrJg7haWB8ahoFyMnh4SAicSR189Z
	IGwxiQv31rN1MXJxCAksYpQ4t/YRlPOLUWLt07XsIFVsAmoSX74cBrNFBPQk+tY3MoIUMQv0
	MkpsbV8ONkpYwEJiy9tTYDaLgKrEywu7WEFsXgFLiSPfN0PZghI/Jt8Dq2EW0JJYv/M4E4Qt
	L7F5zVtmiJMUJHacfc0Is2zzh1PsEDUiEvtevGOcwCgwC8moWUhGzUIyahaSlgWMLKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxguP6mdQOxpUNFocYBTgYlXh4JW7PCRRiTSwrrsw9xCjB
	wawkwru5Z26gEG9KYmVValF+fFFpTmrxIcZkoE8nMkuJJucDU05eSbyhsYmZkaWRmYWRibk5
	acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTBOldj2yCNr77JH4p8+1HxtMmHYqf7SlOtV
	77JLOrpvlzBbsqtbeGa95oh7ejLmrl3Rizt98pXO12JT93+K35XL+/vYTv332/S7fgtdOSXT
	oerBKrFb3OnLxDvzu0/VaX5deGf5HtO2f91l6wyDV6uL+GtzXzrFn3qlq81Cg6tk8eHas19+
	PPihxFKckWioxVxUnAgAr/coTC8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Also, unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/n2-drv.c     |    6 ++----
 drivers/char/hw_random/octeon-rng.c |    4 ++--
 drivers/char/hw_random/omap-rng.c   |    6 +++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 20b962e..f9beed5 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -700,7 +700,7 @@ static int n2rng_probe(struct platform_device *op)
 	if (err)
 		goto out_free_units;
 
-	dev_set_drvdata(&op->dev, np);
+	platform_set_drvdata(op, np);
 
 	schedule_delayed_work(&np->work, 0);
 
@@ -721,7 +721,7 @@ out:
 
 static int n2rng_remove(struct platform_device *op)
 {
-	struct n2rng *np = dev_get_drvdata(&op->dev);
+	struct n2rng *np = platform_get_drvdata(op);
 
 	np->flags |= N2RNG_FLAG_SHUTDOWN;
 
@@ -736,8 +736,6 @@ static int n2rng_remove(struct platform_device *op)
 
 	kfree(np);
 
-	dev_set_drvdata(&op->dev, NULL);
-
 	return 0;
 }
 
diff --git a/drivers/char/hw_random/octeon-rng.c b/drivers/char/hw_random/octeon-rng.c
index 1eada56..f2885db 100644
--- a/drivers/char/hw_random/octeon-rng.c
+++ b/drivers/char/hw_random/octeon-rng.c
@@ -96,7 +96,7 @@ static int octeon_rng_probe(struct platform_device *pdev)
 
 	rng->ops = ops;
 
-	dev_set_drvdata(&pdev->dev, &rng->ops);
+	platform_set_drvdata(pdev, &rng->ops);
 	ret = hwrng_register(&rng->ops);
 	if (ret)
 		return -ENOENT;
@@ -108,7 +108,7 @@ static int octeon_rng_probe(struct platform_device *pdev)
 
 static int __exit octeon_rng_remove(struct platform_device *pdev)
 {
-	struct hwrng *rng = dev_get_drvdata(&pdev->dev);
+	struct hwrng *rng = platform_get_drvdata(pdev);
 
 	hwrng_unregister(rng);
 
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index d2903e7..6843ec8 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -116,7 +116,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	};
 
 	omap_rng_ops.priv = (unsigned long)priv;
-	dev_set_drvdata(&pdev->dev, priv);
+	platform_set_drvdata(pdev, priv);
 
 	priv->mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->base = devm_ioremap_resource(&pdev->dev, priv->mem_res);
@@ -124,7 +124,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 		ret = PTR_ERR(priv->base);
 		goto err_ioremap;
 	}
-	dev_set_drvdata(&pdev->dev, priv);
+	platform_set_drvdata(pdev, priv);
 
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
@@ -151,7 +151,7 @@ err_ioremap:
 
 static int __exit omap_rng_remove(struct platform_device *pdev)
 {
-	struct omap_rng_private_data *priv = dev_get_drvdata(&pdev->dev);
+	struct omap_rng_private_data *priv = platform_get_drvdata(pdev);
 
 	hwrng_unregister(&omap_rng_ops);
 
-- 
1.7.10.4


