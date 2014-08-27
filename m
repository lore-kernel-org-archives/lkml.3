Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaH0BLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:11:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23313 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaH0BLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:11:44 -0400
X-AuditID: cbfee691-f79546d0000011a1-ad-53fd304594c5
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 07/18] backlight: ili922x: remove 'else' after a return
Date: Wed, 27 Aug 2014 10:11:33 +0900
Message-id: <004b01cfc193$d7430280$85c90780$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAGN3w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zfV1Xg7/BBrNa5S2O7pzIZHF54SVW
	i/tfjzJaXN41h82BxWPnrLvsHneu7WHz6NuyitHj8ya5AJYoLpuU1JzMstQifbsErozDV64x
	FyzhrPjyML2B8Rh7FyMnh4SAicTxNUdZIWwxiQv31rN1MXJxCAksY5T4s+sOXNGr/l2sEInp
	jBJTVp5ghnB+M0osmXwTrIpNQE3iy5fDYLaIgILE5t5nYGOZBXIlfs9cyQhiCwnYSlxeuJYJ
	xOYUsJOY/WE6WL2wgJfE98OLWEBsFgFViRUb5jCD2LxA9YemL2SCsAUlfky+xwIxU0ti/c7j
	TBC2vMTmNW+B6jmALlWXePRXF+IEI4lJN3+wQ5SISOx78Y4R4plT7BJt++MgVglIfJt8iAWi
	VVZi0wFmiBJJiYMrbrBMYJSYhWTxLCSLZyFZPAvJhgWMLKsYRVMLkguKk9KLTPWKE3OLS/PS
	9ZLzczcxQmJy4g7G+wesDzEKcDAq8fB+WPAnWIg1say4MvcQoynQRROZpUST84GRn1cSb2hs
	ZmRhamJqbGRuaaYkzqsj/TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PlbBOf41Kzmswm
	JqTylT5sYF7t/PnRDkFb9Z5OwTBJKcnTih2GYfuvezHNDGHpfj3Dr/vbNfPZdx8UXOMsfPez
	Z37d1kWx21/Ku51pCg16sLXgoYp3Sbrdkk0/Ojkz5sudjxQPz73zYFZa6VXfUznbbyWY+jyT
	W75lSXZtSQHH/OibBto5bUosxRmJhlrMRcWJADLhe9TEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV1Xg7/BBhvXSFsc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZh69cYy5Ywlnx5WF6A+Mx9i5GTg4JAROJV/27WCFsMYkL99az
	dTFycQgJTGeUmLLyBDOE85tRYsnkm2AdbAJqEl++HAazRQQUJDb3PgPrZhbIlfg9cyUjiC0k
	YCtxeeFaJhCbU8BOYvaH6WD1wgJeEt8PL2IBsVkEVCVWbJjDDGLzAtUfmr6QCcIWlPgx+R4L
	xEwtifU7jzNB2PISm9e8BarnALpUXeLRX12IE4wkJt38wQ5RIiKx78U7xgmMQrOQTJqFZNIs
	JJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM45p9J72Bc1WBxiFGAg1GJh/fD
	gj/BQqyJZcWVuYcYJTiYlUR4kxX+BgvxpiRWVqUW5ccXleakFh9iNAV6dCKzlGhyPjAd5ZXE
	GxqbmBlZGplZGJmYmyuJ8x5stQ4UEkhPLEnNTk0tSC2C6WPi4JRqYOypmC/wdl7pGU+hu882
	ONde+qDqrW0ZLKLTq5Hhv7gzSuFJw+1JDunXrTyY6m/4C4iltnfX3n6Yo9VxcIvp+rB1W7bZ
	PNwwQ+p6wfHKUg3lC99WbFM/wPDWLf2E7JL78z5Wr7sU+HH1ptn8vNtuL977Z85hy12r9A7U
	a6xsOrw2s3fye8Oou0FKLMUZiYZazEXFiQA0kTfrDwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: else is not generally useful after a break or return

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/ili922x.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
index ea67fe199e34..e7f0890cc211 100644
--- a/drivers/video/backlight/ili922x.c
+++ b/drivers/video/backlight/ili922x.c
@@ -495,17 +495,18 @@ static int ili922x_probe(struct spi_device *spi)
 			"no LCD found: Chip ID 0x%x, ret %d\n",
 			reg, ret);
 		return -ENODEV;
-	} else {
-		dev_info(&spi->dev, "ILI%x found, SPI freq %d, mode %d\n",
-			 reg, spi->max_speed_hz, spi->mode);
 	}
 
+	dev_info(&spi->dev, "ILI%x found, SPI freq %d, mode %d\n",
+		 reg, spi->max_speed_hz, spi->mode);
+
 	ret = ili922x_read_status(spi, &reg);
 	if (ret) {
 		dev_err(&spi->dev, "reading RS failed...\n");
 		return ret;
-	} else
-		dev_dbg(&spi->dev, "status: 0x%x\n", reg);
+	}
+
+	dev_dbg(&spi->dev, "status: 0x%x\n", reg);
 
 	ili922x_display_init(spi);
 
-- 
2.0.0


