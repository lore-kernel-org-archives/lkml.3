Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3CKGel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:34:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19373 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3CKGej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:34:39 -0400
X-AuditID: cbfee68d-b7f786d000005188-20-513d7afb8184
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 09/14] power: max8903_charger: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:34:35 +0900
Message-id: <007901ce1e22$7f6ffc90$7e4ff5b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAAIJUw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zA93fVbaBBp/O61lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MV8/aWAuuclTMutPI2sDYy97FyMkhIWAiMeH3WVYIW0ziwr31
	bF2MXBxCAssYJVoPdjDDFK1/togdIrGIUWLiwd/MEM5sJome1t2MIFVsAmoSX74cBhsrIqAh
	0bZ6CguIzSyQL3H40GUwW0jAVmL3zxdg9ZwCdhI3ll1iA7GFBRwl/m17BbaNRUBV4ty9xWA1
	vED1H19+ZoawBSV+TL4HNVNLYvO2JlYIW15i85q3QDUcQJeqSzz6qwtxgpFEb/MkqBIRiX0v
	3jGC3CwhMI9d4tX1L2wQuwQkvk0+xALRKyux6QDUw5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIV
	CxhZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmKExFbvDsbbB6wPMSYDrZ/ILCWanA+MzbyS
	eENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MJqWeUx7
	9ETspPJbH4PK1epHjbc+OZDWcnvy5jVas9Zr1yTZN2ktuKpW1WlcwP7k/I7dcy4KT8p6lBC1
	NHNX6aap4VNbJHa1/J5RMj3oV2D18zWh+52F73L2u7FZ/fS2M+Asf6bVmxp8eFWRwd0nzQV+
	0hPm7Fr48O683xmh4U8mH3+dv+/NURclluKMREMt5qLiRADJYpNzwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO7vKttAg61TtCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqtnbawFVzkqZt1pZG1g
	7GXvYuTkkBAwkVj/bBGULSZx4d56ti5GLg4hgUWMEhMP/maGcGYzSfS07mYEqWITUJP48uUw
	WIeIgIZE2+opLCA2s0C+xOFDl8FsIQFbid0/X4DVcwrYSdxYdokNxBYWcJT4t+0VM4jNIqAq
	ce7eYrAaXqD6jy8/M0PYghI/Jt+DmqklsXlbEyuELS+xec1boBoOoEvVJR791YU4wUiit3kS
	VImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M
	4Mh9JrWDcWWDxSFGAQ5GJR7eCTq2gUKsiWXFlbmHGCU4mJVEeFdusgkU4k1JrKxKLcqPLyrN
	SS0+xJgM9OhEZinR5HxgUskriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoR
	zBYmDk6pBsZNIs/fHGbTiNoXW652Z7LL0R6voJbXQizPbEW22unoMSoUM/4TTqmMmS2Rbn28
	dtLvr8+5876+m784aLmvNPd0/ytLOh/pfMpL1Dky8dVWlchfO/ql9iUdWvPL0mPCTWWVM0JB
	adpZWo8M3a4+X6Hl9vB3ZMrFS35he2alhgSdyNw+MXPl/CAlluKMREMt5qLiRAAbbr82IAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/max8903_charger.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/power/max8903_charger.c b/drivers/power/max8903_charger.c
index 14e2b96..08f0d79 100644
--- a/drivers/power/max8903_charger.c
+++ b/drivers/power/max8903_charger.c
@@ -189,7 +189,7 @@ static int max8903_probe(struct platform_device *pdev)
 	int ta_in = 0;
 	int usb_in = 0;
 
-	data = kzalloc(sizeof(struct max8903_data), GFP_KERNEL);
+	data = devm_kzalloc(dev, sizeof(struct max8903_data), GFP_KERNEL);
 	if (data == NULL) {
 		dev_err(dev, "Cannot allocate memory.\n");
 		return -ENOMEM;
@@ -341,7 +341,6 @@ err_dc_irq:
 err_psy:
 	power_supply_unregister(&data->psy);
 err:
-	kfree(data);
 	return ret;
 }
 
@@ -359,7 +358,6 @@ static int max8903_remove(struct platform_device *pdev)
 		if (pdata->dc_valid)
 			free_irq(gpio_to_irq(pdata->dok), data);
 		power_supply_unregister(&data->psy);
-		kfree(data);
 	}
 
 	return 0;
-- 
1.7.2.5


