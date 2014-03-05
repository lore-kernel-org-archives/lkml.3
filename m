Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbaCEBBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:01:25 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59793 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbaCEBBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:01:24 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] irqchip: Silence sparse warning
Date: Tue,  4 Mar 2014 17:01:21 -0800
Message-Id: <1393981281-25553-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/irqchip/irqchip.c:27:13: warning: symbol 'irqchip_init'
was not declared. Should it be static?

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/irqchip/irqchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irqchip.c b/drivers/irqchip/irqchip.c
index f496afce29de..3469141f10f6 100644
--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -10,6 +10,7 @@
 
 #include <linux/init.h>
 #include <linux/of_irq.h>
+#include <linux/irqchip.h>
 
 #include "irqchip.h"
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

