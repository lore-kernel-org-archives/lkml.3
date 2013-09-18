Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab3IRMP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:15:28 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:40743 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3IRMPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:24 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 37/41] ARM: ux500: Remove AUXDATA relating to Ethernet clock-name bindings
Date: Wed, 18 Sep 2013 13:14:34 +0100
Message-Id: <1379506478-16625-38-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 7e32c7b..689d3a8 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -235,7 +235,6 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires clock name bindings. */
 	OF_DEV_AUXDATA("stericsson,db8500-prcmu", 0x80157000, "db8500-prcmu",
 			&db8500_prcmu_pdata),
-	OF_DEV_AUXDATA("smsc,lan9115", 0x50000000, "smsc911x.0", NULL),
 	OF_DEV_AUXDATA("stericsson,ux500-cryp", 0xa03cb000, "cryp1", NULL),
 	OF_DEV_AUXDATA("stericsson,ux500-hash", 0xa03c2000, "hash1", NULL),
 	OF_DEV_AUXDATA("stericsson,snd-soc-mop500", 0, "snd-soc-mop500.0",
-- 
1.8.1.2

