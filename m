Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaEMTOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:14:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaEMTNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:13:54 -0400
Date: Tue, 13 May 2014 12:13:24 -0700
From: tip-bot for Jason Cooper <tipbot@zytor.com>
Message-ID: <tip-2ed9fd28c2884e9f41c133f86a7e377d7c0a96bf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, jason@lakedaemon.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, jason@lakedaemon.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1400006821-32145-1-git-send-email-jason@lakedaemon.net>
References: <1400006821-32145-1-git-send-email-jason@lakedaemon.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] MAINTAINERS: Add co-maintainer for drivers/
 irqchip
Git-Commit-ID: 2ed9fd28c2884e9f41c133f86a7e377d7c0a96bf
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

Commit-ID:  2ed9fd28c2884e9f41c133f86a7e377d7c0a96bf
Gitweb:     http://git.kernel.org/tip/2ed9fd28c2884e9f41c133f86a7e377d7c0a96bf
Author:     Jason Cooper <jason@lakedaemon.net>
AuthorDate: Tue, 13 May 2014 18:47:01 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 13 May 2014 21:10:55 +0200

MAINTAINERS: Add co-maintainer for drivers/irqchip

Thomas Gleixner has asked me to assist with the review and merging of
patches for the irqchip subsystem.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Link: http://lkml.kernel.org/r/1400006821-32145-1-git-send-email-jason@lakedaemon.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6bef70b..4195801 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4818,6 +4818,14 @@ L:	linux-kernel@vger.kernel.org
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
