Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbaH0BMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:12:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8264 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaH0BMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:12:40 -0400
X-AuditID: cbfee691-f79546d0000011a1-66-53fd3085786f
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 10/18] backlight: lms501kf03: remove 'else' after a return
Date: Wed, 27 Aug 2014 10:12:37 +0900
Message-id: <004e01cfc193$fd5df420$f819dc60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAIeBQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zA91Wg7/BBjvmSVkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnPj95n
	L5jNWTHjWCNzA+NZ9i5GDg4JAROJ3XMluhg5gUwxiQv31rN1MXJxCAksY5R4Nu0OXM2sReoQ
	8UWMEtcvvmGHcH4zSuxtPMwG0s0moCbx5cthdhBbREBBYnPvM1YQm1kgV+L3zJWMILaQgK3E
	5YVrmUBsTgE7idkfpoPVCwv4Srxt7AGbwyKgKrF4xzSwGl6g+mXzZrFB2IISPybfY4GYqSWx
	fudxJghbXmLzmrfMEIeqSzz6qwtxgpHEgVsd7BAlIhL7XrxjBLlZQuAUu8S9Vc1MELsEJL5N
	PsQC0SsrsekAMyQgJCUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLVK07M
	LS7NS9dLzs/dxAiJyYk7GO8fsD7EKMDBqMTD+2HBn2Ah1sSy4srcQ4ymQBdNZJYSTc4HRn5e
	SbyhsZmRhamJqbGRuaWZkjivjvTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mm+IT9c7K
	e94MaXzczVzl2T9FNT3D18Nw4cISlkZXVV1pucyTW0PKVtvIW54V5jqUOd+q2T991uoimQNV
	859+5urpsK5dJjJBZcargEmC/8vMQs6squk0/lwaKNL+1J01PnUX5z8Tl3Nu61assFP4+M3k
	w6J3a9zN9a7X5hUbfnkpJjXrCbsSS3FGoqEWc1FxIgDscCM2xAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAd1Wg7/BBjv3iVkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZz4/eZy+YzVkx41gjcwPjWfYuRg4OCQETiVmL1LsYOYFMMYkL
	99azdTFycQgJLGKUuH7xDTuE85tRYm/jYTaQKjYBNYkvXw6zg9giAgoSm3ufsYLYzAK5Er9n
	rmQEsYUEbCUuL1zLBGJzCthJzP4wHaxeWMBX4m1jD9gcFgFVicU7poHV8ALVL5s3iw3CFpT4
	MfkeC8RMLYn1O48zQdjyEpvXvGWGOFpd4tFfXYgTjCQO3OpghygRkdj34h3jBEahWUgmzUIy
	aRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzzz6R2MK5ssDjEKMDBqMTD
	+3HBn2Ah1sSy4srcQ4wSHMxKIrzJCn+DhXhTEiurUovy44tKc1KLDzGaAj06kVlKNDkfmI7y
	SuINjU3MjCyNzCyMTMzNlcR5D7RaBwoJpCeWpGanphakFsH0MXFwSjUwXsj9XLphn9iZ0mil
	r0Jck+ryZsScVRI+bpp74G3H6bVsZZeeB37s1Pz0W8nh589uvr0rDSdL6x+6+dDptkZTi0ht
	0RydCftvr1+2fOuBbQZvc/+u8KneJyHP9P+YarqTUGCb1avor6pv7mo97+zZbDvllbpq9kW/
	gG09wlGvK49MOmxziCklX4mlOCPRUIu5qDgRAIt1U80PAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: else is not generally useful after a break or return

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/lms501kf03.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c
index 77258b7b04be..7e3810308c3e 100644
--- a/drivers/video/backlight/lms501kf03.c
+++ b/drivers/video/backlight/lms501kf03.c
@@ -232,19 +232,19 @@ static int lms501kf03_power_on(struct lms501kf03 *lcd)
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
 		return -EINVAL;
-	} else {
-		pd->power_on(lcd->ld, 1);
-		msleep(pd->power_on_delay);
 	}
 
+	pd->power_on(lcd->ld, 1);
+	msleep(pd->power_on_delay);
+
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
 		return -EINVAL;
-	} else {
-		pd->reset(lcd->ld);
-		msleep(pd->reset_delay);
 	}
 
+	pd->reset(lcd->ld);
+	msleep(pd->reset_delay);
+
 	ret = lms501kf03_ldi_init(lcd);
 	if (ret) {
 		dev_err(lcd->dev, "failed to initialize ldi.\n");
-- 
2.0.0


