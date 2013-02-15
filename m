Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965341Ab3BOGnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:43:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33437 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931Ab3BOGnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:43:17 -0500
X-AuditID: cbfee690-b7f066d00000169f-e2-511dd904ad31
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
In-reply-to: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
Subject: [PATCH V2 02/11] rtc: max77686: use dev_info() instead of printk()
Date: Fri, 15 Feb 2013 15:43:15 +0900
Message-id: <001f01ce0b47$bbac2e10$33048a30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LR47AXgjtu6e1Qmq7gnKtv11nagAABfVQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ12Wm7KBBjM3c1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MSz/nMhf0cFY8XNrC2MB4jL2LkZNDQsBEYsPZOSwQtpjEhXvr
	2boYuTiEBJYxSmzcfZgJpuhV91tWiMR0RonJ984zQjizmSTuP7nIBlLFJqAm8eXLYaCxHBwi
	AvoSbS0aIDXMAr2MEmd6d4PFhQRsJabedgYxOQXsJN5PNwXpFBbwlrh8/C3YLhYBVYkN12+x
	gti8QNWfrn5jhLAFJX5Mvgd2KLOAlsTmbU2sELa8xOY1b5lBRkoIqEs8+qsLEhYRMJK4/+kI
	VLmIxL4X78AulhBYxC4x4f5/qF0CEt8mH2KB6JWV2HSAGeJdSYmDK26wTGCUmIVk8ywkm2ch
	2TwLyYoFjCyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MULiasIOxnsHrA8xJgOtn8gsJZqc
	D4zLvJJ4Q2NjEzMTUxNzS1NzU9KElcR55S/JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpg
	5I3cGzVT+LOF4U2Tc/933fuTeZ8jbb7q+h+6x/1zXaoORHVYxJs5fbYoedt0Z9N74RLd1YVc
	b46Lqp/71RA/8W7jfQPWb0r9DyaEK+cfnHptzux2kV71pZY8nh8tot4/1BbtDvpxaecXxyAB
	PS/lR8oLXkof4bTexrKxSO77g2D99wYb3t0RUWIpzkg01GIuKk4EAKfa/sfBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoC7LTdlAg9VvWS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqWfc5kLejgrHi5tYWxg
	PMbexcjJISFgIvGq+y0rhC0mceHeerYuRi4OIYHpjBKT751nhHBmM0ncf3KRDaSKTUBN4suX
	w0DdHBwiAvoSbS0aIDXMAr2MEmd6d4PFhQRsJabedgYxOQXsJN5PNwXpFBbwlrh8/C0TiM0i
	oCqx4fotsL28QNWfrn5jhLAFJX5MvscCYjMLaEls3tbECmHLS2xe85YZZKSEgLrEo7+6IGER
	ASOJ+5+OQJWLSOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECI7aZ9I7GFc1WBxiFOBgVOLhFZCQDRRiTSwrrsw9xCjBwawkwrsmBCjEm5JYWZVa
	lB9fVJqTWnyIMRno0YnMUqLJ+cCEklcSb2hsYmZkaWRmYWRibk6asJI4L+OpJwFCAumJJanZ
	qakFqUUwW5g4OKUaGEVuHfjVwmy3rO/ynUlTk+Nd1TeZRu+umXS4Na+oQcFihZaexzOv19op
	0x1P7cypvsP/SXBhR9Qmixvfl7XsqW18ov3hQbHeCY6jdfev75WzOH/f8Mea69GdmzxExCJL
	55dP7vMz0qu6yecqLJYdeJCZl8XOaoFzzPpXDHsveD9YOunKl/plO5VYijMSDbWYi4oTAdSI
	BsYeAwAA
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
No changes since v1:

 drivers/rtc/rtc-max77686.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 2da0855..abe27c0 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -507,7 +507,7 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 	struct max77686_rtc_info *info;
 	int ret, virq;
 
-	printk(KERN_INFO "%s\n", __func__);
+	dev_info(&pdev->dev, "%s\n", __func__);
 
 	info = kzalloc(sizeof(struct max77686_rtc_info), GFP_KERNEL);
 	if (!info)
@@ -546,7 +546,7 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 			&max77686_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
-		printk(KERN_INFO "%s: fail\n", __func__);
+		dev_info(&pdev->dev, "%s: fail\n", __func__);
 
 		ret = PTR_ERR(info->rtc_dev);
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
-- 
1.7.2.5


