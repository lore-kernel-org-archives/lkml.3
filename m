Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaA1MTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:19:13 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26902 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbaA1MTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:01 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-be-52e7a032184d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 01/18] regulator: max14577: Remove unused state container
 definition
Date: Tue, 28 Jan 2014 13:18:25 +0100
Message-id: <1390911522-28209-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4NV3jBc+DDK5lWUx9+ITN4vqX56wW
	r18YWpxtesNucf/rUUaLb1c6mCw2Pb7GanF51xw2i7VH7rJb3G5cwWZxupvVgdtj56y77B6b
	VnWyedy5tofNY97JQI/NS+o9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK+P+zlNMBU1cFXf3
	dbE2MK7j6GLk5JAQMJG4s6uZDcIWk7hwbz2QzcUhJLCUUWLNz5msEE4fk8SkYzuYQKrYBIwl
	Ni9fAlYlIrCaSWLNgqksIAlmgV5GiZu7PUBsYYEwiZu7VoI1sAioSrza9JoVxOYVcJc4NfU5
	UJwDaJ2CxJxJNiBhTgEPiVdXG8HKhUBKjr9jmcDIu4CRYRWjaGppckFxUnqukV5xYm5xaV66
	XnJ+7iZGSCB+3cG49JjVIUYBDkYlHt4H3c+ChFgTy4orcw8xSnAwK4nwJs5+HiTEm5JYWZVa
	lB9fVJqTWnyIkYmDU6qBUZj7QfCNLwqTplwo8Ck3mryL62DpxRqe/9NsbxlbNZc/Eb5kyn/q
	qU0O+4Of2+T/WS0zXOEhxpOauPpm3to1Gv0X1vYwnDpnx/fhmqZUz8J8yQUHBG2Wieq2TrxX
	971V21iMXY+v9+vDSZeWnuLb2RF1v7HBaZZlbYNMj+UM3ib9t5NXHrpWr8RSnJFoqMVcVJwI
	AN+Gu3ciAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the "struct max14577_regulator" because this is not used
anywhere. It should be removed earlier along with changing the driver
after review on the mailing lists.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/max14577.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index b1078ba3f393..38821458d413 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -1,7 +1,7 @@
 /*
  * max14577.c - Regulator driver for the Maxim 14577
  *
- * Copyright (C) 2013 Samsung Electronics
+ * Copyright (C) 2013,2014 Samsung Electronics
  * Krzysztof Kozlowski <k.kozlowski@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -22,12 +22,6 @@
 #include <linux/mfd/max14577-private.h>
 #include <linux/regulator/of_regulator.h>
 
-struct max14577_regulator {
-	struct device *dev;
-	struct max14577 *max14577;
-	struct regulator_dev **regulators;
-};
-
 static int max14577_reg_is_enabled(struct regulator_dev *rdev)
 {
 	int rid = rdev_get_id(rdev);
-- 
1.7.9.5

