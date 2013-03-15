Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3COJRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:17:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61322 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab3COJRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:17:19 -0400
X-AuditID: cbfee68d-b7f786d000005188-31-5142e71e86d9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] gpio: 74x164: use spi_get_drvdata() and spi_set_drvdata()
Date: Fri, 15 Mar 2013 18:17:18 +0900
Message-id: <006901ce215d$e42c0b90$ac8422b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hXeQVIYFGJae2SqSpBat0OyhvAQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zY125506BBje2alq8OrORzeLywkus
	FlP+LGeyuLxrDpsDi8eda3vYPPq2rGL0+PlSx+PzJrkAligum5TUnMyy1CJ9uwSujD07nrMW
	LOeq2Hr0CnsD426OLkZODgkBE4nrU04yQthiEhfurWfrYuTiEBJYxihx4MADVpiiue07WCAS
	0xkl/u5aC+X8YpRoXnsHrJ1NQE3iy5fD7CC2iICexI0LHWBxZoEiiedds8AmCQv4SSxv28cG
	YrMIqEqsvDCfBcTmFbCVWHfqFzOELSjxY/I9FoheLYn1O48zQdjyEpvXvAWq4QC6SF3i0V9d
	mFUPd2xihygRkdj34h3UN+vYJTp+20OsEpD4NvkQC0SrrMSmA8wQJZISB1fcYJnAKDYLyeJZ
	SBbPQrJ4FpINCxhZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmKExFjvDsbbB6wPMSYDrZ/I
	LCWanA+M0bySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MDLtjHzAtSBvhozv27crqjpij25huSYqYHr8r+4Mjmua2odLHay7XuUl9k+fetJoavtu
	3RsTnh4+uOhe1fP3NnafWBcf+aiQYBHiccV/+1z33+quP0TTX09btfWyT30B+/LbB+ctbP0S
	9K5hTufcbe+e7t4pYpgRIV+66AXTirBHfX2a5hF9lf+UWIozEg21mIuKEwEleIaLxwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQV25506BBks3qFq8OrORzeLywkus
	FlP+LGeyuLxrDpsDi8eda3vYPPq2rGL0+PlSx+PzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xow9O56zFiznqth69Ap7A+Nuji5GTg4JAROJue07WCBsMYkL99az
	dTFycQgJTGeU+LtrLQuE84tRonntHUaQKjYBNYkvXw6zg9giAnoSNy50gMWZBYoknnfNYgWx
	hQX8JJa37WMDsVkEVCVWXpgPtoFXwFZi3alfzBC2oMSPyfdYIHq1JNbvPM4EYctLbF7zFqiG
	A+gidYlHf3VhVj3csYkdokREYt+Ld4wTGAVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqu
	kV5xYm5xaV66XnJ+7iZGcAw/k97BuKrB4hCjAAejEg+vw0PHQCHWxLLiytxDjBIczEoivB8v
	OgUK8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4wveSVxBsam5gZWRqZWRiZmJuTJqwkznuw
	1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2Puh+kcrCf5v8e/F5j2KSWRZ/JVb+VTipeL2HoCFT53
	M19a/uhWeq7v3djC1oATS1W+TY15IeWvk1DjkL50ttueosaNaxWmmPpz3auK23VTN4rnj5aJ
	Y2D4zOcF+SWnqhsv5dnO38W+qfKD2TG1jpRQN++35wM31i9f0LGrS3VC+uPCNqFF1UosxRmJ
	hlrMRcWJAEDYIxslAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data
using spi_device instead of using dev_{get|set}_drvdata with
&spi->dev, so we can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-74x164.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-74x164.c b/drivers/gpio/gpio-74x164.c
index 464be96..7216079 100644
--- a/drivers/gpio/gpio-74x164.c
+++ b/drivers/gpio/gpio-74x164.c
@@ -137,7 +137,7 @@ static int gen_74x164_probe(struct spi_device *spi)
 
 	mutex_init(&chip->lock);
 
-	dev_set_drvdata(&spi->dev, chip);
+	spi_set_drvdata(spi, chip);
 
 	chip->spi = spi;
 
@@ -176,7 +176,7 @@ static int gen_74x164_probe(struct spi_device *spi)
 	return ret;
 
 exit_destroy:
-	dev_set_drvdata(&spi->dev, NULL);
+	spi_set_drvdata(spi, NULL);
 	mutex_destroy(&chip->lock);
 	return ret;
 }
@@ -186,11 +186,11 @@ static int gen_74x164_remove(struct spi_device *spi)
 	struct gen_74x164_chip *chip;
 	int ret;
 
-	chip = dev_get_drvdata(&spi->dev);
+	chip = spi_get_drvdata(spi);
 	if (chip == NULL)
 		return -ENODEV;
 
-	dev_set_drvdata(&spi->dev, NULL);
+	spi_set_drvdata(spi, NULL);
 
 	ret = gpiochip_remove(&chip->gpio_chip);
 	if (!ret)
-- 
1.7.2.5


