Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbaFRXxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:53:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42953 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbaFRXwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:52:32 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-ad-53a2263ebc1f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com,
        broonie@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv7 4/4] mfd: sec-core: Prepare regulators for suspend state to
 reduce power-consumption
Date: Thu, 19 Jun 2014 08:52:25 +0900
Message-id: <1403135545-7451-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403135545-7451-1-git-send-email-cw00.choi@samsung.com>
References: <1403135545-7451-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkUNdObVGwwYydShZTHz5hs7j+5Tmr
	xdmmN+wW978eZbS4vGsOm8XtxhVsFqe7WS0urvjC5MDhsWlVJ5vHnWt72DzmnQz06NuyitHj
	8ya5ANYoLpuU1JzMstQifbsEroz/P/4zFzxhr9h8v4epgfEgWxcjJ4eEgInElOMHGSFsMYkL
	99YDxbk4hASWMkrMnr+cHabo0vT9TBCJRYwS+75PZQFJCAk0MUms2OMLYrMJaEnsf3EDbKqI
	QJTE3IXfwWxmgVqJfdeaWEFsYYEMicVfH4L1sgioStw6dY0ZxOYVcJF4OXclE8QyOYkPex6B
	LeYUcJV49ecx1C4XiV+PGlhBjpAQmMcu0XDvERvEIAGJb5MPARVxACVkJTYdYIaYIylxcMUN
	lgmMwgsYGVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBAb76X/P+nYw3jxgfYgxGWjcRGYp
	0eR8YLTklcQbGpsZWZiamBobmVuakSasJM676GFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5O
	qQbGnL2zz+w5mcdYeX/xaUULV8WOcq+yHRKikfbtotuW8e5/oCvwvNn/95tjXGICLvtmej41
	MvJoNV74/oLiFIsEyU0/Wk42er5P2tCwekVg9YSvCQ+FJm3M6vjdl77GJfJd/pHLVoWHHDbo
	M5cfNBdI++vaumXeZ7kLH3i4S7PeXI7heVv6RMtJiaU4I9FQi7moOBEAXwolQYwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jAV07tUXBBlO7pS2mPnzCZnH9y3NW
	i7NNb9gt7n89ymhxedccNovbjSvYLE53s1pcXPGFyYHDY9OqTjaPO9f2sHnMOxno0bdlFaPH
	501yAaxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6Z
	OUCnKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz/v/4z1zwhL1i8/0e
	pgbGg2xdjJwcEgImEpem72eCsMUkLtxbDxTn4hASWMQose/7VBaQhJBAE5PEij2+IDabgJbE
	/hc3wJpFBKIk5i78DmYzC9RK7LvWxApiCwtkSCz++hCsl0VAVeLWqWvMIDavgIvEy7kroZbJ
	SXzY84gdxOYUcJV49ecx1C4XiV+PGlgnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iREcS8+kdjCubLA4xCjAwajEw+txcWGwEGtiWXFl7iFGCQ5mJRFe+V9AId6UxMqq1KL8+KLS
	nNTiQ4zJQFdNZJYSTc4HxnleSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KL
	YLYwcXBKNTDO7DoZ7l8iqaVed5z3uk2Dx5XDgstrxXV5lSzNAzZF/dnbo35w+i3rDd8F/t3Z
	I5AkHqd6aGNVX+wHPYlZd1fus+iccH8b3/cNCqfsJII2hd8S297fc27N+3Tez1sPzTf/NuNJ
	i5vt/GT/aVorrRcvcN6rsi/+gFjDj3Wszls2Mqlarl+loGSsxFKckWioxVxUnAgAi4eiI+kC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use regulator_suspend_prepare() function to prepare the proper state
of regulators for suspend state to remove un-necessary leakage power-consumption.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/mfd/sec-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 2621328..f6469b7 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -31,6 +31,7 @@
 #include <linux/mfd/samsung/s2mpu02.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
+#include <linux/regulator/machine.h>
 #include <linux/regmap.h>
 
 static const struct mfd_cell s5m8751_devs[] = {
@@ -430,6 +431,13 @@ static int sec_pmic_suspend(struct device *dev)
 	 */
 	disable_irq(sec_pmic->irq);
 
+	switch (sec_pmic->device_type) {
+	case S2MPS14X:
+	case S2MPU02:
+		regulator_suspend_prepare(PM_SUSPEND_MEM);
+		break;
+	};
+
 	return 0;
 }
 
-- 
1.8.0

