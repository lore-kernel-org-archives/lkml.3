Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3CFHxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:53:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46433 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab3CFHxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:53:06 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-fa-5136f5e0a8a8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 16/30] rtc: rtc-mv: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:53:04 +0900
Message-id: <008a01ce1a3f$a230ebe0$e692c3a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAMtHQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zfd0HX80CDVYvsLa4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZDQuesxU84azY9OIjWwPjL/YuRg4OCQETiavPeboYOYFMMYkL
	99azgdhCAssYJTZ+Z4eIm0gc/X+cqYuRCyi+iFHi3dLL7BDObCaJqwf3g3WwCahJfPlyGGyo
	iIC+RFuLBkgNs0Avo8SZ3t1gcSEBW4meeWDLOAXsJKZMfAy2QFjAVeLa86WsIDaLgKrEtZY2
	sJG8QOVzfk1nhrAFJX5MvscCYjMLaEms3wlyEIgtL7F5zVtmiF/UJR791QUJiwgYSWz6+p8V
	okREYt+Ld4wg50gILGOXODJ9OyPELgGJb5MPsUD0ykpsOsAM8a+kxMEVN1gmMErMQrJ5FpLN
	s5BsnoVkxQJGllWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIVHVt4Px5gHrQ4zJQOsnMkuJ
	JucDozKvJN7Q2NjEzMTUxNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	Ghi9Uv+557PemK1e/+Op7j/H1WxHlwouFPdeOlvmmnZd3m3JF5FLHkwScPBjL3YJDPvnMb9m
	g+t09z1vVqRdClfgXNV3JPRCQcWvedl7l9wocFJ02jxbzEP2YLPhHfvVRTlnNlr/4lhkN5Pn
	98Vvz0obMie3Jf5aFyj6UZ3zh1ur+fzHUY/0+YWVWIozEg21mIuKEwEGiI6ZwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO6Dr2aBBu3XzC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRsOC52wFTzgrNr34yNbA
	+Iu9i5GTQ0LAROLo/+NMELaYxIV769m6GLk4hAQWMUq8W3qZHcKZzSRx9eB+NpAqNgE1iS9f
	DgMlODhEBPQl2lo0QGqYBXoZJc707gaLCwnYSvTM4wEp5xSwk5gy8THYMmEBV4lrz5eygtgs
	AqoS11rawEbyApXP+TWdGcIWlPgx+R4LiM0soCWxfifEccwC8hKb17xlBhkvIaAu8eivLkhY
	RMBIYtPX/6wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL
	89L1kvNzNzGC4/aZ1A7GlQ0WhxgFOBiVeHgtlMwChVgTy4orcw8xSnAwK4nwcp0BCvGmJFZW
	pRblxxeV5qQWH2JMBnp0IrOUaHI+MKXklcQbGpuYGVkamVkYmZibkyasJM7LeOpJgJBAemJJ
	anZqakFqEcwWJg5OqQbGXtG7HTXNx5P6Hwr0my89YcCXVWN9cnngsqlT356+VeQ5qcNcMWF9
	X/lRx7IZQdzu2jeFbdbHsVu2vimwTctYrivpsTTA8764pGCGSZ9C3tTYXZeqrqXt2lx5NVuL
	farRO9Vpa+6ek4+e+9halGEPz6bXRf3afnZ9sUfE9mrp60wyeid9lleJpTgj0VCLuag4EQCF
	n0fWHwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-mv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index 59d1671..cb2b76a 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -262,12 +262,13 @@ static int __init mv_rtc_probe(struct platform_device *pdev)
 
 	if (pdata->irq >= 0) {
 		device_init_wakeup(&pdev->dev, 1);
-		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+		pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 						 &mv_rtc_alarm_ops,
 						 THIS_MODULE);
-	} else
-		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	} else {
+		pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 						 &mv_rtc_ops, THIS_MODULE);
+	}
 	if (IS_ERR(pdata->rtc))
 		return PTR_ERR(pdata->rtc);
 
@@ -291,7 +292,6 @@ static int __exit mv_rtc_remove(struct platform_device *pdev)
 	if (pdata->irq >= 0)
 		device_init_wakeup(&pdev->dev, 0);
 
-	rtc_device_unregister(pdata->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


