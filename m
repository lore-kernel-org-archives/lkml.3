Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881Ab3DGOvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 10:51:32 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:45898 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933823Ab3DGOv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 10:51:29 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/2] ARM: at91/setup: fix trivial typos
Date: Sun,  7 Apr 2013 16:49:58 +0200
Message-Id: <1365346199-29525-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few trivial typos in panic, warning and debug messages.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 arch/arm/mach-at91/setup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 4b67847..9e7c1e1 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -333,7 +333,7 @@ static void at91_dt_rstc(void)
 
 	of_id = of_match_node(rstc_ids, np);
 	if (!of_id)
-		panic("AT91: rtsc no restart function availlable\n");
+		panic("AT91: rtsc no restart function available\n");
 
 	arm_pm_restart = of_id->data;
 
@@ -353,7 +353,7 @@ static void at91_dt_ramc(void)
 
 	np = of_find_matching_node(NULL, ramc_ids);
 	if (!np)
-		panic("unable to find compatible ram conroller node in dtb\n");
+		panic("unable to find compatible ram controller node in dtb\n");
 
 	at91_ramc_base[0] = of_iomap(np, 0);
 	if (!at91_ramc_base[0])
@@ -403,7 +403,7 @@ static void at91_dt_shdwc(void)
 
 	np = of_find_matching_node(NULL, shdwc_ids);
 	if (!np) {
-		pr_debug("AT91: unable to find compatible shutdown (shdwc) conroller node in dtb\n");
+		pr_debug("AT91: unable to find compatible shutdown (shdwc) controller node in dtb\n");
 		return;
 	}
 
@@ -419,7 +419,7 @@ static void at91_dt_shdwc(void)
 
 	if (!of_property_read_u32(np, "atmel,wakeup-counter", &reg)) {
 		if (reg > AT91_SHDW_CPTWK0_MAX) {
-			pr_warn("AT91: shdwc wakeup conter 0x%x > 0x%x reduce it to 0x%x\n",
+			pr_warn("AT91: shdwc wakeup counter 0x%x > 0x%x reduce it to 0x%x\n",
 				reg, AT91_SHDW_CPTWK0_MAX, AT91_SHDW_CPTWK0_MAX);
 			reg = AT91_SHDW_CPTWK0_MAX;
 		}
-- 
1.8.1.5

