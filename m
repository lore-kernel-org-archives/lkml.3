Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3IRMPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:15:44 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:44650 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab3IRMPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 40/41] ARM: ux500: Remove SSP AUXDATA pertaining to DMA bindings
Date: Wed, 18 Sep 2013 13:14:37 +0100
Message-Id: <1379506478-16625-41-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are now cared for from the Device Tree.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 28a69d1..27734e7 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -219,7 +219,6 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires call-back bindings. */
 	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &db8500_pmu_platdata),
 	/* Requires DMA bindings. */
-	OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80126000, "sdi0",  &mop500_sdi0_data),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  &mop500_sdi1_data),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80005000, "sdi2",  &mop500_sdi2_data),
-- 
1.8.1.2

