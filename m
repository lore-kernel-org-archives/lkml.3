Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaBGIDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:03:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21030 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBGIDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:03:50 -0500
X-AuditID: cbfee690-b7f266d00000287c-d1-52f4936522c4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Mark Jackson'" <mpfj@newflow.co.uk>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
In-reply-to: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
Subject: [PATCH 03/10] rtc: rtc-ds1390: Remove unnecessary OOM messages
Date: Fri, 07 Feb 2014 17:03:49 +0900
Message-id: <000c01cf23db$2208b640$661a22c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2qAzLOfgRWJTRVWYElXe2alJBAAAF1pQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zA93UyV+CDLpeK1ksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF9u9sFvs7Oxgd2Dz2TDzJ5nFixm8Wjzsfp7N59G1Zxegxfd5PJo/Pm+QC
	2KK4bFJSczLLUov07RK4Mmb2z2IuWMlW0b3gHGMD41zWLkZODgkBE4lPpz6wQ9hiEhfurWfr
	YuTiEBJYxijxuPcSG0zRt77lTBCJRYwST/dtA+sQEvjFKHF+gTeIzSagJvHly2GgOAeHiIC+
	RFuLBkiYWWALo8SpFl6IcluJX5+XgC3mFLCTWHTiLJgtLOAuce7EHCYQm0VAVeLkt7MsIDYv
	UP3EGTfZIGxBiR+T77FAzNSSWL/zOBOELS+xec1bZpC1EgLqEo/+6kJcYCSxv8cMokJEYt+L
	d4wg10sIvGSX+PLxETvEKgGJb5MPsUC0ykpsOsAM8a2kxMEVN1gmMErMQrJ4FpLFs5AsnoVk
	xQJGllWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYIXE7YQfjvQPWhxiTgdZPZJYSTc4Hxn1e
	SbyhsZmRhamJqbGRuaUZacJK4rxqj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAa9Bv8
	c63/t1nBv0tnom5IV0HT/+pPYRuzw3auifriLMMh7DglveVoe/Cdy2a5vBKNqz0clu3gi1M8
	bM1T9cnAe8FNgddqmnzt1/s1T4Y7dPuePnRBz/7brDz2+52xaTs/z7EKz+nzN6h7/LNv+jKD
	7mDDDIesDY9sLmdfvld36O+NB7nRfkosxRmJhlrMRcWJAODVNVrxAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jAd3UyV+CDG62yVssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF9u9sFvs7Oxgd2Dz2TDzJ5nFixm8Wjzsfp7N59G1Zxegxfd5PJo/Pm+QC
	2KIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWbM7J/FXLCSraJ7wTnGBsa5
	rF2MnBwSAiYS3/qWM0HYYhIX7q1n62Lk4hASWMQo8XTfNnaQhJDAL0aJ8wu8QWw2ATWJL18O
	A8U5OEQE9CXaWjRAwswCWxglTrXwQpTbSvz6vARsPqeAncSiE2fBbGEBd4lzJ+aA7WIRUJU4
	+e0sC4jNC1Q/ccZNNghbUOLH5HssEDO1JNbvPM4EYctLbF7zlhlkrYSAusSjv7oQFxhJ7O8x
	g6gQkdj34h3jBEahWUgGzUIyaBaSQbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJ
	EZwUnknvYFzVYHGIUYCDUYmH98TSz0FCrIllxZW5hxglOJiVRHh/NnwJEuJNSaysSi3Kjy8q
	zUktPsSYDPTnRGYp0eR8YMLKK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFq
	EcwWJg5OqQbGBg2R+j3sF9uiTa+ZZJ57oXoKmBxyXm9QKZ6nmVb8cLJCuWTPX3EJbTfhLRu0
	zQIkZrnlz2mKLDkcLN419cIHra1r1Ltu3DU5sj/74G4HtdJV7yrDN+xesmFFatUrk44Gy9e7
	5jYsS7gY/rvJc5ni8wXnvncs/rb9sgm3k/ec/8tf7V5u9M1MiaU4I9FQi7moOBEA4wR2J04D	AAA=
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
 drivers/rtc/rtc-ds1390.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index be9d8c0..e67bfcb 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -132,10 +132,9 @@ static int ds1390_probe(struct spi_device *spi)
 	spi_setup(spi);
 
 	chip = devm_kzalloc(&spi->dev, sizeof(*chip), GFP_KERNEL);
-	if (!chip) {
-		dev_err(&spi->dev, "unable to allocate device memory\n");
+	if (!chip)
 		return -ENOMEM;
-	}
+
 	spi_set_drvdata(spi, chip);
 
 	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
-- 
1.7.10.4


