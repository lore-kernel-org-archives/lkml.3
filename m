Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab3DFGoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 02:44:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27380 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3DFGoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 02:44:16 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-d5-515fc43f1f7c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
In-reply-to: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
Subject: [PATCH 4/6] mfd: mc13xxx: use spi_get_drvdata() and spi_set_drvdata()
Date: Sat, 06 Apr 2013 15:44:14 +0900
Message-id: <001a01ce3292$27532ee0$75f98ca0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ykfPaYTuV5qPCS+S/kzkYYtE9uwAACTkA
Content-language: ko
x-cr-hashedpuzzle: B9FT DgxA HnvL Lngc M0JK Odw2 QxqV TevZ TfXl V/e9 bXT9 eWUl
 ea0L etp+ inOE
 i+ld;3;agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBzAGEAbQBlAG8AQABsAGkAbgB1AHgALgBpAG4AdABlAGwALgBjAG8AbQA=;Sosha1_v1;7;{9DE8D711-0575-4AE6-AD76-2181262AE07E};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Sat,
 06 Apr 2013 06:44:09
 GMT;WwBQAEEAVABDAEgAIAA0AC8ANgBdACAAbQBmAGQAOgAgAG0AYwAxADMAeAB4AHgAOgAgAHUAcwBlACAAcwBwAGkAXwBnAGUAdABfAGQAcgB2AGQAYQB0AGEAKAApACAAYQBuAGQAIABzAHAAaQBfAHMAZQB0AF8AZAByAHYAZABhAHQAYQAoACkA
x-cr-puzzleid: {9DE8D711-0575-4AE6-AD76-2181262AE07E}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zA137I/GBBkeXcVlcXniJ1eLyrjls
	Fqe7WR2YPeadDPTo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujE27BQtOclVsOHqDvYHxDkcX
	IyeHhICJxMf+1UwQtpjEhXvr2boYuTiEBJYxSpw8u40Vpqhv8y1miMQiRomH/YugnF+MEr3t
	98Gq2ATUJL58OcwOYosIaEl0HzsPNIqDg1nAReLoNBGQsJCArcTmWYdYQGxOATuJM/+3MYLY
	wgJ+Et37D7CB2CwCqhL3Zl0Gu4gXqP7I31ssELagxI/J98BsZqDx63ceZ4Kw5SU2r3nLDLJK
	QkBd4tFfXYgLjCQ2P25kgygRkdj34h0jyMkSAi9YJLY8/c8M8ZipRMeGN+wQ9iV2iWv3QiFu
	EJD4NhnkTpCZshKbDkCVS0ocXHGDZQKj1CwkF81CctEsJBfNQrJ6ASPLKkbR1ILkguKk9CJT
	veLE3OLSvHS95PzcTYyQWJ24g/H+AetDjMlA6ycyS4km5wNjPa8k3tDYzMjC1MTU2Mjc0ow0
	YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjLJNTz+/Ll7l1CrGtuhB8EzhozOX
	OP3ZdNvjzskHjjI/hHPtN7/ykF6h/lfi0ruWqkj9M78YAn4v+F/h/mSS1PLsv284tdsK2BKF
	1+1ZUyiqzeHaXJF06R1baotp/YLzx3t8ti01u8iSaJHz5qJe5+7nLv3MjuVRzCpGi9YLrs3x
	PHlEfecvayWW4oxEQy3mouJEANG6TP/rAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV37I/GBBvvusVpcXngJSOyaw2Zx
	upvVgdlj3slAj74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAHao6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGPM2LRbsOAkV8WGozfYGxjvcHQxcnJICJhI9G2+xQxhi0lcuLeerYuRi0NIYBGjxMP+RcwQ
	zi9Gid72+6wgVWwCahJfvhxmB7FFBLQkuo+dB+rg4GAWcJE4Ok0EJCwkYCuxedYhFhCbU8BO
	4sz/bYwgtrCAn0T3/gNsIDaLgKrEvVmXmUBsXqD6I39vsUDYghI/Jt8Ds5mBxq/feZwJwpaX
	2LzmLTPIKgkBdYlHf3UhLjCS2Py4kQ2iRERi34t3jCAnSwi8YJHY8vQ/1GOmEh0b3rBPYBSZ
	hWTFLCQrZiFZMQvJrAWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxglPBM+kdjKsaLA4x
	CnAwKvHwWtyOCxRiTSwrrsw9xCjBwawkwiv7HCjEm5JYWZValB9fVJqTWnyIMRkYAhOZpUST
	84FpKq8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGJcKbbQ8
	rF2wRcjRvUHJ+PufZa3fl32X03y1ZDv3n/JpD3pqexsEFgY8snNpyG9++Ew7x2LWdvuWa6Hu
	HvNmLrJgiinc7tQtn/gnubztibryhdBTu4IuhzzOvNcfK9KbtWTqr8sr4jJ5Fd04v1Zt3rAj
	43bLrU+JkqU2z+7IPpX5PXv5zhDry0osxRmJhlrMRcWJAOJ/5uFJAwAA
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
 drivers/mfd/mc13xxx-spi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 3032bae..77189da 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -131,7 +131,7 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 	if (!mc13xxx)
 		return -ENOMEM;
 
-	dev_set_drvdata(&spi->dev, mc13xxx);
+	spi_set_drvdata(spi, mc13xxx);
 	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
 
 	mc13xxx->dev = &spi->dev;
@@ -144,7 +144,7 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 		ret = PTR_ERR(mc13xxx->regmap);
 		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
 				ret);
-		dev_set_drvdata(&spi->dev, NULL);
+		spi_set_drvdata(spi, NULL);
 		return ret;
 	}
 
@@ -164,7 +164,7 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 
 static int mc13xxx_spi_remove(struct spi_device *spi)
 {
-	struct mc13xxx *mc13xxx = dev_get_drvdata(&spi->dev);
+	struct mc13xxx *mc13xxx = spi_get_drvdata(spi);
 
 	mc13xxx_common_cleanup(mc13xxx);
 
-- 
1.7.2.5


