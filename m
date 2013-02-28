Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab3B1Inf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:43:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48456 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3B1Ine (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:43:34 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-d3-512f18b4f2a5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 12/19] rtc: rtc-ab3100: remove erroneous __init/__exit
 annotations
Date: Thu, 28 Feb 2013 17:43:32 +0900
Message-id: <00b001ce158f$b09192c0$11b4b840$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAALNDw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA90tEvqBBusfW1ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8e3KFdaCxdwVV19/ZW9g3MTZxcjBISFgIjGhlaeLkRPIFJO4cG89WxcjF4eQwDJG
	iamXbjFCJEwkbl07zwKRmM4ocetnAzNIQkjgF6PExvnlIDabgJrEly+H2UGGigjoS7S1aIDU
	Mwv0Mkqc6d3NDlFvK3GsrY0FxOYUsJP4/fQoK4gtLBAi8f/bGbA4i4CqxIO/68AW8wLV75nT
	xAJhC0r8mHwPzGYW0JJYv/M4E4QtL7F5zVtmiGfUJR791QUJiwgYSby5swqqXERi34t3jCD3
	SAg8Ypd4ceA0G8QuAYlvkw+xQPTKSmw6wAzxr6TEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaW
	VYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxghcTpxB+P9A9aHGJOB1k9klhJNzgfGeV5JvKGx
	sYmZiamJuaWpuSlpwkrivPKXZAKFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MGZMbtDIOmvo
	LcVx0jRR1/xGWPxeA7ceb5VwsXiOfTLslg47mws5DwczXj/OsXbuxz4hjQMtbXpHUp57c2dv
	TTqY2TpnB+f6W9p1avmeRhMb8z2WrVjkH6MX/fX7AqkbV//ms78q9PdwTS92ql69b9cPQc3s
	yZyam0RP7flT0nSF697l8zaSSizFGYmGWsxFxYkAbXNv1OkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd0tEvqBBr8mm1ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPHtyhXWgsXcFVdff2VvYNzE2cXIySEhYCJx
	69p5FghbTOLCvfVsXYxcHEIC0xklbv1sYAZJCAn8YpTYOL8cxGYTUJP48uUwexcjB4eIgL5E
	W4sGSD2zQC+jxJne3ewQ9bYSx9rawIZyCthJ/H56lBXEFhYIkfj/7QxYnEVAVeLB33WMIDYv
	UP2eOU0sELagxI/J98BsZgEtifU7jzNB2PISm9e8ZQbZKyGgLvHory5IWETASOLNnVVQ5SIS
	+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC08Az
	6R2MqxosDjEKcDAq8fB2mOgFCrEmlhVX5h5ilOBgVhLhdeHXDxTiTUmsrEotyo8vKs1JLT7E
	mAz06ERmKdHkfGCKyiuJNzQ2MTOyNDKzMDIxNydNWEmcl/HUkwAhgfTEktTs1NSC1CKYLUwc
	nFINjPpiPXeU9zyaaJ95YjbT4zlCL87Nf7SxYZ9cWof7qgUb9Ka0lT6My5bsWbQx6saqCRlu
	T1O0nf1mfIp06/s868LKic3b/gVfP3Tg7aTCRfZPE9ffZ8te+erOj1cR8eUvhRRkn9RfXZB5
	5HASf8TsE8cW35ZvvMoZqVVwxnT6rm2nHB+pdn1+meuhxFKckWioxVxUnAgApEv0T0cDAAA=
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
 drivers/rtc/rtc-ab3100.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
index 261a07e..c02ce69 100644
--- a/drivers/rtc/rtc-ab3100.c
+++ b/drivers/rtc/rtc-ab3100.c
@@ -199,7 +199,7 @@ static const struct rtc_class_ops ab3100_rtc_ops = {
 	.alarm_irq_enable = ab3100_rtc_irq_enable,
 };
 
-static int __init ab3100_rtc_probe(struct platform_device *pdev)
+static int ab3100_rtc_probe(struct platform_device *pdev)
 {
 	int err;
 	u8 regval;
@@ -240,7 +240,7 @@ static int __init ab3100_rtc_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit ab3100_rtc_remove(struct platform_device *pdev)
+static int ab3100_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
@@ -254,7 +254,7 @@ static struct platform_driver ab3100_rtc_driver = {
 		.name = "ab3100-rtc",
 		.owner = THIS_MODULE,
 	},
-	.remove	 = __exit_p(ab3100_rtc_remove),
+	.remove	 = ab3100_rtc_remove,
 };
 
 static int __init ab3100_rtc_init(void)
-- 
1.7.2.5


