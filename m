Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935313Ab3BOF5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:57:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25458 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3BOF5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:57:11 -0500
X-AuditID: cbfee68f-b7f656d000000d78-57-511dce329ba9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/11] rtc: use pr_err()/pr_warn() instead of printk()
Date: Fri, 15 Feb 2013 14:57:06 +0900
Message-id: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4Afg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zI12jc7KBBlcfmlpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MWRemMhc0CFQs3XyHvYGxm7eLkZNDQsBEovn8REYIW0ziwr31
	bF2MXBxCAssYJf7Ov8/cxcgBVtT/oxIiPp1R4vvizywQzmwmiWUTHzGBdLMJqEl8+XKYHaRB
	REBfoq1FA6SGWaCXUeJM7252kBphATeJ75/fg9WzCKhKrHq+B2wzr4CtxLTjZ5khbEGJH5Pv
	sYDYzAJaEpu3NbFC2PISm9e8hTpIXeLRX12IVXpAYQeIChGJfS/eMYKslRBoZ5d4ffUrK8Qq
	AYlvkw+xQLTKSmw6wAzxr6TEwRU3WCYwis1CsngWksWzkCyehWTFAkaWVYyiqQXJBcVJ6UXG
	esWJucWleel6yfm5mxghcdK/g/HuAetDjMlA6ycyS4km5wPjLK8k3tDY2MTMxNTE3NLU3JQ0
	YSVxXvlLMoFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGJN/KclucpAQZhUqK4jLTGwX9n2h
	ou0u8T6g5WzLpqnZe+ZeihMIi2qZ56l18lt79eLqW9EvBRUT1a8wMi+/y5zj8XzWznMPj1z7
	LCmXtmDticssklwh58Mqoz0PJL1zPrgioqn9qchk28+7/K/P+6aTGaCcHcuxd9lDtf5dlj2z
	GA7WdS0tU2Ipzkg01GIuKk4EAINnmBypAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQV2jc7KBBjff6Ftc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjFkXpjIXNAhULN18h72B
	sZu3i5GDQ0LARKL/R2UXIyeQKSZx4d56ti5GLg4hgemMEt8Xf2aBcGYzSSyb+IgJpIpNQE3i
	y5fD7CDNIgL6Em0tGiA1zAK9jBJnenezg9QIC7hJfP/8HqyeRUBVYtXzPYwgNq+ArcS042eZ
	IWxBiR+T77GA2MwCWhKbtzWxQtjyEpvXvGWGOE5d4tFfXYhVekBhB4gKEYl9L94xTmAUmIVk
	0Cwkg2YhGTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFR+ExqB+PKBotDjAIc
	jEo8vAISsoFCrIllxZW5hxglOJiVRHjXhACFeFMSK6tSi/Lji0pzUosPMSYD/TmRWUo0OR+Y
	IPJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1OzW1ILUIZgsTB6dUA6Mvs4CN0eJT
	Lx59Es7++mA666cDZhtWK/THqd5+e0PKv3GxWcSlX4J+u3XuBgbcf/j38n6TLdc/HY7cnucq
	aby04sdFTt18ziSXS1K7U269W63gbcV/MJKxqnoPW3m+9vfVTTnln7eZTJfV/79kfVbixrcZ
	bUdKOebZnzI6Ydam8um9Uk9mh7USS3FGoqEWc1FxIgD/H9o8BgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/class.c   |    4 +++-
 drivers/rtc/rtc-dev.c |    7 ++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 26388f1..9b742d3 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -11,6 +11,8 @@
  * published by the Free Software Foundation.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/kdev_t.h>
@@ -261,7 +263,7 @@ static int __init rtc_init(void)
 {
 	rtc_class = class_create(THIS_MODULE, "rtc");
 	if (IS_ERR(rtc_class)) {
-		printk(KERN_ERR "%s: couldn't create class\n", __FILE__);
+		pr_err("couldn't create class\n");
 		return PTR_ERR(rtc_class);
 	}
 	rtc_class->suspend = rtc_suspend;
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 9a86b4b..471c30e 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -11,6 +11,8 @@
  * published by the Free Software Foundation.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/sched.h>
@@ -480,7 +482,7 @@ void rtc_dev_prepare(struct rtc_device *rtc)
 void rtc_dev_add_device(struct rtc_device *rtc)
 {
 	if (cdev_add(&rtc->char_dev, rtc->dev.devt, 1))
-		printk(KERN_WARNING "%s: failed to add char device %d:%d\n",
+		pr_warn("%s: failed to add char device %d:%d\n",
 			rtc->name, MAJOR(rtc_devt), rtc->id);
 	else
 		pr_debug("%s: dev (%d:%d)\n", rtc->name,
@@ -499,8 +501,7 @@ void __init rtc_dev_init(void)
 
 	err = alloc_chrdev_region(&rtc_devt, 0, RTC_DEV_MAX, "rtc");
 	if (err < 0)
-		printk(KERN_ERR "%s: failed to allocate char dev region\n",
-			__FILE__);
+		pr_err("failed to allocate char dev region\n");
 }
 
 void __exit rtc_dev_exit(void)
-- 
1.7.2.5


