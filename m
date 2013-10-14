Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab3JNUuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:50:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35300 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758485Ab3JNUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:50:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/3] clocksource: sun4i: Select CLKSRC_MMIO
Date: Mon, 14 Oct 2013 21:07:46 +0200
Message-Id: <1381777668-32565-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381777668-32565-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1381777668-32565-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner SoCs timer use the clocksource MMIO functions. We thus
need to select them in Kconfig.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 41c6946..cea50f0 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -33,6 +33,7 @@ config ORION_TIMER
 	bool
 
 config SUN4I_TIMER
+	select CLKSRC_MMIO
 	bool
 
 config VT8500_TIMER
-- 
1.8.4

