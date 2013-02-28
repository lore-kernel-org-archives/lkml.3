Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3B1Kid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:38:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14723 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3B1Kib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:38:31 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-aa-512f33a2fb8f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901ce159f$94e48270$bead8750$%han@samsung.com>
In-reply-to: <000901ce159f$94e48270$bead8750$%han@samsung.com>
Subject: [PATCH 3/7] rtc: rtc-ds1302: add __exit annotation
Date: Thu, 28 Feb 2013 19:38:26 +0900
Message-id: <000b01ce159f$bd9253f0$38b6fbd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vn5THVyS/kU1xRpiO8bTmT1G2WgAABg4w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ91FxvqBBqd+6Vtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mvcv3shY0clTcOZLVwHiJrYuRk0NCwETiyvJGRghbTOLCvfVA
	cS4OIYFljBJNk08xwhT93v6OCSKxiFHiyo8b7BDObCaJw90TWUCq2ATUJL58OQyU4OAQEdCX
	aGvRAKlhFuhllDjTu5sdpEZIwFZiVXcrK4jNKWAnsWf+JDBbWMBa4sXWZWA2i4CqxL5XH5lB
	bF6g+mcNh9kgbEGJH5Pvge1iFtCS2LytiRXClpfYvOYtM8heCQF1iUd/dUHCIgJGEg+7zrND
	lIhI7HvxjhHkHgmBRewS9+7ehdolIPFt8iEWiF5ZiU0HmCEelpQ4uOIGywRGiVlINs9CsnkW
	ks2zkKxYwMiyilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMksvp3MN49YH2IMRlo/URmKdHk
	fGBk5pXEGxobm5iZmJqYW5qam5ImrCTOK39JJlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD
	o7i6q3XSp9qQAwv2KvdZWngm7TlsKqh1qT46IWXug5LczZ0cnpK7v4ZJT/+5b/Eyx4k2LTd2
	hFStSvt6+mtLOnfJ+dlLlhlfz1u3rpdZQC5cyvDpW8+LpZvjChc4Vqe8EapMNtYNe7ZRiK/Y
	m39F2S7Ri9+2l/6yu+Hhs2/BtsvPrcys5i0+qcRSnJFoqMVcVJwIAIpHyXPCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO4iY/1Ag3MftCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxt7le1kLGjkq7hzJamC8
	xNbFyMkhIWAi8Xv7OyYIW0ziwr31QHEuDiGBRYwSV37cYIdwZjNJHO6eyAJSxSagJvHly2Gg
	BAeHiIC+RFuLBkgNs0Avo8SZ3t3sIDVCArYSq7pbWUFsTgE7iT3zJ4HZwgLWEi+2LgOzWQRU
	Jfa9+sgMYvMC1T9rOMwGYQtK/Jh8D2wXs4CWxOZtTawQtrzE5jVvmUH2SgioSzz6qwsSFhEw
	knjYdZ4dokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66
	XnJ+7iZGcNw+k9rBuLLB4hCjAAejEg9vh4leoBBrYllxZe4hRgkOZiURXhd+/UAh3pTEyqrU
	ovz4otKc1OJDjMlAj05klhJNzgemlLySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhPLEnN
	Tk0tSC2C2cLEwSnVwHjCQ/tyU23JiQL+lvd7cqd9EIjemLhMqrDmwOu+1kMPNc+e50xR9//F
	sejiU5u0+NwQJr4lsqzBXnNbvY7VOAUcnpTa/ueEbZb+zy1zPYW8W6NixD7uNeub0pec/3/q
	cVPLq4vjtxSeMShLL9E5caNr8fTlm9cYiSv+O+m9TmO7zY7TJ3Li0pRYijMSDbWYi4oTATOR
	XGgfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_driver_probe() is used, bind/unbind via sysfs is
disabled. Thus, __init/__exit annotations can be added to
probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds1302.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
index fdbcdb2..d20b5f1 100644
--- a/drivers/rtc/rtc-ds1302.c
+++ b/drivers/rtc/rtc-ds1302.c
@@ -234,7 +234,7 @@ static int __init ds1302_rtc_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int ds1302_rtc_remove(struct platform_device *pdev)
+static int __exit ds1302_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
@@ -249,7 +249,7 @@ static struct platform_driver ds1302_platform_driver = {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
 	},
-	.remove		= ds1302_rtc_remove,
+	.remove		= __exit_p(ds1302_rtc_remove),
 };
 
 static int __init ds1302_rtc_init(void)
-- 
1.7.2.5


