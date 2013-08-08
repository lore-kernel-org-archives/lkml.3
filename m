Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab3HHFbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 01:31:03 -0400
Received: from 4.mo4.mail-out.ovh.net ([178.32.98.131]:48083 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756454Ab3HHFbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 01:31:01 -0400
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
Subject: [PATCH v3 04/19] clk: at91: add PMC macro file for dt definitions
Date: Thu,  8 Aug 2013 07:04:30 +0200
Message-Id: <1375938270-3965-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 2862037565202200624
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

This patch adds a new macro file for PMC macros.

This macro file includes the definitions of SR (status register) bit
offsets and will be use to reference PMC irqs.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 include/dt-bindings/clk/at91/common/pmc.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 include/dt-bindings/clk/at91/common/pmc.h

diff --git a/include/dt-bindings/clk/at91/common/pmc.h b/include/dt-bindings/clk/at91/common/pmc.h
new file mode 100644
index 0000000..edc51d6
--- /dev/null
+++ b/include/dt-bindings/clk/at91/common/pmc.h
@@ -0,0 +1,20 @@
+/*
+ * This header provides constants for AT91 pmc status.
+ *
+ * The constants defined in this header are being used in dts.
+ */
+
+#ifndef _DT_BINDINGS_CLK_AT91_PMC_H
+#define _DT_BINDINGS_CLK_AT91_PMC_H
+
+#define AT91_PMC_MOSCS		0		/* MOSCS Flag */
+#define AT91_PMC_LOCKA		1		/* PLLA Lock */
+#define AT91_PMC_LOCKB		2		/* PLLB Lock */
+#define AT91_PMC_MCKRDY		3		/* Master Clock */
+#define AT91_PMC_LOCKU		6		/* UPLL Lock */
+#define AT91_PMC_PCKRDY(id)	(8 + id)	/* Programmable Clock */
+#define AT91_PMC_MOSCSELS	16		/* Main Oscillator Selection */
+#define AT91_PMC_MOSCRCS	17		/* Main On-Chip RC */
+#define AT91_PMC_CFDEV		18		/* Clock Failure Detector Event */
+
+#endif
-- 
1.7.9.5

