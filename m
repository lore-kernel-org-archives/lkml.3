Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3KYD1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 22:27:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30452 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3KYD1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 22:27:30 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-26-5292c3a1017d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "=?iso-8859-1?Q?'Uwe_Kleine-K=F6nig'?=" 
	<u.kleine-koenig@pengutronix.de>,
        "'Marc Reilly'" <marc@cpdesign.com.au>
Subject: [PATCH] mfd: mc13xxx: remove unnecessary spi_set_drvdata()
Date: Mon, 25 Nov 2013 12:27:29 +0900
Message-id: <002601cee98e$44f75210$cee5f630$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7pjkTa060eOFAWTu+craBbmDLVng==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zI92FhycFGWz/LmlxeeElVov7X48y
	WlzeNYfN4uLcDSwWp7tZLW5PnMzowObxb9cpNo871/awecw7GejR/9fAo2/LKkaPz5vkAtii
	uGxSUnMyy1KL9O0SuDIuPXzCVHCZteJRx3yWBsbTLF2MHBwSAiYStyeLdDFyApliEhfurWfr
	YuTiEBJYxihxffd7FoiEiUTvnIPMEInpjBJ/Ty9hgXB+MUpM/LCCEaSKTUBN4suXw+wgtgiQ
	fXPPLCaQImaBB4wSDztOsoEkhAWcJX4f/coKYrMIqErsencFrJlXwFbi38d2NghbUOLH5Htg
	q5kFdCR6v39jhrDlJTavecsMcba6xKO/uhC79CQmbzjGBlEiIrHvxTtGkL0SAufYJRac2McI
	sUtA4tvkQ1Avy0psOsAM8ZmkxMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelF
	RnrFibnFpXnpesn5uZsYIZHYt4Px5gHrQ4zJQOsnMkuJJucDIzmvJN7Q2MzIwtTE1NjI3NKM
	NGElcd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDO4Kjit9v/8NytfZ3Wva2fDDUb
	NW63mSjpZPHnTsuqzbiv3qbutpxbeXu92Kes3UXKYYtrv+3h1Pr9m+PkdR++mjeGByqDP0h8
	ra2Xc+Lc76RW7///+73jnqfX54UF8d0yXLc+eVnT3MbuD4lus5/cWjT7R4Xso0VNrvGfujbd
	eF+gXKn1T0OJpTgj0VCLuag4EQCxi+4R2gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jQd2FhycFGbRNFLO4vPASq8X9r0cZ
	LS7vmsNmcXHuBhaL092sFrcnTmZ0YPP4t+sUm8eda3vYPOadDPTo/2vg0bdlFaPH501yAWxR
	DYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBHKCmU
	JeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzLj18wlRwmbXiUcd8lgbG0yxd
	jJwcEgImEr1zDjJD2GISF+6tZ+ti5OIQEpjOKPH39BIWCOcXo8TEDysYQarYBNQkvnw5zA5i
	iwDZN/fMYgIpYhZ4wCjxsOMkG0hCWMBZ4vfRr6wgNouAqsSud1fAmnkFbCX+fWxng7AFJX5M
	vgd2BrOAjkTv92/MELa8xOY1b4FsDqCT1CUe/dWF2KUnMXnDMTaIEhGJfS/eMU5gFJiFZNIs
	JJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBkf5MagfjygaLQ4wCHIxK
	PLwWlZOChFgTy4orcw8xSnAwK4nw7qkDCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MAnl
	lcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAOj3LkNnmpd/5y3
	qLS+9Px5hzd/z8HXu6w+VyZpOp516wt7k9mdfXaKeTSThJJel4zd7cW1xdw5Ss/8w5Y/lazQ
	qQ2uie74mfX1pIzLVYY139U9Ai/3ey7iUu/T4d+14f7+ncuvOBTnGk49o84Q37xYnNn02Kld
	tuV/WtksJRYGRsp/33TwrYASS3FGoqEWc1FxIgDAcqUEOAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/mc13xxx-spi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 5f14ef6..cbcc86d 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -149,7 +149,6 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 		ret = PTR_ERR(mc13xxx->regmap);
 		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
 				ret);
-		spi_set_drvdata(spi, NULL);
 		return ret;
 	}
 
-- 
1.7.10.4


