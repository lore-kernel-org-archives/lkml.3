Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaDAUga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:36:30 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62344 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaDAUgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:36:25 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Paul Bolle <pebolle@tiscali.nl>,
        Rob Herring <rob.herring@linaro.org>
Subject: [PATCH] dt: Remove dangling "select PROC_DEVICETREE"
Date: Tue,  1 Apr 2014 21:36:14 +0100
Message-Id: <1396384574-30776-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PROC_DEVICETREE has been removed from the tree. This commit
removes a dangling select of the config symbol.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Rob Herring <rob.herring@linaro.org>
---
 arch/arm/mach-omap2/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 0af7ca02314d..07d4bb098a49 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -104,7 +104,6 @@ config ARCH_OMAP2PLUS
 	select MACH_OMAP_GENERIC
 	select OMAP_DM_TIMER
 	select PINCTRL
-	select PROC_DEVICETREE if PROC_FS
 	select SOC_BUS
 	select SPARSE_IRQ
 	select TI_PRIV_EDMA
-- 
1.8.3.2

