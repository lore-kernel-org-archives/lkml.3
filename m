Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbaLCAQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:16:52 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:33477 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933444AbaLCAMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:12:25 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH 08/12] clocksource: add dependencies for Vybrid pit clocksource
Date: Wed,  3 Dec 2014 01:12:07 +0100
Message-Id: <1417565531-4507-9-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417565531-4507-1-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
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
index 9042060..7d757b7 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -153,6 +153,8 @@ config FSL_FTM_TIMER
 
 config VF_PIT_TIMER
 	bool
+	select CLKSRC_MMIO
+	select CLKSRC_OF
 	help
 	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
 
-- 
2.1.3

