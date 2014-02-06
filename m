Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaBFIRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:17:01 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28279 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaBFIQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:16:59 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-17-52f344fa8f9f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 02/12] backlight: adp8860: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:16:57 +0900
Message-id: <000301cf2313$cdaeced0$690c6c70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAAEjew
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zQ91fLp+DDHYc57KYs34Nm8XlhZdY
	LS7vmsNmMeHwZnYHFo9XVx09Tsz4zeLRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGSsmrGYr
	6GCv+Pp9LWMD41fWLkZODgkBE4nuCd+ZIWwxiQv31rN1MXJxCAksY5R4cmMqXNHm+dPBbCGB
	6YwSmx4EQhT9YpSY/uMcI0iCTUBN4suXw+xdjBwcIgL6Em0tGiBhZoEqiX1N85ghem0ldp8+
	CTaHU8BOYtunViYQW1jAS2JW20SwOIuAqsTFV2/ZQGxeoPorW/ezQNiCEj8m32OBmKklsX7n
	cSYIW15i85q3zCBrJQTUJR791QUJiwgYSWxbM50NokREYt+Ld4wQr5xjl1jwzBxilYDEt8mH
	WCBaZSU2HYAGg6TEwRU3WCYwSsxCsngWksWzkCyehWTDAkaWVYyiqQXJBcVJ6UWmesWJucWl
	eel6yfm5mxgh8ThxB+P9A9aHGJOB1k9klhJNzgfGc15JvKGxmZGFqYmpsZG5pRlpwkrivOmP
	koKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MO6cUrXdIjxrUum2By1O4Vtvl4YUMF+6YPON
	x/dqUMuiKVf3fi0X6TtTuy3uqy13fOPjpK99qpI+Upc23F0/J/3oxtuJCRo2HQrMnN1sxr9y
	b0lk9W1fHLOW2VjRrI5J8aj81ax3SVH7JqqocdxYfWejhA7/JXe/x+GX3dbtzXu8rlVIk0P9
	uRJLcUaioRZzUXEiAD5MHVPdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd1fLp+DDLa/ZbOYs34Nm8XlhZdY
	LS7vmsNmMeHwZnYHFo9XVx09Tsz4zeLRt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCuVFMoSc0qBQgGJxcVK+naYJoSGuOla
	wDRG6PqGBMH1GBmggYR1jBkrJqxmK+hgr/j6fS1jA+NX1i5GTg4JAROJzfOnQ9liEhfurWcD
	sYUEpjNKbHoQ2MXIBWT/YpSY/uMcI0iCTUBN4suXw+xdjBwcIgL6Em0tGiBhZoEqiX1N85gh
	em0ldp8+CTaTU8BOYtunViYQW1jAS2JW20SwOIuAqsTFV2/BdvEC1V/Zup8FwhaU+DH5HgvE
	TC2J9TuPM0HY8hKb17xlBlkrIaAu8eivLkhYRMBIYtua6WwQJSIS+168Y5zAKDQLyaRZSCbN
	QjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC4/2Z1A7GlQ0WhxgFOBiVeHg3
	rP8UJMSaWFZcmXuIUYKDWUmEd6v55yAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgemoryS
	eENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYLTXvRK15VXVNDm3
	4qwFSmfKtjGf/PZswxvXXMnc3cc2vtaNUC48fbtJV3df8Z2JXWLf38U7zLVO3DK5btWhqREf
	L++//vvfn/DKfL8vM3xs1Xe9FmPWf2zx01h1D1/wrMXHLsxbUi3n++szW98fteBEofZjgocu
	ZJxlvuzaLVdbIHBS8+EJdT8lluKMREMt5qLiRAAPCADkOwMAAA==
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
 drivers/video/backlight/adp8860_bl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 9d65671..be8d83d 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -224,10 +224,8 @@ static int adp8860_led_probe(struct i2c_client *client)
 
 	led = devm_kzalloc(&client->dev, sizeof(*led) * pdata->num_leds,
 				GFP_KERNEL);
-	if (led == NULL) {
-		dev_err(&client->dev, "failed to alloc memory\n");
+	if (led == NULL)
 		return -ENOMEM;
-	}
 
 	ret = adp8860_write(client, ADP8860_ISCFR, pdata->led_fade_law);
 	ret = adp8860_write(client, ADP8860_ISCT1,
-- 
1.7.10.4


