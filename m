Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaH0BL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:11:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23398 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaH0BLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:11:54 -0400
X-AuditID: cbfee68d-f79c46d000000b84-ab-53fd305931aa
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 08/18] backlight: ld9040: remove 'else' after a return
Date: Wed, 27 Aug 2014 10:11:52 +0900
Message-id: <004c01cfc193$e2f1bb80$a8d53280$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAG6lQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zQ91Ig7/BBhvXs1kc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmLJu9m
	L+hkr1i9ZAlbA+Nb1i5GTg4JAROJllX/WSBsMYkL99azdTFycQgJLGOU+HDrHBNM0bsfr1kg
	EtMZJWa9uc4O4fxmlJi24ilYFZuAmsSXL4fZQWwRAQWJzb3PwFYwC+RK/J65khHEFhKwlbi8
	cC1YPaeAncTsD9PB6oUFPCWerOtjBrFZBFQlnr/sA6vnBamfvYYNwhaU+DH5HgvETC2J9TuP
	M0HY8hKb17wF6uUAulRd4tFfXYgTjCR+dX6AKheR2PfiHSPIzRICx9glpj3ewQaxS0Di2+RD
	LBC9shKbDjBDPCwpcXDFDZYJQK8i2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJDveLE3OLS
	vHS95PzcTYyQuOzdwXj7gPUhRgEORiUe3g8L/gQLsSaWFVfmHmI0BbpoIrOUaHI+MPrzSuIN
	jc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgLJVY+cvdek/6
	0YwyPcHiCuaouk/m2zym6p5pS5o/LUjarkMnfo/MEjfJD45y015/2mck+O7AAqNPu+1D2hgs
	4oVT0uz2rli9e3XU5L/bD/xd1nJx19PYtQv3FH2sX3H0pnyE2UOnL4Yv17mviHtVsb5mce2s
	KpWORXJLQpS/TzC3iO1dnuj2XomlOCPRUIu5qDgRAPmUkrPGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQd1Ig7/BBo+/MFkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZiybvZi/oZK9YvWQJWwPjW9YuRk4OCQETiXc/XrNA2GISF+6t
	Z+ti5OIQEpjOKDHrzXV2COc3o8S0FU+ZQKrYBNQkvnw5zA5iiwgoSGzufQY2iVkgV+L3zJWM
	ILaQgK3E5YVrweo5BewkZn+YDlYvLOAp8WRdHzOIzSKgKvH8ZR9YPS9I/ew1bBC2oMSPyfdY
	IGZqSazfeZwJwpaX2LzmLVAvB9Cl6hKP/upCnGAk8avzA1S5iMS+F+8YJzAKzUIyaRaSSbOQ
	TJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCofya9g3FVg8UhRgEORiUe3g8L
	/gQLsSaWFVfmHmKU4GBWEuFNVvgbLMSbklhZlVqUH19UmpNafIjRFOjRicxSosn5wISUVxJv
	aGxiZmRpZGZhZGJuriTOe7DVOlBIID2xJDU7NbUgtQimj4mDU6qBMSl1I4No1FmbqN8pqo02
	0nX6cfcWP9eW8dOp5zZP8DngsqjGVDstK/BStZCBlnxArYO5od+yB5vT57RzfE490nV9e22G
	gd6VzpIkwyuO+h2yF+95ZH1v4xGV2BooIsYVv4GBQ71b06fRM+ZUi67X3Ut86YsLQ6e8/WCx
	8NvMCtu1ckk7tyqxFGckGmoxFxUnAgAWX/L/EAMAAA==
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


