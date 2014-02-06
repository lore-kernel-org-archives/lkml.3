Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaBFIYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:24:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29904 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaBFIYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:24:48 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-7b-52f346ce5830
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Alberto Panizzo'" <alberto@amarulasolutions.com>,
        "'Alberto Panizzo'" <maramaopercheseimorto@gmail.com>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 08/12] backlight: l4f00242t03: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:24:45 +0900
Message-id: <000901cf2314$e4ae9b00$ae0bd100$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAASmew
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA91zbp+DDK6t47WYs34Nm8WZSRNY
	LC4vvMRqcXnXHDaLPwfWMTqweqz9eJ/VY+esu+weJ2b8ZvHo27KK0ePzJrkA1igum5TUnMyy
	1CJ9uwSujLfPJzMV3GCr2Dqzl7WB8ThrFyMnh4SAicSaK6vYIGwxiQv31gPZXBxCAssYJRq6
	17HDFP2fv4oRIrGIUeLX7mPMEM4vRonHl7+DjWITUJP48uUwUAcHh4iAvkRbiwZIDbPAekaJ
	2Zc+MILUCAnYSuw+fRKsnlPATmLbp1YmEFtYwE9i95etzCC9LAKqEhMP8oOEeYHKp/X3sUPY
	ghI/Jt9jAbGZBbQk1u88zgRhy0tsXvMWrFVCQF3i0V9dkLCIgJFEc+MvVogSEYl9L96B3S8h
	8IhdYvu9v2AzWQQEJL5NPsQC0SsrsekAM8S/khIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlW
	MYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoREau8OxtsHrA8xJgOtn8gsJZqcD4z0vJJ4Q2Mz
	IwtTE1NjI3NLM9KElcR5kx4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgvLSmsjz85c4H
	0T8X16xi59BLlLtV5JD6kkdIx0J32wPlNVbhNm/OG0nYROuUF74Q1fFdsdbj3cPNSkv7N764
	zq12K3rPEg6plrnyvFoib6c2WWgqBJ6a6Lbx+LPfpy+uf9+0x/NR86ryqdO6HU7lrzJ/5GAS
	MPlt7v2Tb3J/1p0W+m+oHPFZXImlOCPRUIu5qDgRAF9+UarqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd1zbp+DDKZe5LSYs34Nm8WZSRNY
	LC4vvMRqcXnXHDaLPwfWMTqweqz9eJ/VY+esu+weJ2b8ZvHo27KK0ePzJrkA1qgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoO1KCmWJOaVAoYDE
	4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoy3zyczFdxgq9g6s5e1gfE4axcjJ4eEgInE
	//mrGCFsMYkL99azdTFycQgJLGKU+LX7GDOE84tR4vHl72AdbAJqEl++HGbvYuTgEBHQl2hr
	0QCpYRZYzygx+9IHsElCArYSu0+fBKvnFLCT2PaplQnEFhbwk9j9ZSszSC+LgKrExIP8IGFe
	oPJp/X3sELagxI/J91hAbGYBLYn1O48zQdjyEpvXvAVrlRBQl3j0VxckLCJgJNHc+IsVokRE
	Yt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcBp4
	JrWDcWWDxSFGAQ5GJR7eDes/BQmxJpYVV+YeYpTgYFYS4d1q/jlIiDclsbIqtSg/vqg0J7X4
	EGMy0J8TmaVEk/OBKSqvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuY
	ODilGhizfz0t3PY04HHw68bndW++yZ7deWyK26YT7KufNMnrnD7xwudZ6dRyPyc3AdPgE14H
	jzR/3i9lr6hZ8aFueb/f5fgLKx2TQ1OyalomJT6fuoNn8RsN/pszZ+ROXNE194ymde/3jqh2
	RuaQ9XOmzHVZ4edltaasUKLM+XvXBK2GgHCdx6efv5JVYinOSDTUYi4qTgQAiBxMNkcDAAA=
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
 drivers/video/backlight/l4f00242t03.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index 63e7638..5fa2649 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -181,11 +181,8 @@ static int l4f00242t03_probe(struct spi_device *spi)
 
 	priv = devm_kzalloc(&spi->dev, sizeof(struct l4f00242t03_priv),
 				GFP_KERNEL);
-
-	if (priv == NULL) {
-		dev_err(&spi->dev, "No memory for this device.\n");
+	if (priv == NULL)
 		return -ENOMEM;
-	}
 
 	spi_set_drvdata(spi, priv);
 	spi->bits_per_word = 9;
-- 
1.7.10.4


