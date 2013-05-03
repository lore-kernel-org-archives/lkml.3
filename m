Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab3ECGhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:37:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64737 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762719Ab3ECGhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:37:13 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-ba-51835b184ec0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 35/42] rtc: rtc-stmp3xxx: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:37:12 +0900
Message-id: <003101ce47c8$a4a8cbc0$edfa6340$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyKP/D0aunJSrTxeAZtjLIcuAIg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zA12J6OZAg+6dkhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBl7NmRVbCJp2LKteWsDYwzuLoYOTkkBEwkmv7OYIWwxSQu3FvP1sXIxSEksIxRYtKm
	bUxdjBxgRd/WZ0PEpzNKPH56kBGkQUjgF6PE73meIDabgJrEly+H2UHqRQT0JdpaNEDqmQW6
	GSUeNc9lBqkRFgiV2L7+IDuIzSKgKnFnRj9YnFfAUmLipyksELagxI/J98BsZgEtifU7jzNB
	2PISm9e8ZYY4VEFix9nXYDeICOhJbJk2mRGiRkRi34t3jCCLJQSOsUtc2XaMDWKZgMS3yYdY
	IJ6Rldh0AGqOpMTBFTdYJjCKzUKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5xaV5
	6XrJ+bmbGCFx17eD8eYB60OMyUDrJzJLiSbnA+M2ryTe0NjMyMLUxNTYyNzSjDRhJXFetRbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mc76snL8u50PehQ/HLmifEbj9qGGihI0r65/P
	fx7p91w93tYkraVoPifZx7m3KVO6ZMMtxp218/5xH3m49e15oa/CSrti89S1LLQWexaEvXsy
	OSBg1snkn3P14rkffPTWN8+fVaSnExy45rJy8HdjzjU1JwPtbd97Mnz6zCMctmrDbIYyS9dv
	SizFGYmGWsxFxYkAJj9AjNECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQV2J6OZAg2NPRC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNizI6tgE0/FlGvLWRsYZ3B1MXJwSAiYSHxb
	n93FyAlkiklcuLeerYuRi0NIYDqjxOOnBxlBEkICvxglfs/zBLHZBNQkvnw5zA7SKyKgL9HW
	ogFSzyzQzSjxqHkuM0iNsECoxPb1B9lBbBYBVYk7M/rB4rwClhITP01hgbAFJX5MvgdmMwto
	SazfeZwJwpaX2LzmLTPEQQoSO86+BrtBREBPYsu0yYwQNSIS+168Y5zAKDALyahZSEbNQjJq
	FpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo/qZ9A7GVQ0WhxgFOBiVeHgVWpoC
	hVgTy4orcw8xSnAwK4nwuv0ACvGmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MOHklcQbGpuY
	GVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjHMeu7TU7Lh2+VNkyQfNx
	YN6ppiV777V78kxld2djcA1hPvFxqt+PCVPPaqzuEn/5gGnh9YbueX9UtX/tkpKr/l3Arm5U
	0dpYUrzHTOlY38aA7HM5dy55bM5b53rcWq2uJpnvz5byVL46/wxP4SSD/3luFw8EP5pTIH3R
	eItqxnT7+s1nXZcrsRRnJBpqMRcVJwIAHHtMxy4DAAA=
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
 drivers/rtc/rtc-stmp3xxx.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index 483ce08..90a3e86 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -225,7 +225,6 @@ static int stmp3xxx_rtc_remove(struct platform_device *pdev)
 
 	writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
 			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
@@ -274,25 +273,19 @@ static int stmp3xxx_rtc_probe(struct platform_device *pdev)
 
 	rtc_data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				&stmp3xxx_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc_data->rtc)) {
-		err = PTR_ERR(rtc_data->rtc);
-		goto out;
-	}
+	if (IS_ERR(rtc_data->rtc))
+		return PTR_ERR(rtc_data->rtc);
 
 	err = devm_request_irq(&pdev->dev, rtc_data->irq_alarm,
 			stmp3xxx_rtc_interrupt, 0, "RTC alarm", &pdev->dev);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot claim IRQ%d\n",
 			rtc_data->irq_alarm);
-		goto out;
+		return err;
 	}
 
 	stmp3xxx_wdt_register(pdev);
 	return 0;
-
-out:
-	platform_set_drvdata(pdev, NULL);
-	return err;
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
1.7.2.5


