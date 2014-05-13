Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaEMSr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:47:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:36969 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753939AbaEMSrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:47:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18YEixZmp23xpvxD8j8AIUfqiBixDojtYw=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7365357429E
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Add co-maintainer for drivers/irqchip
Date: Tue, 13 May 2014 18:47:01 +0000
Message-Id: <1400006821-32145-1-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner has asked me to assist with the review and merging of
patches for the irqchip subsystem.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc67b1fdb50..1bb769324710 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4812,6 +4812,14 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
 F:	kernel/irq/
+
+IRQCHIP DRIVERS
+M:	Thomas Gleixner <tglx@linutronix.de>
+M:	Jason Cooper <jason@lakedaemon.net>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
+T:	git git://git.infradead.org/users/jcooper/linux.git irqchip/core
 F:	drivers/irqchip/
 
 IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
-- 
1.9.3

