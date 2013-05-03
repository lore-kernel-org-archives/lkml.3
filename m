Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762620Ab3ECGY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:24:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20413 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762203Ab3ECGY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:24:26 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-0e-5183581822e0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>,
        "'Srinidhi Kasagar'" <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 04/42] rtc: rtc-ab8500: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:24:24 +0900
Message-id: <001201ce47c6$daecece0$90c6c6a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HxqZS58H5kiN0TFKmJRcH+HN6yg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zA12JiOZAgx8HFS2WXLzKbjFn/Ro2
	i8sLL7FaTPmznMni8q45bBb7OzsYLW5taWJzYPfYM/Ekm8eda3vYPE7M+M3i0bdlFaPH96Vr
	2D2mz/vJ5PF5k1wAexSXTUpqTmZZapG+XQJXxpW77YwF89gq2h7MZ29gnMbaxcjJISFgIrHu
	w1x2CFtM4sK99WxdjFwcQgLLGCX+vVwLVzRz7XUmiMR0RokXl+6DJYQEfjFKzNleC2KzCahJ
	fPlyGGgSB4eIgL5EW4sGSD2zwHugkm/XwDYICwRLfL81F6yXRUBVYuHGM0wgNq+ApcT1F1MZ
	IWxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMcZCCxI6zr8HqRQT0JHY8WcQKUSMise/FO0aQ
	xRICj9gl3p3ZzwixTEDi2+RDLCDHSQjISmw6ADVHUuLgihssExjFZiFZPQvJ6llIVs9CsmIB
	I8sqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJAY7dvBePOA9SHGZKD1E5mlRJPzgTGeVxJv
	aGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGEsuoAwdv
	BqTP87i2KMqZu/hO188m/2sSaRKS9pWTX6k+ijwp4Lz39aZer7CglN+m/3IiZYtlzoswv7ky
	6clBnp5THjvcXxxKOx337+oj54CP3B3PVHK4HuulrX+gfsXb/mAVg23g3OoTR3ZyqE2Wm7jo
	e+zRglxJ27a6M9u6C26ya2ex7OtSYinOSDTUYi4qTgQAHsUJDucCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQV2JiOZAg3UXZS2WXLzKbjFn/Ro2
	i8sLL7FaTPmznMni8q45bBb7OzsYLW5taWJzYPfYM/Ekm8eda3vYPE7M+M3i0bdlFaPH96Vr
	2D2mz/vJ5PF5k1wAe1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6q
	rZKLT4CuW2YO0EVKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xowrd9sZ
	C+axVbQ9mM/ewDiNtYuRk0NCwERi5trrTBC2mMSFe+vZuhi5OIQEpjNKvLh0H6xISOAXo8Sc
	7bUgNpuAmsSXL4fZuxg5OEQE9CXaWjRA6pkF3gOVfLvGDlIjLBAs8f3WXLBeFgFViYUbz4At
	4BWwlLj+YiojhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5khDlKQ2HH2NVi9iICexI4ni1gh
	akQk9r14xziBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIE
	J4BnUjsYVzZYHGIU4GBU4uFVaGkKFGJNLCuuzD3EKMHBrCTC6/YDKMSbklhZlVqUH19UmpNa
	fIgxGejTicxSosn5wOSUVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgt
	TBycUg2Mkme+xyj+9skLbjy8aPKM5o2ft3QfKp/9ItgidPt5UdU/jl052r2RYjFeF2IrPry7
	s37x6/Bgn7RVkfL1ldc//HYXsf/SGesZtIJzqTiD2dmyu7eyNjumLvhazDPFlq3wv/6Ei9oV
	cbxLF7Z++LHm2ZpFd5Jm1HlNirB2fjCJR8p5+tucsEsKSizFGYmGWsxFxYkAqU0L4kQDAAA=
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
 drivers/rtc/rtc-ab8500.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index 63cfa31..c5b62d4 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -451,8 +451,6 @@ static int ab8500_rtc_remove(struct platform_device *pdev)
 {
 	ab8500_sysfs_rtc_unregister(&pdev->dev);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


