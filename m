Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbaH0BOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:14:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33790 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbaH0BOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:14:45 -0400
X-AuditID: cbfee68f-f797f6d000001173-cf-53fd31049d11
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 17/18] backlight: jornada720: remove 'else' after a return
Date: Wed, 27 Aug 2014 10:14:43 +0900
Message-id: <005501cfc194$48f833a0$dae89ae0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAANVtg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zfV0Ww7/BBmsWCVkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBldP5wK
	VrFXzN31ib2BsZ+ti5GTQ0LARGLdv05GCFtM4sK99UBxLg4hgWWMEus3bWGEKWprnMYCkVjE
	KNG8byIzhPObUaJ9xzawKjYBNYkvXw6zg9giAgoSm3ufsYLYzAK5Er9nrgSrERKwlbi8cC0T
	iM0pYCcx+8N0sHphAV+JOc8+MIPYLAKqElt+LQQ7jxeo/uLNk4wQtqDEj8n3WCBmakms33mc
	CcKWl9i85i1QLwfQpeoSj/7qQpxgJHF0/l42iBIRiX0v3jGC3CwhcIpdYn7PTzaIXQIS3yYf
	YoHolZXYdIAZ4mFJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KLjPWKE3OL
	S/PS9ZLzczcxQqKyfwfj3QPWhxgFOBiVeHg/LPgTLMSaWFZcmXuI0RTooonMUqLJ+cDYzyuJ
	NzQ2M7IwNTE1NjK3NFMS510o9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyPXMeuV3+V4
	67fO3r1r4t6rbGt3vZGRY53yK/dkuGvM4tXMF06LP55SU6yyfFJD7XTHgybm315Gmkb3axlf
	K38w4Wz0t3LBW/1tZm8bps67wnN9/v+Mwt7znOWvq9X1H5hd2fKc9fGipQU1WYusg86tz/cQ
	lGiYpL03mvPH2pg/05PtpcTiL0oosRRnJBpqMRcVJwIAQL88lcUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAV0Ww7/BBm+a+S2O7pzIZHF54SVW
	i/tfjzJaXN41h82BxWPnrLvsHneu7WHz6NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMrh9OBavYK+bu+sTewNjP1sXIySEhYCLR1jiNBcIWk7hwbz1Q
	nItDSGARo0TzvonMEM5vRon2HdsYQarYBNQkvnw5zA5iiwgoSGzufcYKYjML5Er8nrkSrEZI
	wFbi8sK1TCA2p4CdxOwP08HqhQV8JeY8+8AMYrMIqEps+bUQ7ApeoPqLN08yQtiCEj8m32OB
	mKklsX7ncSYIW15i85q3QL0cQJeqSzz6qwtxgpHE0fl72SBKRCT2vXjHOIFRaBaSSbOQTJqF
	ZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH/DOpHYwrGywOMQpwMCrx8H5c
	8CdYiDWxrLgy9xCjBAezkghvssLfYCHelMTKqtSi/Pii0pzU4kOMpkCPTmSWEk3OB6ajvJJ4
	Q2MTMyNLIzMLIxNzcyVx3gOt1oFCAumJJanZqakFqUUwfUwcnFINjNlfF/LeaLnU4dx6iX3V
	wefqDOaOZz/s9OaKaFq6wHtew3X1vJTPe47e/iZ5fjZbv2799XXxnLxtO3U/O2w3K9Tl5nFW
	f1h55/QyZcN1809FMW7aylm9btfuFdWHuS+HbJmy7U3Sdw3Gfw9e7mb9KW1ya47n1+DD2+72
	yHaevLC7O+x5aOELsxglluKMREMt5qLiRACthj/jDwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: else is not generally useful after a break or return

Suggested-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/jornada720_lcd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index 228bc319de19..dfa0fa0d5c78 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -27,11 +27,7 @@
 
 static int jornada_lcd_get_power(struct lcd_device *ld)
 {
-	/* LDD2 in PPC = LCD POWER */
-	if (PPSR & PPC_LDD2)
-		return FB_BLANK_UNBLANK;	/* PW ON */
-	else
-		return FB_BLANK_POWERDOWN;	/* PW OFF */
+	return PPSR & PPC_LDD2 ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;
 }
 
 static int jornada_lcd_get_contrast(struct lcd_device *ld)
-- 
2.0.0


