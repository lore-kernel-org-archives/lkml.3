Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaFCMGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:06:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29826 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaFCMGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:06:32 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-98-538dba4667c4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Haojian Zhuang'" <haojian.zhuang@linaro.org>
Subject: [PATCH 1/2] rtc: rtc-sa1100: Make of_device_id array const
Date: Tue, 03 Jun 2014 21:06:30 +0900
Message-id: <002101cf7f24$40f3e670$c2dbb350$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9/JEDaC3X0p7C2RhWGHyaVfFroSQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zY123Xb3BBhs3SFosuXiV3WLO+jVs
	FpfPHWa0uLzwEqvF5V1z2Cz2d3YwOrB57Jl4ks3jzrU9bB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFcdmkpOZklqUW6dslcGV0PNjFWnCLtaJhykW2Bsb7LF2MnBwSAiYS6y88YISwxSQu3FvP
	1sXIxSEksIxR4tT0ecxdjBxgRZ0v5EFqhAQWMUpcn+0JUfObUWJP1wt2kASbgJrEly+H2UHq
	RQT0JdpaNEBqmAX2MkpseTUbbJmwgLPE1XPvwZaxCKhKLH0/mRXE5hWwlbi5vJEJwhaU+DH5
	Hlg9s4CWxPqdx5kgbHmJzWveQt2jLvHory5IWERAT+LduzNQJSIS+168g/rlGrvE0VUZEKsE
	JL5NPsQC0SorsekAM0SJpMTBFTdYJjCKzUKyeBaSxbOQLJ6FZMMCRpZVjKKpBckFxUnpRaZ6
	xYm5xaV56XrJ+bmbGCGROHEH4/0D1ocYk4HWT2SWEk3OB0ZyXkm8obGZkYWpiamxkbmlGWnC
	SuK86Y+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw1iRwbTgYpXTp5kkJmfKAnZl8R29+
	lGRuvrzb22/bGb8mIb5vV55cr8/tffJB05v3nsYbRZ1I89dbV2xmjX/THZUiv4P5YVlbXlTM
	xGk3XV/tcTWvn7CpI2nVxmbG9OP2ewLCEvmU23w/NKyxeO8m8yUo1Ofx/Hl80eZp0v+tbD/s
	YF/NPXWWEktxRqKhFnNRcSIAIoegE9oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jAV23Xb3BBvcvilosuXiV3WLO+jVs
	FpfPHWa0uLzwEqvF5V1z2Cz2d3YwOrB57Jl4ks3jzrU9bB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM6Hiwi7XgFmtFw5SLbA2M
	91m6GDk4JARMJDpfyHcxcgKZYhIX7q1nA7GFBBYxSlyf7dnFyAVk/2aU2NP1gh0kwSagJvHl
	y2F2kF4RAX2JthYNkBpmgb2MEltezWYBqREWcJa4eu49I4jNIqAqsfT9ZFYQm1fAVuLm8kYm
	CFtQ4sfke2D1zAJaEut3HmeCsOUlNq95ywxxm7rEo7+6IGERAT2Jd+/OQJWISOx78Y5xAqPA
	LCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI70Z1I7GFc2WBxi
	FOBgVOLh/bG3J1iINbGsuDL3EKMEB7OSCO+/9b3BQrwpiZVVqUX58UWlOanFhxiTgR6dyCwl
	mpwPTEJ5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cC4MrFn
	U8cHl/fSd4rM5OymLvN1tssTYDyq27NuYoXI7bsTJRWd9TjfihunntF6sOCtmJjgCve79edq
	1Ta4CEduczJU+Z58Q9QkcnmU7EHbu0XN7lfOx+57vr9z4ja1yIvz1p7NfJQefYtNeBFrvnAP
	+5EGkdfL+OuUDPiteBl8RNd8Y23jX6PEUpyRaKjFXFScCAD/iTEqOAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle
it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-sa1100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 0f7adeb..b6e1ca0 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -338,7 +338,7 @@ static SIMPLE_DEV_PM_OPS(sa1100_rtc_pm_ops, sa1100_rtc_suspend,
 			sa1100_rtc_resume);
 
 #ifdef CONFIG_OF
-static struct of_device_id sa1100_rtc_dt_ids[] = {
+static const struct of_device_id sa1100_rtc_dt_ids[] = {
 	{ .compatible = "mrvl,sa1100-rtc", },
 	{ .compatible = "mrvl,mmp-rtc", },
 	{}
-- 
1.7.10.4


