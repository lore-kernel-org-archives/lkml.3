Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab3JGQh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:37:26 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:52097 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab3JGQhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:37:11 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net
Subject: [PATCH v2 23/29] openrisc: remove unnecessary prom.c includes
Date: Mon,  7 Oct 2013 11:29:31 -0500
Message-Id: <1381163377-21044-24-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
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

