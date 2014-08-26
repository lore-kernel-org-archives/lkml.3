Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475AbaHZM7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:59:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32258 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbaHZM7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:59:36 -0400
X-AuditID: cbfee68d-f79c46d000000b84-3b-53fc84b5b2ec
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 08/18] backlight: ld9040: remove 'else' after a return
Date: Tue, 26 Aug 2014 21:59:33 +0900
Message-id: <00b201cfc12d$952babb0$bf830310$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAGIwA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zI92tLX+CDc5/tbA4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDLmXv7I
	VHCXrWLLumWsDYzHWLsYOTkkBEwkNj3ayg5hi0lcuLeerYuRi0NIYBmjxJvHk4AcDrCiwzP9
	IeLTGSW2z/3EBOH8ZpQ4+vcVG0g3m4CaxJcvh8EmiQgoSGzufQa2gVkgV+L3zJWMILaQgK3E
	/G0rwOKcAnYSSw+fYwdZICzgJnHvSBBImEVAVWLNjUksIDYvUPnySd+YIWxBiR+T77FAjNSS
	WL/zOBOELS+xec1bZog71SUe/dWFuMBIYk7LMagSEYl9L94xgpwsIXCKXWLjxj1sELsEJL5N
	PsQC0SsrsekAMyQcJCUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLUK07M
	LS7NS9dLzs/dxAiJyd4djLcPWB9iFOBgVOLhvRH/O1iINbGsuDL3EKMp0EUTmaVEk/OBkZ9X
	Em9obGZkYWpiamxkbmmmJM6rKPUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjlnVJBo21
	2WvKNhy6nHv4u+8J6bCjYrumunDtKONOXmX7TsD9xbyi4jD3D3/Smd3WtedUxpe13Xo35ePn
	tyvd1NyitxgtsjzQ+enhyxnbpP02vUx/GSSUKbHrZNXnypDJL94+qGnRUWJ1Ml8S8b1ryRyZ
	Nt1qC7cKx96aS9UiBS1LOMw5ShYpsRRnJBpqMRcVJwIAOUBn4cQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd2tLX+CDWYeN7U4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgz5l7+yFRwl61iy7plrA2Mx1i7GDk4JARMJA7P9O9i5AQyxSQu
	3FvP1sXIxSEkMJ1RYvvcT0wQzm9GiaN/X7GBVLEJqEl8+XKYHcQWEVCQ2Nz7jBXEZhbIlfg9
	cyUjiC0kYCsxf9sKsDingJ3E0sPn2EGWCQu4Sdw7EgQSZhFQlVhzYxILiM0LVL580jdmCFtQ
	4sfkeywQI7Uk1u88zgRhy0tsXvOWGeJmdYlHf3UhLjCSmNNyDKpERGLfi3eMExiFZiGZNAvJ
	pFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDEP5PewbiqweIQowAHoxIP
	743438FCrIllxZW5hxglOJiVRHh/JP0JFuJNSaysSi3Kjy8qzUktPsRoCvToRGYp0eR8YDLK
	K4k3NDYxM7I0MrMwMjE3VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAyCd9Y1NNAn8OJ/tc
	prLAfbf37l6gGThNP85ZyuC1ZjqnzIMH8eu0VX/L2R1i+sUkqB6SyT8vw/lJ9pP5Svwfr5pa
	3k2etCnuh47OqscTHrqu/CSwR/w9S5hd/QyN2cFPFzoumqQjmvzrl6eAa/BengJ/3555Tt19
	kZKTqv1aTPh0lJcZrWNTYinOSDTUYi4qTgQAcIWIcA4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: else is not generally useful after a break or return

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ld9040.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index ccb44e8e4927..f71eaf10c4eb 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -566,11 +566,11 @@ static int ld9040_power_on(struct ld9040 *lcd)
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
 	ret = ld9040_ldi_init(lcd);
 	if (ret) {
 		dev_err(lcd->dev, "failed to initialize ldi.\n");
-- 
2.0.0


