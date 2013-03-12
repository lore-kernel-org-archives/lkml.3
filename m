Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab3CLFsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:48:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30057 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3CLFsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:48:18 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-62-513ec1a02097
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: da903x_bl: switch to using SIMPLE_DEV_PM_OPS
Date: Tue, 12 Mar 2013 14:48:16 +0900
Message-id: <003d01ce1ee5$316a57c0$943f0740$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5TFGbi0DDqigSHaFNclqJo2Q/A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zQ90FB+0CDT4tsLaYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDI+XT3O
	WHCEu+LCIdUGxkucXYycHBICJhIv161jgbDFJC7cW8/WxcjFISSwjFHi278zrDBFZ759YIZI
	TGeUWLXlABOE84tR4nDLQmaQKjYBNYkvXw6zdzFycIgI6Eu0tWiAhJkFSiW2PngPtkFYwEPi
	/emHjCA2i4CqxMdJT8BsXgFbiavzZjFB2IISPybfY4Ho1ZJYv/M4E4QtL7F5zVtmkPESAuoS
	j/7qQmzSkzjw1x2iQkRi34t3jCCXSQhsYpdY8+gBK8QqAYlvkw+xQLTKSmw6wAzxlqTEwRU3
	WCYwis1CsngWksWzkCyehWTFAkaWVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxghEda/g/Hu
	AetDjMlA6ycyS4km5wMjNK8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4
	otKc1OJDjEwcnFINjMWOuyIiNliueLlk0jfTI/PuqDed2Gu6dNLbM/cFnU7kHpG+oZWw6qDD
	JNGIV/f0p3D5zZkTVbps53l57fitngVJf18yK86N0H7O8LNpj8cZH/8lTVmsq669mNtyVHv9
	gSX7D7h+eLlX8e2JWCXH757/3ec2RglZ/3h6OHf3hXciX9oNPJMW3/2jxFKckWioxVxUnAgA
	W28F1MYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd0FB+0CDbbvN7eYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzPl09zlhwhLviwiHVBsZLnF2MnBwSAiYSZ759YIawxSQu3FvP
	1sXIxSEkMJ1RYtWWA0wQzi9GicMtC8Gq2ATUJL58OczexcjBISKgL9HWogESZhYoldj64D0L
	iC0s4CHx/vRDRhCbRUBV4uOkJ2A2r4CtxNV5s5ggbEGJH5PvsUD0akms33mcCcKWl9i85i0z
	yHgJAXWJR391ITbpSRz46w5RISKx78U7xgmMArOQDJqFZNAsJINmIWlZwMiyilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4fp9J7WBc2WBxiFGAg1GJh1fxm22gEGtiWXFl7iFGCQ5mJRHe
	jM12gUK8KYmVValF+fFFpTmpxYcYk4H+nMgsJZqcD0wteSXxhsYmZkaWRmYWRibm5qQJK4nz
	Hmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAuFfI6FpE/ivTI2Ka5Xvr9Xgmhfd17xZjDvhSFdek
	L857O8vmN5Oh7IUvBiFrn1nduMJ0W2U6k92ZiQcOTspu7pQ7EhhqEVRUv/WmC+OWackiFfG5
	zRtOTpXcJaw5d81utZYTm/6H2nL8cRN7k2G+58cxZplS52jp5FShy+nz51rz+3hcEfqhxFKc
	kWioxVxUnAgAruMY+yMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces #ifdefs in the code. Also, CONFIG_PM_SLEEP is used
to avoid warnings of unused functions if CONFIG_PM_SLEEP is not
defined.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/da903x_bl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 8179cef..c625f6d 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -161,7 +161,7 @@ static int da903x_backlight_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int da903x_backlight_suspend(struct device *dev)
 {
 	struct backlight_device *bl = dev_get_drvdata(dev);
@@ -176,20 +176,16 @@ static int da903x_backlight_resume(struct device *dev)
 	backlight_update_status(bl);
 	return 0;
 }
-
-static const struct dev_pm_ops da903x_backlight_pm_ops = {
-	.suspend	= da903x_backlight_suspend,
-	.resume		= da903x_backlight_resume,
-};
 #endif
 
+static SIMPLE_DEV_PM_OPS(da903x_backlight_pm_ops, da903x_backlight_suspend,
+			da903x_backlight_resume);
+
 static struct platform_driver da903x_backlight_driver = {
 	.driver		= {
 		.name	= "da903x-backlight",
 		.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
 		.pm	= &da903x_backlight_pm_ops,
-#endif
 	},
 	.probe		= da903x_backlight_probe,
 	.remove		= da903x_backlight_remove,
-- 
1.7.2.5


