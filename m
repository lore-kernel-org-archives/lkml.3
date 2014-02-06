Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaBFIcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:32:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:9572 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbaBFIcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:32:31 -0500
X-AuditID: cbfee690-b7f266d00000287c-cf-52f3489d5eda
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Matthias Kaehlcke'" <matthias.list@kaehlcke.net>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 12/12] backlight: tps65217_bl: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:32:29 +0900
Message-id: <000d01cf2315$f90a7050$eb1f50f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAAmfmg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zY915Hp+DDJazWsxZv4bN4vLCS6wW
	l3fNYbO48WsykwOLx4+5f9g9Tsz4zeLRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGZ0XLzMW
	NHFW/Du0maWB8QB7FyMnh4SAicTOWRdZIWwxiQv31rN1MXJxCAksY5Q4s/gsE0zR05cnWSES
	ixgl9l07wAjh/GKUmHukhQ2kik1ATeLLl8NAYzk4RAT0JdpaNEBMZoEKiSn7lUAqhARsJXaf
	Pgm2jFPATmLbp1aw+cICfhKHXv8Ds1kEVCUerJzHCGLzAtUvPjyJHcIWlPgx+R4LiM0soCWx
	fudxJghbXmLzmrfMIKskBNQlHv3VBQmLCBhJbDu6lw2iRERi34t3jBCvXGKX+DhVBWKVgMS3
	yYdYIFplJTYdYIYokZQ4uOIGywRGiVlIFs9CsngWksWzkGxYwMiyilE0tSC5oDgpvchErzgx
	t7g0L10vOT93EyMkHifsYLx3wPoQYzLQ+onMUqLJ+cB4ziuJNzQ2M7IwNTE1NjK3NCNNWEmc
	V+1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxnnlWlJ3FmsIbdnacHSbg/DZmZ6qDi1H
	07fttmJprZ0usHq/5ca6HvXXFSVbdjL5+SrcZ5596VzLdK7enS5XjimqXDYo3rB3fprTqttz
	Gt6Wuc+euq3h5T9LywtMWpkX578y2Zeb1JfyNrh1sZZTcS7z1hMfmq5NqPi/fvYS97zml4fU
	o75vX6HEUpyRaKjFXFScCABK461q3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd25Hp+DDHZssrSYs34Nm8XlhZdY
	LS7vmsNmcePXZCYHFo8fc/+we5yY8ZvFo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzOi9eZixo4qz4d2gzSwPjAfYuRk4OCQETiacvT7JC2GISF+6t
	Z+ti5OIQEljEKLHv2gFGCOcXo8TcIy1sIFVsAmoSX74cBurm4BAR0Jdoa9EAMZkFKiSm7FcC
	qRASsJXYfRpiJqeAncS2T61MILawgJ/Eodf/wGwWAVWJByvnMYLYvED1iw9PYoewBSV+TL7H
	AmIzC2hJrN95nAnClpfYvOYtM8gqCQF1iUd/dUHCIgJGEtuO7mWDKBGR2PfiHeMERqFZSCbN
	QjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHPHPpHcwrmqwOMQowMGo
	xMO7Yf2nICHWxLLiytxDjBIczEoivFvNPwcJ8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4w
	GeWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2PZs4UysUtv
	Tl2y0aAij11BvOut0q5zN9L6lL9FWbHKqv5ZMt2/1XjLQa1JXy/b7RJ2zJqXlJjJvUyY9zS7
	7KVft9ce9AvZxRHr3x4U/OXzw/3m3XveOYc8/GvHt0v46J+He1cISmdeDLnH9nn776a6uRk/
	p5aEzPXMXFgnkqyvJOmfuuYes58SS3FGoqEWc1FxIgCn7KUfPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tps65217_bl.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/video/backlight/tps65217_bl.c b/drivers/video/backlight/tps65217_bl.c
index cbba37e..595dcf5 100644
--- a/drivers/video/backlight/tps65217_bl.c
+++ b/drivers/video/backlight/tps65217_bl.c
@@ -200,7 +200,6 @@ tps65217_bl_parse_dt(struct platform_device *pdev)
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata) {
-		dev_err(&pdev->dev, "failed to allocate platform data\n");
 		err = ERR_PTR(-ENOMEM);
 		goto err;
 	}
@@ -296,10 +295,8 @@ static int tps65217_bl_probe(struct platform_device *pdev)
 
 	tps65217_bl = devm_kzalloc(&pdev->dev, sizeof(*tps65217_bl),
 				GFP_KERNEL);
-	if (tps65217_bl == NULL) {
-		dev_err(&pdev->dev, "allocation of struct tps65217_bl failed\n");
+	if (tps65217_bl == NULL)
 		return -ENOMEM;
-	}
 
 	tps65217_bl->tps = tps;
 	tps65217_bl->dev = &pdev->dev;
-- 
1.7.10.4


