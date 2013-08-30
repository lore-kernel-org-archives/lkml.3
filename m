Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3H3ESF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:18:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51584 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3H3ESD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:18:03 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-a3-52201cf8a5bc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Evgeniy Polyakov'" <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002e01cea537$c9b15730$5d140590$%han@samsung.com>
In-reply-to: <002e01cea537$c9b15730$5d140590$%han@samsung.com>
Subject: [PATCH 2/2] w1: ds1wm: use dev_get_platdata()
Date: Fri, 30 Aug 2013 13:18:01 +0900
Message-id: <002f01cea537$ea3b9240$beb2b6c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6lN8WeMbrNZ1LKSuiE3q4f6N2buQAAAkGA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY90fMgpBBsd2qVnMWb+GzeLywkus
	Fpd3zWGz+LX6HJsDi8fjHduZPE7M+M3i0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBlbZu5l
	LfjJU/F+6mfWBsanXF2MnBwSAiYSjXea2SFsMYkL99azdTFycQgJLGOU2Ph6OSNM0aLeRUwQ
	iUWMEp2rT0M5vxglHj6dxQxSxSagJvHly2GgURwcIgL6Em0tGiBhZoEcicOPZrGA2EICthJ7
	Fk9jBinhFLCT+LCQFSQsLGAmcW3xNbBdLAKqElvWX2UDsXmByvtfvmWEsAUlfky+xwIxUkti
	/c7jTBC2vMTmNW/BRkoIqEs8+qsLEhYRMJJY27SbGaJERGLfi3dQr1xil9jzthxilYDEt8mH
	WCBaZSU2HWCGKJGUOLjiBssERolZSBbPQrJ4FpLFs5BsWMDIsopRNLUguaA4Kb3IWK84Mbe4
	NC9dLzk/dxMjJCL7dzDePWB9iDEZaP1EZinR5HxgROeVxBsamxlZmJqYGhuZW5qRJqwkzqvW
	Yh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbFMODzv4RbBn9wv+Bslr7/Rs5PiOuh1qfCb
	7rcdWkXz/5a+yd4nedzuqcuxe+7W5eGPzsyfvUSCzSpp1rtFxnN/6L51UV7M/OO2rtrlnCcl
	Cy6Iumd3PufqVKxdbKrD2NnZenG/x6+tKiesvqYxp/p4VSVqh1R+7Vc4ys5ve8ffoXarUcGu
	ZUosxRmJhlrMRcWJAMrOWzbeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd0fMgpBBj+uK1nMWb+GzeLywkus
	Fpd3zWGz+LX6HJsDi8fjHduZPE7M+M3i0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZW2buZS34yVPxfupn1gbGp1xdjJwcEgImEot6FzFB2GISF+6t
	Z+ti5OIQEljEKNG5+jQThPOLUeLh01nMIFVsAmoSX74cZu9i5OAQEdCXaGvRAAkzC+RIHH40
	iwXEFhKwldizeBozSAmngJ3Eh4WsIGFhATOJa4uvMYLYLAKqElvWX2UDsXmByvtfvmWEsAUl
	fky+xwIxUkti/c7jTBC2vMTmNW/BRkoIqEs8+qsLEhYRMJJY27SbGaJERGLfi3eMExiFZiGZ
	NAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDEP5PewbiqweIQowAH
	oxIPb8NU+SAh1sSy4srcQ4wSHMxKIrzx24BCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9M
	Rnkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwMi4fvqnW7Xq
	LcytCz79XrVQfNfVuIprmXNNozd4yLamZ029F/Sv4Grhqp1f50me/pBhXpR67uo+tU6bBS9a
	fvwPjz49t0AlL4jvQc3TlILEScZC6r2Hpzz/ddzEpXfFDPGn73qWq8xPc7UJ5X52lvFqMbN1
	wclzC57+/pCQoBum3aS3dAqr+WclluKMREMt5qLiRABLhU4RPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/w1/masters/ds1wm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 96cab6ac..a606dba 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -255,17 +255,17 @@ static int ds1wm_find_divisor(int gclk)
 static void ds1wm_up(struct ds1wm_data *ds1wm_data)
 {
 	int divisor;
-	struct ds1wm_driver_data *plat = ds1wm_data->pdev->dev.platform_data;
+	struct device *dev = &ds1wm_data->pdev->dev;
+	struct ds1wm_driver_data *plat = dev_get_platdata(dev);
 
 	if (ds1wm_data->cell->enable)
 		ds1wm_data->cell->enable(ds1wm_data->pdev);
 
 	divisor = ds1wm_find_divisor(plat->clock_rate);
-	dev_dbg(&ds1wm_data->pdev->dev,
-		"found divisor 0x%x for clock %d\n", divisor, plat->clock_rate);
+	dev_dbg(dev, "found divisor 0x%x for clock %d\n",
+		divisor, plat->clock_rate);
 	if (divisor == 0) {
-		dev_err(&ds1wm_data->pdev->dev,
-			"no suitable divisor for %dHz clock\n",
+		dev_err(dev, "no suitable divisor for %dHz clock\n",
 			plat->clock_rate);
 		return;
 	}
@@ -481,7 +481,7 @@ static int ds1wm_probe(struct platform_device *pdev)
 	ds1wm_data->cell = mfd_get_cell(pdev);
 	if (!ds1wm_data->cell)
 		return -ENODEV;
-	plat = pdev->dev.platform_data;
+	plat = dev_get_platdata(&pdev->dev);
 	if (!plat)
 		return -ENODEV;
 
-- 
1.7.10.4


