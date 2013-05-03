Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762335Ab3ECGRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:17:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60628 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab3ECGRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:17:01 -0400
X-AuditID: cbfee68f-b7f066d000003683-a4-5183565c1c31
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/4] backlight: atmel-pwm-bl: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:16:59 +0900
Message-id: <000b01ce47c5$d1f66b80$75e34280$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HxcxX75n6OXEPSPuJvwSqHn4tQw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zQ92YsOZAg3N3+S3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErozn8/ax
	F6zgrHj8cw1bA+Mv9i5GTg4JAROJy1d+skLYYhIX7q1n62Lk4hASWMYo0TJlCRNMUevPi0wQ
	iUWMEs/f3WKBcH4xSpz+Og2sik1ATeLLl8NAYzk4RAT0JdpaNEDCzAKlElsfvGcBsYUFIiUe
	35nOAlLCIqAq8XaDG4jJK2Ap8fqMNEgFr4CgxI/J91ggOrUk1u88zgRhy0tsXvOWGeIcBYkd
	Z18zgtgiAnoSdxqfMUPUiEjse/GOEeQyCYFt7BL3T35iA0mwCAhIfJt8CGythICsxKYDUHMk
	JQ6uuMEygVFsFpLVs5CsnoVk9SwkKxYwsqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECImx
	/h2Mdw9YH2JMBlo/kVlKNDkfGKN5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqem
	FqQWxReV5qQWH2Jk4uCUamCMqw7T9f5jkxhzLDp0ijZ/saHz8kW8wWzP7Zef2qM9KU9tQ8YO
	1wLJ79xSPcLrRM7vmNrzslnlyE3t9hsTUtkfRvJ1qtrMruwuuCp1eVn5MeX5c7esOKevfSPx
	x7xvHOFfrl+5eH1eTmug4I3VSi77xdiNmqYvC7R7vZK549yS3Jll8zec3fpJiaU4I9FQi7mo
	OBEAZiAhvMcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd2YsOZAgwWtPBZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPG83n72AtWcFY8/rmGrYHxF3sXIyeHhICJROvPi0wQtpjEhXvr
	2boYuTiEBBYxSjx/d4sFwvnFKHH66zSwKjYBNYkvXw4DdXNwiAjoS7S1aICEmQVKJbY+eM8C
	YgsLREo8vjOdBaSERUBV4u0GNxCTV8BS4vUZaZAKXgFBiR+T77FAdGpJrN95nAnClpfYvOYt
	M8Q5ChI7zr5mBLFFBPQk7jQ+Y4aoEZHY9+Id4wRGgVlIRs1CMmoWklGzkLQsYGRZxSiaWpBc
	UJyUnmuoV5yYW1yal66XnJ+7iREcwc+kdjCubLA4xCjAwajEw6vQ0hQoxJpYVlyZe4hRgoNZ
	SYTX7QdQiDclsbIqtSg/vqg0J7X4EGMy0J8TmaVEk/OBySWvJN7Q2MTMyNLIzMLIxNycNGEl
	cd4DrdaBQgLpiSWp2ampBalFMFuYODilGhinc802uhly46T6grSIyftYVSJOiubqh8669sDn
	2Q8Rti611VG6E79cEqm9+fxwXMSOQk2/hsRNJlxmc9RWrNj8/+DUqi55hzfWH5wmf/o64V5r
	XuvV/OD8Z6/VVE5aM/i+SilncbiQuSO4/+kzF/7ihE87p4f8/dPMV7jVXyN/7+XZSakN3XOU
	WIozEg21mIuKEwHmb24yJAMAAA==
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
 drivers/video/backlight/atmel-pwm-bl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index a60d6af..0393d82 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -195,7 +195,6 @@ static int __init atmel_pwm_bl_probe(struct platform_device *pdev)
 	return 0;
 
 err_free_bl_dev:
-	platform_set_drvdata(pdev, NULL);
 	backlight_device_unregister(bldev);
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
@@ -212,7 +211,6 @@ static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
 	pwm_channel_disable(&pwmbl->pwmc);
 	pwm_channel_free(&pwmbl->pwmc);
 	backlight_device_unregister(pwmbl->bldev);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5


