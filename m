Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3HACBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:01:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23240 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3HACBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:01:30 -0400
X-AuditID: cbfee68f-b7f436d000000f81-ad-51f9c177fae9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] mfd: max8997: cast void pointer to data of
 max8997_pmic_dt_match
Date: Thu, 01 Aug 2013 11:01:27 +0900
Message-id: <002e01ce8e5b$08700410$19500c30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6OWwTxUwbU93hcQvKatK1eMQoyfw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zQ93ygz8DDb6fN7S4vPASq8X9r0cZ
	LS7vmsNmcbtxBZvF6W5Wi2MzljA6sHncubaHzWPeyUCPvi2rGD0+b5ILYInisklJzcksSy3S
	t0vgyvh45Qt7wUK2itsndjA1ME5h7WLk5JAQMJHo/d/ADGGLSVy4t56ti5GLQ0hgGaPEqe13
	WWCK9jxpYoJILGKUeH+4nx3C+cUo0T11FRtIFZuAmsSXL4eBEhwcIgJ+Eg0r2EHCzAKzGSVW
	P1cGsYUFgiVunvwMVs4ioCrx8vF2sBpeAUuJ3sadLBC2oMSPyfdYIHq1JNbvPM4EYctLbF7z
	FupSBYkdZ18zgtgiAnoSJ5/vZIaoEZHY9+IdI8htEgL72CUeNy5ihlgmIPFt8iEWkNskBGQl
	Nh2AmiMpcXDFDZYJjGKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+
	7iZGSNz172C8e8D6EGMy0PqJzFKiyfnAuM0riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+O8bXs2LvZ6/ijCfrtc02aeM/EmLmzHP+sfqZp/bALv
	V3crB61up5VPPZKcNhu+VpjFOTtOc+VCl+eJlRNvFu9ZFJC2QYRBc6n5xOc/k/50p33pXp/1
	3WY263SZSwXrhQPU9vd8ErRd+cFuw4efX86dmWvO9fnyv9SL/2Z36hcIz9s+XX+padMZJZbi
	jERDLeai4kQAGFlrsNECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd3ygz8DDaZM0rO4vPASq8X9r0cZ
	LS7vmsNmcbtxBZvF6W5Wi2MzljA6sHncubaHzWPeyUCPvi2rGD0+b5ILYIlqYLTJSE1MSS1S
	SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
	0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8z4eOULe8FCtorbJ3YwNTBOYe1i5OSQEDCR2POk
	iQnCFpO4cG89WxcjF4eQwCJGifeH+9khnF+MEt1TV7GBVLEJqEl8+XIYKMHBISLgJ9Gwgh0k
	zCwwm1Fi9XNlEFtYIFji5snPYOUsAqoSLx9vB6vhFbCU6G3cyQJhC0r8mHyPBaJXS2L9zuNM
	ELa8xOY1b5khDlKQ2HH2NSOILSKgJ3Hy+U5miBoRiX0v3jFOYBSYhWTULCSjZiEZNQtJywJG
	llWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwVH9TGoH48oGi0OMAhyMSjy8GVt/BgqxJpYV
	V+YeYpTgYFYS4d2aDhTiTUmsrEotyo8vKs1JLT7EmAz06URmKdHkfGDCySuJNzQ2MTOyNDKz
	MDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRq3p6wu33bCbuFjXwfzmB4ugHwcn
	PzL5F3753rVg7TBG7f2ntZvvsZXuZ5q8907+MY6meZx3akSmLSs1U+Sc9rrj8YrP7M/UciYy
	xtR7i7sdldo0lfPX4YlbTWpiQ1tD1y65eP+ppQLzpMeavWYmN7L43Hv5xfQTg8RO9+7RzIp/
	c6YjyP6IlRJLcUaioRZzUXEiAMzvYx0uAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting (void *) data of max8997_pmic_dt_match is necessary,
because variable 'data' of struct 'of_device_id' is defined as
'const void *data'. Thus, pointer should be used instead of value.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/max8997.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 1471405..e6d668a 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -51,7 +51,7 @@ static struct mfd_cell max8997_devs[] = {
 
 #ifdef CONFIG_OF
 static struct of_device_id max8997_pmic_dt_match[] = {
-	{ .compatible = "maxim,max8997-pmic", .data = TYPE_MAX8997 },
+	{ .compatible = "maxim,max8997-pmic", .data = (void *)TYPE_MAX8997 },
 	{},
 };
 #endif
-- 
1.7.10.4


