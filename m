Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890Ab3DBNWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:22:09 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:53320 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451Ab3DBNWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:22:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/9] ARM: ux500: Increase the size of the PRCMU's TCPM size
Date: Tue,  2 Apr 2013 14:21:48 +0100
Message-Id: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tightly Coupled Program Memory location is actually 32kB in
size, rather than the originally depicted 4kB.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/devices-db8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index f3d9419..afa5b04 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -225,7 +225,7 @@ static struct resource db8500_prcmu_res[] = {
 	{
 		.name  = "prcmu-tcpm",
 		.start = U8500_PRCMU_TCPM_BASE,
-		.end   = U8500_PRCMU_TCPM_BASE + SZ_4K - 1,
+		.end   = U8500_PRCMU_TCPM_BASE + SZ_32K - 1,
 		.flags = IORESOURCE_MEM,
 	},
 };
-- 
1.7.10.4

