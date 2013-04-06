Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab3DFGmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 02:42:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51663 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab3DFGmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 02:42:49 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-fe-515fc3e879ab
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/6] mfd: wm831x: use spi_get_drvdata() and spi_set_drvdata()
Date: Sat, 06 Apr 2013 15:42:48 +0900
Message-id: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ykfPaYTuV5qPCS+S/kzkYYtE9uw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t8zY90Xh+MDDTZv0rG4vPASq8XlXXPY
	LE53szowe8w7GejRt2UVo8fnTXIBzFFcNimpOZllqUX6dglcGZ/P9LAX3OWqeDbtHXMD42+O
	LkZODgkBE4nFh3ezQdhiEhfurQeyuTiEBJYxSsz60sYMUzT9+0xWiMR0Rokr3y9DOb8YJZou
	fGEBqWITUJP48uUwO4gtIqAl0X3sPNAoDg5mAReJo9NEQMLCAr4S69tvgw1lEVCVaDt8Eczm
	FbCVeHB6JxOELSjxY/I9sJHMQGPW7zzOBGHLS2xe85YZZKSEgLrEo7+6EJv0JL593A1VLiKx
	78U7RpDTJATmsUssXLqPEWKXgMS3yYdYIHplJTYdgPpLUuLgihssExjFZiHZPAvJ5llINs9C
	smIBI8sqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJBomriD8f4B60OMyUDrJzJLiSbnA6Mx
	ryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M+S8s
	nJYs+b/2ttyLKYt5G6+73f78Lsv47eL//zf+Pleft9X6nsqSwl8n0yvPFmVZej3crZr/qDHw
	7PPzd69/Z5Y+J8G76JbEubmW3RxM3yc9T+1hmyCz5UR4XrUsJ3+OwV9t+d7mWXNWLxEKljke
	+Trf3+T7SdVrL31EJ20/a64gVqxx6VitkRJLcUaioRZzUXEiAJewob28AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xoO6Lw/GBBl9uq1tcXniJ1eLyrjls
	Fqe7WR2YPeadDPTo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
	SwtzJYW8xNxUWyUXnwBdt8wcoD1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQ
	QMI6xozPZ3rYC+5yVTyb9o65gfE3RxcjJ4eEgInE9O8zWSFsMYkL99azdTFycQgJTGeUuPL9
	MiuE84tRounCFxaQKjYBNYkvXw6zg9giAloS3cfOA3VwcDALuEgcnSYCEhYW8JVY336bGcRm
	EVCVaDt8EczmFbCVeHB6JxOELSjxY/I9sJHMQGPW7zzOBGHLS2xe85YZZKSEgLrEo7+6EJv0
	JL593A1VLiKx78U7xgmMArOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10v
	OT93EyM4Vp9J7WBc2WBxiFGAg1GJh9fidlygEGtiWXFl7iFGCQ5mJRFe2edAId6UxMqq1KL8
	+KLSnNTiQ4zJQI9OZJYSTc4HppG8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqem
	FqQWwWxh4uCUamCcEMxv0WIjz25VG/hDmFVkTsx3Bhm5vXNi/jiVBtQUnA7J4ZC+2fzpqp2J
	2LtZ/5KX3f32zHWpoXxD8F+uhJVtC3UXRaVGn6tfkxMZvp6nbvPf96x3S018fWU3d/utctdS
	jjx/U+Ol2P+AunX/2OyLbIUMTrW2yu+1n/T4puqGFGbu5Je2+UosxRmJhlrMRcWJAPkXQVUZ	AwAA
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
 drivers/mfd/wm831x-spi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index 4e70e15..e7ed14f66 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -37,7 +37,7 @@ static int wm831x_spi_probe(struct spi_device *spi)
 	spi->bits_per_word = 16;
 	spi->mode = SPI_MODE_0;
 
-	dev_set_drvdata(&spi->dev, wm831x);
+	spi_set_drvdata(spi, wm831x);
 	wm831x->dev = &spi->dev;
 
 	wm831x->regmap = devm_regmap_init_spi(spi, &wm831x_regmap_config);
@@ -53,7 +53,7 @@ static int wm831x_spi_probe(struct spi_device *spi)
 
 static int wm831x_spi_remove(struct spi_device *spi)
 {
-	struct wm831x *wm831x = dev_get_drvdata(&spi->dev);
+	struct wm831x *wm831x = spi_get_drvdata(spi);
 
 	wm831x_device_exit(wm831x);
 
@@ -69,7 +69,7 @@ static int wm831x_spi_suspend(struct device *dev)
 
 static void wm831x_spi_shutdown(struct spi_device *spi)
 {
-	struct wm831x *wm831x = dev_get_drvdata(&spi->dev);
+	struct wm831x *wm831x = spi_get_drvdata(spi);
 
 	wm831x_device_shutdown(wm831x);
 }
-- 
1.7.2.5


