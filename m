Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab3B1InN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:43:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48351 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab3B1InI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:43:08 -0500
X-AuditID: cbfee68d-b7f636d0000009be-96-512f189b2880
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 11/19] rtc: rtc-at32ap700x: remove erroneous __init/__exit
 annotations
Date: Thu, 28 Feb 2013 17:43:07 +0900
Message-id: <00af01ce158f$a14bf760$e3e3e620$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAKTaA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zI93ZEvqBBmv/ylksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8X7rTNaCW9wV53bsY2pgfMHZxcjJISFgIvFx5zQWCFtM4sK99WxdjFwcQgLLGCV+
	H1zKBFN0d+YTFojEdEaJH8+7oZxfjBIXJ5xjA6liE1CT+PLlMHsXIweHiIC+RFuLBkgNs0Av
	o8SZ3t3sIDVCArYSx9rawNZxCthJ/H56lBXEFhaIkFh44CSYzSKgKrH563ewzbxA9ecW/2KD
	sAUlfky+B9bLLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSTz+9ZEVokREYt+Ld4wg
	90gIPGKX6JxzhBFil4DEt8mHWCB6ZSU2HWCGeFhS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEj
	yypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkFjt3cF4+4D1IcZkoPUTmaVEk/OBsZ5XEm9o
	bGxiZmJqYm5pam5KmrCSOK/cJZlAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYytHzIV5Hk+
	WXP2zHs4f9by5S6Vhg0/50xJkt7knH004saxcLnY2PmbBGNPZE/2CastV2hZsqxT82VXTyjz
	kVthP9/Ozumf57GvI201Z8mxanPx7V9PLju/TaWy6s6tS/zzpm1YNvnRrl3bW1eV/1L4c0nw
	TsyNXwHaDf7h/5b99LpueMzw2v4/SizFGYmGWsxFxYkAX4FCN+sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd3ZEvqBBn1zpCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHi/dSZrwS3uinM79jE1ML7g7GLk5JAQMJG4
	O/MJC4QtJnHh3nq2LkYuDiGB6YwSP553s0A4vxglLk44xwZSxSagJvHly2H2LkYODhEBfYm2
	Fg2QGmaBXkaJM7272UFqhARsJY61tYFN5RSwk/j99CgriC0sECGx8MBJMJtFQFVi89fvTCA2
	L1D9ucW/2CBsQYkfk++B9TILaEms33mcCcKWl9i85i0zyF4JAXWJR391QcIiAkYSj399ZIUo
	EZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGc
	CJ5J7WBc2WBxiFGAg1GJh7fDRC9QiDWxrLgy9xCjBAezkgivC79+oBBvSmJlVWpRfnxRaU5q
	8SHGZKBHJzJLiSbnA5NUXkm8obGJmZGlkZmFkYm5OWnCSuK8jKeeBAgJpCeWpGanphakFsFs
	YeLglGpgrNvEbbKITUxFKX5aRFj9HT/1t/4qVs+3zfu2e6LU4R+Zzr+77h9TOaUd9ug8+8rr
	7Q3WeWKt0g3GhjOCJ05esdIjbMnMuxVnDKY2xUyq/zj9zM2V2bLNSzPXz3y/daUu0+Lcph23
	N/v8Ndj5Ny7ZPuSUJbe12d2Z1/5z+q1tCr8c3NjzRmefnxJLcUaioRZzUXEiAAQ4YWRIAwAA
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
 drivers/rtc/rtc-at32ap700x.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index 8dd0830..1f2b262 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -195,7 +195,7 @@ static struct rtc_class_ops at32_rtc_ops = {
 	.alarm_irq_enable = at32_rtc_alarm_irq_enable,
 };
 
-static int __init at32_rtc_probe(struct platform_device *pdev)
+static int at32_rtc_probe(struct platform_device *pdev)
 {
 	struct resource	*regs;
 	struct rtc_at32ap700x *rtc;
@@ -277,7 +277,7 @@ out:
 	return ret;
 }
 
-static int __exit at32_rtc_remove(struct platform_device *pdev)
+static int at32_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_at32ap700x *rtc = platform_get_drvdata(pdev);
 
@@ -295,7 +295,7 @@ static int __exit at32_rtc_remove(struct platform_device *pdev)
 MODULE_ALIAS("platform:at32ap700x_rtc");
 
 static struct platform_driver at32_rtc_driver = {
-	.remove		= __exit_p(at32_rtc_remove),
+	.remove		= at32_rtc_remove,
 	.driver		= {
 		.name	= "at32ap700x_rtc",
 		.owner	= THIS_MODULE,
-- 
1.7.2.5


