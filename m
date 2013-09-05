Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965102Ab3IECms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:42:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64803 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762619Ab3IECmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:42:47 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-7e-5227efa52f6a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
In-reply-to: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
Subject: [PATCH 4/6] backlight: lm3639: Don't mix different enum types
Date: Thu, 05 Sep 2013 11:42:45 +0900
Message-id: <002501cea9e1$99d40db0$cd7c2910$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p4TRpKe++09SiQwq9N1m2ivIIowAAFWrg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zQ92l79WDDFr+qljMWb+GzWLy7i5W
	i8sLLwGJXXPYLJb/WsdisXvXU1YHNo+ds+6ye5yY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA
	tigum5TUnMyy1CJ9uwSujEOTj7EUbOSu2Hc5sIHxDGcXIyeHhICJxKWbjewQtpjEhXvr2boY
	uTiEBJYxSrS/mMMMUzTn1G8miMQiRol/225DVf1ilFj49w8LSBWbgJrEly+HgUZxcIgI6Eu0
	tWiA1DALbGWU2PxxNytIjZCArcT5JbPZQGxOATuJTz/2MoLYwgJuErc3nQKLswioSrTNnw42
	kxeoft+7vUwQtqDEj8n3wOLMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxKopa5gh
	SkQk9r14xwhyj4TAW3aJ3+cnM0PsEpD4NvkQC0SvrMSmA1APS0ocXHGDZQKjxCwkm2ch2TwL
	yeZZSFYsYGRZxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iRESvRN2MN47YH2IMRlo/URmKdHk
	fGD055XEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	MX2W0oH3xyweJx6fIdxRHKt4Ouiyf7BO6jcn44knJmR773Tbd1g8MOOO28ewj7Nzz+hfNt2Q
	9VHI3lQv/0t63d2jPV0P3eQeO/wVfSWmMiP4ydEJR9dN8X4Q/2jtjPCMCX6hLmVbvU/U3t2s
	v1zyM0NpjujMBQdUasITvwtOmF36+8bBqXPVM5VYijMSDbWYi4oTAVKs82f0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAd2l79WDDJ5dUrCYs34Nm8Xk3V2s
	FpcXXgISu+awWSz/tY7FYveup6wObB47Z91l9zgx4zeLx575P1g9+rasYvQ4fmM7k8fnTXIB
	bFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QHco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDMOTT7GUrCRu2Lf5cAGxjOc
	XYycHBICJhJzTv1mgrDFJC7cW8/WxcjFISSwiFHi37bbUM4vRomFf/+wgFSxCahJfPlymL2L
	kYNDREBfoq1FA6SGWWAro8Tmj7tZQWqEBGwlzi+ZzQZicwrYSXz6sZcRxBYWcJO4vekUWJxF
	QFWibf50sJm8QPX73u1lgrAFJX5MvgcWZxbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUE
	jCRWTVnDDFEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQv
	XS85P3cTIzg1PJPawbiyweIQowAHoxIPb4OxepAQa2JZcWXuIUYJDmYlEV6LlUAh3pTEyqrU
	ovz4otKc1OJDjMlAj05klhJNzgemrbySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRm
	p6YWpBbBbGHi4JRqYCwMtmKdHDNJnWlacovAJh42hcNe4gvPMxiv0s99EViy90eJR6h+Qs+m
	Hx6PkvbNk/m2L0ex/uhaH4eYxbv3H8mprPttv/L5TJcJ+gfDco4zcNkKKP34KMh+lrF/gdYp
	2+k1q2y/Lr+wci+fi+qJ+xpNSi67NiR7Tj1vmMwTY7POYm/nnb1ThZVYijMSDbWYi4oTAde7
	IK9RAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't mix different enum types to fix the sparse warnings.

drivers/video/backlight/lm3639_bl.c:80:51: warning: mixing different enum types
drivers/video/backlight/lm3639_bl.c:80:51:     int enum lm3639_fleds  versus
drivers/video/backlight/lm3639_bl.c:80:51:     int enum lm3639_bleds
drivers/video/backlight/lm3639_bl.c:82:51: warning: mixing different enum types
drivers/video/backlight/lm3639_bl.c:82:51:     int enum lm3639_fleds  versus
drivers/video/backlight/lm3639_bl.c:82:51:     int enum lm3639_bleds

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lm3639_bl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
index 053964d..6c888e3 100644
--- a/drivers/video/backlight/lm3639_bl.c
+++ b/drivers/video/backlight/lm3639_bl.c
@@ -76,10 +76,13 @@ static int lm3639_chip_init(struct lm3639_chip_data *pchip)
 		goto out;
 
 	/* output pins config. */
-	if (!pdata->init_brt_led)
-		reg_val = pdata->fled_pins | pdata->bled_pins;
-	else
-		reg_val = pdata->fled_pins | pdata->bled_pins | 0x01;
+	if (!pdata->init_brt_led) {
+		reg_val = pdata->fled_pins;
+		reg_val |= pdata->bled_pins;
+	} else {
+		reg_val = pdata->fled_pins;
+		reg_val |= pdata->bled_pins | 0x01;
+	}
 
 	ret = regmap_update_bits(pchip->regmap, REG_ENABLE, 0x79, reg_val);
 	if (ret < 0)
-- 
1.7.10.4


