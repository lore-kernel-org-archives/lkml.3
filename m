Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3IZSv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:51:27 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51108 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3IZSvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:21 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 06/21] arc: remove unnecessary prom.h includes
Date: Thu, 26 Sep 2013 13:50:41 -0500
Message-Id: <1380221456-11192-7-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Remove unnecessary prom.h includes in preparation to remove prom.h.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/devtree.c | 1 -
 arch/arc/kernel/setup.c   | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
index 2340af0..6fb5137 100644
--- a/arch/arc/kernel/devtree.c
+++ b/arch/arc/kernel/devtree.c
@@ -14,7 +14,6 @@
 #include <linux/memblock.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
-#include <asm/prom.h>
 #include <asm/clk.h>
 #include <asm/mach_desc.h>
 
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 2c68bc7e..f30cf31 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -21,7 +21,6 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/irq.h>
-#include <asm/prom.h>
 #include <asm/unwind.h>
 #include <asm/clk.h>
 #include <asm/mach_desc.h>
-- 
1.8.1.2

