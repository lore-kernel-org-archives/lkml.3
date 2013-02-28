Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3B1Ili (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:41:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36506 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab3B1Ilg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:41:36 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-fd-512f183405d4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 07/19] rtc: rtc-ps3: remove erroneous __init/__exit annotations
Date: Thu, 28 Feb 2013 17:41:24 +0900
Message-id: <00ab01ce158f$6434eda0$2c9ec8e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAGkcg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zQ10TCf1Ag/n3TS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGjFmvGAsecFX03FrN2sD4haOLkZNDQsBEYtvZb6wQtpjEhXvr
	2boYuTiEBJYxSiw6f48NpmjX4hksEIlFjBK93X+hqmYzSVzc/QOsnU1ATeLLl8PsXYwcHCIC
	+hJtLRogNcwCvYwSZ3p3s4PUCAnYShxra2MBsTkF7CR+Pz0K1iss4C/xaeVKJhCbRUBVYtH2
	62A2L1D92qkf2SBsQYkfk++B9TILaEms33mcCcKWl9i85i0zyF4JAXWJR391QcIiAkYSV1v3
	QJWISOx78Y4R5B4JgWXsElfvbYfaJSDxbfIhFoheWYlNB5ghHpaUOLjiBssERolZSDbPQrJ5
	FpLNs5CsWMDIsopRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJLYm7mC8f8D6EGMy0PqJzFKi
	yfnA2MwriTc0NjYxMzE1Mbc0NTclTVhJnFf+kkygkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BkbGt45rjyx8zHyHO82NTSRGWuagT6le+4lr8ZNqhDjr2MMmPHT8w9+x7tqr5Qpr3PV2uaf9
	tPdvEOtwLp1z+kLf841NN4r6Yy1Ylm8N6OEOMNAPSijdUy3k/OCr17EbWuKbzQ5LvrXmSuBx
	s/+b/bnbt3lrVPUaa16WoLebTU7NfbDxw431h5VYijMSDbWYi4oTATyKe3PDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgK6JhH6gQf81Q4vLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMWPWK8aCB1wVPbdWszYw
	fuHoYuTkkBAwkdi1eAYLhC0mceHeerYuRi4OIYFFjBK93X+hnNlMEhd3/2AFqWITUJP48uUw
	excjB4eIgL5EW4sGSA2zQC+jxJne3ewgNUICthLH2trApnIK2En8fnoUrFdYwF/i08qVTCA2
	i4CqxKLt18FsXqD6tVM/skHYghI/Jt8D62UW0JJYv/M4E4QtL7F5zVtmkL0SAuoSj/7qgoRF
	BIwkrrbugSoRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJERy5z6R2MK5ssDjEKMDBqMTD22GiFyjEmlhWXJl7iFGCg1lJhNeFXz9QiDclsbIq
	tSg/vqg0J7X4EGMy0KMTmaVEk/OBSSWvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATSE0tS
	s1NTC1KLYLYwcXBKNTBu2Kqz+7CXc8HRH6bzNlTYmL2N0H59xfmsZrS2dVJKy6ezHRr5G6M+
	nT07T27y1IJvsiK/T02bYzW7kLn7vdV+9aI/k1Nbs7f5LhHkt/qVnW3zzLJw+1rlK51LHl5x
	cmJSmNEvJL31rXWph72uSv6/HcwOnjPinjQWNCSt6p068ZyXwvI2o2dKLMUZiYZazEXFiQDs
	ll5aIAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__init/__exit annotations for probe()/remove() are supposed to be
__devinit/__devexit, because __init/__exit for probe()/remove()
are not correct. However, __devinit/__devexit are not used,
because CONFIG_HOTPLUG was removed. Thus, these annotations
should be removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ps3.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ps3.c b/drivers/rtc/rtc-ps3.c
index 968133c..8a24d11 100644
--- a/drivers/rtc/rtc-ps3.c
+++ b/drivers/rtc/rtc-ps3.c
@@ -58,7 +58,7 @@ static const struct rtc_class_ops ps3_rtc_ops = {
 	.set_time = ps3_set_time,
 };
 
-static int __init ps3_rtc_probe(struct platform_device *dev)
+static int ps3_rtc_probe(struct platform_device *dev)
 {
 	struct rtc_device *rtc;
 
@@ -71,7 +71,7 @@ static int __init ps3_rtc_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __exit ps3_rtc_remove(struct platform_device *dev)
+static int ps3_rtc_remove(struct platform_device *dev)
 {
 	rtc_device_unregister(platform_get_drvdata(dev));
 	return 0;
@@ -82,7 +82,7 @@ static struct platform_driver ps3_rtc_driver = {
 		.name = "rtc-ps3",
 		.owner = THIS_MODULE,
 	},
-	.remove = __exit_p(ps3_rtc_remove),
+	.remove = ps3_rtc_remove,
 };
 
 static int __init ps3_rtc_init(void)
-- 
1.7.2.5


