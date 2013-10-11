Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab3JKIoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:44:18 -0400
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:38714 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753170Ab3JKIoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:44:13 -0400
X-Greylist: delayed 3370 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2013 04:44:13 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH v4 04/17] clk: at91: add PMC macro file for dt definitions
Date: Fri, 11 Oct 2013 10:41:25 +0200
Message-Id: <1381480885-11994-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 13398771842949937376
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new macro file for PMC macros.

This macro file includes the definitions of SR (status register) bit
offsets and will be use to reference PMC irqs.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 include/dt-bindings/clk/at91.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 include/dt-bindings/clk/at91.h

diff --git a/include/dt-bindings/clk/at91.h b/include/dt-bindings/clk/at91.h
new file mode 100644
index 0000000..0b4cb99
--- /dev/null
+++ b/include/dt-bindings/clk/at91.h
@@ -0,0 +1,22 @@
+/*
+ * This header provides constants for AT91 pmc status.
+ *
+ * The constants defined in this header are being used in dts.
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#ifndef _DT_BINDINGS_CLK_AT91_H
+#define _DT_BINDINGS_CLK_AT91_H
+
+#define AT91_PMC_MOSCS		0		/* MOSCS Flag */
+#define AT91_PMC_LOCKA		1		/* PLLA Lock */
+#define AT91_PMC_LOCKB		2		/* PLLB Lock */
+#define AT91_PMC_MCKRDY		3		/* Master Clock */
+#define AT91_PMC_LOCKU		6		/* UPLL Lock */
+#define AT91_PMC_PCKRDY(id)	(8 + (id))	/* Programmable Clock */
+#define AT91_PMC_MOSCSELS	16		/* Main Oscillator Selection */
+#define AT91_PMC_MOSCRCS	17		/* Main On-Chip RC */
+#define AT91_PMC_CFDEV		18		/* Clock Failure Detector Event */
+
+#endif
-- 
1.7.9.5

