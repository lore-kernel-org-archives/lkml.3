Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaH0BOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:14:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33599 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbaH0BOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:14:08 -0400
X-AuditID: cbfee690-f79ce6d00000115a-64-53fd30df783b
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 15/18] backlight: wm831x_bl: add blank line after
 declarations
Date: Wed, 27 Aug 2014 10:14:06 +0900
Message-id: <005301cfc194$32ca6800$985f3800$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAL/vA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zY937Bn+DDfq+Mlsc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBkrOpML
	utgq/nVmNjDOYu1i5OSQEDCR6J91hBHCFpO4cG89WxcjF4eQwDJGibs7mxhhig7+XsYCkVjE
	KHG+cwsjhPObUeLin5nMIFVsAmoSX74cZgexRQQUJDb3PgNbwSyQK/F75kqwSUICthKXF65l
	ArE5BewkZn+YDlYvLBAs8WvVEzYQm0VAVaJpZScLiM0LVP+weQIbhC0o8WPyPRaImVoS63ce
	Z4Kw5SU2r3kLdAMH0KXqEo/+6kKcYCSxdP4HZogSEYl9L96B3SwhcIxd4tfWUywQuwQkvk0+
	xALRKyux6QAzxMOSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmegVJ+YW
	l+al6yXn525ihMTkhB2M9w5YH2IU4GBU4uH9sOBPsBBrYllxZe4hRlOgiyYyS4km5wMjP68k
	3tDYzMjC1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwLypMbYhny
	Lq6eZdRZxnIkYtvE82ICzWziOUteKGe/S0o6xTi16Oru+CJP1sBT96Vchc4dfDb5kd9v/a/b
	bqc7LXx7deZJqT9F6Qf5wiqzo98/nrrneMktQam1xsFzJ1nvDXpVq+RjveDjI++b/a9vBZus
	lb740/Vmf6XsCpWq2sT3Cw5EleQrsRRnJBpqMRcVJwIANG0fSsQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd37Bn+DDSZaWRzdOZHJ4vLCS6wW
	978eZbS4vGsOmwOLx85Zd9k97lzbw+bRt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCuVFMoSc0qBQgGJxcVK+naYJoSGuOla
	wDRG6PqGBMH1GBmggYR1jBkrOpMLutgq/nVmNjDOYu1i5OSQEDCROPh7GQuELSZx4d56ti5G
	Lg4hgUWMEuc7tzBCOL8ZJS7+mckMUsUmoCbx5cthdhBbREBBYnPvM7BJzAK5Er9nrmQEsYUE
	bCUuL1zLBGJzCthJzP4wHaxeWCBY4teqJ2wgNouAqkTTyk6wzbxA9Q+bJ7BB2IISPybfY4GY
	qSWxfudxJghbXmLzmrdAN3AAXaou8eivLsQJRhJL539ghigRkdj34h3jBEahWUgmzUIyaRaS
	SbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzvz6R2MK5ssDjEKMDBqMTD+3HB
	n2Ah1sSy4srcQ4wSHMxKIrzJCn+DhXhTEiurUovy44tKc1KLDzGaAj06kVlKNDkfmIrySuIN
	jU3MjCyNzCyMTMzNlcR5D7RaBwoJpCeWpGanphakFsH0MXFwSjUwttkKLdWRUPY1fN2iujbq
	lJDVfHvm58UO8d9k2X+LvgzyzJlmW5Obue2354ysrBtdHvtuMpazbju0Y+MD1auu4b2qPRq5
	Vss4lOS2xFvyfmq7adV4PThTda5ysG70A5XPLgsD+6e94FEwzrqnvoNnz5IHuwuVphX1qr5c
	m3k98gfzC7fY05pKLMUZiYZazEXFiQDB9muHDQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: Missing a blank line after declarations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/wm831x_bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 8b9455e93069..07ca98e2a5d4 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -111,6 +111,7 @@ static int wm831x_backlight_update_status(struct backlight_device *bl)
 static int wm831x_backlight_get_brightness(struct backlight_device *bl)
 {
 	struct wm831x_backlight_data *data = bl_get_data(bl);
+
 	return data->current_brightness;
 }
 
-- 
2.0.0


