Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbaHZM6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:58:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52087 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591AbaHZM6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:58:17 -0400
X-AuditID: cbfee690-f79ce6d00000115a-46-53fc8467ac42
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 04/18] backlight: ams369fg06: remove 'else' after a return
Date: Tue, 26 Aug 2014 21:58:15 +0900
Message-id: <00ae01cfc12d$66967820$33c36860$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAADRUA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zI930lj/BBhNP6lkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBkv+k+w
	FPxlqzi7fzVbA+Mz1i5GTg4JAROJEy/62CFsMYkL99azdTFycQgJLGOU+LJ8EVzRhq1zoBKL
	GCXa7x5ngXB+M0qs/T+LBaSKTUBN4suXw2CjRAQUJDb3QqxgFsiV+D1zJSOILSRgKzF/2wqw
	OKeAncTSw+eA6jk4hAW8JG6/kQQJswioSvyb8oAJxOYFKr88ZzYjhC0o8WPyPRaIkVoS63ce
	Z4Kw5SU2r3nLDDJGQkBd4tFfXYgLjCT+LP3MCFEiIrHvxTtGiF9OsUus2ecCsUpA4tvkQywQ
	rbISmw4wQ5RIShxccYNlAqPELCSLZyFZPAvJ4llINixgZFnFKJpakFxQnJReZKJXnJhbXJqX
	rpecn7uJERKTE3Yw3jtgfYhRgINRiYf3RvzvYCHWxLLiytxDjKZAF01klhJNzgdGfl5JvKGx
	mZGFqYmpsZG5pZmSOO9rqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgnHtu5/4rViymz
	+rbbWdkb3slSmtrukeK8LqGLz2hZ852tx395LhPseZjudmZK/JpPH6+KtLZ7bUqKncN4pNcx
	/KKW8D+17mfc1y79/7MnftFr041F0pt9Ph7dntchoHaPz/5ZxYkJIu6y3EmCVzrW8+l1HH+2
	WW3XXc65C5x+FK+QOHzBZHGqEktxRqKhFnNRcSIAbcI3R8QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAd30lj/BBocWaFsc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZL/pPsBT8Zas4u381WwPjM9YuRk4OCQETiQ1b57BB2GISF+6t
	B7K5OIQEFjFKtN89zgLh/GaUWPt/FgtIFZuAmsSXL4fZQWwRAQWJzb0Qk5gFciV+z1zJCGIL
	CdhKzN+2AizOKWAnsfTwOaB6Dg5hAS+J228kQcIsAqoS/6Y8YAKxeYHKL8+ZzQhhC0r8mHyP
	BWKklsT6nceZIGx5ic1r3jKDjJEQUJd49FcX4gIjiT9LPzNClIhI7HvxjnECo9AsJJNmIZk0
	C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjvlnUjsYVzZYHGIU4GBU4uG9
	Ef87WIg1say4MvcQowQHs5II74+kP8FCvCmJlVWpRfnxRaU5qcWHGE2BHp3ILCWanA9MR3kl
	8YbGJmZGlkZmFkYm5uZK4rwHWq0DhQTSE0tSs1NTC1KLYPqYODilGhh3VHnd4vj1z/SdoPa+
	wANGJ9fUp3xkSGdoOnzv7Rm961FLN+vZhBstPreIkeleV5vof66i93/ezrgpv+iRtwfTVCYn
	p6Ro/cOaZnqrLt7v+3zhmEaL3Nb9s6sVTuaysBeIaiY9n3D64UYJ/zl9fz4VPfn7IO5j3wqW
	M3zb/91u2S57ZkJR+8QgJZbijERDLeai4kQAbXM++w8DAAA=
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
 drivers/video/backlight/ams369fg06.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 4726c8be626f..5f897f99cc9b 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -325,11 +325,11 @@ static int ams369fg06_power_on(struct ams369fg06 *lcd)
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
 	ret = ams369fg06_ldi_init(lcd);
 	if (ret) {
 		dev_err(lcd->dev, "failed to initialize ldi.\n");
-- 
2.0.0


