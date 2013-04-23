Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3DWPEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:04:13 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:50865 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab3DWPD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:03:59 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/10] ARM: ux500: Remove ux500-musb platform registation when booting with DT
Date: Tue, 23 Apr 2013 16:03:13 +0100
Message-Id: <1366729394-11406-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the ux500-musb driver has been enabled for Device Tree, there is no
requirement to register it from platform code.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 5a6b9ae..36ef6ed 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -227,8 +227,6 @@ static struct device * __init u8500_of_init_devices(void)
 {
 	struct device *parent = db8500_soc_device_init();
 
-	db8500_add_usb(parent, usb_db8500_dma_cfg, usb_db8500_dma_cfg);
-
 	return parent;
 }
 
-- 
1.7.10.4

