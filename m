Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab3GaI56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:57:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23806 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282Ab3GaI5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:57:50 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-49-51f8d18d8eec
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/3] backlight: lm3639: Don't mix different enum types
Date: Wed, 31 Jul 2013 17:57:48 +0900
Message-id: <002e01ce8dcc$0814f8c0$183eea40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6NzAGYWV0SL+quQom35h5T9xXT5A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zA93eiz8CDc48ZreYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDIOTT7G
	UrCRu2Lf5cAGxjOcXYycHBICJhIbZ7SwQNhiEhfurWfrYuTiEBJYxijR8X8VK0zRsRn72CES
	0xklLl5/xgrh/GKU+HhvEztIFZuAmsSXL4eBbA4OEQF9ibYWDZAws0CxxOyzTxhBbGEBN4nj
	+w+CDWURUJXoOXAFrJVXwFJiy+kHjBC2oMSPyfdYIHq1JNbvPM4EYctLbF7zlhniIAWJHWdf
	g9WLCOhJfD/ykxmiRkRi34t3jCC3SQhsY5fYvOINC8QyAYlvkw+xgNwmISArsekA1BxJiYMr
	brBMYBSbhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxQqJswg7G
	ewesDzEmA62fyCwlmpwPjNK8knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTCqXA72f1EQpHd7kvF/x7Yrm6pnX5QXZDcO+XjoaT//TSO/xMezN91p
	aBH8ZvBrvd4p/r66ecue1kzZmVOUn3F55VXXi3u8LHdoWsgczK/4kaq9NlFIibPn2pSzCT8X
	n93PGhCiNm/3/ewLT9Q3XPSfvPqcyMyJ6lEH95kemJgmUtz5gO3K9+p2JZbijERDLeai4kQA
	cSm/HMgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd3eiz8CDc72sVjMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZhyYfYynYyF2x73JgA+MZzi5GTg4JAROJYzP2sUPYYhIX7q1n
	62Lk4hASmM4ocfH6M1YI5xejxMd7m8Cq2ATUJL58OQxkc3CICOhLtLVogISZBYolZp99wghi
	Cwu4SRzff5AVxGYRUJXoOXAFrJVXwFJiy+kHjBC2oMSPyfdYIHq1JNbvPM4EYctLbF7zlhni
	IAWJHWdfg9WLCOhJfD/ykxmiRkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkZwDD+T2sG4ssHiEKMAB6MSD6/Dhe+BQqyJZcWVuYcYJTiYlUR4
	5YN+BArxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjC95JXEGxqbmBlZGplZGJmYm5MmrCTO
	e6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo/ANSx6Jnas2bzeTsP07cbcYf+/z309WlTCEzHx4
	6fqehVsOPYxs279bJkuUd/5srsATF4xMtveVPtOdMn0h44NTYQcSOkz3Syg9+Bq+6avpxr+v
	6u+Ksq84Yn/d8EHjD/X0sMeWx9rj3S4cvf61qoHtic4X8QerT921T2Pt7GZKkA7WDo53uaTE
	UpyRaKjFXFScCAA8rV/rJQMAAA==
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


