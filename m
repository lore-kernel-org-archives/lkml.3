Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab3BYINq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 03:13:46 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35703 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab3BYINp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 03:13:45 -0500
X-AuditID: cbfee690-b7f6b6d000004563-a1-512b1d3513a9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] backlight: platform_lcd: remove unnecessary ifdefs
Date: Mon, 25 Feb 2013 17:13:41 +0900
Message-id: <001301ce1330$05b74d60$1125e820$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4TMAWY/k5Gl7s5To252aayYJP61w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zA11TWe1Ag+9thhZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV0bH5i7W
	gl7uigkvGhkbGGdydjFyckgImEg0P/zABmGLSVy4tx7I5uIQEljGKHFm72w2mKIti28zQySm
	M0o0LrzHBOH8YpR4ceUhE0gVm4CaxJcvh9m7GDk4RAT0JdpaNEDCzAKlElsfvGcBsYUF3CWO
	vFjCDmKzCKhKfOueA1bOK2ArcbA3GiTMKyAo8WPyPRaIVi2J9TuPM0HY8hKb17xlBimXEFCX
	ePRXFyQsIqAn8eb6N6hyEYl9L94xglwmIbCLXeLIrGesEKsEJL5NPsQC0SsrsekAM8RbkhIH
	V9xgmcAoNgvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYoTE2IQd
	jPcOWB9iTAZaP5FZSjQ5HxijeSXxhsbGJmYmpibmlqbmpqQJK4nzyl+SCRQSSE8sSc1OTS1I
	LYovKs1JLT7EyMTBKdXAmDk/4FhFkMqGTwr/9kfOaXa5sOnTgWlF0Rvm6M3w2H+jUMymKZ7l
	eu+8Dn2mpRV67rM9VAP3eTnOa1yn3cq3csO1B6wHL0qaX067rFW8J3vle48zh1b9fXs5sjiR
	91Ifi8zz07Odd6bVrvGbdCDhXMbRZbz7JRsVVRZHXNmzeXWU9R5l4b/bw5RYijMSDbWYi4oT
	AZnliv/HAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQV1TWe1Agz/ndCzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMjs1drAW93BUTXjQyNjDO5Oxi5OSQEDCR2LL4NjOELSZx4d56
	ti5GLg4hgemMEo0L7zFBOL8YJV5cecgEUsUmoCbx5cth9i5GDg4RAX2JthYNkDCzQKnE1gfv
	WUBsYQF3iSMvlrCD2CwCqhLfuueAlfMK2Eoc7I0GCfMKCEr8mHyPBaJVS2L9zuNMELa8xOY1
	b5lByiUE1CUe/dUFCYsI6Em8uf4NqlxEYt+Ld4wTGAVmIZk0C8mkWUgmzULSsoCRZRWjaGpB
	ckFxUnqukV5xYm5xaV66XnJ+7iZGcAQ/k97BuKrB4hCjAAejEg9vw0qtQCHWxLLiytxDjBIc
	zEoivJqhQCHelMTKqtSi/Pii0pzU4kOMyUB/TmSWEk3OByaXvJJ4Q2MTMyNLIzMLIxNzc9KE
	lcR5GU89CRASSE8sSc1OTS1ILYLZwsTBKdXAaLiuOCXqePCUkMTyr64reBe/1P5p2fgyaZIR
	Y1vfzt2qq5o9n/5ZttRo+SsJq31LVC3+H5q7hIX/k9+Va/OKXvyviYw5fe7RK9e5S4NTzx1+
	uDEn6sYmHs9SM2unntpHN1onrAk7ZVWulZi14LPPxPSkvbemNr368bL06tubGjGb9F8cPDJz
	wVslluKMREMt5qLiRABqWgmzJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the macro such as SIMPLE_DEV_PM_OPS is used, there is
no need to use '#ifdef CONFIG_PM' to prevent build error. Thus,
this patch removes unnecessary ifdefs.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/platform_lcd.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index 17a6b83..54d94de 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -121,7 +121,7 @@ static int platform_lcd_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int platform_lcd_suspend(struct device *dev)
 {
 	struct platform_lcd *plcd = dev_get_drvdata(dev);
@@ -141,10 +141,10 @@ static int platform_lcd_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(platform_lcd_pm_ops, platform_lcd_suspend,
 			platform_lcd_resume);
-#endif
 
 #ifdef CONFIG_OF
 static const struct of_device_id platform_lcd_of_match[] = {
@@ -158,9 +158,7 @@ static struct platform_driver platform_lcd_driver = {
 	.driver		= {
 		.name	= "platform-lcd",
 		.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
 		.pm	= &platform_lcd_pm_ops,
-#endif
 		.of_match_table = of_match_ptr(platform_lcd_of_match),
 	},
 	.probe		= platform_lcd_probe,
-- 
1.7.2.5


