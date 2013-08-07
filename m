Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab3HGK5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:57:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:51146 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab3HGK5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:57:04 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] clocksource: add an "menu" item to Kconfig
Date: Wed,  7 Aug 2013 12:56:57 +0200
Message-Id: <1375873017-30625-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a menu item to clocksource' Kconfig file. Without it the
changeable items look somehow lost in the main drivers' menu

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/clocksource/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index d0e207b..95660d8 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -1,3 +1,5 @@
+menu "Clocksource Framework"
+
 config CLKSRC_OF
 	bool
 
@@ -123,3 +125,4 @@ config VF_PIT_TIMER
 	bool
 	help
 	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
+endmenu
-- 
1.8.3.2

