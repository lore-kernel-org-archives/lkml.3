Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3KYDZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 22:25:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30143 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab3KYDZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 22:25:13 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-9e-5292c318fbb1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] rtc: ds1305: remove unnecessary spi_set_drvdata()
Date: Mon, 25 Nov 2013 12:25:11 +0900
Message-id: <002501cee98d$f30c6760$d9253620$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7pjfLqgY9wk70cRx2PTgAYmzUG/w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zI12Jw5OCDO7sEbRYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY8tkuYK/LBXn9/axNzC2snQxcnJICJhIXH+7ihHCFpO4cG89WxcjF4eQwDJGictn
	dzLBFJ350MYEkZjOKHF03kdWCOcXkLOkDaydTUBN4suXw+xdjBwcIgL6Em0tGiA1zAK9jBJn
	enezg9QICzhJ9D6aCGazCKhK/H9yEWwDr4CtxNwF11ggbEGJH5PvgdnMAloS63ceZ4Kw5SU2
	r3nLDDJfQkBd4tFfXZCwiICexNOV/6DKRST2vXjHCLJXQuAQu8Tnb/PZIHYJSHybfIgFoldW
	YtMBZojHJCUOrrjBMoFRbBaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dL
	zs/dxAiJvN4djLcPWB9iTAZaP5FZSjQ5Hxi5eSXxhsZmRhamJqbGRuaWZqQJK4nzJj1MChIS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAyLBb5VvTJLUGU6HDm3Q6F281Phd7NEYxzb104lPr
	pzoZD761srg1XqiQXO1X84Hj34NLchdn7brx6ubfSJ20f3fUXC86NE78bNwTJV5juUw8edNt
	EW1utxUFNdpRwSYW/z8wNer7GzabOnI5VCqt2aByJq+xg8WTIW35K523xy4trv5zJs1EiaU4
	I9FQi7moOBEAAUD5h9ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQV2Jw5OCDC6d5rVYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPLZLmCvywV5/f2sTcwtrJ0MXJySAiYSJz5
	0MYEYYtJXLi3nq2LkYtDSGA6o8TReR9ZIZxfQM6SNkaQKjYBNYkvXw6zdzFycIgI6Eu0tWiA
	1DAL9DJKnOndzQ5SIyzgJNH7aCKYzSKgKvH/yUWwDbwCthJzF1xjgbAFJX5MvgdmMwtoSazf
	eZwJwpaX2LzmLTPIfAkBdYlHf3VBwiICehJPV/6DKheR2PfiHeMERoFZSCbNQjJpFpJJs5C0
	LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHNfPpHYwrmywOMQowMGoxMNrUTkpSIg1
	say4MvcQowQHs5II7546oBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnA1NOXkm8obGJmZGl
	kZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwWt61tVvVsCVdQEhVxk3yR6Wy
	vAT/+4NG3isZYwtqTlt0zOl+6PKj3fjIEcaF3RtUdnsVuIV7Syh0rE63sN2YY5wgbrmh71R3
	4ape3tJZL9eliDwKshUp3X9wkjErn9nCebzuqe0PLwXenpTlaCMox9TsVvXClH/ujXULhR/y
	lYeJ2FWYxSuxFGckGmoxFxUnAgCOxxkMLwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds1305.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index 80f3237..2dd586a 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -787,7 +787,6 @@ static int ds1305_remove(struct spi_device *spi)
 		cancel_work_sync(&ds1305->work);
 	}
 
-	spi_set_drvdata(spi, NULL);
 	return 0;
 }
 
-- 
1.7.10.4


