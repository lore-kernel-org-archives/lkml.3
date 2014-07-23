Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbaGWN0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:26:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51973 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaGWNYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:24:52 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH 1/3] pinctrl: dra7: dt-bindings: add pin off modes for dra7 SoC
Date: Wed, 23 Jul 2014 18:54:40 +0530
Message-ID: <1406121882-32658-2-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.0.2.673.g9ab0882
In-Reply-To: <1406121882-32658-1-git-send-email-mugunthanvnm@ti.com>
References: <1406121882-32658-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pin off modes for dra7 SoC so that during module disable or suspend
state it can help saving power

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 include/dt-bindings/pinctrl/dra.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/dt-bindings/pinctrl/dra.h b/include/dt-bindings/pinctrl/dra.h
index 002a285..a0ff2d0 100644
--- a/include/dt-bindings/pinctrl/dra.h
+++ b/include/dt-bindings/pinctrl/dra.h
@@ -46,5 +46,13 @@
 #define PIN_INPUT_PULLUP	(PULL_ENA | INPUT_EN | PULL_UP)
 #define PIN_INPUT_PULLDOWN	(PULL_ENA | INPUT_EN)
 
+/* Off mode states */
+#define PIN_OFF_NONE		0
+#define PIN_OFF_OUTPUT_HIGH	(OFF_EN | OFFOUT_EN | OFFOUT_VAL)
+#define PIN_OFF_OUTPUT_LOW	(OFF_EN | OFFOUT_EN)
+#define PIN_OFF_INPUT_PULLUP	(OFF_EN | OFF_PULL_EN | OFF_PULL_UP)
+#define PIN_OFF_INPUT_PULLDOWN	(OFF_EN | OFF_PULL_EN)
+#define PIN_OFF_WAKEUPENABLE	WAKEUP_EN
+
 #endif
 
-- 
2.0.2.673.g9ab0882

