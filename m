Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaGKOTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:19:12 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18421 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaGKOTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:19:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Jul 2014 07:12:01 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <pdeschrijver@nvidia.com>, <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 3/8] ARM: tegra: Add PLL_M_UD and PLL_C_UD to tegra124-car binding header
Date: Fri, 11 Jul 2014 17:18:28 +0300
Message-ID: <1405088313-20048-4-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add these clocks to the binding header so that EMC timings that have
them as parent can refer to the clocks.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 include/dt-bindings/clock/tegra124-car.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h
index 4faabce..f58b24d 100644
--- a/include/dt-bindings/clock/tegra124-car.h
+++ b/include/dt-bindings/clock/tegra124-car.h
@@ -337,6 +337,10 @@
 #define TEGRA124_CLK_DSIB_MUX 310
 #define TEGRA124_CLK_SOR0_LVDS 311
 #define TEGRA124_CLK_XUSB_SS_DIV2 312
-#define TEGRA124_CLK_CLK_MAX 313
+
+#define TEGRA124_CLK_PLL_M_UD 313
+#define TEGRA124_CLK_PLL_C_UD 314
+
+#define TEGRA124_CLK_CLK_MAX 315
 
 #endif	/* _DT_BINDINGS_CLOCK_TEGRA124_CAR_H */
-- 
1.8.1.5

