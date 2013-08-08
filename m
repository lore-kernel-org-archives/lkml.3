Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab3HHGQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 02:16:33 -0400
Received: from 4.mo4.mail-out.ovh.net ([178.32.98.131]:53148 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932632Ab3HHGQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 02:16:32 -0400
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
Subject: [PATCH v3 10/19] ARM: at91/dt: add system clk id definitions in dt-bindings include dir
Date: Thu,  8 Aug 2013 08:15:04 +0200
Message-Id: <1375942504-9010-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4054084090394671152
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

This patch adds system clk ids definitions into dt-bindinds include dir
(include/dt-bindings/clk/at91/'soc-name'/system-clk.h).

These definitions will be used by dt definition to define and reference
system clks.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 .../dt-bindings/clk/at91/at91rm9200/clk-system.h   |   16 +++++++++++++++
 .../dt-bindings/clk/at91/at91sam9261/clk-system.h  |   15 ++++++++++++++
 include/dt-bindings/clk/at91/common/clk-system.h   |   21 ++++++++++++++++++++
 3 files changed, 52 insertions(+)
 create mode 100644 include/dt-bindings/clk/at91/at91rm9200/clk-system.h
 create mode 100644 include/dt-bindings/clk/at91/at91sam9261/clk-system.h
 create mode 100644 include/dt-bindings/clk/at91/common/clk-system.h

diff --git a/include/dt-bindings/clk/at91/at91rm9200/clk-system.h b/include/dt-bindings/clk/at91/at91rm9200/clk-system.h
new file mode 100644
index 0000000..43bccd5
--- /dev/null
+++ b/include/dt-bindings/clk/at91/at91rm9200/clk-system.h
@@ -0,0 +1,16 @@
+/*
+ * This header provides constants for AT91RM9200 system clocks.
+ *
+ * The constants defined in this header are being used in dts.
+ */
+
+#ifndef _DT_BINDINGS_CLK_AT91RM9200_SYSTEM_H
+#define _DT_BINDINGS_CLK_AT91RM9200_SYSTEM_H
+
+#include <dt-bindings/clk/at91/common/system-clk.h>
+
+#define AT91RM9200_UDP_SYS_CLK		1
+#define AT91RM9200_MCKUDP_SYS_CLK	2
+#define AT91RM9200_UHP_SYS_CLK		4
+
+#endif
diff --git a/include/dt-bindings/clk/at91/at91sam9261/clk-system.h b/include/dt-bindings/clk/at91/at91sam9261/clk-system.h
new file mode 100644
index 0000000..28a140a
--- /dev/null
+++ b/include/dt-bindings/clk/at91/at91sam9261/clk-system.h
@@ -0,0 +1,15 @@
+/*
+ * This header provides constants for AT91SAM9261 system clocks.
+ *
+ * The constants defined in this header are being used in dts.
+ */
+
+#ifndef _DT_BINDINGS_CLK_AT91SAM9261_SYSTEM_H
+#define _DT_BINDINGS_CLK_AT91SAM9261_SYSTEM_H
+
+#include <dt-bindings/clk/at91/common/system-clk.h>
+
+#define AT91SAM9261_HCK0_SYS_CLK	16
+#define AT91SAM9261_HCK1_SYS_CLK	17
+
+#endif
diff --git a/include/dt-bindings/clk/at91/common/clk-system.h b/include/dt-bindings/clk/at91/common/clk-system.h
new file mode 100644
index 0000000..c0fb124
--- /dev/null
+++ b/include/dt-bindings/clk/at91/common/clk-system.h
@@ -0,0 +1,21 @@
+/*
+ * This header provides constants for AT91 system clocks.
+ *
+ * The constants defined in this header are being used in dts.
+ */
+
+#ifndef _DT_BINDINGS_CLK_AT91_SYSTEM_H
+#define _DT_BINDINGS_CLK_AT91_SYSTEM_H
+
+#define AT91_PCK_SYS_CLK	0
+#define AT91_DDRCK_SYS_CLK	2
+#define AT91_LCDCK_SYS_CLK	3
+#define AT91_SMDCK_SYS_CLK	4
+#define AT91_UHP_SYS_CLK	6
+#define AT91_UDP_SYS_CLK	7
+
+#define AT91_PROG_SYS_CLK(id)	(8 + id)
+
+#define AT91_MAX_SYS_CLKS	32
+
+#endif
-- 
1.7.9.5

