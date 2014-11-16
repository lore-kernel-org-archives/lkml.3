Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaKPIGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 03:06:08 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56741 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaKPIGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 03:06:06 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH] clocksource: meson6: Select CLKSRC_MMIO
Date: Sun, 16 Nov 2014 09:03:40 +0100
Message-Id: <1416125020-5715-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select CLKSRC_MMIO when the meson6_timer driver is enabled since it
depends on clocksource MMIO functions.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 9042060..f657a48 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -32,6 +32,7 @@ config ARMADA_370_XP_TIMER
 
 config MESON6_TIMER
 	bool
+	select CLKSRC_MMIO
 
 config ORION_TIMER
 	select CLKSRC_OF
-- 
1.9.1

