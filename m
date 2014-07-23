Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbaGWK6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:58:31 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:33584 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbaGWKyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:21 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 11/25] clocksource: sh_mtu2: Tidy up Kconfig typo for MTU2
Date: Wed, 23 Jul 2014 12:53:53 +0200
Message-Id: <1406112847-26275-11-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

It should be "MTU2" instead of "TMU2"

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Acked-by: Wolfram Sang <wsa@sang-engineering.com>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 6a11518..b17c909 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -175,7 +175,7 @@ config SH_TIMER_MTU2
 	default SYS_SUPPORTS_SH_MTU2
 	help
 	  This enables build of a clockevent driver for the Multi-Function
-	  Timer Pulse Unit 2 (TMU2) hardware available on SoCs from Renesas.
+	  Timer Pulse Unit 2 (MTU2) hardware available on SoCs from Renesas.
 	  This hardware comes with 16 bit-timer registers.
 
 config SH_TIMER_TMU
-- 
1.7.9.5

