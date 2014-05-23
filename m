Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaEWKjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:39:01 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59437 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaEWKco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:44 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 54/71] documentaion: DT: allow a A5 compatible string in global timer
Date: Fri, 23 May 2014 12:31:34 +0200
Message-Id: <1400841111-6683-54-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Leach <matthew.leach@arm.com>

The global timer is present on the Cortex A5. Add a compatibility
string to the DT binding to allow a Cortex A5 global timer.

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 .../devicetree/bindings/arm/global_timer.txt       |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/global_timer.txt b/Documentation/devicetree/bindings/arm/global_timer.txt
index 1e54898..bdae3a8 100644
--- a/Documentation/devicetree/bindings/arm/global_timer.txt
+++ b/Documentation/devicetree/bindings/arm/global_timer.txt
@@ -4,8 +4,11 @@
 
 ** Timer node required properties:
 
-- compatible : Should be "arm,cortex-a9-global-timer"
-		Driver supports versions r2p0 and above.
+- compatible : should contain
+	     * "arm,cortex-a5-global-timer" for Cortex-A5 global timers.
+	     * "arm,cortex-a9-global-timer" for Cortex-A9 global
+	         timers or any compatible implementation. Note: driver
+	         supports versions r2p0 and above.
 
 - interrupts : One interrupt to each core
 
-- 
1.7.9.5

