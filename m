Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3HHHMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 03:12:07 -0400
Received: from 12.mo4.mail-out.ovh.net ([178.33.104.253]:48637 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751033Ab3HHHMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 03:12:06 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH v3 12/19] clk: at91: add peripheral clk macros for peripheral clk dt bindings
Date: Thu,  8 Aug 2013 09:10:39 +0200
Message-Id: <1375945839-9573-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4991677239106500656
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the peripheral divisors macros (for sam9x5 compatible IPs)
which will be used by peripheral clk dt definitions.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 .../clk/at91/at91sam9x5/clk-peripheral.h           |   15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h

diff --git a/include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h b/include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h
new file mode 100644
index 0000000..a6dd506
--- /dev/null
+++ b/include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h
@@ -0,0 +1,15 @@
+/*
+ * This header provides constants for AT91 peripheral clks.
+ *
+ * The constants defined in this header are being used in dts.
+ */
+
+#ifndef _DT_BINDINGS_CLK_AT91SAM9X5_PERIPH_H
+#define _DT_BINDINGS_CLK_AT91SAM9X5_PERIPH_H
+
+#define AT91SAM9X5_PERIPH_CLK_DIV1	0
+#define AT91SAM9X5_PERIPH_CLK_DIV2	1
+#define AT91SAM9X5_PERIPH_CLK_DIV4	2
+#define AT91SAM9X5_PERIPH_CLK_DIV8	3
+
+#endif
-- 
1.7.9.5

