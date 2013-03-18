Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab3CRJcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:32:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20861 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3CRJcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:32:12 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-28-5146df1b1cf1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
In-reply-to: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
Subject: [PATCH 08/10] rtc: rtc-tps6586x: switch to using SIMPLE_DEV_PM_OPS
Date: Mon, 18 Mar 2013 18:32:11 +0900
Message-id: <01be01ce23bb$77a0da90$66e28fb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4juxtMJTZWEDnPSfOGR4wzonE6SAAAFCfQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zY13p+26BBp8nKVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MvdMfMRZsYqs4uGw5cwPjRtYuRk4OCQETicczT7FB2GISF+6t
	B7K5OIQEljFKrJr2gxmmaPObDjBbSGARo8SOTQIQRbOZJLo2r2UHSbAJqEl8+XIYyObgEBHQ
	l2hr0QCpYRboZZQ407ubHaLZVmLetcWMIDangJ3E1v5JYFcIC3hLrJp1FmwBi4CqRNOaHiYQ
	mxeofunVDnYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJgJPG4+yA7
	RImIxL4X7xhB7pEQWMYusXPTbUaIXQIS3yYfYoHolZXYdADqX0mJgytusExglJiFZPMsJJtn
	Idk8C8mKBYwsqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzFCIqt/B+PdA9aHGJOB1k9klhJN
	zgdGZl5JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUa
	GBVmMatkMGtXLvu90mD1nM5Zi40ikw/2KXz/098rtUltwoQ5/67MklT4snTH7Eb76/kXk95r
	OMceEkqO/LnvoMDG8wfrfMUlIzYquedk7RO3T1/P6Pjqxs5XT7SO9Hpx272JnzxTIdPTLCjg
	QeqGF69iAq7Z6yqoXzzzb/7Kpy7e6V2i3aWpk5VYijMSDbWYi4oTAXPXCAHCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK70fbdAg4s7ZCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxt7pjxgLNrFVHFy2nLmB
	cSNrFyMnh4SAicTmNx3MELaYxIV769lAbCGBRYwSOzYJdDFyAdmzmSS6Nq9lB0mwCahJfPly
	GMjm4BAR0Jdoa9EAqWEW6GWUONO7mx2i2VZi3rXFjCA2p4CdxNb+SWDLhAW8JVbNOgu2jEVA
	VaJpTQ8TiM0LVL/0agc7hC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLEhYR
	MJJ43H2QHaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWle
	ul5yfu4mRnDcPpPawbiyweIQowAHoxIP7471boFCrIllxZW5hxglOJiVRHgdbwOFeFMSK6tS
	i/Lji0pzUosPMSYDPTqRWUo0OR+YUvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKa
	nZpakFoEs4WJg1OqgdFousbHnm5GHcGXJ4zP/CzW39T85ZbkdhV/Va0QmxWzP7FFH9/P8JA9
	cc+VnU67dhy/qXXMf+rlSW4aB/dxXj9psILhj8chvXMVh5589b5kdzVqmv/cmT/Fam5b1l6R
	mPOJqY0x3DzqOHPm6l/d3Vbt/1WnWO83n79wqVrpO93Pc4Kq555gcctUYinOSDTUYi4qTgQA
	08t7fR8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using SIMPLE_DEV_PM_OPS  macro to declare the driver's
pm_ops. It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-tps6586x.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
index b6aab9f..badfea4 100644
--- a/drivers/rtc/rtc-tps6586x.c
+++ b/drivers/rtc/rtc-tps6586x.c
@@ -333,9 +333,8 @@ static int tps6586x_rtc_resume(struct device *dev)
 }
 #endif
 
-static const struct dev_pm_ops tps6586x_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(tps6586x_rtc_suspend, tps6586x_rtc_resume)
-};
+static SIMPLE_DEV_PM_OPS(tps6586x_pm_ops, tps6586x_rtc_suspend,
+			tps6586x_rtc_resume);
 
 static struct platform_driver tps6586x_rtc_driver = {
 	.driver	= {
-- 
1.7.2.5


