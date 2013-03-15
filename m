Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3COJSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:18:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54061 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab3COJSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:18:13 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-f2-5142e742e676
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006901ce215d$e42c0b90$ac8422b0$%han@samsung.com>
In-reply-to: <006901ce215d$e42c0b90$ac8422b0$%han@samsung.com>
Subject: [PATCH 2/2] gpio: mc33880: use spi_get_drvdata() and spi_set_drvdata()
Date: Fri, 15 Mar 2013 18:17:54 +0900
Message-id: <006a01ce215d$f9b44860$ed1cd920$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hXeQVIYFGJae2SqSpBat0OyhvAQAAAnlA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zfV2n506BBs93G1i8OrORzeLywkus
	FlP+LGeyuLxrDpsDi8eda3vYPPq2rGL0+PlSx+PzJrkAligum5TUnMyy1CJ9uwSujH+HNjAW
	NHFV/Dv4m72BcRpHFyMnh4SAiUTfz2XMELaYxIV769m6GLk4hASWMUrM+zCZBaZo5dX9UInp
	jBIXnxxgh3B+MUoc/XmHEaSKTUBN4suXw+wgtoiAnsSNCx1gcWaBIonnXbNYQWwhAVuJ3Rd/
	MoHYnAJ2Eh3ztrKB2MIC/hJ3Jt0A62URUJW4NuEPWA0vUP3lE3sZIWxBiR+T77FAzNSSWL/z
	OBOELS+xec1boBc4gC5Vl3j0VxfiBCOJ7S9XQ50gIrHvxTtGkJslBE6xS0xr28kKsUtA4tvk
	QywQvbISmw5AQ0JS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiY73ixNzi
	0rx0veT83E2MkKjs38F494D1IcZkoPUTmaVEk/OBUZ1XEm9obGZkYWpiamxkbmlGmrCSOK9a
	i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsacm8xL3Y0u6ykfyn3tYvhjYdy7m5VO4lHd
	EsnrNryMeXzk1s7AIOavH1n3HtlXmir75O2cJWbCFcbrgt62fIj8fuFPWIH45WdMOssvaukK
	95bMeMAbMdVyl2fzzQtWJzNu66k3f6vVeiGVOeX/LJWjXoGXt+v/+6YqtPHFESsGlQxVtdkH
	2SYosRRnJBpqMRcVJwIATm76huACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQV2n506BBmvP61i8OrORzeLywkus
	FlP+LGeyuLxrDpsDi8eda3vYPPq2rGL0+PlSx+PzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xox/hzYwFjRxVfw7+Ju9gXEaRxcjJ4eEgInEyqv72SBsMYkL99YD
	2VwcQgLTGSUuPjnADuH8YpQ4+vMOI0gVm4CaxJcvh9lBbBEBPYkbFzrA4swCRRLPu2axgthC
	ArYSuy/+ZAKxOQXsJDrmbQXbICzgL3Fn0g2wXhYBVYlrE/6A1fAC1V8+sZcRwhaU+DH5HgvE
	TC2J9TuPM0HY8hKb17xl7mLkALpUXeLRX12IE4wktr9cDXWCiMS+F+8YJzAKzUIyaRaSSbOQ
	TJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCYfya1g3Flg8UhRgEORiUe3gP9
	DoFCrIllxZW5hxglOJiVRHg9vRwDhXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmI7ySuIN
	jU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGRSea4b/TFV+VxQWl/
	Nv1jLhTq+jjP/H3hv77iWdtMH534eM9CnPG2j0TnGYGTwYetWHRWerGmxz547pR6QDifo+5z
	YPt1d520qeX/H3xZyJXt/p/RNqn+VfHLWKePXz2s8rbHLvLo+r184dVW/QD/JKN7ve8f6v5g
	kqu1fHpK/b/fSjWmayFKLMUZiYZazEXFiQAeEOSjPQMAAA==
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
 drivers/gpio/gpio-mc33880.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-mc33880.c b/drivers/gpio/gpio-mc33880.c
index 3395879..63a7a1b 100644
--- a/drivers/gpio/gpio-mc33880.c
+++ b/drivers/gpio/gpio-mc33880.c
@@ -107,7 +107,7 @@ static int mc33880_probe(struct spi_device *spi)
 
 	mutex_init(&mc->lock);
 
-	dev_set_drvdata(&spi->dev, mc);
+	spi_set_drvdata(spi, mc);
 
 	mc->spi = spi;
 
@@ -142,7 +142,7 @@ static int mc33880_probe(struct spi_device *spi)
 	return ret;
 
 exit_destroy:
-	dev_set_drvdata(&spi->dev, NULL);
+	spi_set_drvdata(spi, NULL);
 	mutex_destroy(&mc->lock);
 	return ret;
 }
@@ -152,11 +152,11 @@ static int mc33880_remove(struct spi_device *spi)
 	struct mc33880 *mc;
 	int ret;
 
-	mc = dev_get_drvdata(&spi->dev);
+	mc = spi_get_drvdata(spi);
 	if (mc == NULL)
 		return -ENODEV;
 
-	dev_set_drvdata(&spi->dev, NULL);
+	spi_set_drvdata(spi, NULL);
 
 	ret = gpiochip_remove(&mc->chip);
 	if (!ret)
-- 
1.7.2.5


