Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3B1Ipl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:45:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21886 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3B1Ipj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:45:39 -0500
X-AuditID: cbfee690-b7f6b6d000004563-81-512f19321fc7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 17/19] rtc: rtc-generic: remove erroneous __init/__exit
 annotations
Date: Thu, 28 Feb 2013 17:45:38 +0900
Message-id: <00b501ce158f$fb855910$f2900b30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAP8CQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zA10jSf1Ag65PuhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj75x57AVzuSt2tR9laWBcz9nFyMkhIWAice/ZQzYIW0ziwr31
	QDYXh5DAMkaJnc8vMsEUzZ+ykh0isYhR4vDObYwQzmwmid973zODVLEJqEl8+XIYqIqDQ0RA
	X6KtRQOkhlmgl1HiTO9udpAaIQFbiWNtbSwgNqeAncTvp0dZQWxhgVCJS9dfgNksAqoSTT/6
	GUFsXqD60xOOskPYghI/Jt8D62UW0JJYv/M4E4QtL7F5zVtmkL0SAuoSj/7qgoRFBIwkdk+e
	BVUiIrHvxTuwmyUElrFL9Hw9CrVLQOLb5EMsEL2yEpsOMEM8LClxcMUNlgmMErOQbJ6FZPMs
	JJtnIVmxgJFlFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZIbE3YwXjvgPUhxmSg9ROZpUST
	84GxmVcSb2hsbGJmYmpibmlqbkqasJI4r/wlmUAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jKY7DN0/dSzJnqOQw3duyuxlgk9VIvyPBPmK9MrYN1Z1zld4cGf9mthqr1/1zv5+3kyvJ+Ws
	2SPgtLjkyOPSYxKFT+TcZuov6A/9LZYis0JeyrM8bW2+24OZaxqnrJSZXfk4e7/lDcPNXRWh
	/Af3Cc18LvF5LTv3l1UTV95S+Phtj9yym9yrviqxFGckGmoxFxUnAgCCyIHhwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgK6RpH6gwaOpmhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4++ceewFc7krdrUfZWlg
	XM/ZxcjJISFgIjF/ykp2CFtM4sK99WxdjFwcQgKLGCUO79zGCOHMZpL4vfc9M0gVm4CaxJcv
	h4E6ODhEBPQl2lo0QGqYBXoZJc707gabJCRgK3GsrY0FxOYUsJP4/fQoK4gtLBAqcen6CzCb
	RUBVoulHPyOIzQtUf3rCUXYIW1Dix+R7YL3MAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCw
	iICRxO7Js6BKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgRH7jOpHYwrGywOMQpwMCrx8HaY6AUKsSaWFVfmHmKU4GBWEuF14dcPFOJNSays
	Si3Kjy8qzUktPsSYDPToRGYp0eR8YFLJK4k3NDYxM7I0MrMwMjE3J01YSZyX8dSTACGB9MSS
	1OzU1ILUIpgtTBycUg2MrJbCK94o39C9vVDIdKFWUPDB3gN/9DZof+Z+9uVar4f2fv+rzos/
	zbMsCGaZ+U321ey8tboaD4rYeXddSrHVl+8Wa9q04vHT6cYWC3NXK8n8YNj3d+3cGUty9ma+
	dLfRqBZYWXSn5++Ll0vXmsf6REXmiv3PP72ScVl55I7VO/Z/T2NTfLr6jRJLcUaioRZzUXEi
	APdcQEYgAwAA
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
 drivers/rtc/rtc-generic.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-generic.c b/drivers/rtc/rtc-generic.c
index 98322004..f7fd59a 100644
--- a/drivers/rtc/rtc-generic.c
+++ b/drivers/rtc/rtc-generic.c
@@ -34,7 +34,7 @@ static const struct rtc_class_ops generic_rtc_ops = {
 	.set_time = generic_set_time,
 };
 
-static int __init generic_rtc_probe(struct platform_device *dev)
+static int generic_rtc_probe(struct platform_device *dev)
 {
 	struct rtc_device *rtc;
 
@@ -48,7 +48,7 @@ static int __init generic_rtc_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __exit generic_rtc_remove(struct platform_device *dev)
+static int generic_rtc_remove(struct platform_device *dev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
@@ -62,7 +62,7 @@ static struct platform_driver generic_rtc_driver = {
 		.name = "rtc-generic",
 		.owner = THIS_MODULE,
 	},
-	.remove = __exit_p(generic_rtc_remove),
+	.remove = generic_rtc_remove,
 };
 
 static int __init generic_rtc_init(void)
-- 
1.7.2.5


