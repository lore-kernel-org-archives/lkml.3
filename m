Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab3HNBVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 21:21:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39978 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3HNBVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 21:21:51 -0400
X-AuditID: cbfee68f-b7f436d000000f81-6e-520adbac9ca6
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sangjung Woo <sangjung.woo@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        Myugnjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] drivers/rtc/rtc-max77686.c: Fix wrong register
Date: Wed, 14 Aug 2013 10:21:41 +0900
Message-id: <1376443301-969-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRsSkSHfNba4gg5n7FS3mrF/DZtF59gmz
	xeVdc9gsbjeuYLNYsKfEgdXjxIzfLB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVMfvYTPaC
	r+wVq7qrGxjPs3UxcnJICJhIHLm5mQXCFpO4cG89UJyLQ0hgKaPEtrYN7DBFB1bPZ4dITGeU
	uD7pGJTTxiTRtv4OM0gVm4CuxJMDl8FsESB71fNdYDazwDxGiY0vPUFsYQF7ibnH9oCtYxFQ
	ldi0ZSETiM0r4CaxadJtoNUcQNsUJOZMsoFYfJ9NYu5yVohyAYlvkw+xQJTISmw6wAxRIilx
	cMUNlgmMggsYGVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525iBAbi6X/P+ncw3j1gfYgxGWjc
	RGYp0eR8YCDnlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiR
	iYNTqoFxRvy5KDkm7dAL3jekVk6QiDzwzunVZpXKxd+Wb7gj+nwb39HT2lMU/hWzyOionP15
	i1Grru1ixJyX+eufmxtarHVPtHl5sfzarLa0WDnZmTmlxe83Pymar8r6y+vtG/W783rffRZ+
	yd7HYHX5A/POKbyfjggU/Dvev6KY++2igAT2WfUVW/sblFiKMxINtZiLihMBW4I3KVoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jQd01t7mCDKbtlrKYs34Nm0Xn2SfM
	Fpd3zWGzuN24gs1iwZ4SB1aPEzN+s3j0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGENY8bsYzPZC76yV6zqrm5gPM/WxcjJISFgInFg9Xx2CFtM4sK99UBx
	Lg4hgemMEtcnHWOHcNqYJNrW32EGqWIT0JV4cuAymC0CZK96vgvMZhaYxyix8aUniC0sYC8x
	99geFhCbRUBVYtOWhUwgNq+Am8SmSbeBNnAAbVOQmDPJZgIj9wJGhlWMoqkFyQXFSem5RnrF
	ibnFpXnpesn5uZsYwYH+THoH46oGi0OMAhyMSjy8FnZcQUKsiWXFlbmHGCU4mJVEeL/aAIV4
	UxIrq1KL8uOLSnNSiw8xJgMtn8gsJZqcD4zCvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJ
	pCeWpGanphakFsFsYeLglGpgLAve83r7EssJ7xrMxUtfiq9lFVV+XvnR/831wChnj+BJChL5
	Kyc+vjn1/DEfjkTuPrZdLhP+vVn4YknwtO1MvJL/3YxmsSwQzNczzT0RdGNVdUj+pvs9x89L
	iRvs7PBQP+fcdTyh4apKY9qO7yzX2188X8Nw8Ex1b8cujzU6N1skm5VD72XEK7EUZyQaajEX
	FScCAEsWpM64AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to read the wrong register when checking whether the RTC timer has
reached or not.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
Signed-off-by: Myugnjoo Ham <myungjoo.ham@samsung.com>
Reviewed-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/rtc/rtc-max77686.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 9915cb9..9efe118 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -240,9 +240,9 @@ static int max77686_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	}
 
 	alrm->pending = 0;
-	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS1, &val);
+	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS2, &val);
 	if (ret < 0) {
-		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",
+		dev_err(info->dev, "%s:%d fail to read status2 reg(%d)\n",
 				__func__, __LINE__, ret);
 		goto out;
 	}
-- 
1.7.9.5

