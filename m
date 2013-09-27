Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3I0C0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:26:16 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33776 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3I0CZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:25:32 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 4/6] ARM: PSCI: remove unnecessary include of arm-gic.h
Date: Thu, 26 Sep 2013 21:24:52 -0500
Message-Id: <1380248694-13388-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380248694-13388-1-git-send-email-robherring2@gmail.com>
References: <1380248694-13388-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Now that gic_secondary_init is no longer needed to be called by SMP init
functions, the header is not needed.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/kernel/psci_smp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/kernel/psci_smp.c b/arch/arm/kernel/psci_smp.c
index 70ded3f..570a48c 100644
--- a/arch/arm/kernel/psci_smp.c
+++ b/arch/arm/kernel/psci_smp.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/irqchip/arm-gic.h>
 #include <linux/smp.h>
 #include <linux/of.h>
 
-- 
1.8.1.2

