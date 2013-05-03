Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab3ECGji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:39:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62008 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab3ECGjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:39:35 -0400
X-AuditID: cbfee68f-b7f066d000003683-3e-51835ba6841c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>,
        "'Guan Xuetao'" <gxt@mprc.pku.edu.cn>
Subject: [PATCH 40/42] rtc: rtc-puv3: remove unnecessary platform_set_drvdata()
Date: Fri, 03 May 2013 15:39:34 +0900
Message-id: <003601ce47c8$f9aa1e30$ecfe5a90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyOpJZWXaFy1yRvKKx9bj39NiAA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zI91l0c2BBpMPmlosuXiV3WLO+jVs
	FgdvfGO3uLzwEqvF5V1z2Cz2d3YwOrB57Jl4ks3jxIzfLB6P91p69G1Zxegxfd5PJo/Pm+QC
	2KK4bFJSczLLUov07RK4MlonzmIqOM5WMX2zTQPjHtYuRk4OCQETiY03T7FA2GISF+6tZ+ti
	5OIQEljGKHHz0C2gIg6wotmr7CDi0xkldu37xwTh/GKU+PvgAjNIN5uAmsSXL4fZQRpEBPQl
	2lo0QGqYBTYxSixbeI4JpEZYwF/i+oPVTCA1LAKqEmv+SYOEeQUsJXa29zJB2IISPybfAzuI
	WUBLYv3O40wQtrzE5jVvmSEOVZDYcfY1I4gtIqAn0bhoPjtEjYjEvhfvGCFqLrFLLD6tBmKz
	CAhIfJt8iAXiF1mJTQegxkhKHFxxg2UCo9gsJJtnIdk8C8nmWUg2LGBkWcUomlqQXFCclF5k
	rFecmFtcmpeul5yfu4kREof9OxjvHrA+xJgMtH4is5Rocj4wjvNK4g2NzYwsTE1MjY3MLc1I
	E1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLjXuMBr7+RTLPMSV81dbFDTMsul
	89AzXdkf86fueODsdFlEdt1rhU4PpguNSeyGyyJa63eFzvUJT/jJlrapKb37lHZh5rGYr7F3
	f29WWhD/f2dNk7hpwNtm0Rye7/87Ei98mLN50ToPM+OChpXVcQFaGUaR2j7B3ff6Odb4Lgwx
	nCd540zfEyWW4oxEQy3mouJEAPMFd73ZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jQd1l0c2BBr/fG1osuXiV3WLO+jVs
	FgdvfGO3uLzwEqvF5V1z2Cz2d3YwOrB57Jl4ks3jxIzfLB6P91p69G1Zxegxfd5PJo/Pm+QC
	2KIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWa0TpzFVHCcrWL6ZpsGxj2s
	XYwcHBICJhKzV9l1MXICmWISF+6tZ+ti5OIQEpjOKLFr3z8mCOcXo8TfBxeYQarYBNQkvnw5
	zA7SLCKgL9HWogFSwyywiVFi2cJzTCA1wgL+EtcfrGYCqWERUJVY808aJMwrYCmxs72XCcIW
	lPgx+R4LiM0soCWxfudxJghbXmLzmrfMEAcpSOw4+5oRxBYR0JNoXDSfHaJGRGLfi3eMExgF
	ZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCcP5PewbiqweIQ
	owAHoxIPr0JLU6AQa2JZcWXuIUYJDmYlEV63H0Ah3pTEyqrUovz4otKc1OJDjMlAj05klhJN
	zgemoLySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JQCJqU1dWWl
	PdGlcn/srTfmiaxrUZlm1xrSb1B6oUej60mS6oaY2s1Tg6NElA/5Gec+3OW6cFPqykWTnsxv
	+yciI9bc9ZaF4+axa56Mqd+uJmZefSQ07UM6Q7zVXL2EY1H/v3/mX3tOrk63Ueer79GOhe9T
	Zp5Q9je/NXXqj8a4D2wJFu8rJjE1KrEUZyQaajEXFScCAEkJu7M3AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-puv3.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index 72f4371..402732c 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -224,7 +224,6 @@ static int puv3_rtc_remove(struct platform_device *dev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
-	platform_set_drvdata(dev, NULL);
 	rtc_device_unregister(rtc);
 
 	puv3_rtc_setpie(&dev->dev, 0);
-- 
1.7.2.5


