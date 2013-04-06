Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab3DFGoy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 02:44:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51776 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab3DFGow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 02:44:52 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-b0-515fc4630f38
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
In-reply-to: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
Subject: [PATCH 6/6] mfd: stmpe: use spi_get_drvdata()
Date: Sat, 06 Apr 2013 15:44:51 +0900
Message-id: <001c01ce3292$3d293d90$b77bb8b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ykfPaYTuV5qPCS+S/kzkYYtE9uwAAD1yg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zQ93kI/GBBid2K1pcXniJ1eLyrjls
	Fqe7WR2YPeadDPTo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujGX3jrMV/GOteNXey9rA+Jel
	i5GDQ0LAROLXZvcuRk4gU0ziwr31bF2MXBxCAssYJQ61zGaESJhIzH+0gxEisYhRYv7ho+wQ
	zi9GiUkzfjGDVLEJqEl8+XKYHcQWEdCS6D52ng1kA7OAi8TRaSIgYSEBW4nNsw6xgNicAnYS
	Z/5vA1sgLGAmcfneWlYQm0VAVeL8vj1MIDYvUP3V/RvYIWxBiR+T74H1MgONX7/zOBOELS+x
	ec1bZohn1CUe/dUFMUUEjCQ+X82BqBCR2PfiHdj5EgL72CWuP3nOBrFKQOLb5EPQcJCV2HSA
	GeJdSYmDK26wTGCUmIVk8Swki2chWTwLyYoFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3
	MUIib+IOxvsHrA8xJgOtn8gsJZqcD4zcvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VusA4UE0hNL
	UrNTUwtSi+KLSnNSiw8xMnFwSjUwCrl0/wr8dNlk26JF1qsuCe26cViq53Rk7eEu//Izf9MO
	H+w4lxjzo8pg2a3FnPxlAfsPMc/gubnoy6rEi/wN57ienJmZtpV18qrX0bONblv5vJa69tKn
	zLJo2fyVWVaVJxpcozYtnfb74zoLWRGbHzr2nlsOvJzp8fGtlNKXFLY7F/0O+Z+VL1RiKc5I
	NNRiLipOBACvmDql0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd3kI/GBBk9+yFhcXniJ1eLyrjls
	Fqe7WR2YPeadDPTo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
	SwtzJYW8xNxUWyUXnwBdt8wcoD1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQ
	QMI6xoxl946zFfxjrXjV3svawPiXpYuRk0NCwERi/qMdjBC2mMSFe+vZuhi5OIQEFjFKzD98
	lB3C+cUoMWnGL2aQKjYBNYkvXw6zg9giAloS3cfOA3VwcDALuEgcnSYCEhYSsJXYPOsQ2AJO
	ATuJM/+3gS0QFjCTuHxvLSuIzSKgKnF+3x4mEJsXqP7q/g3sELagxI/J98B6mYHGr995nAnC
	lpfYvOYtM8gqCQF1iUd/dUFMEQEjic9XcyAqRCT2vXjHOIFRaBaSQbOQDJqFZNAsJC0LGFlW
	MYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH9jPpHYyrGiwOMQpwMCrx8FrcjgsUYk0sK67M
	PcQowcGsJMIr+xwoxJuSWFmVWpQfX1Sak1p8iDEZ6M+JzFKiyfnApJNXEm9obGJmZGlkZmFk
	Ym5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYwx3DxfGL2ELs3yT71s7HrL3CKIrXEm
	G8edvcxtz75t6b5rorH818Gf0/9r/I7Id/t98PEDH+vcrT9jlrLuKitZGLKuap3Rt0e9uWdz
	nVeI/Iiu5fHmu7PtxX5RszWG+yTKjPdOLbWIdCz3ztK+K/xk79Ea/SUvV5tc/dj6v9r7hbqC
	anHQJ1YlluKMREMt5qLiRAAjTClpMAMAAA==
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
 drivers/mfd/stmpe-spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index 973659f..a81badb 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -103,7 +103,7 @@ stmpe_spi_probe(struct spi_device *spi)
 
 static int stmpe_spi_remove(struct spi_device *spi)
 {
-	struct stmpe *stmpe = dev_get_drvdata(&spi->dev);
+	struct stmpe *stmpe = spi_get_drvdata(spi);
 
 	return stmpe_remove(stmpe);
 }
-- 
1.7.2.5


