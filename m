Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3KFKGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:06:14 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:63347 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab3KFKGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:06:07 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 6/7] ARM: ux500: Clean-up legacy extern prototype
Date: Wed,  6 Nov 2013 10:05:47 +0000
Message-Id: <1383732348-18576-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
References: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/setup.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-ux500/setup.h b/arch/arm/mach-ux500/setup.h
index e5682da..7164cfd 100644
--- a/arch/arm/mach-ux500/setup.h
+++ b/arch/arm/mach-ux500/setup.h
@@ -19,9 +19,6 @@
 void ux500_restart(enum reboot_mode mode, const char *cmd);
 
 void __init ux500_map_io(void);
-extern void __init u8500_map_io(void);
-
-extern struct device * __init u8500_init_devices(void);
 
 extern void __init ux500_init_irq(void);
 
-- 
1.8.1.2

