Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435AbaHZM7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:59:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32200 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934373AbaHZM7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:59:15 -0400
X-AuditID: cbfee68e-f79536d000000fd1-5b-53fc84a28f91
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 07/18] backlight: ili922x: remove 'else' after a return
Date: Tue, 26 Aug 2014 21:59:13 +0900
Message-id: <00b101cfc12d$8954aa30$9bfdfe90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAFctA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI91FLX+CDabeFbA4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDIWvfrE
	WvCDo+LoptNMDYzz2bsYOTkkBEwk7vzfxwphi0lcuLeerYuRi0NIYBmjxJqjMxhhis7PuMoC
	kZjOKPHu1k5mCOc3o8SlKX0sIFVsAmoSX74cBhsrIqAgsbn3GdhYZoFcid8zV4JNEhKwlZi/
	bQVYnFPATmLp4XNg9cIC7hKbpy5kBrFZBFQl1jaeB6vnBap/9PwWC4QtKPFj8j0WiJlaEut3
	HmeCsOUlNq95C9TLAXSpusSjv7ogpoiAkcTHKV4QFSIS+168YwQ5WULgFLtE75P9TBCrBCS+
	TT7EAtEqK7HpADPEv5ISB1fcYJnAKDELyeJZSBbPQrJ4FpIVCxhZVjGKphYkFxQnpRcZ6RUn
	5haX5qXrJefnbmKERGXfDsabB6wPMQpwMCrx8N6I/x0sxJpYVlyZe4jRFOiiicxSosn5wNjP
	K4k3NDYzsjA1MTU2Mrc0UxLnTZD6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBccoBpTN7
	UuXun1mWbCy0V0Pt46bpazdlskhqus/eqrJ+j8pRCd0FehwzP81dfqNXWH3yit4d2pXW6j2x
	diWnN4YqeHJIGm2+eW/T+/SJHfqMzhZx3W36NvKXWY/Prux9u2Eiz9YgPbfCEJvbD95lbwnq
	PiS4okq2yO9cQaf82y33uCO6+1YZKLEUZyQaajEXFScCABUSOL/FAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd1FLX+CDVoX8Foc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZi159Yi34wVFxdNNppgbG+exdjJwcEgImEudnXGWBsMUkLtxb
	z9bFyMUhJDCdUeLdrZ3MEM5vRolLU/rAqtgE1CS+fDkM1i0ioCCxufcZK4jNLJAr8XvmSkYQ
	W0jAVmL+thVgcU4BO4mlh8+B1QsLuEtsnrqQGcRmEVCVWNt4HqyeF6j+0fNbLBC2oMSPyfdY
	IGZqSazfeZwJwpaX2LzmLVAvB9Cl6hKP/uqCmCICRhIfp3hBVIhI7HvxjnECo9AsJINmIRk0
	C8mgWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjvln0jsYVzVYHGIU4GBU4uG9
	Ef87WIg1say4MvcQowQHs5II74+kP8FCvCmJlVWpRfnxRaU5qcWHGE2B/pzILCWanA9MR3kl
	8YbGJmZGlkZmFkYm5uZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhgXpD75N2FtnvTPUD1R
	hgkKOp0/14t+eHe6VPfled9fVw7zcW+5+6rgPc+MLwLty5ZN/FIbMHtVpv3T/gAJ/8CLk4/9
	be9ustx41ThTwNNLKdc1USuZvzfpKdsv35sOsWuWsp7ptEybl7BuFl9hO1eore7u2n0htruN
	7oV4J7lff/NW4sPt/YlKLMUZiYZazEXFiQAD9zQwDwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: else is not generally useful after a break or return

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
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


