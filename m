Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3EFEWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:22:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32235 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3EFEWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:22:02 -0400
X-AuditID: cbfee68f-b7f066d000003683-a0-51872fe9c7bb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 5/8] gpio-charger: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:22:00 +0900
Message-id: <003a01ce4a11$41508ae0$c3f1a0a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KETDnfpOFAkj1TBGtAnF0JGT/ZA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zQ92X+u2BBsd7RCwObtW0mLhyMrPF
	5YWXWC2WTJ7PanF51xw2B1aPCf2fGD02r9DyWPLmEKtH35ZVjB6fN8kFsEZx2aSk5mSWpRbp
	2yVwZTSsWcNUsIGtYsHcl0wNjCtYuxg5OSQETCRm/TrODGGLSVy4t54NxBYSWMYocfWIAEzN
	vz9f2bsYuYDiixglvs64wwzh/GKUmHz7PTtIFZuAmsSXL4fBbBEBDYm21VNYQIqYBSYzSuxv
	2AY2VljAR+Loze9gq1kEVCXOt08Cs3kFLCW2H3gEZQtK/Jh8jwXEZhbQkli/8zgThC0vsXnN
	W6hTFSR2nH3NCLFMT+LdjemMEDUiEvtevGMEWSwhsI9d4mvvdiaIZQIS3yYfAhrKAZSQldh0
	AGqOpMTBFTdYJjCKzUKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmb
	GCGR17+D8e4B60OMyUDrJzJLiSbnAyM3ryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS
	1OzU1ILUovii0pzU4kOMTBycUg2Mspvqz1fdvrjX7V+rjcabN8sttqxqZL91J83jzJZLZ8yD
	mHeKiR/c9W1lKLuu1UntvMZrCzg+qeb8vTP3zqrrCzaf5pZKnccRtPTvrxvHJkjtnbh6yw5f
	rdfNB08w58zW3drftiekt/RASZnjzKSrN2ekbPq0/e6PlKibZxbyLv2aNGFH2zrJ7JlKLMUZ
	iYZazEXFiQD2u0TV0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd2X+u2BBhvW8lkc3KppMXHlZGaL
	ywsvsVosmTyf1eLyrjlsDqweE/o/MXpsXqHlseTNIVaPvi2rGD0+b5ILYI1qYLTJSE1MSS1S
	SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
	0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8xoWLOGqWADW8WCuS+ZGhhXsHYxcnJICJhI/Pvz
	lR3CFpO4cG89WxcjF4eQwCJGia8z7jBDOL8YJSbffg9WxSagJvHly2EwW0RAQ6Jt9RQWkCJm
	gcmMEvsbtrGBJIQFfCSO3vwOtoJFQFXifPskMJtXwFJi+4FHULagxI/J91hAbGYBLYn1O48z
	QdjyEpvXvGWGOElBYsfZ14wQy/Qk3t2YzghRIyKx78U7xgmMArOQjJqFZNQsJKNmIWlZwMiy
	ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4sp9J72Bc1WBxiFGAg1GJh7fgSVugEGtiWXFl
	7iFGCQ5mJRFen71AId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HJp28knhDYxMzI0sjMwsj
	E3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamA0WxVwoiowNzT4iNUj7Rz9AzIJzzkb
	mo3M5774IWJ2yy1pZryIvuCZpa/Plh+MPCL045MEU2/TkZlGWg8eSNtVFXAemt1csEGD82eP
	9STRJ6o79Ke/tPFlXbe7pPA1z8kvXwXcTee9U/68/GbHEovWk4xz3GXsf9S+3O+y5PDMeTx3
	lOIyzixQYinOSDTUYi4qTgQAehpg5zADAAA=
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
 drivers/power/gpio-charger.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index e9883ee..4e858a2 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -155,8 +155,6 @@ static int gpio_charger_remove(struct platform_device *pdev)
 
 	gpio_free(gpio_charger->pdata->gpio);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


