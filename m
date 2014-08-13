Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaHMALL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:11:11 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:55710 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaHMALI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:11:08 -0400
From: Kevin Hilman <khilman@linaro.org>
To: daniel.lezcano@linaro.org
Cc: t.figa@samsung.com, k.chander@samsung.com, kgene.kim@samsung.com,
        linaro-kernel@lists.linaro.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-pm@vger.kernel.org (open list:CPUIDLE DRIVERS),
        linux-arm-kernel@lists.infradead.org (open list:CPUIDLE DRIVER -...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] cpuidle: big.LITTLE: add Exynos5800 compatible string
Date: Tue, 12 Aug 2014 17:11:05 -0700
Message-Id: <1407888665-24603-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos 5800 is big.LITTLE SoC compatible with the 5420.  Add the
compatible string so this driver works on the 5800.

Tested on exynos5800-peach-pi (aka Samsung Chromebook2)

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 drivers/cpuidle/cpuidle-big_little.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
index 0a1f827308db..bf3ab66fdaaf 100644
--- a/drivers/cpuidle/cpuidle-big_little.c
+++ b/drivers/cpuidle/cpuidle-big_little.c
@@ -166,6 +166,7 @@ static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int match_id)
 static const struct of_device_id compatible_machine_match[] = {
 	{ .compatible = "arm,vexpress,v2p-ca15_a7" },
 	{ .compatible = "samsung,exynos5420" },
+	{ .compatible = "samsung,exynos5800" },
 	{},
 };
 
-- 
1.9.2

