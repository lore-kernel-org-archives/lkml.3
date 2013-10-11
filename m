Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab3JKJz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:55:27 -0400
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:39451 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756973Ab3JKJzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:55:25 -0400
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
Subject: [PATCH v4 10/17] clk: at91: add peripheral clk macros for peripheral clk dt bindings
Date: Fri, 11 Oct 2013 11:53:00 +0200
Message-Id: <1381485180-13796-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 14602077368062343392
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

This patch adds the peripheral divisors macros (for sam9x5 compatible IPs)
which will be used by peripheral clk dt definitions.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 include/dt-bindings/clk/at91.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/dt-bindings/clk/at91.h b/include/dt-bindings/clk/at91.h
index 0b4cb99..a3b07ca 100644
--- a/include/dt-bindings/clk/at91.h
+++ b/include/dt-bindings/clk/at91.h
@@ -19,4 +19,10 @@
 #define AT91_PMC_MOSCRCS	17		/* Main On-Chip RC */
 #define AT91_PMC_CFDEV		18		/* Clock Failure Detector Event */
 
+/* sam9x5 peripheral divisors */
+#define AT91SAM9X5_PERIPH_CLK_DIV1	0
+#define AT91SAM9X5_PERIPH_CLK_DIV2	1
+#define AT91SAM9X5_PERIPH_CLK_DIV4	2
+#define AT91SAM9X5_PERIPH_CLK_DIV8	3
+
 #endif
-- 
1.7.9.5

