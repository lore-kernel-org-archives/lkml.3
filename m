Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaK1Ehd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 23:37:33 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44618 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaK1EdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 23:33:07 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V4 01/16] irqchip: Update docs regarding irq_domain_add_tree()
Date: Thu, 27 Nov 2014 20:32:07 -0800
Message-Id: <1417149142-3756-2-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
References: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several drivers now use this API, including the ARM GIC driver, so remove
the outdated comment.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 Documentation/IRQ-domain.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
index 8a8b82c9ca53..0ccd7b7f6043 100644
--- a/Documentation/IRQ-domain.txt
+++ b/Documentation/IRQ-domain.txt
@@ -95,8 +95,7 @@ since it doesn't need to allocate a table as large as the largest
 hwirq number.  The disadvantage is that hwirq to IRQ number lookup is
 dependent on how many entries are in the table.
 
-Very few drivers should need this mapping.  At the moment, powerpc
-iseries is the only user.
+Very few drivers should need this mapping.
 
 ==== No Map ===-
 irq_domain_add_nomap()
-- 
2.1.0

