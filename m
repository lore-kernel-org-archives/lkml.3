Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3EFEV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:21:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49176 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3EFEV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:21:28 -0400
X-AuditID: cbfee691-b7fe56d000004b96-03-51872fbc96e4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/8] bq27x00_battery: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:21:16 +0900
Message-id: <003901ce4a11$2691c570$73b55050$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KEQuNUV1mvM3XThW/QM1RRI2NUw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zA909+u2BBi/bpSwObtW0mLhyMrPF
	5YWXWC2WTJ7PanF51xw2B1aPCf2fGD02r9DyWPLmEKtH35ZVjB6fN8kFsEZx2aSk5mSWpRbp
	2yVwZUw48p294A97xYzJvUwNjBfYuhg5OSQETCRW7/zFCGGLSVy4tx4sLiSwjFFiW58FTE3P
	zXmsXYxcQPFFjBJTd7SwQhT9YpTYeS0FxGYTUJP48uUwO4gtIqAh0bZ6CgtIA7PAZEaJ/Q3b
	wKYKC/hLbFy9EWwbi4CqxLub95lAbF4BS4krz5ewQtiCEj8m32MBsZkFtCTW7zzOBGHLS2xe
	85YZ4iIFiR1nXwPN4QBapiexbYIwRImIxL4X7xhB9koI7GOX2HxtL9QuAYlvkw+xgNRLCMhK
	bDoANUZS4uCKGywTGMVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT8
	3E2MkKibuIPx/gHrQ4zJQOsnMkuJJucDozavJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxsWssPs2/2PLpPwn6GU6ZA2VqOvcsVr51fNLNmbeNN
	yRvHpjXx/qp51PDDbu1ht1PHuuL+iuk9r5oTVMS/kXmOzps3xgbuF784Lphx1DIze7bMoxeZ
	D/V3z9DTS/QpPa+Ypv3l3f++5jPM9b5OV7vfrjiSy97Jr5lefeFoYNCWK0sXW0/2NT6mxFKc
	kWioxVxUnAgA4HcQPNACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd09+u2BBvuWiFkc3KppMXHlZGaL
	ywsvsVosmTyf1eLyrjlsDqweE/o/MXpsXqHlseTNIVaPvi2rGD0+b5ILYI1qYLTJSE1MSS1S
	SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
	0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8yYcOQ7e8Ef9ooZk3uZGhgvsHUxcnJICJhI9Nyc
	xwphi0lcuLceKM7FISSwiFFi6o4WsISQwC9GiZ3XUkBsNgE1iS9fDrOD2CICGhJtq6ewgDQw
	C0xmlNjfsA1sqrCAv8TG1RsZQWwWAVWJdzfvM4HYvAKWEleeL2GFsAUlfky+xwJiMwtoSazf
	eZwJwpaX2LzmLTPERQoSO86+BprDAbRMT2LbBGGIEhGJfS/eMU5gFJiFZNIsJJNmIZk0C0nL
	AkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBUf1MegfjqgaLQ4wCHIxKPLwFT9oChVgT
	y4orcw8xSnAwK4nw+uwFCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MOHklcQbGpuYGVka
	mVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVANj58W6s/m7TI5KTpBT/fZqdUaG
	glNbhJbnAVavXH7PouxVleZKt5UbD+YoZMxiT1JcVVNvfNKq51rZ5KscjIuSZs/mk/Zi4wsU
	OOPf9VWT+eeGdmn9yVNXCa25MYNDluuYvHNVfWOw+FJ+lg1sHP9PPWZOb2WZttCyMOOQa46y
	TX/bghbHaCWW4oxEQy3mouJEAMLcGLAuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/bq27x00_battery.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 26037ca..b309713 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -966,7 +966,6 @@ static int bq27000_battery_probe(struct platform_device *pdev)
 	return 0;
 
 err_free:
-	platform_set_drvdata(pdev, NULL);
 	kfree(di);
 
 	return ret;
@@ -978,7 +977,6 @@ static int bq27000_battery_remove(struct platform_device *pdev)
 
 	bq27x00_powersupply_unregister(di);
 
-	platform_set_drvdata(pdev, NULL);
 	kfree(di);
 
 	return 0;
-- 
1.7.2.5


