Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbaGaLX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:23:58 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:37508 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaGaLWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:22:30 -0400
From: Humberto Silva Naves <hsnaves@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Humberto Silva Naves <hsnaves@gmail.com>
Subject: [PATCHv2 2/5] clk: samsung: exynos5410: Organize register offset constants
Date: Thu, 31 Jul 2014 13:22:09 +0200
Message-Id: <1406805732-17372-3-git-send-email-hsnaves@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The different register groups (SRC, DIV, PLL, GATE, etc) are
now separated by a blank line, and within the same group, the
definitions are ordered by address. This is done to reduce the
chances of potential conflicts when adding new entries, and
to improve the readability of code. While at it, replaced some
spaces with tabs to keep consistency.

Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
---
 drivers/clk/samsung/clk-exynos5410.c |   42 +++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5410.c b/drivers/clk/samsung/clk-exynos5410.c
index bf57c80..92c56b7 100644
--- a/drivers/clk/samsung/clk-exynos5410.c
+++ b/drivers/clk/samsung/clk-exynos5410.c
@@ -19,39 +19,43 @@
 
 #include "clk.h"
 
-#define APLL_LOCK               0x0
-#define APLL_CON0               0x100
-#define CPLL_LOCK               0x10020
-#define CPLL_CON0               0x10120
-#define MPLL_LOCK               0x4000
-#define MPLL_CON0               0x4100
-#define BPLL_LOCK               0x20010
-#define BPLL_CON0               0x20110
-#define KPLL_LOCK               0x28000
-#define KPLL_CON0               0x28100
+#define APLL_LOCK		0x0
+#define APLL_CON0		0x100
+#define MPLL_LOCK		0x4000
+#define MPLL_CON0		0x4100
+#define CPLL_LOCK		0x10020
+#define CPLL_CON0		0x10120
+#define BPLL_LOCK		0x20010
+#define BPLL_CON0		0x20110
+#define KPLL_LOCK		0x28000
+#define KPLL_CON0		0x28100
 
 #define SRC_CPU			0x200
-#define DIV_CPU0		0x500
 #define SRC_CPERI1		0x4204
-#define DIV_TOP0		0x10510
-#define DIV_TOP1		0x10514
-#define DIV_FSYS1		0x1054c
-#define DIV_FSYS2		0x10550
-#define DIV_PERIC0		0x10558
 #define SRC_TOP0		0x10210
 #define SRC_TOP1		0x10214
 #define SRC_TOP2		0x10218
 #define SRC_FSYS		0x10244
 #define SRC_PERIC0		0x10250
+#define SRC_CDREX		0x20200
+#define SRC_KFC			0x28200
+
 #define SRC_MASK_FSYS		0x10340
 #define SRC_MASK_PERIC0		0x10350
+
+#define DIV_CPU0		0x500
+#define DIV_TOP0		0x10510
+#define DIV_TOP1		0x10514
+#define DIV_FSYS1		0x1054c
+#define DIV_FSYS2		0x10550
+#define DIV_PERIC0		0x10558
+#define DIV_KFC0		0x28500
+
 #define GATE_BUS_FSYS0		0x10740
+
 #define GATE_IP_FSYS		0x10944
 #define GATE_IP_PERIC		0x10950
 #define GATE_IP_PERIS		0x10960
-#define SRC_CDREX		0x20200
-#define SRC_KFC			0x28200
-#define DIV_KFC0		0x28500
 
 /* list of PLLs */
 enum exynos5410_plls {
-- 
1.7.10.4

