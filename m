Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab3CNIIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:08:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41248 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3CNIIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:08:49 -0400
X-AuditID: cbfee690-b7f656d0000007e3-dd-5141858fe8d8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] rtc: rtc-ds1307: use dev_dbg() instead of pr_debug()
Date: Thu, 14 Mar 2013 17:08:47 +0900
Message-id: <008201ce208b$27435470$75c9fd50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4giyaoazxrxLGpTaGs2jjBBAJCGw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t8zQ93+VsdAgzsXVC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG11e8Bff4Kub8vcXcwLiXu4uRk0NCwERi96KVzBC2mMSFe+vZ
	uhi5OIQEljFKzDy1hBWmaPHanVCJRYwSi9bMZYZwZjNJTJmxHayKTUBN4suXw+xdjBwcIgL6
	Em0tGiA1zAK9jBJnenezg9QIC3hKnH5wB2wdi4CqxLEbnSwgNq+ArURP7xx2CFtQ4sfke2Bx
	ZgEtifU7jzNB2PISm9e8ZQaZLyGgLvHory5IWERAT2JZz0RGiBIRiX0v3jGC7JUQ6GaX6F52
	iAlil4DEt8mHWCB6ZSU2HYD6WFLi4IobLBMYxWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk
	9CITveLE3OLSvHS95PzcTYyQSJmwg/HeAetDjMlA6ycyS4km5wMjLa8k3tDYzMjC1MTU2Mjc
	0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjIEmEvrvonSuV3SlynAsEVjH
	ImRdxrsxhuNgce6f1McxryS/5eYmFHLxKTK6suTsNfERK36a/9TLeGlAxi39p44at9/sC64/
	lxa98I/C11MZhZ7dH49dmKKyfonCl7uG715X/dbjuan8ZV6129xdC1NPVnxV9KpmjONJS/gR
	dLF2yv6zGicSlFiKMxINtZiLihMB3rSTQaoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd3+VsdAgyV75C0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxtdXvAX3+Crm/L3F3MC4
	l7uLkZNDQsBEYvHanWwQtpjEhXvrgWwuDiGBRYwSi9bMZYZwZjNJTJmxnRWkik1ATeLLl8Ps
	XYwcHCIC+hJtLRogNcwCvYwSZ3p3s4PUCAt4Spx+cIcZxGYRUJU4dqOTBcTmFbCV6Omdww5h
	C0r8mHwPLM4soCWxfudxJghbXmLzmrfMIPMlBNQlHv3VBQmLCOhJLOuZyAhRIiKx78U7xgmM
	ArOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Dp9J7WBc2WBx
	iFGAg1GJh/dAv0OgEGtiWXFl7iFGCQ5mJRFeTy/HQCHelMTKqtSi/Pii0pzU4kOMyUCPTmSW
	Ek3OB6aIvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpglP6d
	aPzd+4zYmSUZwlOWqpZ1HH8vJj5NYerrtfsurRb5mBHN3/qk2FYj9EJpzdG5xWp17elRl4R9
	dHijMzKM/kxd/OTpDs+lHkFnLVcYtU+JzjzKEmxkNz1x7+t8DlZjvzw1Vr7ON43FDhUJAfWa
	ryS7RPZY1+Rdevr6/L/pbULeX305asOVWIozEg21mIuKEwGnlSQzBwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_dbg() is more preferred than pr_debug().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds1307.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index a65621c..b859d3c 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -713,7 +713,7 @@ static int ds1307_probe(struct i2c_client *client,
 		tmp = ds1307->read_block_data(ds1307->client,
 				DS1337_REG_CONTROL, 2, buf);
 		if (tmp != 2) {
-			pr_debug("read error %d\n", tmp);
+			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
 			goto exit_free;
 		}
@@ -752,7 +752,7 @@ static int ds1307_probe(struct i2c_client *client,
 		tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
 				RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
 		if (tmp != 2) {
-			pr_debug("read error %d\n", tmp);
+			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
 			goto exit_free;
 		}
@@ -796,7 +796,7 @@ static int ds1307_probe(struct i2c_client *client,
 			tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
 					RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
 			if (tmp != 2) {
-				pr_debug("read error %d\n", tmp);
+				dev_dbg(&client->dev, "read error %d\n", tmp);
 				err = -EIO;
 				goto exit_free;
 			}
@@ -824,7 +824,7 @@ read_rtc:
 	/* read RTC registers */
 	tmp = ds1307->read_block_data(ds1307->client, ds1307->offset, 8, buf);
 	if (tmp != 8) {
-		pr_debug("read error %d\n", tmp);
+		dev_dbg(&client->dev, "read error %d\n", tmp);
 		err = -EIO;
 		goto exit_free;
 	}
@@ -866,7 +866,7 @@ read_rtc:
 
 		tmp = i2c_smbus_read_byte_data(client, DS1340_REG_FLAG);
 		if (tmp < 0) {
-			pr_debug("read error %d\n", tmp);
+			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
 			goto exit_free;
 		}
-- 
1.7.2.5


