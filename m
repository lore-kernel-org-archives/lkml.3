Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3B1ImR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:42:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21227 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab3B1ImP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:42:15 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-d9-512f18661a23
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 09/19] rtc: rtc-pxa: remove erroneous __init/__exit annotations
Date: Thu, 28 Feb 2013 17:42:14 +0900
Message-id: <00ad01ce158f$81d994f0$858cbed0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAIN9A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zQ900Cf1Agzl/1Swu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG74u/jAXt3BUf/+Q1ME7k7GLk5JAQMJF4sPIgE4QtJnHh3no2
	EFtIYBmjxKrDLl2MHGA1lxbwdjFyAYUXMUp8P7ScFcKZzSTxqXEnWAObgJrEly+H2UEaRAT0
	JdpaNEBqmAV6GSXO9O5mhxhqK3GsrY0FxOYUsJP4/fQoK4gtLOAvsevUHRaQXhYBVYm+Zfog
	YV6g8gOX9zFC2IISPybfA2tlFtCSWL/zOBOELS+xec1bZog71SUe/dUFCYsIGEkcutjCClEi
	IrHvxTtGkHMkBJaxS1x80Al2MouAgMS3yYdYIHplJTYdYIYEg6TEwRU3WCYwSsxCsnkWks2z
	kGyehWTFAkaWVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxghMdW3g/HmAetDjMlA6ycyS4km
	5wNjMq8k3tDY2MTMxNTE3NLU3JQ0YSVxXvlLMoFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUa
	GBNWdBhOsH+6I+7/H40JaosTUv7wsep+No4uaN+iZvPLa9qzOJ1bUunp+gsM9/0QPh+x15ph
	zzHjG//eOEfqpp0I+aU1Qdjn/4QrWmmLJNm27r0Qdvi4FJNor8ClvI01j37uk/l1+DPDs+vm
	MUz93E+PczTkeRVOzFu6+PUG+WRnH56fvfftHymxFGckGmoxFxUnAgAovt9hvwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgG6ahH6gwavLChaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo/fFX8aCdu6Kj3/yGhgn
	cnYxcnBICJhIXFrA28XICWSKSVy4t56ti5GLQ0hgEaPE90PLWSGc2UwSnxp3soFUsQmoSXz5
	cpgdpFlEQF+irUUDpIZZoJdR4kzvbnaQGiEBW4ljbW0sIDangJ3E76dHWUFsYQF/iV2n7rCA
	9LIIqEr0LdMHCfMClR+4vI8RwhaU+DH5Hlgrs4CWxPqdx5kgbHmJzWveMkPcrC7x6K8uSFhE
	wEji0MUWVogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGMEx+0xqB+PKBotDjAIcjEo8vB0meoFCrIllxZW5hxglOJiVRHhd+PUDhXhTEiur
	Uovy44tKc1KLDzEmA/05kVlKNDkfmE7ySuINjU3MjCyNzCyMTMzNSRNWEudlPPUkQEggPbEk
	NTs1tSC1CGYLEwenVANjhBr/Fv7eWXOuizNmRB6Lf/HBv+HbgeSt73K++ev6nfnJFLpNqXfZ
	7qO7/lzP1XPv2659bsKnpWGTCn8mbXhj9LKav+NQkcBpzVuWC7uOWIfMff2UZ+06V28uKX3f
	Smc12WPpDUlLZ5S+OXXhY/lrDfPZZh3Tvs25U3BNn5lfes2Pzg+sZo0cSizFGYmGWsxFxYkA
	Hif30B0DAAA=
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
 drivers/rtc/rtc-pxa.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index 03c85ee..eb874d0 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -317,7 +317,7 @@ static const struct rtc_class_ops pxa_rtc_ops = {
 	.proc = pxa_rtc_proc,
 };
 
-static int __init pxa_rtc_probe(struct platform_device *pdev)
+static int pxa_rtc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct pxa_rtc *pxa_rtc;
@@ -390,7 +390,7 @@ err_map:
 	return ret;
 }
 
-static int __exit pxa_rtc_remove(struct platform_device *pdev)
+static int pxa_rtc_remove(struct platform_device *pdev)
 {
 	struct pxa_rtc *pxa_rtc = platform_get_drvdata(pdev);
 
@@ -442,7 +442,7 @@ static const struct dev_pm_ops pxa_rtc_pm_ops = {
 #endif
 
 static struct platform_driver pxa_rtc_driver = {
-	.remove		= __exit_p(pxa_rtc_remove),
+	.remove		= pxa_rtc_remove,
 	.driver		= {
 		.name	= "pxa-rtc",
 		.of_match_table = of_match_ptr(pxa_rtc_dt_ids),
-- 
1.7.2.5


