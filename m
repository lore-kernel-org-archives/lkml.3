Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3CLAC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:02:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23588 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3CLACY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:02:24 -0400
X-AuditID: cbfee690-b7f656d0000007e3-6d-513e708f83cb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2] backlight: l4f00242t03: check return value of
 regulator_enable()
Date: Tue, 12 Mar 2013 09:02:22 +0900
Message-id: <008e01ce1eb4$df3a9cb0$9dafd610$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4etN8f2tU+mOK+QJKBWR8HxcDKZQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI93+ArtAg18rWCzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsEroxrx+QK
	evkrzp76x9rA+JCni5GTQ0LARGLp+W2MELaYxIV769m6GLk4hASWMUpc+LqKDabo1IdNLBCJ
	6YwSHyY9har6xShxuH8ZK0gVm4CaxJcvh9m7GDk4RAT0JdpaNEDCzAKlElsfvGcBCQsLhEks
	maQJEmYRUJW4t/IK2GJeAVuJR51NrBC2oMSPyfdYIFq1JNbvPM4EYctLbF7zlhlkjISAusSj
	v7ogYREBPYmr+3dBlYhI7HvxjhHkMgmBTewSC14eYIHYJSDxbfIhFoheWYlNB5gh3pKUOLji
	BssERrFZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjJMIm7GC8
	d8D6EGMy0PqJzFKiyfnACM0riTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUo
	vqg0J7X4ECMTB6dUA2N9DHfhti8Xn5/hfx1144NoZS379pm3WAKZJ/K9mZy+MjRN+pzTdxGT
	6GQBzmMZCu23jwYfigie+Xv6xDsBznnpHAcc3E/K2zPYbJpmFMHsHNrc+NjmwVuP0IOck+y/
	B/1Ns64rmXssJ11tfUhhnO8ibldHl/nZFTHVPMv7DhikBN/hsei8o8RSnJFoqMVcVJwIAPUi
	+TbGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoG5/gV2gQTeXxZz1a9gsLi+8xGpx
	edccNovdu56yOrB4nJjxm8Vjz/wfrB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmHHtmFxBL3/F2VP/WBsYH/J0MXJySAiYSJz6sIkFwhaTuHBvPVsX
	IxeHkMB0RokPk55COb8YJQ73L2MFqWITUJP48uUwexcjB4eIgL5EW4sGSJhZoFRi64P3LCBh
	YYEwiSWTNEHCLAKqEvdWXmEEsXkFbCUedTaxQtiCEj8m32OBaNWSWL/zOBOELS+xec1bZpAx
	EgLqEo/+6oKERQT0JK7u3wVVIiKx78U7xgmMArOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4ep9J7WBc2WBxiFGAg1GJh1fxm22gEGtiWXFl7iFGCQ5mJRHe
	yhS7QCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OByaWvJJ4Q2MTMyNLIzMLIxNzc9KElcR5
	D7RaBwoJpCeWpGanphakFsFsYeLglGpgTPn37fiPpc2crZPeHPm47NZDFo5IxWPrumsPG+h5
	1hap525Sawrw/LjlXoWGUH30gmkswRP3S2R7ukXV55v6+69cvpfj0KVKG1cTpp6dfFymicen
	v+tnmvxC/6Fqx+zXPJELVdhuVaifOl8533Lnj0QnAYM9b16Y5q2zy/EpdGlwO3fzp+8SJZbi
	jERDLeai4kQAiKG+pSIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator_enable() was marked as as __must_check, therefore,
the return value of regulator_enable() should be checked.
Also, this patch checks return value of regulator_set_voltage().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Change since v1:
- Added regulator_disable() for IO regulator before returning

 drivers/video/backlight/l4f00242t03.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index fb61557..a35a38c 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -51,14 +51,33 @@ static void l4f00242t03_lcd_init(struct spi_device *spi)
 	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
 	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 	const u16 cmd[] = { 0x36, param(0), 0x3A, param(0x60) };
+	int ret;
 
 	dev_dbg(&spi->dev, "initializing LCD\n");
 
-	regulator_set_voltage(priv->io_reg, 1800000, 1800000);
-	regulator_enable(priv->io_reg);
+	ret = regulator_set_voltage(priv->io_reg, 1800000, 1800000);
+	if (ret) {
+		dev_err(&spi->dev, "failed to set the IO regulator voltage.\n");
+		return;
+	}
+	ret = regulator_enable(priv->io_reg);
+	if (ret) {
+		dev_err(&spi->dev, "failed to enable the IO regulator.\n");
+		return;
+	}
 
-	regulator_set_voltage(priv->core_reg, 2800000, 2800000);
-	regulator_enable(priv->core_reg);
+	ret = regulator_set_voltage(priv->core_reg, 2800000, 2800000);
+	if (ret) {
+		dev_err(&spi->dev, "failed to set the core regulator voltage.\n");
+		regulator_disable(priv->io_reg);
+		return;
+	}
+	ret = regulator_enable(priv->core_reg);
+	if (ret) {
+		dev_err(&spi->dev, "failed to enable the core regulator.\n");
+		regulator_disable(priv->io_reg);
+		return;
+	}
 
 	l4f00242t03_reset(pdata->reset_gpio);
 
-- 
1.7.2.5


