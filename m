Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab3DFGod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 02:44:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27394 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3DFGob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 02:44:31 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-54-515fc44ea8d1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
In-reply-to: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
Subject: [PATCH 5/6] mfd: arizona: use spi_get_drvdata()
Date: Sat, 06 Apr 2013 15:44:30 +0900
Message-id: <001b01ce3292$309072b0$91b15810$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ykfPaYTuV5qPCS+S/kzkYYtE9uwAADD/w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zfV2/I/GBBmtnSllcXniJ1eLyrjls
	Fqe7WR2YPeadDPTo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujJn/N7MXLGOrOPrqD2MD4yLW
	LkZODgkBE4mmS1uZIGwxiQv31rN1MXJxCAksY5Rof72bGaZo+fOHLBCJRYwSp17/YIdwfjFK
	zPr5khGkik1ATeLLl8PsILaIgJZE97HzQKM4OJgFXCSOThMBCQsJ2EpsnnWIBcTmFLCTOPN/
	GyNIibCAhcSBy/kgYRYBVYmltyexgdi8QOXLr26FsgUlfky+B9bKDDR9/c7jTBC2vMTmNW+Z
	QcZICKhLPPqrC3GAkUT/7n5WiBIRiX0v3jGCXCwhsItdYnv7KiaIXQIS3yaDnAPSKyux6QDU
	u5ISB1fcYJkA9BuSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJ
	vf4djHcPWB9iTAZaP5FZSjQ5Hxi7eSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGan
	phakFsUXleakFh9iZOLglGpg9E9r31EvWMSjvG3pjqkFgj/26P/7pHFzjj9Tn8WJDQ1851M2
	sL62zkx9e/HUp26WVRx9fzRO+imHx6ntTOeQaTPu8mEo75qitvoej0xkZaiVxul9vgWmn9+n
	/1Y5YdT8xqkk9E5X8Eax6YxLWO986A7Y8bFf0v1SeVx3d8IzvfP3Fd75OE9VYinOSDTUYi4q
	TgQAGyS9T9MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAV2/I/GBBuvPiVpcXniJ1eLyrjls
	Fqe7WR2YPeadDPTo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
	SwtzJYW8xNxUWyUXnwBdt8wcoD1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQ
	QMI6xoyZ/zezFyxjqzj66g9jA+Mi1i5GTg4JAROJ5c8fskDYYhIX7q1n62Lk4hASWMQocer1
	D3YI5xejxKyfLxlBqtgE1CS+fDnMDmKLCGhJdB87D9TBwcEs4CJxdJoISFhIwFZi86xDYEM5
	BewkzvzfxghSIixgIXHgcj5ImEVAVWLp7UlsIDYvUPnyq1uhbEGJH5PvgbUyA01fv/M4E4Qt
	L7F5zVtmkDESAuoSj/7qQhxgJNG/u58VokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWj
	aGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcGQ/k97BuKrB4hCjAAejEg+vxe24QCHWxLLiytxD
	jBIczEoivLLPgUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0w6eSXxhsYmZkaWRmYWRibm
	5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAKPbue1l0tlRVEFtGTHXCAbsZUlNDuEz4
	UhoMTG9q3r2hKpH2Z+VJdqbyatM1YU8MlvSH/w7Ly3r+6nHo2x/Vr+Vz5II+iX5Z/89hecCZ
	Y6rr9v/eNflpx5lP30qrnl5v9VgSPXm6neItuWMqrnzZV2bOXy/wflmVbUXAklyG4LAXp1ct
	3im6UomlOCPRUIu5qDgRAAZjzO4wAwAA
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
 drivers/mfd/arizona-spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/arizona-spi.c b/drivers/mfd/arizona-spi.c
index 1b9fdd6..b57e642 100644
--- a/drivers/mfd/arizona-spi.c
+++ b/drivers/mfd/arizona-spi.c
@@ -67,7 +67,7 @@ static int arizona_spi_probe(struct spi_device *spi)
 
 static int arizona_spi_remove(struct spi_device *spi)
 {
-	struct arizona *arizona = dev_get_drvdata(&spi->dev);
+	struct arizona *arizona = spi_get_drvdata(spi);
 	arizona_dev_exit(arizona);
 	return 0;
 }
-- 
1.7.2.5


