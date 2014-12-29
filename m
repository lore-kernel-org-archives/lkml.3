Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaL2Xe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:34:58 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:41129 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaL2Xc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:32:27 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        marc.zyngier@arm.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 05/12] clocksource: add dependencies for Vybrid pit clocksource
Date: Tue, 30 Dec 2014 00:32:08 +0100
Message-Id: <1419895935-22966-6-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419895935-22966-1-git-send-email-stefan@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the minimal dependencies required to use the Vybrid PIT
clocksource driver. Those are not part of the SoC dependencies.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/clocksource/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index fc01ec2..a2eb7a2 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -154,6 +154,8 @@ config FSL_FTM_TIMER
 
 config VF_PIT_TIMER
 	bool
+	select CLKSRC_MMIO
+	select CLKSRC_OF
 	help
 	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
 
-- 
2.2.1

