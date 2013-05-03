Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab3ECGkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:40:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23351 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab3ECGkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:40:02 -0400
X-AuditID: cbfee690-b7f136d000000fea-c7-51835bc158de
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, juhosg@openwrt.org
Subject: [PATCH 41/42] rtc: rtc-rp5c01: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:40:00 +0900
Message-id: <003701ce47c9$0941aa20$1bc4fe60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyQhuIb21znUtR7e/MRy8TLcZdA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zA92D0c2BBiuamC2WXLzKbjFn/Ro2
	i0tTLjFZXN41h81if2cHowOrx56JJ9k8Tsz4zeKxZXGGx/R5P5k8Pm+SC2CN4rJJSc3JLEst
	0rdL4Mo49+Ace8EOzopvX2ayNDDeYu9i5OSQEDCRaJmwhBnCFpO4cG89WxcjF4eQwDJGiSt9
	b1lhij4+usgOkVjEKHH192QmCOcXo8Ss059YQKrYBNQkvnw5DFTFwSEioC/R1qIBEmYWqJVY
	1f+SCcQWFgiW+Nl3lw3EZhFQlTjw8wxYnFfAUuLMpE/MELagxI/J91ggerUk1u88zgRhy0ts
	XvMW6lIFiR1nXzOC2CICehK/pj1nhagRkdj34h0jyG0SAofYJW4u6GGCWCYg8W3yIRaQ2yQE
	ZCU2HYCaIylxcMUNlgmMYrOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGJXnFibnFpXrpe
	cn7uJkZI5E3YwXjvgPUhxmSg9ROZpUST84GRm1cSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGxvBH6/cFrfpgY2BYbTlZlU31vLfiq36R+Rn9u69w
	ui+WiXzo6bHHde/SRyXqSvJ3Dsj2l4ib9s6unF93dPka6ZuVv5nSJ/xQ4GPNtNQN5jpR/Pai
	1NJv8UV2hz8cX3fZdgWDzLOknriEgjahVeE+tgEzjn98bnrs/nHzY09kXbKV1pgILI2pUmIp
	zkg01GIuKk4EADJnu1TSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd0D0c2BBhs221gsuXiV3WLO+jVs
	FpemXGKyuLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Vjy+IMj+nzfjJ5fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYce7BOfaCHZwV377MZGlgvMXexcjJISFgIvHx
	0UUoW0ziwr31bF2MXBxCAosYJa7+nswE4fxilJh1+hMLSBWbgJrEly+HgTo4OEQE9CXaWjRA
	wswCtRKr+l8ygdjCAsESP/vusoHYLAKqEgd+ngGL8wpYSpyZ9IkZwhaU+DH5HgtEr5bE+p3H
	mSBseYnNa94yQxykILHj7GtGEFtEQE/i17TnrBA1IhL7XrxjnMAoMAvJqFlIRs1CMmoWkpYF
	jCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLj+pn0DsZVDRaHGAU4GJV4eBVamgKFWBPL
	iitzDzFKcDArifC6/QAK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4w5eSVxBsam5gZWRqZ
	WRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2POY/kHnDkBAg4SUy+ZF+cWS/+r
	3/Vli1jJ5I5dK0rbtm9/ryO095lmRcjzUyXHSoMWSV9llTl4PTt/95OWmtNT1TM8Jje5H/av
	XfG/wiSb+Y1P+dmVFj3VrAWue/w2ck32nNwSdcmSyTSnptf5xaIvHIe2JCZEWr5/IfOh+WEA
	x5VZQkcmzVBiKc5INNRiLipOBADVeSFLLwMAAA==
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
 drivers/rtc/rtc-rp5c01.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
index 873c689..89d0736 100644
--- a/drivers/rtc/rtc-rp5c01.c
+++ b/drivers/rtc/rtc-rp5c01.c
@@ -251,21 +251,15 @@ static int __init rp5c01_rtc_probe(struct platform_device *dev)
 
 	rtc = devm_rtc_device_register(&dev->dev, "rtc-rp5c01", &rp5c01_rtc_ops,
 				  THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		error = PTR_ERR(rtc);
-		goto out;
-	}
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 	priv->rtc = rtc;
 
 	error = sysfs_create_bin_file(&dev->dev.kobj, &priv->nvram_attr);
 	if (error)
-		goto out;
+		return error;
 
 	return 0;
-
-out:
-	platform_set_drvdata(dev, NULL);
-	return error;
 }
 
 static int __exit rp5c01_rtc_remove(struct platform_device *dev)
-- 
1.7.2.5


