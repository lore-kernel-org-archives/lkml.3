Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaBISyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:54:14 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62417 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaBISsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:33 -0500
From: Richard Weinberger <richard@nod.at>
To: Christian Daudt <bcm@fixthebug.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM
	SUB-ARCHITECT...),
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM BCM281XX...),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 12/28] Remove GENERIC_TIME
Date: Sun,  9 Feb 2014 19:47:50 +0100
Message-Id: <1391971686-9517-13-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/arm/mach-bcm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index b1aa6a9..8dd5fbf 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -19,7 +19,6 @@ config ARCH_BCM_MOBILE
 	select CPU_V7
 	select CLKSRC_OF
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_TIME
 	select GPIO_BCM_KONA
 	select SPARSE_IRQ
 	select TICK_ONESHOT
-- 
1.8.4.2

