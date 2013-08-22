Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3HVCVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:21:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34524 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3HVCU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:20:59 -0400
X-AuditID: cbfee68e-b7f276d000002279-16-5215758a4990
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Evgeniy Polyakov'" <zbr@ioremap.net>,
        "'Martin Fuzzey'" <mfuzzey@parkeon.com>,
        "'Shawn Guo'" <shawn.guo@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] w1: mxc_w1: remove unnecessary platform_set_drvdata()
Date: Thu, 22 Aug 2013 11:20:58 +0900
Message-id: <002901ce9ede$3cfa5490$b6eefdb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6e3jzfXIYIGZR0TzKVCGWGAHjLfQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zQ92uUtEgg6ZGNYs569ewWVxeeInV
	4vKuOWwWL+deZ7d4um4Js8Wv1efYHNg8Hu/YzuRx59oeNo8TM36zeKy9O4vJo2/LKkaPz5vk
	AtiiuGxSUnMyy1KL9O0SuDJWHX/AXDCbtWLTrCesDYyLWboYOTkkBEwktr27yAZhi0lcuLce
	yObiEBJYxijR++gEUBEHWNHHZ8wQ8UWMEr93vIUq+sUoMW3iSXaQbjYBNYkvXw6zgzSICOhL
	tLVogISZBXYySvRdSwaxhQXcJDbtWccKYrMIqErce9YGdgSvgK3Exf7VjBC2oMSPyfdYIHq1
	JNbvPM4EYctLbF7zlhniHnWJR391ITbpSezcKglRISKx78U7RpDLJAQusUvMX7WaGWKVgMS3
	yYegXpGV2HSAGeJdSYmDK26wTGAUm4Vk8Swki2chWTwLyYoFjCyrGEVTC5ILipPSi4z0ihNz
	i0vz0vWS83M3MUIisW8H480D1ocYk4HWT2SWEk3OB0ZyXkm8obGZkYWpiamxkbmlGWnCSuK8
	ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYXY7Z5jRnlQnvPb9NQnem6bU/xtcryz8k
	CD40FE7xWOZcyG1cu4CJkz3ydUZ3vLYD67dkPfd1eQ92v1ku/fPjxT7Z/Nkd9R6OLy9kT7m8
	/e4PR6G5tgmvF1zg+MWYbB62y6ud6Un6jdfLX57fdfPntsVmezdtDQ1besHO51didkUQ615V
	s+rVSizFGYmGWsxFxYkApWWi0toCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd2uUtEgg66PihZz1q9hs7i88BKr
	xeVdc9gsXs69zm7xdN0SZotfq8+xObB5PN6xncnjzrU9bB4nZvxm8Vh7dxaTR9+WVYwenzfJ
	BbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWHX8AXPBbNaKTbOesDYw
	LmbpYuTgkBAwkfj4jLmLkRPIFJO4cG89WxcjF4eQwCJGid873kI5vxglpk08yQ5SxSagJvHl
	y2F2kGYRAX2JthYNkDCzwE5Gib5rySC2sICbxKY961hBbBYBVYl7z9pYQGxeAVuJi/2rGSFs
	QYkfk++xQPRqSazfeZwJwpaX2LzmLTPEbeoSj/7qQmzSk9i5VRKiQkRi34t3jBMYBWYhGTQL
	yaBZSAbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwnD+T2sG4ssHiEKMAB6MS
	D++FnSJBQqyJZcWVuYcYJTiYlUR4pbVEg4R4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5iC
	8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcULLZ5HHVfMj
	pV3vPA/SkhWWdMhbFy24JHnyrkPn38dXvuZ6MG/ekbq3T7/tdZo4L9/vxpc5X2ZcTn/htCV0
	9dbfwh82eV9eqLzlpj7DrIMZXrsjpv0pX2P/su+P6Sk+BqXlDhyq6accJq35V1L87vcdzkNy
	P1atmqe0ZCqbyb3vB+ZfVnFY//2VEktxRqKhFnNRcSIAvgSP1DcDAAA=
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
 drivers/w1/masters/mxc_w1.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 47e12cf..15c7251 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -152,8 +152,6 @@ static int mxc_w1_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(mdev->clk);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.10.4


