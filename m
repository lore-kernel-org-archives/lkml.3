Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935478Ab3BOHZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:25:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60046 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3BOHZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:25:31 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-18-511de2eace4e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
In-reply-to: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
Subject: [PATCH V3 02/11] rtc: max77686: use dev_info() instead of printk()
Date: Fri, 15 Feb 2013 16:25:30 +0900
Message-id: <002c01ce0b4d$a24521b0$e6cf6510$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LTYY6VzXwCUtKTcq8t8M0FTt2HQAAAasg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY91Xj2QDDR6dVbG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZjw6XFizhrPj6YQ5LA+N19i5GTg4JAROJ5keP2CBsMYkL99YD
	2VwcQgLLGCW+7HsCVzR/zkMmiMR0RonHqzewQDizmSSeNe1hAqliE1CT+PLlMFAHB4eIgL5E
	W4sGSA2zQC+jxJne3WCThARsJab+/sYKYnMK2EmsntQBFhcW8Ja4dm4VM0gvi4CqxIYWF5Aw
	L1D5u+93WCBsQYkfk++B2cwCWhKbtzWxQtjyEpvXvAVrlRBQl3j0VxckLCJgJDHx9g42iBIR
	iX0v3jGCnCMhsIhdon9aL9gcFgEBiW+TD7FA9MpKbDrADPGvpMTBFTdYJjBKzEKyeRaSzbOQ
	bJ6FZMUCRpZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGCFx1buD8fYB60OMyUDrJzJLiSbn
	A+MyryTe0NjYxMzE1MTc0tTclDRhJXFeuUsygUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	F/HsCLmTOlGg+CRXMctr2ec/Yj5n6GwK7PD973dm12rtjlbn2pUOFieFddd+192zRPD7DtWJ
	/jNWRTtNvtVXclrzmsdzG94JN00ubHuk/k9SwaVq/vW9f2bHfjlXWxtyj3P3safr58Xp31nw
	V/LWhaZg3S12K6/eTmPvPDVdqXXdROd/Wbu3flRiKc5INNRiLipOBADsgluIwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO6rR7KBBkc+yVtc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjEeHSwuWcFZ8/TCHpYHx
	OnsXIyeHhICJxPw5D5kgbDGJC/fWs3UxcnEICUxnlHi8egMLhDObSeJZ0x6wKjYBNYkvXw4D
	dXNwiAjoS7S1aIDUMAv0Mkqc6d0NNlVIwFZi6u9vrCA2p4CdxOpJHWBxYQFviWvnVjGD9LII
	qEpsaHEBCfMClb/7focFwhaU+DH5HpjNLKAlsXlbEyuELS+xec1bsFYJAXWJR391QcIiAkYS
	E2/vYIMoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66X
	nJ+7iREctc+kdzCuarA4xCjAwajEwysgIRsoxJpYVlyZe4hRgoNZSYRX7hZQiDclsbIqtSg/
	vqg0J7X4EGMy0J8TmaVEk/OBCSWvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATSE0tSs1NT
	C1KLYLYwcXBKNTDO+C+j+dM96NiE794Kjz5/XNnF9dxsjUgHu1iB/+0FwhN+1PD8Y1vNUZ/H
	cUj011edw+2t1/pTCu8yiPwNe3l+ymaFj7M//NN9Lfpk9jaJVimNhbu1d26/NOPi4RNsK+Z+
	DXBsf8o69UbMiaba78W1D+ZnHzxrN8/N4NWLUrGo0K3mawocdp8oUWIpzkg01GIuKk4EANwW
	MdQeAwAA
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

No changes since v2:

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


