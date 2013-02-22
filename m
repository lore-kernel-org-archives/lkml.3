Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3BVK1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:27:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38631 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab3BVK1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:27:14 -0500
X-AuditID: cbfee68f-b7f656d000000d78-80-51274800ce2a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: ams369fg06: make power_on() call optional
Date: Fri, 22 Feb 2013 19:27:12 +0900
Message-id: <002b01ce10e7$2d7364b0$885a2e10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Q5y1dDoEECFIES6StXVdKKgOFZA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t8zfV0GD/VAg1WXrCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG1BmHGAuOc1RMXXeFqYGxhb2LkZNDQsBE4vC3Z0wQtpjEhXvr
	2boYuTiEBJYxSrx+9pkNpuhZ834miMQiRokrvzvZIZzZTBKte9eAjWITUJP48uUwkM3BISKg
	L9HWogESZhYoldj64D0LiC0s4Crxaek0VhCbRUBVYuvB6ywg5bwCthJvfuSAhHkFBCV+TL7H
	AtGqJbF+53EmCFteYvOat8wg5RIC6hKP/upCLNKTWLxXFKJCRGLfi3eMIIdJCLSzS1ydvIUR
	YpOAxLfJh1ggWmUlNh1ghvhKUuLgihssExjFZiFZPAvJ4llIFs9CsmIBI8sqRtHUguSC4qT0
	ImO94sTc4tK8dL3k/NxNjJAo6d/BePeA9SHGZKD1E5mlRJPzgVGWVxJvaGxsYmZiamJuaWpu
	Spqwkjiv/CWZQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Me7KnXA9cMGNK8K3XqhVrIjeU
	GlRMeHq/j/2fqoX5hssGNy1cGpWDC2MWLOD4npioka4rEje/nnHB+umP68sVzXxfz7plH8gn
	wnk3PLijTs/J1NRz8tYuw7XHBI8rbSjk+yJ3X7rabXr3yd+7heKrLjw+bPgsx5ExsMXop+6z
	jQ94ouO3TapSYinOSDTUYi4qTgQADb7ptKgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jAV0GD/VAg9VtZhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+qMQ4wFxzkqpq67wtTA
	2MLexcjJISFgIvGseT8ThC0mceHeerYuRi4OIYFFjBJXfneyQzizmSRa964B62ATUJP48uUw
	kM3BISKgL9HWogESZhYoldj64D0LiC0s4Crxaek0VhCbRUBVYuvB6ywg5bwCthJvfuSAhHkF
	BCV+TL7HAtGqJbF+53EmCFteYvOat8wg5RIC6hKP/upCLNKTWLxXFKJCRGLfi3eMExgFZiEZ
	NAvJoFlIBs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAMPpPawbiyweIQowAH
	oxIPb4OLWqAQa2JZcWXuIUYJDmYlEV4DC/VAId6UxMqq1KL8+KLSnNTiQ4zJQG9OZJYSTc4H
	poe8knhDYxMzI0sjMwsjE3Nz0oSVxHkZTz0JEBJITyxJzU5NLUgtgtnCxMEp1cDIsMZPQn6z
	mAP/v2Yh7R9Ck5yvdUy2PyB4JMzvp1/SRIOJi3efM1n35X9PUMYLhTdSLGmX2bQuCd3bvr2N
	f956w5UCsdMMN116yJPlb5WtYSRpFXf9tY+mQX2nRcU3Yy6fmn3RXFNmXgioij5ax+Kr9erh
	q4vzo6zXB32w/H4x9LvqTtcnpYuUWIozEg21mIuKEwGVNCi/BQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes power_on() call optional. The voltage source can
be provided to some boards using ams369fg06 panel, thus in this
case, power on/off sequence is not necessary.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index d29e494..c02aa2c 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -317,10 +317,7 @@ static int ams369fg06_power_on(struct ams369fg06 *lcd)
 	pd = lcd->lcd_pd;
 	bd = lcd->bd;
 
-	if (!pd->power_on) {
-		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EINVAL;
-	} else {
+	if (pd->power_on) {
 		pd->power_on(lcd->ld, 1);
 		msleep(pd->power_on_delay);
 	}
@@ -370,7 +367,8 @@ static int ams369fg06_power_off(struct ams369fg06 *lcd)
 
 	msleep(pd->power_off_delay);
 
-	pd->power_on(lcd->ld, 0);
+	if (pd->power_on)
+		pd->power_on(lcd->ld, 0);
 
 	return 0;
 }
-- 
1.7.2.5


