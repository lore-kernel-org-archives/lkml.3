Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3B1Ij5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:39:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47685 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3B1Ijz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:39:55 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-c3-512f17da0296
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 03/19] rtc: rtc-ds1302: remove erroneous __init annotation
Date: Thu, 28 Feb 2013 17:39:53 +0900
Message-id: <00a701ce158f$2e14e130$8a3ea390$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAACfRg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ91b4vqBBlc3c1ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8en8P9aCx2wVs99cZGtgvMnaxcjBISFgItF31aaLkRPIFJO4cG89G4gtJLCMUeLp
	1kqIuInEtffPmboYuYDi0xkl9n/7ywLh/GKUePD8CytIFZuAmsSXL4fZQYaKCOhLtLVogNQw
	C/QySpzp3c0OMdVW4lhbGwuIzSlgJ/H76VGwXmEBL4kpf3eC1bAIqErs3t3CDGLzAtUv/r2Q
	DcIWlPgx+R5YL7OAlsT6nceZIGx5ic1r3jJDPKMu8eivLkhYRMBI4twJiLXMAiIS+168YwS5
	R0LgEbvEvY+NbBC7BCS+TT7EAtErK7HpADPEw5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZ
	VjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmKExOnEHYz3D1gfYkwGWj+RWUo0OR8Y53kl8YbG
	xiZmJqYm5pam5qakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwMjIceC5GXuD
	aOsGx/jeHL0q83a12/dWqdc0J16Y43xm97RLtvrz9UwKjfr+asQu6E4O+HfZtvnqEZmCy+fN
	l3p1NCT7TpozqzbjdNSPjGjBV19vZr1dGNOz7pTYrqoYtf935f+bLfvzf2Vdh8zKC+ELo1b8
	m/R44lo7058XZS7/mbD9/tbNs78rsRRnJBpqMRcVJwIA487qVOkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd1b4vqBBitb2C2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzPh0/h9rwWO2itlvLrI1MN5k7WLk5JAQMJG4
	9v45E4QtJnHh3nq2LkYuDiGB6YwS+7/9ZYFwfjFKPHj+BayDTUBN4suXw+xdjBwcIgL6Em0t
	GiA1zAK9jBJnenezg9QICdhKHGtrYwGxOQXsJH4/PQrWKyzgJTHl706wGhYBVYndu1uYQWxe
	oPrFvxeyQdiCEj8m3wPrZRbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUEjCTOnYBYyywg
	IrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgR
	PJPewbiqweIQowAHoxIPb4eJXqAQa2JZcWXuIUYJDmYlEV4Xfv1AId6UxMqq1KL8+KLSnNTi
	Q4zJQI9OZJYSTc4HJqm8knhDYxMzI0sjMwsjE3Nz0oSVxHkZTz0JEBJITyxJzU5NLUgtgtnC
	xMEp1cC44tSdg+Lr9kjUnOYW4px66/YSXdPy9RbcJyvSFPRqFAx8KjzeN0jntC36cvPQg7j3
	seelNRp5m+fvT9279UTsFX/TsthvCYaLrL7tNCh5vfnuhf2ndDo1LBfaPpVJ3Jj+7NLWxn+3
	egts3nbGejgk3Xdk7kordT+fkdUQZJczm/2kDfe9A5OVWIozEg21mIuKEwFwud2JSAMAAA==
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
 drivers/rtc/rtc-ds1302.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
index fdbcdb2..fad99ba 100644
--- a/drivers/rtc/rtc-ds1302.c
+++ b/drivers/rtc/rtc-ds1302.c
@@ -205,7 +205,7 @@ static struct rtc_class_ops ds1302_rtc_ops = {
 	.ioctl		= ds1302_rtc_ioctl,
 };
 
-static int __init ds1302_rtc_probe(struct platform_device *pdev)
+static int ds1302_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 
-- 
1.7.2.5


