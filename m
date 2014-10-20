Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaJTTHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:07:09 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:53354 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaJTTEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:12 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/19] irqchip: mips-gic: Clean up #includes
Date: Mon, 20 Oct 2014 12:03:55 -0700
Message-Id: <1413831846-32100-9-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort the #includes and remove those which are unnecessary.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/irqchip/irq-mips-gic.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index adcb9b2..a1ccde6 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -7,19 +7,16 @@
  * Copyright (C) 2012 MIPS Technologies, Inc.  All rights reserved.
  */
 #include <linux/bitmap.h>
+#include <linux/clocksource.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/irqchip/mips-gic.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
-#include <linux/irq.h>
-#include <linux/clocksource.h>
 
-#include <asm/io.h>
 #include <asm/setup.h>
 #include <asm/traps.h>
-#include <linux/hardirq.h>
-#include <asm-generic/bitops/find.h>
 
 unsigned int gic_frequency;
 unsigned int gic_present;
-- 
2.1.0.rc2.206.gedb03e5

