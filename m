Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3IYQOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:14:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38954 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754931Ab3IYQNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:13:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/5] clocksource: sun4i: Select CLKSRC_MMIO
Date: Wed, 25 Sep 2013 17:03:06 +0300
Message-Id: <1380117790-19390-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
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

