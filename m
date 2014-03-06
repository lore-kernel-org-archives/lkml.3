Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaCFKmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:42:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaCFKmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:42:38 -0500
Date: Thu, 6 Mar 2014 02:42:26 -0800
From: tip-bot for Stephen Boyd <tipbot@zytor.com>
Message-ID: <tip-559ba4b153acfbfe49007def9d0efc475d5f937c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sboyd@codeaurora.org
In-Reply-To: <1393981281-25553-1-git-send-email-sboyd@codeaurora.org>
References: <1393981281-25553-1-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: Silence sparse warning
Git-Commit-ID: 559ba4b153acfbfe49007def9d0efc475d5f937c
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

Commit-ID:  559ba4b153acfbfe49007def9d0efc475d5f937c
Gitweb:     http://git.kernel.org/tip/559ba4b153acfbfe49007def9d0efc475d5f937c
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Tue, 4 Mar 2014 17:01:21 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 6 Mar 2014 11:40:47 +0100

irqchip: Silence sparse warning

drivers/irqchip/irqchip.c:27:13: warning: symbol 'irqchip_init'
was not declared. Should it be static?

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: trivial@kernel.org
Link: http://lkml.kernel.org/r/1393981281-25553-1-git-send-email-sboyd@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irqchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irqchip.c b/drivers/irqchip/irqchip.c
index f496afc..3469141 100644
--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -10,6 +10,7 @@
 
 #include <linux/init.h>
 #include <linux/of_irq.h>
+#include <linux/irqchip.h>
 
 #include "irqchip.h"
 
