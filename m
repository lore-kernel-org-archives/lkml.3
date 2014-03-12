Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaCLMQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:16:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50329 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaCLMQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:16:27 -0400
Date: Wed, 12 Mar 2014 05:16:11 -0700
From: tip-bot for Stephen Boyd <tipbot@zytor.com>
Message-ID: <tip-1a75b8e64571a85d5e648cfdf4c40e0d9923abc5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkosina@suse.cz, tglx@linutronix.de, sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jkosina@suse.cz, sboyd@codeaurora.org
In-Reply-To: <531F7765.40207@codeaurora.org>
References: <531F7765.40207@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: Remove unused include
Git-Commit-ID: 1a75b8e64571a85d5e648cfdf4c40e0d9923abc5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a75b8e64571a85d5e648cfdf4c40e0d9923abc5
Gitweb:     http://git.kernel.org/tip/1a75b8e64571a85d5e648cfdf4c40e0d9923abc5
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Tue, 11 Mar 2014 13:51:49 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Mar 2014 13:12:04 +0100

irqchip: Remove unused include

The "irqchip.h" include here is not needed as the only thing in
irqchip.h is IRQCHIP_DECLARE which this file doesn't use. Drop
it.

Reported-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Link: http://lkml.kernel.org/r/531F7765.40207@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irqchip.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/irqchip/irqchip.c b/drivers/irqchip/irqchip.c
index 3469141..cad3e24 100644
--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -12,8 +12,6 @@
 #include <linux/of_irq.h>
 #include <linux/irqchip.h>
 
-#include "irqchip.h"
-
 /*
  * This special of_device_id is the sentinel at the end of the
  * of_device_id[] array of all irqchips. It is automatically placed at
