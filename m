Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab3DFGn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 02:43:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61021 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab3DFGnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 02:43:25 -0400
X-AuditID: cbfee68e-b7f946d000001e37-2f-515fc40ccd87
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
In-reply-to: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
Subject: [PATCH 2/6] mfd: da9052: use spi_get_drvdata() and spi_set_drvdata()
Date: Sat, 06 Apr 2013 15:43:23 +0900
Message-id: <001801ce3292$0925a880$1b70f980$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ykfPaYTuV5qPCS+S/kzkYYtE9uwAAAY6w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zI12eI/GBBtumCllcXniJ1eLyrjls
	Fqe7WR2YPeadDPTo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujP4ld5gKjnNUNL68xdTAOJm9
	i5GTQ0LAROLCtlUsELaYxIV769m6GLk4hASWMUrc+N3IAlP0fFMfI4gtJDCdUWLZM3WIol+M
	EhcnPWQFSbAJqEl8+XIYbKqIgJZE97HzQJM4OJgFXCSOThOB6LWV2DzrENhMTgE7iTP/t4HN
	FBbwldjc3M4EYrMIqEos/t7PDtLKC1S//JELSJhXQFDix+R7YK3MQNPX7zzOBGHLS2xe85YZ
	pFxCQF3i0V9dEFNEwEhi8qwoiAoRiX0v3jGCHCwhsItd4sXS1YwQmwQkvk0GuQakVVZi0wFm
	iGclJQ6uuMEygVFiFpLFs5AsnoVk8SwkKxYwsqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93E
	CIm7vh2MNw9YH2JMBlo/kVlKNDkfGLd5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamBsMKv9L8Q9o/1Veu2tRMUdIjEhQVO/K3xmvXd4SUtv/Mcm
	ns+1+yQDT7g+iL4gsJxp7b8WI2H1t40bqg4L8DktcOvdEaNvyrnsUl270+NVyv4e1SWLys/U
	vHlc4lL/2ag493jQ4e+R1ya0c78r4Kwz3ORRkPDni018VYlDduhlgQSJ+Zub5yqxFGckGmox
	FxUnAgAVfuie0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQV2eI/GBBi17eC0uL7zEanF51xw2
	i9PdrA7MHvNOBnr0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
	pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZo
	IGEdY0b/kjtMBcc5Khpf3mJqYJzM3sXIySEhYCLxfFMfI4QtJnHh3no2EFtIYDqjxLJn6l2M
	XED2L0aJi5MesoIk2ATUJL58OQzWLCKgJdF97DxQAwcHs4CLxNFpIhC9thKbZx1iAbE5Bewk
	zvzfBjZfWMBXYnNzOxOIzSKgKrH4ez87SCsvUP3yRy4gYV4BQYkfk++BtTIDTV+/8zgThC0v
	sXnNW2aQcgkBdYlHf3VBTBEBI4nJs6IgKkQk9r14xziBUWgWkkGzkAyahWTQLCQtCxhZVjGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmIER/UzqR2MKxssDjEKcDAq8fBa3I4LFGJNLCuuzD3E
	KMHBrCTCK/scKMSbklhZlVqUH19UmpNafIgxGejNicxSosn5wISTVxJvaGxiZmRpZGZhZGJu
	TpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MghytNxZfF1JcNWOWrjUr52Uev8W/DO8k
	7eaReHhnjQCf4hsRtaO6bUuv7gl8m/eVb9/2ZULGxRMiut85GCSoft1rvnL69w0H/GZeaskT
	2xzQlTLh0Wmb77HXMu3Zrnd8Uwp6HD7HOW/m7g0XZ7y5Yxx95kjFrDuWzrU766+mPOK+r125
	zMbjjRJLcUaioRZzUXEiALo/P3cuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/da9052-spi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index 61d63b9..0680bcb 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -38,7 +38,7 @@ static int da9052_spi_probe(struct spi_device *spi)
 	da9052->dev = &spi->dev;
 	da9052->chip_irq = spi->irq;
 
-	dev_set_drvdata(&spi->dev, da9052);
+	spi_set_drvdata(spi, da9052);
 
 	da9052_regmap_config.read_flag_mask = 1;
 	da9052_regmap_config.write_flag_mask = 0;
@@ -60,7 +60,7 @@ static int da9052_spi_probe(struct spi_device *spi)
 
 static int da9052_spi_remove(struct spi_device *spi)
 {
-	struct da9052 *da9052 = dev_get_drvdata(&spi->dev);
+	struct da9052 *da9052 = spi_get_drvdata(spi);
 
 	da9052_device_exit(da9052);
 	return 0;
-- 
1.7.2.5


