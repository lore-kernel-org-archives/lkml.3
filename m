Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab3IPXL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:11:56 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:40733 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3IPXJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:53 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net
Subject: [PATCH 22/28] openrisc: remove unnecessary prom.c includes
Date: Mon, 16 Sep 2013 18:09:18 -0500
Message-Id: <1379372965-22359-23-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

It appears openrisc prom.c was just copied from another arch with a
bunch of unnecessary includes. Remove all the unecessary ones.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux@lists.openrisc.net
---
 arch/openrisc/kernel/prom.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index 2aae474..6a44340 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -18,34 +18,12 @@
  *
  */
 
-#include <stdarg.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
 #include <linux/init.h>
-#include <linux/threads.h>
-#include <linux/spinlock.h>
 #include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/stringify.h>
-#include <linux/delay.h>
-#include <linux/initrd.h>
-#include <linux/bitops.h>
-#include <linux/module.h>
-#include <linux/kexec.h>
-#include <linux/debugfs.h>
-#include <linux/irq.h>
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 
-#include <asm/prom.h>
 #include <asm/page.h>
-#include <asm/processor.h>
-#include <asm/irq.h>
-#include <linux/io.h>
-#include <asm/mmu.h>
-#include <asm/pgtable.h>
-#include <asm/sections.h>
-#include <asm/setup.h>
 
 void __init early_init_devtree(void *params)
 {
-- 
1.8.1.2

