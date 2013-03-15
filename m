Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3COWeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 18:34:11 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:54330 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3COWeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 18:34:09 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] Trivial: Fix typo in arch/arm/mach-mvebu/irq-armada-370-xp.c
Date: Fri, 15 Mar 2013 23:34:04 +0100
Message-Id: <1363386844-25952-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/mach-mvebu/irq-armada-370-xp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-mvebu/irq-armada-370-xp.c b/arch/arm/mach-mvebu/irq-armada-370-xp.c
index 274ff58..d8dbcc1 100644
--- a/arch/arm/mach-mvebu/irq-armada-370-xp.c
+++ b/arch/arm/mach-mvebu/irq-armada-370-xp.c
@@ -55,7 +55,7 @@ static struct irq_domain *armada_370_xp_mpic_domain;
 /*
  * In SMP mode:
  * For shared global interrupts, mask/unmask global enable bit
- * For CPU interrtups, mask/unmask the calling CPU's bit
+ * For CPU interrupts, mask/unmask the calling CPU's bit
  */
 static void armada_370_xp_irq_mask(struct irq_data *d)
 {
-- 
1.7.10.4

