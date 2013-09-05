Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3IEETT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:19:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49631 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3IEETS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:19:18 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-9d-52280645ca86
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000701cea9ee$609bfff0$21d3ffd0$%han@samsung.com>
In-reply-to: <000701cea9ee$609bfff0$21d3ffd0$%han@samsung.com>
Subject: [PATCH V2 4/6] backlight: lm3639: Don't mix different enum types
Date: Thu, 05 Sep 2013 13:19:16 +0900
Message-id: <001101cea9ef$15ee74f0$41cb5ed0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p7mBpdyq9ywYnR82rhDmFCL2hBAAAJK7g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zI11XNo0ggxs3hC3mrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	WxSXTUpqTmZZapG+XQJXxqHJx1gKNnJX7Lsc2MB4hrOLkZNDQsBEYumd7UwQtpjEhXvr2boY
	uTiEBJYxSiy5sJMdpujV5UOsEInpjBLnDi1kgXB+MUrc/7GHBaSKTUBN4suXw0AdHBwiAvoS
	bS0aIDXMAlsZJTZ/3M0KEhcSsJV4vJEXpJxTwE5i6fM7YJuFBTwlpl/4xgZiswioStx7v4cN
	pJwXqLz5bDxImFdAUOLH5Htgm5gFtCTW7zzOBGHLS2xe85YZpFxCQF3i0V9diAOMJFr/60JU
	iEjse/GOEeQYCYG37BInZxxih9gkIPFt8iEWiFZZiU0HmCG+lZQ4uOIGywRGiVlIFs9CsngW
	ksWzkKxYwMiyilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMkbifuYLx/wPoQYzLQ+onMUqLJ
	+cC4zyuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD
	44EFD7Se7V2kedYiyFX+XKTxtca97z78nvd+h6CRw475E4zuc67hlLUSDHsZUNOgwxnWbmf/
	esmvYyJn9R6ILTy32PJUieBeK8msGA4B8XBxgT53h7dR+gK/XM/u8phXbjPxxDuW8yssFy2S
	+HvC0+SC0N72eUE9N3UmKJ1Z0v5ZQPVV5AW9G0osxRmJhlrMRcWJAFIng/rxAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQV1XNo0gg3n7+S3mrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	W1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0B1K
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoxDk4+xFGzkrth3ObCB8Qxn
	FyMnh4SAicSry4dYIWwxiQv31rN1MXJxCAlMZ5Q4d2ghC4Tzi1Hi/o89LCBVbAJqEl++HGbv
	YuTgEBHQl2hr0QCpYRbYyiix+eNuVpC4kICtxOONvCDlnAJ2Ekuf32ECsYUFPCWmX/jGBmKz
	CKhK3Hu/hw2knBeovPlsPEiYV0BQ4sfke2CbmAW0JNbvPM4EYctLbF7zlhmkXEJAXeLRX12I
	A4wkWv/rQlSISOx78Y5xAqPQLCSDZiEZNAvJoFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L
	10vOz93ECE4Kz6R2MK5ssDjEKMDBqMTD22CsHiTEmlhWXJl7iFGCg1lJhNdiJVCINyWxsiq1
	KD++qDQntfgQYzLQmxOZpUST84EJK68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZ
	qakFqUUwW5g4OKUaGHV9L9t2T7sfI21y7RxXxqmet3dO7VlSIvXrwI3+Xbd4D35d8q49ZPV8
	kcLS2QsOStsc38eTwxb5uzSivtXSp/awCy//2dVsVqwX3eq1fBS4r74vMH/Jc/m2pIWoWsKn
	2qOBO7vOvpp1nj9LeenrROWZnj3PPD2iWb72eMSU3HDb9FohbEephhJLcUaioRZzUXEiAN4W
	X6xOAwAA
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


