Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3JISFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 14:05:36 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40209 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3JISFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 14:05:34 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, badarkhe.manish@gmail.com,
        kgene.kim@samsung.com, a.kesavan@samsung.com
Subject: [PATCH] PM / devfreq: Remove duplicate include of opp.h
Date: Wed,  9 Oct 2013 23:35:24 +0530
Message-Id: <1381341924-16184-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, code include opp.h twice. Remove one inclusion
of opp.h

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
:100644 100644 574b16b... 93c29f4... M	drivers/devfreq/exynos/exynos5_bus.c
 drivers/devfreq/exynos/exynos5_bus.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index 574b16b..93c29f4 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -18,7 +18,6 @@
 #include <linux/opp.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
-#include <linux/opp.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-- 
1.7.10.4

