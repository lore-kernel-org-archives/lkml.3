Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765827Ab3DEA5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 20:57:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31476 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765803Ab3DEA5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 20:57:42 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-7e-515e2184f9fd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] backlight: ili9320: use spi_set_drvdata()
Date: Fri, 05 Apr 2013 09:57:39 +0900
Message-id: <004101ce3198$92513a70$b6f3af50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xmJH+n27OKOYuSb6yuIIk4ZufNA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zQ90WxbhAg2PT+S3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErozPN7ex
	Fkxjq3jUOZe9gXEGaxcjJ4eEgInEqtVvGCFsMYkL99azdTFycQgJLGOU2Pv+I1zR/3N/mUBs
	IYHpjBKXHitD2L8YJWY8KQax2QTUJL58OczexcjBISKgL9HWogESZhYoldj64D0LSFhYwE7i
	7LQskDCLgKrE4f/vwabzCthKXHjVygJhC0r8mHyPBaJVS2L9zuNMELa8xOY1b5lBxkgIqEs8
	+qsLEhYR0JPo2vGPEaJERGLfi3eMINdLCGxil/j7sJkNYpeAxLfJh1ggemUlNh1ghnhKUuLg
	ihssExjFZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjJD46t/B
	ePeA9SHGZKD1E5mlRJPzgfGZVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQbGfWeqrC4u8Qkx/PlWUuwb+0UTjzWNjBUpajcad7NuWrivU+i+knfX
	tPtr92u6rvyr8Yztp9mFEweX7F2Qeieh6M6e54t3fZnPeypVf7sdl8g+u+bHWpFZzuvcwxa1
	92avec016eSVu6Zijo/l2j4X7qsxmJBQccXumdK199K6L/df8pzl8fx6kBJLcUaioRZzUXEi
	AISBGbrFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoG6LYlygwYRPXBZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPG55vbWAumsVU86pzL3sA4g7WLkZNDQsBE4v+5v0wQtpjEhXvr
	2UBsIYHpjBKXHitD2L8YJWY8KQax2QTUJL58OczexcjBISKgL9HWogESZhYoldj64D0LSFhY
	wE7i7LQskDCLgKrE4f/vwTbxCthKXHjVygJhC0r8mHyPBaJVS2L9zuNMELa8xOY1b5lBxkgI
	qEs8+qsLEhYR0JPo2vGPEaJERGLfi3eMExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnD0PpPewbiqweIQowAHoxIPb0ZfbKAQa2JZcWXuIUYJDmYlEd6d
	fHGBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTCx5JfGGxiZmRpZGZhZGJubmpAkrifMe
	bLUOFBJITyxJzU5NLUgtgtnCxMEp1cAYzL6ez9HhzvGeA/e1H9bIu6lyKu/7Kb751dPktt2p
	l74of3r26Uf2BdtbB/c78Kyovti4P7lIx/iP60RrZrODRVNuPJV55/P8cNkCw6hOkfLyWTdt
	JNzW/FK7MSkx45L+JrPqM3nL55n5fLFtdlS+yLAjQGM249brPzUk9c+ddQqX3LJFp7hdiaU4
	I9FQi7moOBEA7Hn82SIDAAA=
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
 drivers/video/backlight/ili9320.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index 1235bf9..c3a5299 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -231,7 +231,7 @@ int ili9320_probe_spi(struct spi_device *spi,
 	ili->power = FB_BLANK_POWERDOWN;
 	ili->platdata = cfg;
 
-	dev_set_drvdata(&spi->dev, ili);
+	spi_set_drvdata(spi, ili);
 
 	ili9320_setup_spi(ili, spi);
 
-- 
1.7.2.5


